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

val to_list : ('a, 'b) Hashtbl.t -> 'b list

val to_list2 : ('a, 'b) Hashtbl.t -> ('a * 'b) list
  
(* can be used with a function that can modify the hashtbl *)
val safe_iter : ('a -> unit) -> ('b, 'a) Hashtbl.t -> unit

(*

(* Module [Hashtbl2]: hash tables and hash functions *)

(* Hash tables are hashed association tables, with in-place modification. *)

(*** Generic interface *)

type ('a, 'b) t
        (* The type of hash tables from type ['a] to type ['b]. *)

val create : int -> ('a,'b) t
        (* [Hashtbl.create n] creates a new, empty hash table, with
           initial size [n].  For best results, [n] should be on the
           order of the expected number of elements that will be in
           the table.  The table grows as needed, so [n] is just an
           initial guess. *)

val clear : ('a, 'b) t -> unit
        (* Empty a hash table. *)

val add : ('a, 'b) t -> 'a -> 'b -> unit
        (* [Hashtbl.add tbl x y] adds a binding of [x] to [y] in table [tbl].
           Previous bindings for [x] are not removed, but simply
           hidden. That is, after performing [Hashtbl.remove tbl x],
           the previous binding for [x], if any, is restored.
           (Same behavior as with association lists.) *)

val find : ('a, 'b) t -> 'a -> 'b
        (* [Hashtbl.find tbl x] returns the current binding of [x] in [tbl],
           or raises [Not_found] if no such binding exists. *)

val find_all : ('a, 'b) t -> 'a -> 'b list
        (* [Hashtbl.find_all tbl x] returns the list of all data
           associated with [x] in [tbl].
           The current binding is returned first, then the previous
           bindings, in reverse order of introduction in the table. *)

val mem :  ('a, 'b) t -> 'a -> bool
        (* [Hashtbl.mem tbl x] checks if [x] is bound in [tbl]. *)

val remove : ('a, 'b) t -> 'a -> unit
        (* [Hashtbl.remove tbl x] removes the current binding of [x] in [tbl],
           restoring the previous binding if it exists.
           It does nothing if [x] is not bound in [tbl]. *)

val replace : ('a, 'b) t -> 'a -> 'b -> unit
        (* [Hashtbl.replace tbl x y] replaces the current binding of [x]
           in [tbl] by a binding of [x] to [y].  If [x] is unbound in [tbl],
           a binding of [x] to [y] is added to [tbl].
           This is functionally equivalent to [Hashtbl.remove tbl x]
           followed by [Hashtbl.add tbl x y]. *)

val iter : ('a -> 'b -> unit) -> ('a, 'b) t -> unit
        (* [Hashtbl.iter f tbl] applies [f] to all bindings in table [tbl].
           [f] receives the key as first argument, and the associated value
           as second argument. The order in which the bindings are passed to
           [f] is unspecified. Each binding is presented exactly once
           to [f]. *)

val fold : ('a -> 'b -> 'c -> 'c) -> ('a, 'b) t -> 'c -> 'c
        (* [Hashtbl.fold f tbl init] computes
           [(f kN dN ... (f k1 d1 init)...)],
           where [k1 ... kN] are the keys of all bindings in [tbl],
           and [d1 ... dN] are the associated values.
           The order in which the bindings are passed to
           [f] is unspecified. Each binding is presented exactly once
           to [f]. *)

val to_list : ('a, 'b) t -> 'b list
  
(*** Functorial interface *)

module type HashedType =
  sig
    type t
    val equal: t -> t -> bool
    val hash: t -> int
  end
        (* The input signature of the functor [Hashtbl.Make].
           [t] is the type of keys.
           [equal] is the equality predicate used to compare keys.
           [hash] is a hashing function on keys, returning a non-negative
           integer. It must be such that if two keys are equal according
           to [equal], then they must have identical hash values as computed
           by [hash].
           Examples: suitable ([equal], [hash]) pairs for arbitrary key
           types include
           ([(=)], [Hashtbl.hash]) for comparing objects by structure, and
           ([(==)], [Hashtbl.hash]) for comparing objects by addresses
           (e.g. for mutable or cyclic keys). *)

module type S =
  sig
    type key
    type 'a t
    val create: int -> 'a t
    val clear: 'a t -> unit
    val add: 'a t -> key -> 'a -> unit
    val remove: 'a t -> key -> unit
    val find: 'a t -> key -> 'a
    val find_all: 'a t -> key -> 'a list
    val replace: 'a t -> key -> 'a -> unit
    val mem: 'a t -> key -> bool
    val iter: (key -> 'a -> unit) -> 'a t -> unit
    val fold: (key -> 'a -> 'b -> 'b) -> 'a t -> 'b -> 'b
  end

module Make(H: HashedType): (S with type key = H.t)

        (* The functor [Hashtbl.Make] returns a structure containing
           a type [key] of keys and a type ['a t] of hash tables
           associating data of type ['a] to keys of type [key].
           The operations perform similarly to those of the generic
           interface, but use the hashing and equality functions
           specified in the functor argument [H] instead of generic
           equality and hashing. *)

(*** The polymorphic hash primitive *)

val hash : 'a -> int
        (* [Hashtbl.hash x] associates a positive integer to any value of
           any type. It is guaranteed that
                if [x = y], then [hash x = hash y]. 
           Moreover, [hash] always terminates, even on cyclic
           structures. *)

external hash_param : int -> int -> 'a -> int = "hash_univ_param" "noalloc"
        (* [Hashtbl.hash_param n m x] computes a hash value for [x], with the
           same properties as for [hash]. The two extra parameters [n] and
           [m] give more precise control over hashing. Hashing performs a
           depth-first, right-to-left traversal of the structure [x], stopping
           after [n] meaningful nodes were encountered, or [m] nodes,
           meaningful or not, were encountered. Meaningful nodes are: integers;
           floating-point numbers; strings; characters; booleans; and constant
           constructors. Larger values of [m] and [n] means that more
           nodes are taken into account to compute the final hash
           value, and therefore collisions are less likely to happen.
           However, hashing takes longer. The parameters [m] and [n]
           govern the tradeoff between accuracy and speed. *)

    *)
