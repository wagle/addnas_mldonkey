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

open Options
open Queues
open Printf2
open Md4
open BasicSocket
open TcpBufferedSocket

open AnyEndian
  
open CommonOptions
open CommonSearch
open CommonServer
open CommonComplexOptions
open CommonFile
open CommonSwarming
open CommonTypes
open CommonGlobals
  
open FasttrackTypes
open FasttrackGlobals
open FasttrackOptions
open FasttrackProtocol
open FasttrackComplexOptions
open FasttrackProto
  
let server_parse_after s gconn sock = 
  try
    let b = buf sock in
    let len = b.len in
    if len > 0 then
      match int_of_char b.buf.[b.pos] with
        0x50 ->
(*          lprintf "We have got a ping\n"; *)
          buf_used sock 1;
          server_send_pong s
      | 0x52 ->
(*          lprintf "We have got a pong\n"; *)
          buf_used sock 1          
      | 0x4b ->
(*          lprintf "We have got a real packet\n"; *)
          begin
            if len > 4 then
              match s.server_ciphers with
                None -> assert false
              | Some ciphers ->

(*                dump_sub b.buf b.pos b.len; *)
                  let xtype = Int64.to_int (Int64.rem ciphers.in_xinu int64_3) in
                  
                  let msg_type, size = 
                    match xtype with
                      0 ->
                        let msg_type = get_int8 b.buf (b.pos+1) in
(* zero *)
                        let len_hi = get_int8 b.buf (b.pos+3) in
                        let len_lo = get_int8 b.buf (b.pos+4) in
                        msg_type, (len_hi lsl 8) lor len_lo
                    | 1 ->
(* zero *)
                        let len_hi = get_int8 b.buf (b.pos+2) in
                        let msg_type = get_int8 b.buf (b.pos+3) in
                        let len_lo = get_int8 b.buf (b.pos+4) in
                        msg_type, (len_hi lsl 8) lor len_lo
                    | _ ->
(*zero*)        
                        let len_lo = get_int8 b.buf (b.pos+2) in
                        let len_hi = get_int8 b.buf (b.pos+3) in
                        let msg_type = get_int8 b.buf (b.pos+4) in
                        msg_type, (len_hi lsl 8) lor len_lo
                  in
(*                lprintf "Message to read: xtype %d type %d len %d\n"
                  xtype msg_type size; *)
                  
                  if len >= size + 5 then begin
                      
                      ciphers.in_xinu <- Int64.logxor ciphers.in_xinu  
                        (Int64.logand
                          (Int64.lognot (Int64.of_int (size + msg_type))) 
                        int64_ffffffff);
                      let m = String.sub b.buf (b.pos+5) size in
                      buf_used sock (size + 5);
                      FasttrackHandler.server_msg_handler sock s msg_type m
                    end (* else
                  lprintf "Waiting for remaining %d bytes\n"
                    (size+5 - len) 
                  else
                    lprintf "Packet too short\n" *)
          end
      | n ->
          lprintf "Packet not understood: %d\n" n;
          raise Exit
  with e -> 
      lprintf "Exception %s in server_parse_after\n"
        (Printexc2.to_string e);
      close sock "not understood"
      
let greet_supernode s =
  let b = Buffer.create 100 in

(* Hope it is the right order: ntohl(sa.sin_addr.s_addr) *)
  LittleEndian.buf_ip b (client_ip s.server_sock);
  BigEndian.buf_int16 b 0; (* client_port *)

(* This next byte represents the user's advertised bandwidth, on
* a logarithmic scale.  0xd1 represents "infinity" (actually,
* 1680 kbps).  The value is approximately 14*log_2(x)+59, where
* x is the bandwidth in kbps. *)
  buf_int8 b 0x68;
(* 1 byte: dunno. *)
  buf_int8 b  0x00;
  
  Buffer.add_string b !!client_name; (* no ending 0 *)
  let m = Buffer.contents b in
  server_send s 0x02 m;
  server_send_ping s
  
let server_parse_netname s gconn sock = 
  let b = TcpBufferedSocket.buf sock in
  let len = b.len in
  let start_pos = b.pos in
  let end_pos = start_pos + len in
  let buf = b.buf in
  let net = String.sub buf start_pos len in
