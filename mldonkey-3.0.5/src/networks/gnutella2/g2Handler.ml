(* Copyright 2001, 2002 b8_bavard, b8_fee_carabine, INRIA *)
(*
    This file is part of mldonkey.

    mldonkey is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    mldonkey is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with mldonkey; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
*)

open Int64ops
open Xml
open Printf2
open Md4
open BasicSocket
open TcpBufferedSocket
open Options
  
open CommonSwarming  
open CommonUploads
open CommonOptions
open CommonSearch
open CommonServer
open CommonComplexOptions
open CommonFile
open CommonTypes
open CommonGlobals
open CommonHosts

open G2Network
open G2Types
open G2Globals
open G2Options
open G2Protocol
open G2ComplexOptions
open G2Proto

(* TODO: try to find a more general function *)
let g2_tag_of_name name = field_of_string name
  
let update_client u =
  new_client u.user_kind

let find_urn urn =
  try
    [find_by_uid urn]
   with _ -> []

let gnutella_uid md4 =
  let md4 = Md4.to_string md4 in
  let s0_8 = String.sub md4 0 8 in
  let s8_12 = String.sub md4 8 4 in
  let s12_16 = String.sub md4 12 4 in
  let s16_20 = String.sub md4 16 4 in
  let s20_32 = String.sub md4 20 12 in
  Printf.sprintf "%s-%s-%s-%s-%s" s0_8 s8_12 s12_16 s16_20 s20_32
  
let xml_profile () = 
  Printf.sprintf 
  "<?xml version=\"1.0\"?><gProfile xmlns=\"http://www.shareaza.com/schemas/GProfile.xsd\"><gnutella guid=\"%s\"/><identity><handle primary=\"%s\"/><name last=\"\" first=\"%s\"/></identity><location><political city=\"\"/></location><avatar path=\"\"/></gProfile>"
    (gnutella_uid !!client_uid)
  (local_login ())
  (local_login ())
  
let g2_packet_handler s sock gconn p = 
  let h = s.server_host in
  if !verbose_msg_servers then begin
      lprintf_nl "Received %s packet from %s:%d: %s" 
        (match sock with Connection _  -> "TCP" | _ -> "UDP")
      (Ip.string_of_addr h.host_addr) h.host_port
        (Print.print p);
    end;
try 
  match p.g2_payload with 
  | PI -> 
      server_send sock s (packet PO []);
      if s.server_need_qrt && (match sock with
          | Connection _  -> true
          | _ -> false) then begin
          s.server_need_qrt <- false;
          send_qrt_sequence s false
        end;
      begin
        (match s.server_query_key with
            UdpQueryKey _  -> ()
          | _ -> host_send_qkr s.server_host);        
      end
   
  | PO -> 
      begin
        (match s.server_query_key with
            UdpQueryKey _  -> ()
          | _ -> host_send_qkr s.server_host);        
        end
  
  | UPROC -> 
      server_send sock s 
        (packet UPROD [
          (packet (UPROD_XML (xml_profile ())) [])
        ])
  
  | UPROD -> ()
  (* We have sent a UPROC request, this is the reply of the client *)
      
  | LNI ->
      List.iter (fun p ->
          match p.g2_payload with
            LNI_V v -> s.server_vendor <- v
          | LNI_HS (leaves,maxleaves) -> 
              s.server_nusers <- Int64.of_int leaves;
              s.server_maxnusers <- Int64.of_int maxleaves;
          | LNI_LS (files,kb) ->
              s.server_nfiles <- files;
          | _ -> ()
      ) p.g2_children;
      server_must_update (as_server s.server_server);
      server_send_lni sock s 0L 0L;

(* Should we really reply to QKR if we are just a leaf ? We should probably
  only reply if we are not already using all the available bandwidth. *)

(* ONLY ULTRAPEERS ARE SUPPOSED TO REPLY TO THESE MESSAGES
  | QKR ->
      server_send sock s
        {
        g2_payload = QKA; 
        g2_children = [
          {
            g2_payload = QKA_QK 123456l;
            g2_children = [];
          };
          {
            g2_payload = QKA_SNA (client_ip sock,0);
            g2_children = [];
          }
        ]
      }
*)
  
  | QKA ->
      H.host_queue_add active_udp_queue h (last_time ());
      if (Queues.Queue.length active_udp_queue) > 100 then
        ignore (H.host_queue_take active_udp_queue);
      List.iter (fun c ->
          match c.g2_payload with
            QKA_QK key -> s.server_query_key <- UdpQueryKey key
          | _ -> ()
      ) p.g2_children;
