(* Copyright 2002 b8_bavard, b8_fee_carabine, INRIA *)
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

(*open LocalisationInit
open LocalisationNotif*)
open Md4

(*add one location*)
val add : Md4.t -> ServerTypes.location -> unit

(*add a liste of notification*)
(*val adds : Md4.t -> ServerMessages.LocalisationInit.localisation list -> unit*)

(*notify add and supp in server groupe cooperation*)
val notifications : Md4.t -> (bool * ServerTypes.location) list -> unit

(*val find : Md4.t -> (ServerTypes.location -> unit) -> unit*)

val supp : Md4.t -> ServerTypes.location -> unit
val remote_supp : Md4.t -> ServerTypes.location -> unit
(*val supp : Md4.t -> ServerTypes.where -> unit*)

val get : Md4.t -> DonkeyProtoServer.QueryLocationReply.t

val print : unit -> unit
val get_list_of_md4 : unit -> (Md4.t * int) list

val get_locate_table : unit -> (Md4.t*ServerTypes.location list) list

val exist : Md4.t -> Ip.t -> bool

