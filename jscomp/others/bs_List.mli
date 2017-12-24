(* Copyright (C) 2017 Authors of BuckleScript
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * In addition to the permissions granted to you by the LGPL, you may combine
 * or link a "work that uses the Library" with a publicly distributed version
 * of this file to produce a combined library or application, then distribute
 * that combined work under the terms of your choosing, with no requirement
 * to comply with the obligations normally placed on you by section 4 of the
 * LGPL version 3 (or the corresponding section of a later version of the LGPL
 * should you choose to use a later version).
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA. *)

type 'a t = 'a list

val headOpt : 'a list -> 'a option

val tailOpt : 'a list -> 'a list option

val nthOpt : 'a list -> int -> 'a option

val nthAssert : 'a list -> int -> 'a

val append : 'a list -> 'a t -> 'a t

val map : 'a list -> ('a -> 'b [@bs]) -> 'b t

val map2 : ('a -> 'b -> 'c [@bs]) -> 'a list -> 'b list -> 'c t

val mapi : (int -> 'a -> 'b [@bs]) -> 'a list -> 'b t

val init : int -> (int -> 'a [@bs]) -> 'a t

val length : 'a list -> int

val toArray : 'a t -> 'a array

val revAppend : 'a list -> 'a list -> 'a list

val rev : 'a list -> 'a list


val flatten : 'a list list -> 'a t

val mapRev : ('a -> 'b [@bs]) -> 'a list -> 'b list

val iter : ('a -> 'b [@bs]) -> 'a list -> unit

val iteri : (int -> 'a -> 'b [@bs]) -> 'a list -> unit

val foldLeft : ('a -> 'b -> 'a [@bs]) -> 'a -> 'b list -> 'a

val foldRight : ('a -> 'b -> 'b [@bs]) -> 'a list -> 'b -> 'b

val mapRev2 : ('a -> 'b -> 'c [@bs]) -> 'a list -> 'b list -> 'd list

val iter2 : ('a -> 'b -> 'c [@bs]) -> 'a list -> 'b list -> unit

val foldLeft2 :
  ('a -> 'b -> 'c -> 'a [@bs]) -> 'a -> 'b list -> 'c list -> 'a

val foldRight2 :
  ('a -> 'b -> 'c -> 'c [@bs]) -> 'a list -> 'b list -> 'c -> 'c

val forAll : ('a -> bool [@bs]) -> 'a list -> bool

val exists : ('a -> bool [@bs]) -> 'a list -> bool

val forAll2 : ('a -> 'b -> bool [@bs]) -> 'a list -> 'b list -> bool

val exists2 : ('a -> 'b -> bool [@bs]) -> 'a list -> 'b list -> bool

val mem : ('a -> 'b -> bool [@bs]) -> 'b -> 'a list -> bool

val memq : 'a -> 'a list -> bool

val assocOpt : ('a -> 'b -> bool [@bs]) -> 'b -> ('a * 'c) list -> 'c option

val assqOpt : 'a -> ('a * 'b) list -> 'b option

val memAssoc : ('a -> 'b -> bool [@bs]) -> 'b -> ('a * 'c) list -> bool

val memAssq : 'a -> ('a * 'b) list -> bool

val removeAssoc :
  ('a -> 'b -> bool [@bs]) -> 'b -> ('a * 'c) list -> ('a * 'c) list

val removeAssq : 'a -> ('a * 'b) list -> ('a * 'b) list

val findOpt : ('a -> bool [@bs]) -> 'a list -> 'a option

val filter : ('a -> bool [@bs]) -> 'a list -> 'a t

val partition : ('a -> bool [@bs]) -> 'a list -> 'a t * 'a t

val split : ('a * 'b) list -> 'a t * 'b t

val zip : 'a list -> 'b list -> ('a * 'b) t