(* Now, we can extend our current searches on this host *)
      Hashtbl.iter (fun _ ss ->
          if not (Intset.mem h.host_num ss.search_hosts) then 
            match ss.search_search with
            | UserSearch (_,words,xml_query) ->
                server_send_query ss.search_uid words xml_query NoConnection s
(*            | FileWordSearch (_,words) -> ()
(*                server_send_query ss.search_uid words NoConnection s *) *)
            | FileUidSearch (file, uid) ->
                server_ask_uid NoConnection s ss.search_uid uid file.file_name
      ) searches_by_uid;
  
  | Q2 md4 ->
      if !verbose_msg_servers then
        lprintf "SEARCH RECEIVED\n";
(* OK, two cases: search by URN/magnet, or search by keywords *)
      
      (* 

      Upon receiving a query, a node should: 

      Verify its authentication 
      Send an acknowledgment if it was not received from a hub 
      Forward it to connected nodes if necessary (detailed below) 
      Process it locally and dispatch results 
      *)    
      
      (match sock with 
         Connection _  -> () 
        | _ -> (
      server_send sock s (packet (QA md4)
        [
          packet (QA_TS ((int64_time ()))) [];
          packet (QA_D ((client_ip sock, !!client_port), 0)) [];
        ]);
        )
      );
      
      
      let by_urn = ref false in
      let keywords = ref "" in
      let min_size = ref None in
      let max_size = ref None in
      
      let files = ref [] in
      List.iter (fun c ->
          match c.g2_payload with
            Q2_URN urn -> 
              by_urn := true;
              files := find_urn urn
          | Q2_DN dn when String2.starts_with dn "magnet" ->
              let name, uids = parse_magnet dn in
              by_urn := true;
              List.iter (fun urn ->
                  files := (find_urn urn) @ !files
              ) uids             
          
          | Q2_DN dn -> keywords := dn
          
          | Q2_MD xml ->
              begin try
                  ignore (Xml.parse_string xml)
                with e -> 
                    lprintf "Error %s parsing Xml \n%s\n"
                      (Printexc2.to_string e)
                    (String.escaped xml)
              end
          | Q2_SZR (min, max) ->
              min_size := Some min;
              max_size := Some max
          | _ -> ()
      ) p.g2_children;
      
      if not !by_urn then begin
