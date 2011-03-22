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

open CommonClient
open CommonComplexOptions
open CommonTypes
open CommonFile
open Options
open BasicSocket
open TcpBufferedSocket
open CommonInteractive
open CommonGlobals
  
open OpenFTTypes
open OpenFTOptions
open OpenFTGlobals
open OpenFTComplexOptions

open OpenFTProtocol

  
  
let disconnect_client c =
  match c.client_sock with
    None -> ()
  | Some sock -> 
      try
        if !!verbose_clients > 0 then begin
            lprintf "Disconnected from source"; lprint_newline ();    
          end;
        connection_failed c.client_connection_control;
        close sock "closed";
      with _ -> ()

let on_close c d =
  connection_failed c.client_connection_control;
  c.client_file <- None  
  
let listen _ = 
  lprintf "OpenFTClients.listen not implemented"; lprint_newline ()

(*


TELECHARGEMENT:

G E T   / m e d i a / E n d e r % 2 7 s % 2 0 S a g a % 2 0 5 % 2 0 - % 2 0 E n d e r % 2 7 s % 2 0 S h a d o w . t x t   H T T P / 1 . 1 (13)(10)
R a n g e :   b y t e s = 0 - 8 0 2 5 5 8 (13)(10)
(13)(10)

*)
  

let http_ok = "HTTP 200 OK"
let http11_ok = "HTTP/1.1 200 OK"
          
let is_http_ok header = 
  let pos = String.index header '\n' in
  match String2.split (String.sub header 0 pos) ' ' with
    http :: code :: ok :: _ -> 
      let code = int_of_string code in
      code >= 200 && code < 299 && 
      String2.starts_with (String.lowercase http) "http"
  | _ -> false

      
let client_parse_header c sock header = 
  if !!verbose_clients > 20 then begin
      lprintf "CLIENT PARSE HEADER"; lprint_newline ();
    end;
  try
    connection_ok c.client_connection_control;
    match c.client_file with
      None -> close sock "no download !"; raise Exit
    | Some d ->
    if !!verbose_clients > 10 then begin
        lprintf "HEADER FROM CLIENT:"; lprint_newline ();
        LittleEndian.dump_ascii header; 
      end;
    if is_http_ok header then
      begin
        
        if !!verbose_clients > 5 then begin
            lprintf "GOOD HEADER FROM CONNECTED CLIENT"; lprint_newline ();
          end;
        
        set_rtimeout sock 120.;
(*              lprintf "SPLIT HEADER..."; lprint_newline (); *)
        let lines = Http_client.split_header header in
(*              lprintf "REMOVE HEADLINE..."; lprint_newline (); *)
        match lines with
          [] -> raise Not_found        
        | _ :: headers ->
(*                  lprintf "CUT HEADERS..."; lprint_newline (); *)
            let headers = Http_client.cut_headers headers in
(*                  lprintf "START POS..."; lprint_newline (); *)
            let start_pos = 
              try
                let range = List.assoc "range" headers in
                try
                  let npos = (String.index range 'b')+6 in
                  let dash_pos = try String.index range '-' with _ -> -10 in
                  let start_pos = Int64.of_string 
                      (String.sub range npos (dash_pos - npos)) in
                  start_pos
                with 
                | e ->
                    lprintf "Exception %s for range [%s]" 
                      (Printexc2.to_string e) range;
                    lprint_newline ();
                    raise e
              with Not_found -> Int64.zero
            in                  
                if d.CommonDownloads.download_pos <> start_pos then 
                  failwith (Printf.sprintf "Bad range %s for %s"
                      (Int64.to_string start_pos)
                    (Int64.to_string d.CommonDownloads.download_pos));
            ()
      end else begin
        if !!verbose_clients > 0 then begin
            lprintf "BAD HEADER FROM CONNECTED CLIENT:"; lprint_newline ();
            LittleEndian.dump header;
          end;        
        disconnect_client c
      end
  with e ->
      lprintf "Exception %s in client_parse_header" (Printexc2.to_string e);
      lprint_newline ();
      LittleEndian.dump header;      
      disconnect_client c

let on_finished file d =
  current_files := List2.removeq file !current_files;
  old_files =:= (file.file_name, file_size file) :: !!old_files;
  List.iter (fun c ->
      c.client_downloads <- List.remove_assoc file c.client_downloads      
  ) file.file_clients
  
      
