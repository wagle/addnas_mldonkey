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

let debug = ref false
    
type event = 
| CLOSED of string (* called when a task has been closed *)
| RTIMEOUT (* called after a timeout on reading *)
| WTIMEOUT (* called after a timeout on writing *)
| LTIMEOUT (* called after a timeout on lifetime *)
| CAN_READ (* called when read is possible *)
| CAN_WRITE (* called when write is possible *)

type t = {
(* DON'T CHANGE THE ORDER OF THESE FOUR FIELDS !!! *)
    mutable fd : Unix.file_descr;
    mutable flags : int;
    mutable want_to_write : bool;
    mutable want_to_read : bool;
    mutable closed : bool;
    mutable pollpos : int;
    mutable read_allowed : bool ref;
    mutable write_allowed : bool ref;
    
(* YOU CAN MODIFY THESE *)
    mutable rtimeout: float;
    mutable next_rtimeout : float;
    
    mutable wtimeout: float;
    mutable next_wtimeout : float;
    
    mutable lifetime : float;
    
    mutable event_handler : handler;
    mutable error : string;

    mutable name : unit -> string;
    born : float;
    mutable dump_info : (unit -> unit);
(*    mutable before_select : (t -> unit); *)
    mutable can_close : bool;
  }

and handler = t -> event -> unit

type timer = {
    mutable next_time : float;
    time_handler : timer -> unit;
    mutable applied : bool;
    mutable delay : float;
  }

let nb_sockets = ref 0

let allow_read = ref true
let allow_write = ref true
  
let set_allow_read s ref = s.read_allowed <- ref
let set_allow_write s ref = s.write_allowed <- ref
  
let minf (x: float) (y: float) =
  if x > y then y else x

let mini (x: int) (y: int) =
  if x > y then y else x

let maxf (x: float) (y: float) =
  if x < y then y else x

let maxi (x: int) (y: int) =
  if x < y then y else x
  
let infinite_timeout = 3600. *. 24. *. 365. (* one year ! *)

let current_time = ref (Unix.gettimeofday ())

let update_time () =
  current_time := Unix.gettimeofday ();
  !current_time

let last_time () = !current_time

let fd t = t.fd

let must_write t b  = t.want_to_write <- b
let must_read t b  = t.want_to_read <- b

(* let set_before_select t f = t.before_select <- f *)
    
let dummy_fd = Obj.magic (-1)

let closed_tasks = ref []

let print_socket s =  
  Printf.printf "FD %d: %20s Socket %s " 
    (Obj.magic s.fd)
  (Date.to_string s.born) (s.name ());
  print_newline ()
  
let close t msg =
  if t.fd <> dummy_fd then begin
      if !debug then begin
          Printf.printf "CLOSING:"; print_socket t;
        end;
      (try 
          Unix.close t.fd;
          with _ -> ());
      t.fd <- dummy_fd;
      closed_tasks := t :: !closed_tasks;
      t.closed <- true;
      t.error <- msg;
      decr nb_sockets
    end

let closed t = t.closed

let set_rtimeout t time =
  t.rtimeout <- time;
  t.next_rtimeout <- time +. !current_time

let set_wtimeout t time =
  t.wtimeout <- time;
  t.next_wtimeout <- time +. !current_time

let set_lifetime t time =
  t.lifetime <- time +. !current_time 

let set_handler t handler =
  t.event_handler <- handler

let handler t = t.event_handler

let fd_tasks  = ref ([]: t list)

let before_select_hooks = ref []
  
let set_before_select_hook f =
  before_select_hooks := f :: !before_select_hooks

let after_select_hooks = ref []
  
let set_after_select_hook f =
  after_select_hooks := f :: !after_select_hooks
  
let default_before_select t = ()

let dump_basic_socket () = ()
  
let create_blocking name fd handler =
  
  let (fdnum : int) = Obj.magic fd in
  if fdnum >= Unix32.fds_size then begin
      Unix.close fd;
      failwith "File Descriptor removed";
    end;
  incr nb_sockets;
  Unix.set_nonblock fd;
(*  Printf.printf "NEW FD %d" (Obj.magic fd); print_newline (); *)
  let _ = update_time () in
  let t = {
      fd = fd;
      
      want_to_write = false;
      want_to_read = true;
      closed = false;
      pollpos = -1;      
      flags = 0;
      
      rtimeout = infinite_timeout;
      next_rtimeout = !current_time +. infinite_timeout;
      
      wtimeout = infinite_timeout;
      next_wtimeout = !current_time +. infinite_timeout;
      
      lifetime = !current_time +. infinite_timeout;

      read_allowed = allow_read;
      write_allowed = allow_write;
      
      event_handler = handler;
      error = "";
(*      before_select = default_before_select; *)
      name = (fun _ -> name);
      born = last_time();
      
      dump_info = dump_basic_socket;
      can_close = true;
    } in
(*  Printf.printf "ADD ONE TASK"; print_newline (); *)
  if !debug then begin
      Printf.printf "OPENING:" ; print_socket t;
    end;
  fd_tasks := t :: !fd_tasks; 
  t

  
let create name fd handler =
  Unix.set_nonblock fd;
  create_blocking name fd handler
  
external select: t list -> float -> unit = "ml_select" 
external use_poll : bool -> unit = "ml_use_poll"
 
let timeout = ref infinite_timeout
let timers = ref []
  
let rec iter_task old_tasks time =
  match old_tasks with
    [] -> ()
  | t :: old_tail ->
(*      Printf.printf "NEXT TASK"; print_newline (); *)
      if t.closed then iter_task old_tail time else
        begin
          fd_tasks := t :: !fd_tasks;
          
(*          t.before_select t; *)
          
          if t.want_to_write then 
            timeout := minf (t.next_wtimeout -. time) !timeout;
          
          if t.want_to_read then
            timeout := minf (t.next_rtimeout -. time) !timeout;
          
          iter_task old_tail time;
        end

let rec iter_timer timers time =
  match timers with
    [] -> []
  | t :: timers ->
      if t.applied then
        iter_timer timers time
      else
        begin
          timeout := minf (t.next_time -. time) !timeout;
          t :: (iter_timer timers time)
        end
          
let add_timer delay f =
  timers := {
    next_time = last_time () +. delay;
    time_handler = f;
    applied = false;
    delay = delay;
  } :: !timers

let reactivate_timer t =
  if t.applied then begin
      t.next_time <- last_time () +. t.delay;
      t.applied <- false;
    end

let add_session_timer enabler delay f = 
  let f t =
    if !enabler then begin
        reactivate_timer t;
        f ()
      end
  in
  add_timer delay f

  
let add_infinite_timer delay f = add_session_timer (ref true) delay f

let add_session_option_timer enabler option f = 
  let f t =
    if !enabler then begin
        t.delay <- !!option;
        reactivate_timer t;
        f ()
      end
  in
  add_timer !!option f

let add_infinite_option_timer option f = add_session_option_timer (ref true) option f
  
let can_read = 1
let can_write = 2

let rec exec_hooks list =
  match list with
    [] -> ()
  | f :: tail ->
      (try f () with _ -> ());
      exec_hooks tail

let rec exec_tasks = 
  function [] -> ()
  | t :: tail ->
      (
        let time = !current_time in
        if not t.closed && t.next_rtimeout < time then 
          (try t.event_handler t RTIMEOUT with _ -> ());
        if not t.closed && t.next_wtimeout < time then 
          (try t.event_handler t WTIMEOUT with _ -> ());
        if not t.closed && t.lifetime < time then 
          (try t.event_handler t LTIMEOUT with _ -> ());
        if not t.closed && t.flags land can_read <> 0 then 
          (try 
              t.next_rtimeout <- time +. t.rtimeout;
              t.event_handler t CAN_READ with _ -> ());
        if not t.closed && t.flags land can_write <> 0 then 
          (try 
              t.next_wtimeout <- time +. t.wtimeout;                
              t.event_handler t CAN_WRITE with _ -> ());
      );
      exec_tasks tail
      
let rec exec_timers = function
    [] -> ()
  | t :: tail ->
      (
        if (not t.applied) && t.next_time <= !current_time then begin
            t.applied <- true;
            try t.time_handler t with _ -> ()
          end
      );
      exec_timers tail
      
let loop () =
  Sys.set_signal  Sys.sigpipe Sys.Signal_ignore;
  while true do
    try
      let time = update_time () in
      exec_tasks !fd_tasks;
      exec_hooks !after_select_hooks;
      exec_timers !timers;

      
      while !closed_tasks <> [] do
        match !closed_tasks with
          [] -> ()
        | t :: tail ->
            closed_tasks := tail;
            (try t.event_handler t (CLOSED t.error) with _ -> ());
      done;
      
(*      Printf.printf "before iter_timer"; print_newline (); *)
      let time = update_time () in
      timeout := infinite_timeout;
      timers := iter_timer !timers time;
(*      Printf.printf "before iter_task"; print_newline ();*)
      
      let old_tasks = !fd_tasks in
      fd_tasks := [];
      iter_task old_tasks time;

(*      Printf.printf "timeout %f" !timeout; print_newline (); *)
      
      if !timeout < 0.0001 then timeout := 0.0001;
(*      
      Printf.printf "TASKS: %d" (List.length !tasks); print_newline ();
      Printf.printf "TIMEOUT: %f" !timeout; print_newline ();
timeout := 5.;
*)
      exec_hooks !before_select_hooks;
(*      Printf.printf "Tasks %d" (List.length !fd_tasks); print_newline ();*)
      select !fd_tasks !timeout; 
    with e ->
        Printf.printf "Exception %s in Select.loop" (Printexc.to_string e);
        print_newline ();
  done
  
  
  
let shutdown t s =
  if t.fd <> dummy_fd then begin
(*      Printf.printf "SHUTDOWN"; print_newline (); *)
      (try Unix.shutdown t.fd Unix.SHUTDOWN_ALL with _ -> ());
      close t s
    end
    
let nb_sockets () = !nb_sockets
  
let _ =
  Printexc.register_exn (fun e ->
      match e with
        Unix.Unix_error (e, f, arg) ->
          Printf.sprintf "%s failed%s: %s" f (if arg = "" then "" else 
              "on " ^ arg) (Unix.error_message e)
      | _ -> raise e
  )
  
let stats buf t =
  Printf.printf "Socket %d\n" (Obj.magic t.fd)
  
let print_socket s =
  print_socket s;
  Printf.printf "  rtimeout %5.0f/%5.0f read %b & %b write %b & %b (born %f)" 
    (s.next_rtimeout -. last_time ())
  s.rtimeout
    (s.want_to_read)
  (!(s.read_allowed))
  (s.want_to_write)
  (!(s.write_allowed))
  (last_time () -. s.born)
  ;
  print_newline ()
  
let print_sockets () =
  Printf.printf "PRINT SOCKETS: %d" (List.length !fd_tasks);
  print_newline ();
  List.iter print_socket !fd_tasks;
  ()
  
let info t = t.name ()
  
let _ =
  add_timer 300. (fun t ->
      reactivate_timer t;
      if !debug then
        print_sockets ())
  
let set_printer s f =
  s.name <- f
  
let set_dump_info s f =
  s.dump_info <- f
  
let _ =
  Heap.register_dumper "BasicSocket" (fun _ ->
      Printf.printf "  %d timers" (List.length !timers); print_newline ();
      Printf.printf "  %d fd_tasks" (List.length !fd_tasks); print_newline ();
      List.iter (fun t -> t.dump_info ()) !fd_tasks;
      Printf.printf "  %d closed_tasks" (List.length !closed_tasks); print_newline ();
      List.iter (fun t -> t.dump_info ()) !closed_tasks;
  )

let prevent_close s = s.can_close <- false
let close_all () =
  List.iter (fun s ->
      if s.can_close then
        close s "close all"
  ) !fd_tasks
  
let start_time = last_time ()
  