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

val from_string : string -> string -> unit
(*d [input_file filename str] creates a file named [filename] whose content is
  [str]. *)

val to_string : string -> string
(*d [to_string filename] returns in a string the content of
 the file [filename]. *)

val to_string_alt : string -> Buffer.t
(*d [to_string_alt filename] returns in a string the content of
 the file using alternative method [filename]. *)

val iter : (string -> unit) -> string -> unit
(*d [iter f filename] read [filename] line by line, applying [f] to each
 one. *)

val to_value : string -> 'a
(*d [to_value filename] read a value from [filename] using [input_value] *)

val from_value : string -> 'a -> unit
(*d [to_value filename v] write a value [v] to [filename] using
  [output_value] *)
  