(* Here, we should try to search for the files and store them in !files *)
          
          let q = 
            let q = 
              match String2.split_simplify !keywords ' ' with
                [] -> raise Not_found
              | s :: tail ->
                  List.fold_left (fun q s ->
                      QAnd (q, (QHasWord s))
                  ) (QHasWord s) tail
            in
            let q = match !min_size with
                None -> q 
              | Some sz ->
                  QAnd (QHasMinVal (Field_Size, sz),q)
            in
            let q = match !max_size with
                None -> q 
              | Some sz ->
                  QAnd (QHasMaxVal (Field_Size, sz),q)
            in
            q
          in
          List.iter (fun (file,_) ->
              files := file :: !files
          ) ( CommonUploads.query q)
        end;
      
      if List.length !files > 0 then 
        server_send sock s (packet (QH2 (0,md4))
          ( 
            (packet (QH2_GU !!client_uid) []) ::
            (packet (QH2_NA (Ip.ip_of_addr h.host_addr, h.host_port)) []) ::
            (packet (QH2_V "MLDK") []) ::
            (packet QH2_UPRO [packet  (QH2_UPRO_NICK (local_login ())) []]) ::
            (List.map (fun sh ->
(*

packet QH2_H (
                    let uids = ref [] in
                    
                    List.iter (fun uid ->
                        match uid with
                          Bitprint _ | Ed2k _ | Sha1 _ ->
                          uids := (packet (QH2_H_URN uid) []) :: !uids
                        | _ -> ()
                    ) sh.shared_info.sh_uids;
                    
                    (packet (QH2_H_DN (
                          Filename.basename sh.shared_codedname)) []) ::
                    (packet (QH2_H_URL "") []) ::
                    (packet (QH2_H_G 1) []) :: (* meaning ??? *)
                    !uids
                  )
*)
                  let info = IndexedSharedFiles.get_result sh.shared_info in
                  packet QH2_H (
                    (packet (QH2_H_DN (
                          Filename.basename sh.shared_codedname)) []) ::
                    (packet (QH2_H_URL "") []) ::
                    (packet (QH2_H_G 1) []) :: (* meaning ??? *)
                    (List.map (fun uid ->
                          packet (QH2_H_URN uid) []  
                      ) info.shared_uids)
                  )
              ) !files)
          ))
  
  
  | KHL ->
      List.iter (fun c ->
          match c.g2_payload with
            KHL_NH (ip,port) 
          | KHL_CH ((ip,port),_) ->
              if !verbose then lprintf_nl "KHL new Ultrapeer: %s %d" (Ip.to_string ip) port;
              ignore (H.new_host (Ip.addr_of_ip ip) port Ultrapeer);
              List.iter (fun c ->
                  match c.g2_payload with
                    KHL_NH_LS (f,kb)
                  | KHL_CH_LS (f,kb) -> (
                    let s = find_server (Ip.addr_of_ip ip) port in
                    match s with 
                      Some s -> 
                        s.server_nfiles <- f;
                        server_must_update (as_server s.server_server);
                     | _ -> (if !verbose then lprintf_nl "KHL LS: No server found: %s %d" (Ip.to_string ip) port)  
                    )

                  | KHL_NH_HS (l,ml) 
                  | KHL_CH_HS (l,ml) -> (
                    let s = find_server (Ip.addr_of_ip ip) port in
                    match s with 
                      Some s -> 
                        s.server_nusers <- Int64.of_int l;
                        s.server_maxnusers <- Int64.of_int ml;
                        server_must_update (as_server s.server_server);
                     | _ -> (if !verbose then lprintf_nl "KHL HS: No server found: %s %d" (Ip.to_string ip) port)
                    )
                  | KHL_NH_V v 
                  | KHL_CH_V v -> (
                    let s = find_server (Ip.addr_of_ip ip) port in
                    match s with 
                      Some s -> 
                        if s.server_vendor = "" then s.server_vendor <- v;
                     | _ -> (if !verbose then lprintf_nl "KHL V: No server found: %s %d" (Ip.to_string ip) port)
                    )
                  | _ -> ()
              ) c.g2_children
          | _ -> ()
      ) p.g2_children;
      server_send_khl sock s;
  
  | QA suid ->
      let ss = try Some (
            let ss = Hashtbl.find searches_by_uid suid in
            ss.search_hosts <- Intset.add h.host_num ss.search_hosts;
            ss
          )
        with _ -> None in
      List.iter (fun c ->
          match c.g2_payload with
          | QA_D ((ip,port),_) ->
              if !verbose then lprintf_nl "QA_D new Ultrapeer: %s %d" (Ip.to_string ip) port;
              let h = H.new_host (Ip.addr_of_ip ip) port Ultrapeer in
              H.connected h;
              begin
                match ss with
                  None -> ()
                | Some ss ->
                    ss.search_hosts <- Intset.add h.host_num ss.search_hosts
              end
(* These ones have not been searched yet *)
          | QA_S ((ip,port),_) -> 
              if !verbose then lprintf_nl "QA_S new Ultrapeer: %s %d" (Ip.to_string ip) port;
              let h = H.new_host (Ip.addr_of_ip ip) port Ultrapeer in
              H.connected h;
          
          
          | _ -> ()
      ) p.g2_children
  
  | QH2 (_, suid) ->

