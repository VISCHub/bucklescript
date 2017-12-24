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

val headOpt : 'a t -> 'a option

val tailOpt : 'a t -> 'a t option

val nthOpt : 'a t -> int -> 'a option

val nthAssert : 'a t -> int -> 'a

val dropOpt : 'a t -> int -> 'a t option 

val takeOpt : 'a t -> int -> 'a t option 

val splitAtOpt : 'a t -> int -> ('a list * 'a list) option 

val append : 'a t -> 'a t -> 'a t

val map : 'a t -> ('a -> 'b [@bs]) -> 'b t

val map2 : ('a -> 'b -> 'c [@bs]) -> 'a t -> 'b t -> 'c t

val mapi : (int -> 'a -> 'b [@bs]) -> 'a t -> 'b t

val init : int -> (int -> 'a [@bs]) -> 'a t

val length : 'a t -> int

val toArray : 'a t -> 'a array

val revAppend : 'a t -> 'a t -> 'a t

val rev : 'a t -> 'a t


val flatten : 'a t t -> 'a t

val mapRev : ('a -> 'b [@bs]) -> 'a t -> 'b t

val iter : ('a -> 'b [@bs]) -> 'a t -> unit

val iteri : (int -> 'a -> 'b [@bs]) -> 'a t -> unit

val foldLeft : ('a -> 'b -> 'a [@bs]) -> 'a -> 'b t -> 'a

val foldRight : ('a -> 'b -> 'b [@bs]) -> 'a t -> 'b -> 'b

val mapRev2 : ('a -> 'b -> 'c [@bs]) -> 'a t -> 'b t -> 'd t

val iter2 : ('a -> 'b -> 'c [@bs]) -> 'a t -> 'b t -> unit

val foldLeft2 :
  ('a -> 'b -> 'c -> 'a [@bs]) -> 'a -> 'b t -> 'c t -> 'a

val foldRight2 :
  ('a -> 'b -> 'c -> 'c [@bs]) -> 'a t -> 'b t -> 'c -> 'c

val forAll : ('a -> bool [@bs]) -> 'a t -> bool

val exists : ('a -> bool [@bs]) -> 'a t -> bool

val forAll2 : ('a -> 'b -> bool [@bs]) -> 'a t -> 'b t -> bool

val exists2 : ('a -> 'b -> bool [@bs]) -> 'a t -> 'b t -> bool

val mem : ('a -> 'b -> bool [@bs]) -> 'b -> 'a t -> bool

val memq : 'a -> 'a t -> bool

val assocOpt : ('a -> 'b -> bool [@bs]) -> 'b -> ('a * 'c) t -> 'c option

val assqOpt : 'a -> ('a * 'b) t -> 'b option

val memAssoc : ('a -> 'b -> bool [@bs]) -> 'b -> ('a * 'c) t -> bool

val memAssq : 'a -> ('a * 'b) t -> bool

val removeAssoc :
  ('a -> 'b -> bool [@bs]) -> 'b -> ('a * 'c) t -> ('a * 'c) t

val removeAssq : 'a -> ('a * 'b) t -> ('a * 'b) t

val findOpt : ('a -> bool [@bs]) -> 'a t -> 'a option

val filter : ('a -> bool [@bs]) -> 'a t -> 'a t

val partition : ('a -> bool [@bs]) -> 'a t -> 'a t * 'a t

val unzip : ('a * 'b) t -> 'a t * 'b t

val zip : 'a t -> 'b t -> ('a * 'b) t