(*  lprintf "net: [%s]\n" (String.escaped net); *)
  let rec iter pos =
    if pos < end_pos then 
      if buf.[pos] = '\000' then begin
          let netname = String.sub buf start_pos (pos-start_pos) in
(*          lprintf "netname: [%s]\n" (String.escaped netname); *)
          buf_used sock (pos-start_pos+1);
          match s.server_ciphers with
            None -> assert false
          | Some ciphers ->
              gconn.gconn_handler <- 
                CipherReader (ciphers.in_cipher, server_parse_after s);
              greet_supernode s
        end else
        iter (pos+1)
  in
  iter start_pos
  
let server_parse_cipher s gconn sock = 
  let b = TcpBufferedSocket.buf sock in
  if b.len >= 8 then
    match s.server_ciphers with
      None -> assert false
    | Some ciphers ->
        cipher_packet_get b.buf b.pos ciphers.in_cipher ciphers.out_cipher;
        buf_used sock 8;
        server_crypt_and_send s ciphers.out_cipher (network_name ^ "\000");
        gconn.gconn_handler <- CipherReader (ciphers.in_cipher, server_parse_netname s);
        lprintf "waiting for netname\n"
          
let out_cipher_seed = Int32.of_string "0x0fACB1238"

let connect_server h =  
  let s = match h.host_server with
      None -> 
        let s = new_server h.host_addr h.host_port in
        h.host_server <- Some s;
        s
    | Some s -> s
  in
  match s.server_sock with
    ConnectionWaiting -> ()
  | ConnectionAborted -> s.server_sock <- ConnectionWaiting
  | Connection _ -> ()
  | NoConnection -> 
      incr nservers;
      s.server_sock <- ConnectionWaiting;
      add_pending_connection (fun _ ->
          decr nservers;
          match s.server_sock with
            ConnectionAborted -> 
              s.server_sock <- NoConnection;
              free_ciphers s
          | Connection _ | NoConnection -> ()
          | ConnectionWaiting ->
              try
                let ip = Ip.ip_of_addr h.host_addr in
                if not (Ip.valid ip) then
                  failwith "Invalid IP for server\n";
                let port = s.server_host.host_port in
                if !verbose_msg_servers then begin
                    lprintf "CONNECT TO %s:%d\n" 
                    (Ip.string_of_addr h.host_addr) port;
                  end;  
                h.host_tcp_request <- last_time ();
                let sock = connect "gnutella to server"
                    (Ip.to_inet_addr ip) port
                    (fun sock event -> 
                      match event with
                        BASIC_EVENT (RTIMEOUT|LTIMEOUT) -> 
(*                  lprintf "RTIMEOUT\n"; *)
                          disconnect_from_server nservers s "TIMEOUT"
                      | _ -> ()
                  ) in
                TcpBufferedSocket.set_read_controler sock download_control;
                TcpBufferedSocket.set_write_controler sock upload_control;
                
                set_server_state s Connecting;
                s.server_sock <- Connection sock;
                incr nservers;
                set_fasttrack_sock sock !verbose_msg_servers
                  (Reader (server_parse_cipher s)
                
                );
                set_closer sock (fun _ error -> 
(*            lprintf "CLOSER %s\n" error; *)
                    disconnect_from_server nservers s error);
                set_rtimeout sock !!server_connection_timeout;
                
                let in_cipher = create_cipher () in
                let out_cipher = create_cipher () in
                s.server_ciphers <- Some {
                  in_cipher = in_cipher;
                  out_cipher = out_cipher;
                  in_xinu = Int64.of_int 0x51;
                  out_xinu = Int64.of_int 0x51;
                };
                set_cipher out_cipher out_cipher_seed 0x29;
                
                let s = String.create 12 in
                cipher_packet_set out_cipher s 0;
                if !verbose_msg_servers then begin
                    lprintf "SENDING %s\n" (String.escaped s);
                    AnyEndian.dump s;
                  end;
                write_string sock s;
              with _ ->
                  disconnect_from_server nservers s "Error during Connect"
      )

