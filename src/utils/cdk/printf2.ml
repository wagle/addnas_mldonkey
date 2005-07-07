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


open Autoconf


external format_int: string -> int -> string = "caml_format_int"
external format_int32: string -> int32 -> string = "caml_int32_format"
external format_nativeint: string -> nativeint -> string = "caml_nativeint_format"
external format_int64: string -> int64 -> string = "caml_int64_format"
external format_float: string -> float -> string = "caml_format_float"

let bad_format fmt pos =
  invalid_arg
    ("printf: bad format " ^ String.sub fmt pos (String.length fmt - pos))

(* Format a string given a %s format, e.g. %40s or %-20s.
   To do: ignore other flags (#, +, etc)? *)

let format_string format s =
  let rec parse_format neg i =
    if i >= String.length format then (0, neg) else
    match String.unsafe_get format i with
    | '1'..'9' ->
        (int_of_string (String.sub format i (String.length format - i - 1)),
         neg)
    | '-' ->
        parse_format true (succ i)
    | _ ->
        parse_format neg (succ i) in
  let (p, neg) =
    try parse_format false 1 with Failure _ -> bad_format format 0 in
  if String.length s < p then begin
    let res = String.make p ' ' in
    if neg 
    then String.blit s 0 res 0 (String.length s)
    else String.blit s 0 res (p - String.length s) (String.length s);
    res
  end else
    s

(* Extract a %format from [fmt] between [start] and [stop] inclusive.
   '*' in the format are replaced by integers taken from the [widths] list.
   The function is somewhat optimized for the "no *" case. *)

let extract_format fmt start stop widths =
  match widths with
  | [] -> String.sub fmt start (stop - start + 1)
  | _  ->
      let b = Buffer.create (stop - start + 10) in
      let rec fill_format i w =
        if i > stop then Buffer.contents b else
          match (String.unsafe_get fmt i, w) with
            ('*', h::t) ->
              Buffer.add_string b (string_of_int h); fill_format (succ i) t
          | ('*', []) ->
              bad_format fmt start (* should not happen *)
          | (c, _) ->
              Buffer.add_char b c; fill_format (succ i) w
      in fill_format start (List.rev widths)

(* Decode a %format and act on it.
   [fmt] is the printf format style, and [pos] points to a [%] character.
   After consuming the appropriate number of arguments and formatting
   them, one of the three continuations is called:
   [cont_s] for outputting a string (args: string, next pos)
   [cont_a] for performing a %a action (args: fn, arg, next pos)
   [cont_t] for performing a %t action (args: fn, next pos)
   "next pos" is the position in [fmt] of the first character following
   the %format in [fmt]. *)

(* Note: here, rather than test explicitly against [String.length fmt]
   to detect the end of the format, we use [String.unsafe_get] and
   rely on the fact that we'll get a "nul" character if we access
   one past the end of the string.  These "nul" characters are then
   caught by the [_ -> bad_format] clauses below.
   Don't do this at home, kids. *) 

let scan_format fmt pos cont_s cont_a cont_t =
  let rec scan_flags widths i =
    match String.unsafe_get fmt i with
    | '*' ->
        Obj.magic(fun w -> scan_flags (w :: widths) (succ i))
    | '0'..'9' | '.' | '#' | '-' | ' ' | '+' -> scan_flags widths (succ i)
    | _ -> scan_conv widths i
  and scan_conv widths i =
    match String.unsafe_get fmt i with
    | '%' ->
        cont_s "%" (succ i)
    | 's' | 'S' as conv ->
        Obj.magic (fun (s: string) ->
          let s = if conv = 's' then s else "\"" ^ String.escaped s ^ "\"" in
          if i = succ pos (* optimize for common case %s *)
          then cont_s s (succ i)
          else cont_s (format_string (extract_format fmt pos i widths) s)
                      (succ i))
    | 'c' | 'C' as conv ->
        Obj.magic (fun (c: char) ->
          if conv = 'c'
          then cont_s (String.make 1 c) (succ i)
          else cont_s ("'" ^ Char.escaped c ^ "'") (succ i))
    | 'd' | 'i' | 'o' | 'x' | 'X' | 'u' ->
        Obj.magic(fun (n: int) ->
          cont_s (format_int (extract_format fmt pos i widths) n) (succ i))
    | 'f' | 'e' | 'E' | 'g' | 'G' ->
        Obj.magic(fun (f: float) ->
          cont_s (format_float (extract_format fmt pos i widths) f) (succ i))
    | 'b' ->
        Obj.magic(fun (b: bool) ->
          cont_s (string_of_bool b) (succ i))
    | 'a' ->
        Obj.magic (fun printer arg ->
          cont_a printer arg (succ i))
    | 't' ->
        Obj.magic (fun printer ->
          cont_t printer (succ i))
    | 'l' ->
        begin match String.unsafe_get fmt (succ i) with
        | 'd' | 'i' | 'o' | 'x' | 'X' | 'u' ->
            Obj.magic(fun (n: int32) ->
              cont_s (format_int32 (extract_format fmt pos (succ i) widths) n)
                     (i + 2))
        | _ ->
            bad_format fmt pos
        end
    | 'n' ->
        begin match String.unsafe_get fmt (succ i) with
        | 'd' | 'i' | 'o' | 'x' | 'X' | 'u' ->
            Obj.magic(fun (n: nativeint) ->
              cont_s (format_nativeint
                         (extract_format fmt pos (succ i) widths)
                         n)
                     (i + 2))
        | _ ->
            bad_format fmt pos
        end
    | 'L' ->
        begin match String.unsafe_get fmt (succ i) with
        | 'd' | 'i' | 'o' | 'x' | 'X' | 'u' ->
            Obj.magic(fun (n: int64) ->
              cont_s (format_int64 (extract_format fmt pos (succ i) widths) n)
                     (i + 2))
        | _ ->
            bad_format fmt pos
        end
    | _ ->
        bad_format fmt pos
  in scan_flags [] (pos + 1)
  
let cprintf kont fmt =
  let fmt = (Obj.magic fmt : string) in
  let len = String.length fmt in
  let dest = Buffer.create (len + 16) in
  let rec doprn i =
    if i >= len then begin
      let res = Buffer.contents dest in
      Buffer.clear dest;  (* just in case kprintf is partially applied *)
      Obj.magic (kont res)
    end else
    match String.unsafe_get fmt i with
    | '%' -> scan_format fmt i cont_s cont_a cont_t
    |  c  -> Buffer.add_char dest c; doprn (succ i)
  and cont_s s i =
    Buffer.add_string dest s; doprn i
  and cont_a printer arg i =
    Buffer.add_string dest (printer () arg); doprn i
  and cont_t printer i =
    Buffer.add_string dest (printer ()); doprn i
  in doprn 0

let lprintf_handler = ref (fun s ->
      Printf.printf "Message [%s] discarded\n" s;
  )

let lprintf fmt =
  cprintf (fun s -> try !lprintf_handler s with _ -> ())
  (fmt : ('a,unit, unit) format )

let lprintf_nl fmt =
  cprintf (fun s -> try !lprintf_handler (s^"\n") with _ -> ())
  (fmt : ('a,unit, unit) format )

let lprint_newline () = lprintf "\n"
let lprint_char c = lprintf "%c" c
let lprint_int c = lprintf "%d" c
let lprint_string c = lprintf "%s" c

let set_lprintf_handler f =
  lprintf_handler := f

let lprintf_max_size = ref 100
let lprintf_size = ref 0
let lprintf_fifo = Fifo.create ()
let lprintf_to_stdout = ref true

let lprintf_output = ref (Some stderr)

let _ =
  set_lprintf_handler (fun s ->
      match !lprintf_output with
        Some out when !lprintf_to_stdout ->
          Printf.fprintf out "%s" s; flush out
      | _ ->
          if !lprintf_size >= !lprintf_max_size then
            ignore (Fifo.take lprintf_fifo)
          else
            incr lprintf_size;
          Fifo.put lprintf_fifo s 
  )

let detach () =
  match !lprintf_output with
    Some oc when oc == Pervasives.stdout -> lprintf_output := None
  | _ -> ()

let close_log () =
  lprintf_to_stdout := false;
  match !lprintf_output with
    None -> ()
  | Some oc ->
      if oc != stderr && oc != stdout then
        close_out oc;
      lprintf_output := None

let log_to_file oc =
  close_log ();
  lprintf_output := Some oc;
  lprintf_to_stdout := true

let log_to_buffer buf =
  try
    while true do
      let s = Fifo.take lprintf_fifo in
      decr lprintf_size;
      Buffer.add_string buf s
    done
  with _ -> ()

let set_logging b =
  lprintf_to_stdout := b
