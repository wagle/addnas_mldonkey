
let execvp_command cmd args handler = failwith "Not yet implemented"
(*
val exec_command : string -> string array -> handler -> t * t
*)  

(*
let exec_command cmd args handler =
  let (in_read, output) = Unix.pipe() in
  let (input, out_write) = Unix.pipe() in
  match Unix.fork() with
    0 -> begin
        try
          match Unix.fork () with
            0 -> begin
                try
                  if input <> Unix.stdin then
                    begin Unix.dup2 input Unix.stdin; Unix.close input end;
                  if output <> Unix.stdout then
                    begin Unix.dup2 output Unix.stdout; Unix.close output end;
                  Unix.close in_read;
                  Unix.close out_write;
                  Unix.execv cmd args;
                  exit 127
                with e -> 
                    Printf.eprintf "Exception %s in exec_command\n"
                      (Printexc2.to_string e) ; 
                    exit 1
              end
          | id -> 
              exit 2
        with _ -> 
            exit 3
      end
  | id -> 
      ignore (snd(Unix.waitpid [] id));
      Unix.close input;
      Unix.close output;
      let t_in = create "pipe_int" in_read handler in
      let t_out = create "pipe_out" out_write (fun _ _ -> ()) in
      must_read (sock t_out) false;
      (t_in, t_out)
  *)

let fork_and_exec cmd ?vars args = ()

(*
let fork_and_exec cmd args = 
            match Unix.fork() with
              0 -> begin
                  try
                    match Unix.fork() with
                      0 -> begin
                          try
                            Unix.execv cmd args;
                            exit 0
                          with e -> 
                              lprintf "Exception %s while starting file_completed_cmd" (Printexc2.to_string e); lprint_newline ();
                              exit 127
                        end
                    | id -> exit 0
                  with _ -> exit 0
                end
            | id -> ignore (snd(Unix.waitpid [] id))
*)

let setuid uid = ()
let setgid gid = ()
let set_close_on_exec fd = ()
let set_signal signal f = Sys.set_signal signal f
  
let max_filedescs = 50
  
let chroot _ = ()

external set_nonblock: Unix.file_descr -> unit = "ml_set_nonblock"
external set_console_title : string -> unit = "os_set_console_title"

let mini (x: int) y = if x < y then x else y

let write fd s pos len = Unix.write fd s pos (mini len 16000)

let glibc_version_num () = ""