let get_file_from_source c file =
  if connection_can_try c.client_connection_control then begin
      connection_try c.client_connection_control;
      match c.client_user.user_kind with
        Indirect_location ("", uid) ->
          (*
          lprintf "++++++ ASKING FOR PUSH +++++++++\n";   

(* do as if connection failed. If it connects, connection will be set to OK *)
          connection_failed c.client_connection_control;

          let uri = (find_download file c.client_downloads).download_uri in
          List.iter (fun s ->
                FasttrackProto.server_send_push s uid uri
) !connected_servers;
*)
          lprintf "PUSH NOT IMPLEMENTED\n"
      | _ ->
          FasttrackClients.connect_client c
    end

    
let exit = Exit
  
let recover_file file = 
  
  (*
  List.iter (fun fuid ->
      try
        List.iter (fun s ->
            match s.search_search with
              FileUidSearch (ss,uid) when uid = fuid -> raise exit
            | _ -> ()
        ) file.file_searches;
        
        let s = {
          search_search = FileUidSearch (file, fuid);
          search_hosts = Intset.empty;
          search_uid = Md4.random ();          
          }  in
        
        Hashtbl.add searches_by_uid s.search_uid s;
        file.file_searches <- s :: file.file_searches
      with _ -> ()
  ) file.file_uids;
*)
  
  Fasttrack.recover_file file;
  ()
  
let disconnect_server s =
  match s.server_sock with
  | Connection sock -> close sock "user disconnect"
  | ConnectionWaiting -> 
      s.server_sock <- ConnectionAborted;
      free_ciphers s
      
  | _ -> ()
    
let download_file (r : result) =
  let file = new_file (Md4.random ()) 
    r.result_name r.result_size r.result_hash in
  lprintf "DOWNLOAD FILE %s\n" file.file_name; 
  if not (List.memq file !current_files) then begin
      current_files := file :: !current_files;
    end;
  List.iter (fun (user, index) ->
      let c = new_client user.user_kind in
      add_download file c index;
      get_file_from_source c file;
  ) r.result_sources;
  recover_file file;
  ()

let recover_files () =
  List.iter (fun file ->
      recover_file file 
  ) !current_files;
  ()
    
let ask_for_files () =
  List.iter (fun file ->
      List.iter (fun c ->
          get_file_from_source c file
      ) file.file_clients
  ) !current_files;
  ()

  (*
let udp_handler p =
  let (ip,port) = match p.UdpSocket.addr with
    | Unix.ADDR_INET(ip, port) -> Ip.of_inet_addr ip, port
    | _ -> raise Not_found
  in
  let buf = p.UdpSocket.content in
  let len = String.length buf in
  Fasttrack.udp_handler (Ip.addr_of_ip ip) port buf
    *)

let _ =
  server_ops.op_server_disconnect <- disconnect_server;
  server_ops.op_server_remove <- (fun s ->
      disconnect_server s;
  )
  
let manage_host h =
  try
    let current_time = last_time () in
(*    lprintf "host queue before %d\n" (List.length h.host_queues);  *)

(*    lprintf "host queue after %d\n" (List.length h.host_queues); *)
(* Don't do anything with hosts older than one hour and not responding *)
    if max h.host_connected h.host_age > last_time () - 3600 then begin
        host_queue_add workflow h current_time;
(* From here, we must dispatch to the different queues *)
        match h.host_kind with
        | Ultrapeer | IndexServer ->        
            if h.host_udp_request + 600 < last_time () then begin
(*              lprintf "waiting_udp_queue\n"; *)
                host_queue_add waiting_udp_queue h current_time;
              end;
            if h.host_tcp_request + 600 < last_time () then begin
                host_queue_add  ultrapeers_waiting_queue h current_time;
              end
        | Peer ->
            if h.host_udp_request + 600 < last_time () then begin
(*              lprintf "g01_waiting_udp_queue\n"; *)
                host_queue_add waiting_udp_queue h current_time;
              end;
            if h.host_tcp_request + 600 < last_time () then
              host_queue_add peers_waiting_queue h current_time;
      end    else 
    if max h.host_connected h.host_age > last_time () - 3 * 3600 then begin
        host_queue_add workflow h current_time;      
      end else
(* This host is too old, remove it *)
      ()
          
  with e ->
      lprintf "Exception %s in manage_host\n" (Printexc2.to_string e)
      
let manage_hosts () = 
  let rec iter () =
    let h = host_queue_take workflow in
    manage_host h;
    iter ()
  in
  try iter () with _ -> 
(*      lprintf "done (set %d len)\n" (Queue.length workflow);  *)
      ()

      