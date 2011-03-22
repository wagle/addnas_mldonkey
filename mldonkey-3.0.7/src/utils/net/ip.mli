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
type t
  
val of_inet_addr : Unix.inet_addr -> t
val of_string : string -> t
val of_ints : int * int * int * int -> t
val get_lo16: t -> int
val get_hi16: t -> int

val to_inet_addr : t -> Unix.inet_addr
val to_string : t -> string
val to_ints : t -> int * int * int * int

val to_fixed_string : t -> string

val valid : t -> bool
val local_ip : t -> bool
val reachable : t -> bool
val usable : t -> bool
val banned : (t * int option -> string option) ref
  
val resolve_one : t -> string
val matches : t -> t list -> bool
val compare : t -> t -> int
val succ : t -> t
val pred : t -> t
  
val localhost : t

val mask_of_shift : int -> t
val network_address : t -> t -> t
val broadcast_address : t -> t -> t

val to_sockaddr : t -> int -> Unix.sockaddr

val from_name : string -> t
  
val option : t Options.option_class
  
val to_int64 : t -> int64
val of_int64 : int64 -> t
  
val my : unit -> t
val any : t
val null : t
  
val rev:t -> t
val equal : t -> t -> bool
val value_to_ip : Options.option_value -> t
val ip_to_value : t -> Options.option_value
  
val async_ip : string -> (t -> unit) -> (int -> unit) -> unit
  
type addr =
  AddrIp of t | AddrName of string
  
val ip_of_addr : addr -> t
val async_ip_of_addr : addr -> (t -> unit) -> (int -> unit) -> unit
val string_of_addr : addr -> string
val addr_of_ip : t -> addr
val addr_of_string : string -> addr

val value_to_addr : Options.option_value -> addr
val addr_to_value : addr -> Options.option_value
val addr_option : addr Options.option_class
  
val allow_local_network : bool ref
  
type ip_range =
  RangeSingleIp of t | RangeRange of t * t | RangeCIDR of t * int 

val localhost_range : ip_range

val range_option : ip_range Options.option_class
val value_to_iprange : Options.option_value -> ip_range
val iprange_to_value : ip_range -> Options.option_value

val range_of_string : string -> ip_range
val string_of_range : ip_range -> string