(*      
let file_complete file =
(*
  lprintf "FILE %s DOWNLOADED" f.file_name;
lprint_newline ();
  *)
  file_completed (as_file file.file_file);
  current_files := List2.removeq file !current_files;
  old_files =:= (file.file_name, file_size file) :: !!old_files;
  List.iter (fun c ->
      c.client_downloads <- List.remove_assoc file c.client_downloads      
  ) file.file_clients;
  
(* finally move file *)
  let incoming_dir =
    if !!commit_in_subdir <> "" then
      Filename.concat !!DO.incoming_directory !!commit_in_subdir
    else !!DO.incoming_directory
  in
  (try Unix2.safe_mkdir incoming_dir with _ -> ());
  let new_name = 
    Filename.concat incoming_dir (canonize_basename file.file_name)
  in
(*  lprintf "RENAME to %s" new_name; lprint_newline ();*)
  let new_name = rename_to_incoming_dir (file_disk_name file)  new_name in
  set_file_disk_name file new_name

let client_to_client s p sock =
  match p with
  | _ -> ()


let client_reader c sock nread = 
  if !!verbose_clients > 20 then begin
      lprintf "CLIENT READER"; lprint_newline ();
    end;
  if nread > 0 then
    let b = TcpBufferedSocket.buf sock in
    match c.client_file with
      None -> disconnect_client c
    | Some file ->
        set_rtimeout sock Date.half_day_in_secs;
        begin
          let fd = try
              Unix64.force_fd (file_fd file) 
            with e -> 
                lprintf "In Unix64.force_fd"; lprint_newline ();
                raise e
          in
          let final_pos = Unix64.seek64 (file_fd file) c.client_pos Unix.SEEK_SET in
          Unix2.really_write fd b.buf b.pos b.len;
        end;
(*      lprintf "DIFF %d/%d" nread b.len; lprint_newline ();*)
        c.client_pos <- c.client_pos ++ (Int64.of_int b.len);
(*
      lprintf "NEW SOURCE POS %s" (Int64.to_string c.client_pos);
lprint_newline ();
  *)
        TcpBufferedSocket.buf_used sock b.len;
        if c.client_pos > file_downloaded file then begin
            file.file_file.impl_file_downloaded <- c.client_pos;
            file_must_update file;
          end;
        if file_downloaded file = file_size file then
          file_complete file 
*)          
          
(*      
      
let friend_parse_header c sock header =
  try
    if String2.starts_with header gnutella_200_ok ||
      String2.starts_with header gnutella_503_shielded then begin
        set_rtimeout sock half_day;
        let lines = Http_client.split_header header in
        match lines with
          [] -> raise Not_found        
        | _ :: headers ->
            let headers = Http_client.cut_headers headers in
            let agent =  List.assoc "user-agent" headers in
            if String2.starts_with agent "LimeWire" ||
              String2.starts_with agent "Gnucleus" ||
              String2.starts_with agent "BearShare"              
            then
              begin
                (* add_peers headers; *)
                write_string sock "GNUTELLA/0.6 200 OK\r\n\r\n";
                if !!verbose_clients > 1 then begin
                    lprintf "********* READY TO BROWSE FILES *********";
                    lprint_newline ();
                  end;
              end
            else raise Not_found
      end 
    else raise Not_found
  with _ -> disconnect_client c

        *)
      
let get_from_client sock (c: client) (file : file) =
  if !!verbose_clients > 0 then begin
      lprintf "FINDING ON CLIENT"; lprint_newline ();
    end;
  let index = List.assoc file c.client_downloads in
  if !!verbose_clients > 0 then begin
      lprintf "FILE FOUND, ASKING"; lprint_newline ();
      end;
  
  write_string sock (Printf.sprintf 
      "GET %s HTTP/1.0\r\nRangeRange: bytes=%Ld-%Ld\r\n\r\n" file.file_name 
      (file_downloaded file) (file_size file));
  let module M = CommonDownloads.Make( struct
        let minimal_read = 1
        let client_disconnected = on_close c
        let download_finished = on_finished file
      end) in
  let d = M.new_download sock 
      (as_client c.client_client)
    (as_file file.file_file) 
  in
  c.client_file <- Some d;
  set_rtimeout sock 30.;
  d
    
let connect_client c =
  if !!verbose_clients > 0 then begin
      lprintf "connect_client"; lprint_newline ();
    end;
  try
    let u = c.client_user in
    let s = u.user_server in
    let ip = s.server_ip in
    let port = s.server_http_port in
    if !!verbose_clients > 0 then begin
        lprintf "connecting %s:%d" (Ip.to_string ip) port; 
        lprint_newline ();
      end;
    let sock = connect "openft download" 
        (Ip.to_inet_addr ip) port
        (fun sock event ->
          match event with
            BASIC_EVENT (RTIMEOUT|LTIMEOUT) ->
              disconnect_client c
          | BASIC_EVENT (CLOSED _) ->
              disconnect_client c
          | _ -> ()
      )
    in
    TcpBufferedSocket.set_read_controler sock download_control;
    TcpBufferedSocket.set_write_controler sock upload_control;
    
    c.client_sock <- Some sock;
    TcpBufferedSocket.set_closer sock (fun _ _ ->
        disconnect_client c
    );
    set_rtimeout sock 30.;
    match c.client_downloads with
      [] -> 
(* Here, we should probably browse the client or reply to
an upload request *)
        if !!verbose_clients > 0 then begin
            lprintf "NOTHING TO DOWNLOAD FROM CLIENT"; lprint_newline ();
          end;
        
        
        (* PUSH TO OTHER CLIENTS NOT IMPLEMENTED YET *)
        disconnect_client c;
    
    
    | (file, _) :: _ ->
        if !!verbose_clients > 0 then begin
            lprintf "READY TO DOWNLOAD FILE"; lprint_newline ();
          end;
        let d = get_from_client sock c file in
        set_reader sock (handler !!verbose_clients (client_parse_header c) 
          (CommonDownloads.download_reader d));
  
   
  with e ->
      lprintf "Exception %s while connecting to client" 
        (Printexc2.to_string e);
      lprint_newline ();
      disconnect_client c
      

