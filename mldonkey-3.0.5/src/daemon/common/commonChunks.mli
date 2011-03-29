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

open CommonTypes
  
type chunk_descr = {
    chunk_checksum_type : file_uid_id * int64;
    chunk_checksum : uid_type;
    chunk_pos : int64;
    chunk_size : int64;
  }
  
val add_wanted_chunk : 
  file -> chunk_descr -> (file -> chunk_descr -> unit) -> unit
  
val remove_wanted_chunk :
  file -> chunk_descr -> unit
  
val find_wanted_chunks :
  file -> chunk_descr list
  
val declare_available_chunk :
  file -> chunk_descr -> unit
  