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

open Md4

val index_result : CommonTypes.result_info -> DonkeyTypes.result
val index_result_no_filter : 
  CommonTypes.result_info -> DonkeyTypes.result
  
val find : CommonTypes.search -> unit
  
val clear : unit -> unit
  
val init : unit -> unit
  
val add_name : CommonTypes.result_info -> string -> unit
  
val find_names : Md4.t -> string list
  
val load_comments : string -> unit
val save_comments : unit -> unit
val add_comment : Md4.t -> string -> unit
  
val load_old_history : unit -> unit
  
val add_to_local_index_timer : unit -> unit
  
val find_result : Md4.t -> DonkeyTypes.result

val save_history : unit -> unit
val install_hooks : unit -> unit
  