(*

- : Xml.xml =
XML ("audios",
 [("xsi:nonamespaceschemalocation",
  "http://www.limewire.com/schemas/audio.xsd")],
 [XML ("audio", [], [])])
  
Xml.parse_string
- : Xml.xml =
XML ("audios",
 [("xsi:nonamespaceschemalocation",
  "http://www.limewire.com/schemas/audio.xsd")],
 [XML ("audio",
   [("samplerate", "44100"); ("seconds", "125"); ("index", "0");
    ("bitrate", "128")],
   []);
  XML ("audio",
   [("title", "It&apos;s Not Unusal"); ("samplerate", "44100");
    ("track", "1"); ("seconds", "120"); ("artist", "Tom Jones");
    ("description", "Tom Jones, hehe"); ("album", "Mars Attacks Soundtrack");
    ("index", "1"); ("bitrate", "128"); ("genre", "Retro"); ("year", "1997")],
   [])])

- : Xml.xml =
XML ("audios",
 [("xsi:nonamespaceschemalocation",
  "http://www.limewire.com/schemas/audio.xsd")],
 [XML ("audio",
   [("samplerate", "44100"); ("seconds", "239"); ("index", "0");
    ("bitrate", "128")],
   [])])

*)
      
      let s = 
        try 
          let s = Hashtbl.find searches_by_uid suid in
          Some s with
          _ -> 
            if !verbose then
              lprintf "***** No Corresponding Search ****\n";
            None 
      in
      let user_nick = ref "" in
      let user_uid = ref Md4.null in
      let user_addr = ref None in
      let user_vendor = ref None in
      let user_files = ref [] in
      let xml_info = ref None in
      List.iter (fun c ->
          match c.g2_payload with
            QH2_GU uid -> user_uid := uid
          | QH2_NA addr -> user_addr := Some addr
          | QH2_V vendor -> user_vendor := Some vendor
          | QH2_UPRO -> 
              List.iter (fun c ->
                  match c.g2_payload with
                    QH2_UPRO_NICK nick -> user_nick := nick
                  | _ -> ()
              ) c.g2_children
          | QH2_H ->
              let res_urn = ref None in
              let res_url = ref "" in
              let res_size = ref None in
              let res_name = ref "" in
              List.iter (fun c ->
                  match c.g2_payload with
                    QH2_H_URN urn -> res_urn := Some urn
                  | QH2_H_URL url -> res_url := url
                  | QH2_H_DN s ->
                      res_name := s
                  | QH2_H_SZDN (sz, s) ->
                      if !res_size = None then 
                        res_size := Some sz;
                      res_name := s
                  | QH2_H_SZ sz -> res_size := Some sz
                  | _ -> ()
              ) c.g2_children;
              user_files := (!res_urn, !res_size, !res_name, !res_url, []) ::
              !user_files
          | QH2_MD xml ->
              begin
                try
                  let xml = Xml.xml_of (Xml.parse_string xml) in
                  xml_info := Some xml
                with e ->
                    if !verbose_unknown_messages then
                      lprintf_nl "Exception %s while parsing: \n%s"
                        (Printexc2.to_string e) xml
              
              end
          | _ -> ()              
      ) p.g2_children;
      
      let user_files = List.rev !user_files in
      let user_files = match !xml_info with
          None -> user_files
        | Some ( (kind, _, files)) -> 
            
            if List.length files = List.length user_files then begin
                List.map2 (fun (urn, size, name, url, _) file ->
                    let (file_type, tags, _) = Xml.xml_of file in
                    (urn, size, name, url, 
                      List.map (fun (tag, v) ->
                          string_tag (g2_tag_of_name tag) v) 
                      tags)
                ) user_files files
              end else begin
                if !verbose_unknown_messages then
                  lprintf_nl "ERROR: Not enough XML entries %d/%d"
                    (List.length files) (List.length user_files);
                user_files 
              end
            
      in
      
      if !verbose_msg_servers then begin
          lprintf_nl "Results Received:";
          List.iter (fun (urn, size, name, url, tags) ->
              lprintf "[name %s] [size %s] [urn %s] [url %s]\n"
                name (match size with
                  None -> "??" | Some sz -> Int64.to_string sz) 
              (match urn with
                  None -> "no URN"
                | Some urn -> Uid.to_string urn)
              url
          ) user_files;
        end;      
      
      let user = 
        let user = new_user (match !user_addr with
              None -> Indirect_location (!user_nick, !user_uid, Ip.null, 0)
            | Some (ip,port) -> Known_location (ip,port))
        in
        (match !user_vendor with Some v -> user.user_vendor <- v | _ -> ());
        user.user_uid <- !user_uid;
        user.user_nick <- !user_nick; 
(*        user.user_gnutella2 <- true; *)
        user
      in
      
