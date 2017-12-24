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


(*
   perf is not everything, there are better memory represenations
   {[
     type 'a cell = {
       mutable head : 'a;
       mutable tail : 'a opt_cell
     }

     and 'a opt_cell = 'a cell Js.null

     and 'a t = {
       length : int ;
       data : 'a opt_cell
     }
   ]}
   However,
   - people use List not because of its perf, but its
   convenencie, in that case, pattern match and compatibility seems
   more attractive, we could keep a mutable list
   - The built in types would indicate that
     its construtor is immutable, a better optimizer would break such code

   {[
     type 'a t = {
       head : 'a;
       mutable tail : 'a t | int 
     }
   ]}
   In the future, we could come up with a safer version
   {[
     type 'a t =
       | Nil
       | Cons of { hd : 'a ; mutable tail : 'a t }
   ]}
*)

type 'a t = 'a list

external mutableCell : 
  'a -> 'a t ->  'a t = "#makemutablelist"
(* 
    [mutableCell x []] == [x]
    but tell the compiler that is a mutable cell, so it wont
    be mis-inlined in the future
     dont inline a binding to mutable cell, it is mutable
*)
external unsafeMutateTail : 
  'a t -> 'a t -> unit = "#setfield1"    
(*
   - the cell is not empty   
   - it is mutated
*)  
external unsafeTail :   
  'a t -> 'a t = "%field1"
(*
   - the cell is not empty   
*)

let headOpt x =
  match x with
  | [] -> None
  | x::_ -> Some x

let tailOpt x =
  match x with
  | [] -> None
  | _::xs -> Some xs 

(* Assume [n >=0] *)
let rec nthAux x n =
  match x with
  | h::t -> if n = 0 then Some h else nthAux t (n - 1)
  | _ -> None

let rec nthAuxAssert x n =
  match x with
  | h::t -> if n = 0 then h else nthAuxAssert t (n - 1)
  | _ -> [%assert "nthAssert"]

let nthOpt x n =
  if n < 0 then None
  else nthAux x n

let nthAssert x n =
  if n < 0 then [%assert "nthAssert"]
  else nthAuxAssert x n 

let rec partitionAux p cell precX precY =
  match cell with
  | [] -> ()
  | h::t ->
    let next = mutableCell h [] in
    if p h [@bs] then     
      begin 
        unsafeMutateTail precX next ;
        partitionAux p t next precY
      end 
    else 
      begin 
        unsafeMutateTail precY next ;
        partitionAux p t precX next 
      end 

let rec splitAux cell precX precY = 
  match cell with 
  | [] -> () 
  | (a,b)::t -> 
    let nextA = mutableCell a [] in 
    let nextB = mutableCell b [] in 
    unsafeMutateTail precX nextA;  
    unsafeMutateTail precY nextB; 
    splitAux t nextA nextB

(* return the tail pointer so it can continue copy other 
   list
*)  
let rec copyAuxCont cellX prec =
  match cellX with
  | [] -> prec
  | h::t ->
    let next = mutableCell h [] in
    unsafeMutateTail prec next ; 
    copyAuxCont t next

let rec copyAuxWitFilter f cellX prec =
  match cellX with
  | [] -> 
    unsafeMutateTail prec []
  | h::t ->
    if f h [@bs] then 
      begin 
        let next = mutableCell h [] in
        unsafeMutateTail prec next ; 
        copyAuxWitFilter f t next
      end
    else copyAuxWitFilter f t prec 

let rec copyAuxWithMap f cellX prec =
  match cellX with
  | [] -> 
    unsafeMutateTail prec []
  | h::t ->
    let next = mutableCell (f h [@bs]) [] in
    unsafeMutateTail prec next ; 
    copyAuxWithMap f t next


let rec zipAux  cellX cellY prec =
  match cellX, cellY with
  | h1::t1, h2::t2 -> 
    let next = mutableCell ( h1, h2) [] in
    unsafeMutateTail prec next ; 
    zipAux  t1 t2 next
  | [],_ | _,[] -> 
    ()

let rec copyAuxWithMap2 f cellX cellY prec =
  match cellX, cellY with
  | h1::t1, h2::t2 -> 
    let next = mutableCell (f h1 h2 [@bs]) [] in
    unsafeMutateTail prec next ; 
    copyAuxWithMap2 f t1 t2 next
  | [],_ | _,[] -> 
    unsafeMutateTail prec []