(*
  
1022569854.519 24.102.10.39:3600 -> 212.198.235.45:51736 of len 82
ascii [ 
G I V   8 1 : 9 7 4 3 2 1 3 F B 4 8 6 2 3 D 0 F F D F A B B 3 8 0 E C 6 C 0 0 / P o l i c e   V i d e o   -   E v e r y   B r e a t h   Y o u   T a k e . m p g(10)(10)]

"GIV %d:%s/%s\n\n" file.file_number client.client_md4 file.file_name

*)

      (*
let find_file file_name file_size = 
  let key = (file_name, file_size) in
  try
    Hashtbl.find files_by_key key  
  with e ->
      lprintf "NO SUCH DOWNLOAD"; lprint_newline ();
      raise e

      
let push_handler cc sock header = 
  if !!verbose_clients > 0 then begin
      lprintf "PUSH HEADER: [%s]" (String.escaped header);
      lprint_newline (); 
    end;
  try
    if String2.starts_with header "GIV" then begin
        if !!verbose_clients > 0 then begin    
            lprintf "PARSING GIV HEADER"; lprint_newline (); 
          end;
        let colon_pos = String.index header ':' in
        let slash_pos = String.index header '/' in
        let uid = Md4.of_string (String.sub header (colon_pos+1) 32) in
        let index = int_of_string (String.sub header 4 (colon_pos-4)) in
        if !!verbose_clients > 0 then begin
            lprintf "PARSED"; lprint_newline ();
          end;
        let c = new_client uid (Indirect_location ("", uid)) in
        match c.client_sock with
          Some _ -> 
            if !!verbose_clients > 0 then begin
                lprintf "ALREADY CONNECTED"; lprint_newline (); 
              end;
            close sock "already connected"
        | None ->
            if !!verbose_clients > 0 then begin
                lprintf "NEW CONNECTION"; lprint_newline ();
              end;
            cc := Some c;
            c.client_sock <- Some sock;
            connection_ok c.client_connection_control;
            try
              if !!verbose_clients > 0 then begin
                  lprintf "FINDING FILE %d" index; lprint_newline ();
                end;
              let file = List2.assoc_inv index c.client_downloads in
              if !!verbose_clients > 0 then begin
                  lprintf "FILE FOUND"; lprint_newline ();
                end;
              get_from_client sock c file
            with e ->
                lprintf "Exception %s during client connection"
                  (Printexc2.to_string e);
                lprint_newline ();
                disconnect_client c
      end
    else raise Not_found
  with _ ->
      match !cc with 
        None -> raise Not_found
      | Some c ->
          disconnect_client c;
          raise Not_found
          
            *)

let client_parse_header2 c sock header = 
    match !c with
    Some c ->
      client_parse_header c sock header
  | _ -> assert false
      

let client_reader2 c sock nread = 
  match !c with
    None -> assert false
  | Some c ->
      match c.client_file with
        None -> assert false
      | Some d ->
          CommonDownloads.download_reader d sock nread

      
let listen () =
  try
    let sock = TcpServerSocket.create "openft client server" 
        Unix.inet_addr_any
        !!http_port
        (fun sock event ->
          match event with
            TcpServerSocket.CONNECTION (s, 
              Unix.ADDR_INET(from_ip, from_port)) ->
              lprintf "CONNECTION RECEIVED FROM %s FOR PUSH"
                (Ip.to_string (Ip.of_inet_addr from_ip))
              ; 
              lprint_newline (); 
              
              
              let sock = TcpBufferedSocket.create
                  "openft client connection" s (fun _ _ -> ()) in
              TcpBufferedSocket.set_read_controler sock download_control;
              TcpBufferedSocket.set_write_controler sock upload_control;

              let c = ref None in
              TcpBufferedSocket.set_closer sock (fun _ s ->
                  match !c with
                    Some c ->  disconnect_client c
                  | None -> ()
              );
              BasicSocket.set_rtimeout (TcpBufferedSocket.sock sock) 30.;
              TcpBufferedSocket.set_reader sock (
                handlers [client_parse_header2 c]
                  (client_reader2 c));
          | _ -> ()
      ) in
    listen_sock := Some sock;
    ()
  with e ->
      lprintf "Exception %s while init openft server" 
        (Printexc2.to_string e);
      lprint_newline ();

(*
ascii: [ H T T P / 1 . 1   2 0 0   O K(13)(10) C o n t e n t - R a n g e :   b y t e s   0 - 2 2 9 8 / 2 2 9 9(13)(10) C o n t e n t - L e n g t h :   2 2 9 9(13)(10) C o n t e n t - T y p e :   t e x t / p l a i n(13)(10) C o n t e n t - M D 5 :   6 3 4 5 3 9 c 4 4 9 a 6 5 1 3 c 8 5 2 c 7 e 3 8 8 b 0 9 c c a 4(13)(10)(13)]
*)
      