(*          lprintf "ADDING RESULTS\n";*)
      List.iter (fun (urn, size, name, url, tags) ->
(*              lprintf "NEW RESULT %s\n" f.Q.name; *)
          
          let url = match urn with
              None -> url
            | Some uid ->
                Printf.sprintf "/uri-res/N2R?%s" (Uid.to_string uid)
          in

          (*
          (match size with
              None -> ()
            | Some size ->
                try
                  let file = Hashtbl.find files_by_key (name, size) in
                  lprintf "++++++++++++ RECOVER FILE BY KEY %s +++++++++++\n" 
                    file.file_name; 
                  let c = update_client user in
                  add_download file c (FileByUrl url)
                with _ -> ());
*)
          
          (match urn with
              None -> ()
            | Some uid ->
                try
                  let file = Hashtbl.find files_by_uid uid in
                  if !verbose then
                    lprintf "++++++++++++ RECOVER FILE BY UID %s +++++++++++\n" 
                  file.file_name;
                  
                  (match size with
                      None -> ()
                    | Some size ->
                        if file_size file = Int64.zero then begin
                            lprintf "Recover correct file size\n";
                            
                            failwith "G2Handler: recover from size 0 not implemented"
(*
                            file.file_file.impl_file_size <- size;
                            CommonSwarming.set_size file.file_swarmer size;
file_must_update file;
  *)
                          end);
                  
                  let c = update_client user in
                  add_download file c (FileByUrl url)
                with _ -> ()
          );
          
          match s, size with
          | Some s, Some size ->
              let uids = match urn with 
                  None -> [] | Some uid -> [uid] in
              let r = new_result name size tags uids [] in
              
              add_source r user (FileByUrl url);
              
              begin
                match s.search_search with
                  UserSearch (s,_,_) ->
                    CommonInteractive.search_add_result false s r
                | _ -> ()
              end
          | _ -> ()
      ) user_files;
      
  | _ -> 
      if !verbose_unknown_messages then
        lprintf_nl "g2_packet_handler: unexpected packet %s"
        (Print.print p)

with e ->
  if !verbose then
  lprintf_nl "g2_packet_handler exception: %s" (Printexc2.to_string e) 
  
          
let udp_packet_handler ip port msg = 
  let addr = Ip.addr_of_ip ip in
  (* if !verbose then lprintf_nl "udp_packet_handler new Ultrapeer: %s %d" (Ip.to_string ip) port; *)
  let h = H.new_host addr port Ultrapeer in
  H.connected h;
(*  if !verbose_udp then
    lprintf "Received UDP packet from %s:%d: \n%s\n" 
      (Ip.to_string ip) port (Print.print msg);*)
  let s = new_server addr port in

  (match s.server_sock with 
    Connection _ -> ()
    | _ -> s.server_connected <- int64_time ());

  g2_packet_handler s NoConnection () msg
  (*
  match msg.g2_payload with
  | PI -> 
      udp_send ip port (packet PO [])
  | _ -> 
      if !verbose_unknown_messages then
        lprintf "g2_udp_packet_handler: unexpected packet \n%s\n"
          (Print.print msg)
*)      

let init s sock gconn = 
(*  gconn.gconn_sock <- s.server_sock; *)
  if !verbose then lprintf_nl "init: %s" (Ip.to_string (peer_ip sock));

  connected_servers := s :: !connected_servers;
  gconn.gconn_handler <- Reader (g2_handler (g2_packet_handler s s.server_sock));

  server_send_ping s.server_sock s; (* *)
  server_send_ping NoConnection s;
  server_send NoConnection s (packet PI []);

 (*  server_send (Connection sock) s (packet PI []);   *)

  (match s.server_query_key with
      UdpQueryKey _  -> ()
    | _ -> host_send_qkr s.server_host);


  server_send_lni (Connection sock) s 0L 0L; (* SZ CG2Neighbour::OnRun() *)
(*
  server_send_khl (Connection sock) s;
*)

  server_send (Connection sock) s (packet UPROC [])

  (*
    G2.recover_files_from_server s;    
*)

(* A good session: PI, KHL, LNI *)
  
    
let udp_client_handler ip port buf =
  if String.length buf > 3 && String.sub buf 0 3 = "GND" then
    try

      (*
      if !verbose then begin 
        lprintf_nl "udp_client_handler %s %d" (Ip.to_string ip) port;
        AnyEndian.dump_hex buf;
      end;
      *)
      let x = (parse_udp_packet ip port buf) in
      udp_packet_handler ip port x

    with AckPacket | FragmentedPacket -> 
      (* if !verbose then lprintf_nl "ACK/FRAGMENT" *)

      ()
    
  else
    if !verbose then begin
      lprintf_nl "Unexpected UDP packet:";
      AnyEndian.dump_hex buf;
    end
      
let update_shared_files () = ()
let declare_word _ = new_shared_words := true
  