let rec copyAuxWithMapI f i cellX prec =
  match cellX with
  | [] -> 
    unsafeMutateTail prec []
  | h::t ->
    let next = mutableCell (f i h [@bs]) [] in
    unsafeMutateTail prec next ; 
    copyAuxWithMapI f (i + 1) t next

let rec takeAux n cell prec = 
  if n = 0 then true
  else 
    match cell with 
    | [] -> false 
    | x::xs -> 
      let cell = mutableCell x [] in 
      unsafeMutateTail prec cell; 
      takeAux (n - 1) xs cell 

let rec splitAtAux n cell prec = 
  if n = 0 then Some cell 
  else 
    match cell with 
    | [] -> None 
    | x::xs -> 
      let cell = mutableCell x [] in 
      unsafeMutateTail prec cell;  
      splitAtAux (n - 1) xs cell

(* invarint [n >= 0] *)    
let  takeOpt lst n = 
  if n < 0 then None
  else 
  if n = 0 then Some []
  else 
    match lst with
    | [] -> None 
    | x::xs -> 
      let cell = mutableCell x [] in 
      let has = takeAux (n-1) xs cell in
      if has then Some cell
      else None
(* invariant [n >= 0 ] *)
let rec dropAux l n = 
  if n = 0 then Some l
  else 
    match l with 
    | _::tl ->  dropAux tl (n -1)
    | [] -> None 

let dropOpt lst n =       
  if n < 0 then None 
  else 
    dropAux lst n 

let splitAtOpt lst n =     
  if n < 0 then None 
  else 
  if n = 0 then Some ([],lst) 
  else 
    match lst with 
    | [] ->  None 
    | x::xs -> 
      let cell = mutableCell x [] in 
      let rest = splitAtAux (n - 1) xs cell in 
      match rest with 
      | Some rest -> Some (cell, rest)
      | None -> None

let append xs ys =
  match xs with
  | [] -> ys
  | h::t ->
    let cell = mutableCell h [] in       
    unsafeMutateTail (copyAuxCont t cell) ys; 
    cell

let map xs f =
  match xs with
  | [] -> []
  | h::t ->
    let cell = mutableCell (f h [@bs]) [] in
    copyAuxWithMap f t cell;
    cell
let rec map2 f l1 l2 =
  match (l1, l2) with
  | (a1::l1, a2::l2) -> 
    let cell = mutableCell (f a1 a2 [@bs]) []  in
    copyAuxWithMap2 f l1 l2 cell; 
    cell 
  | [], _ | _, [] -> []

let rec mapi  f = function
    [] -> []
  | h::t -> 
    let cell = mutableCell (f 0 h [@bs]) [] in 
    copyAuxWithMapI f 1 t cell;
    cell 




let init n f =
  if n < 0 then [%assert "Invalid_argument"]
  else
  if n = 0 then []
  else
    let headX = mutableCell (f 0 [@bs]) [] in
    let cur = ref headX in
    let i = ref 1 in
    while !i < n do
      let v = mutableCell (f !i [@bs]) [] in
      unsafeMutateTail !cur v ; 
      cur := v ;
      incr i ;
    done
    ;
    headX

let rec lengthAux x acc =
  match x with
  | [] -> acc
  | _::t -> lengthAux t (acc + 1)

let length xs = lengthAux xs 0

let rec fillAux arr i x =
  match x with
  | [] -> ()
  | h::t ->
    Bs_Array.unsafe_set arr i h ;
    fillAux arr (i + 1) t

let toArray ( x : _ t) =
  let len = length x in
  let arr = Bs_Array.makeUninitializedUnsafe len in
  fillAux arr 0 x;
  arr


let rec revAppend l1 l2 =
  match l1 with
    [] -> l2
  | a :: l -> revAppend l (a :: l2)

let rev l = revAppend l []

let rec flattenAux prec xs =
  match xs with
  | [] -> unsafeMutateTail prec [] 
  | h::r -> flattenAux (copyAuxCont h prec) r


let rec flatten xs =     
  match xs with 
  | [] -> []
  | []::xs -> flatten xs
  | (h::t):: r ->  
    let cell = mutableCell h [] in 
    flattenAux (copyAuxCont t cell) r ;
    cell 




let rec mapRevAux f accu xs = 
  match xs with 
  | [] -> accu
  | a::l -> mapRevAux f (f a [@bs] :: accu) l

let mapRev f l =
  mapRevAux f [] l


let rec iter f = function
    [] -> ()
  | a::l -> f a [@bs]; iter f l

let rec iteri i f = function
    [] -> ()
  | a::l -> f i a [@bs]; iteri (i + 1) f l

let iteri f l = iteri 0 f l

let rec foldLeft f accu l =
  match l with
    [] -> accu
  | a::l -> foldLeft f (f accu a [@bs]) l

let rec foldRight f l accu =
  match l with
    [] -> accu
  | a::l -> f a (foldRight f l accu) [@bs]


let rec mapRevAux2 f accu l1 l2 =
  match (l1, l2) with  
  | (a1::l1, a2::l2) -> mapRevAux2  f (f a1 a2 [@bs]:: accu) l1 l2
  | (_, _) -> []

let mapRev2 f l1 l2 =
  mapRevAux2 f [] l1 l2

let rec iter2 f l1 l2 =
  match (l1, l2) with
  | (a1::l1, a2::l2) -> f a1 a2 [@bs]; iter2 f l1 l2
  | [],_ | _, [] -> ()

let rec foldLeft2 f accu l1 l2 =
  match (l1, l2) with
  | (a1::l1, a2::l2) -> foldLeft2 f (f accu a1 a2 [@bs]) l1 l2
  | [], _ | _, [] -> accu

let rec foldRight2 f l1 l2 accu =
  match (l1, l2) with
    ([], []) -> accu
  | (a1::l1, a2::l2) -> f a1 a2 (foldRight2 f l1 l2 accu) [@bs]
  | _, [] | [], _ -> accu

let rec forAll p = function
    [] -> true
  | a::l -> p a [@bs] && forAll p l

let rec exists p = function
    [] -> false
  | a::l -> p a [@bs] || exists p l

let rec forAll2 p l1 l2 =
  match (l1, l2) with
    (_, []) | [],_ -> true
  | (a1::l1, a2::l2) -> p a1 a2 [@bs] && forAll2 p l1 l2


let rec exists2 p l1 l2 =
  match (l1, l2) with
    [], _ | _, [] -> false
  | (a1::l1, a2::l2) -> p a1 a2 [@bs] || exists2 p l1 l2


let rec mem eq x = function
    [] -> false
  | a::l -> eq a x [@bs] || mem eq x l

let rec memq x = function
    [] -> false
  | a::l -> a == x || memq x l

let rec assocOpt eq x = function
    [] -> None
  | (a,b)::l -> if eq a x [@bs] then Some b else assocOpt eq x l

let rec assqOpt x = function
    [] -> None
  | (a,b)::l -> if a == x then Some b else assqOpt x l

let rec memAssoc eq x = function
  | [] -> false
  | (a, b) :: l -> eq a x [@bs] || memAssoc eq x l

let rec memAssq x = function
  | [] -> false
  | (a, b) :: l -> a == x || memAssq x l

let rec removeAssoc eq x = function
  | [] -> []
  | (a, b as pair) :: l ->
    if eq a x [@bs] then l else pair :: removeAssoc eq x l

let rec removeAssq x = function
  | [] -> []
  | (a, b as pair) :: l -> if a == x then l else pair :: removeAssq x l

let rec findOpt p = function
  | [] -> None
  | x :: l -> if p x [@bs] then Some x else findOpt p l


let rec filter p xs = 
  match xs with 
  | [] -> []
  | h::t -> 
    if p h [@bs] then 
      begin 
        let cell = (mutableCell h []) in 
        copyAuxWitFilter p t cell ;
        cell 
      end
    else 
      filter p t 


let partition p l =    
  match l with 
  | [] -> [],[]
  | h::t -> 
    let nextX = mutableCell h [] in 
    let nextY = mutableCell h [] in 
    let b = p h [@bs]  in 
    partitionAux p t nextX nextY;
    if b then 
      nextX, unsafeTail nextY  
    else       
      unsafeTail nextX, nextY 


let rec unzip xs = 
  match xs with 
  | [] -> ([], [])
  | (x,y)::l ->
    let cellX = mutableCell x [] in
    let cellY = mutableCell y [] in 
    splitAux l cellX cellY ; 
    cellX, cellY


let rec zip l1 l2 =
  match (l1, l2) with
    _, [] | [], _ -> []
  | (a1::l1, a2::l2) -> 
    let cell = mutableCell (a1,a2) [] in 
    zipAux l1 l2 cell; 
    cell

