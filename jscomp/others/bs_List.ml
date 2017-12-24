

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
external unsafeMutateTail : 
  'a t -> 'a t -> unit = "#setfield1"    
external unsafeTail :   
  'a t -> 'a t = "%field1"
(*
   [mutableCell x] == [x]
   but tell the compiler that is a mutable cell, so it wont
    be mis-inlined in the future
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

(* [precX] or [precY] can be empty 
   in that case, the address may change, so we need 
   return some value 
*)  
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




(* return the tail *)  
let rec copyAux cellX prec =
  match cellX with
  | [] -> prec
  | h::t ->
    let next = mutableCell h [] in
    (* here the mutable is mostly to telling compilers
       dont inline [next], it is mutable
    *)
    unsafeMutateTail prec next ; 
    copyAux t next

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

let append xs ys =
  match xs with
  | [] -> ys
  | h::t ->
    let cell = mutableCell h [] in       
    unsafeMutateTail (copyAux t cell) ys; 
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
  | h::r -> flattenAux (copyAux h prec) r


let rec flatten xs =     
  match xs with 
  | [] -> []
  | []::xs -> flatten xs
  | (h::t):: r ->  
    let cell = mutableCell h [] in 
    flattenAux (copyAux t cell) r ;
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


let rec split = function
    [] -> ([], [])
  | (x,y)::l ->
    let (rx, ry) = split l in (x::rx, y::ry)

let rec combine l1 l2 =
  match (l1, l2) with
    ([], []) -> []
  | (a1::l1, a2::l2) -> (a1, a2) :: combine l1 l2
  | (_, _) -> [%assert "List.combine"]

(** sorting *)

let rec merge cmp l1 l2 =
  match l1, l2 with
  | [], l2 -> l2
  | l1, [] -> l1
  | h1 :: t1, h2 :: t2 ->
    if cmp h1 h2 [@bs] <= 0
    then h1 :: merge cmp t1 l2
    else h2 :: merge cmp l1 t2
;;

let rec chop k l =
  if k = 0 then l else begin
    match l with
    | x::t -> chop (k-1) t
    | _ -> assert false
  end
;;

let stable_sort cmp l =
  let rec rev_merge l1 l2 accu =
    match l1, l2 with
    | [], l2 -> revAppend l2 accu
    | l1, [] -> revAppend l1 accu
    | h1::t1, h2::t2 ->
      if cmp h1 h2 [@bs] <= 0
      then rev_merge t1 l2 (h1::accu)
      else rev_merge l1 t2 (h2::accu)
  in
  let rec rev_merge_rev l1 l2 accu =
    match l1, l2 with
    | [], l2 -> revAppend l2 accu
    | l1, [] -> revAppend l1 accu
    | h1::t1, h2::t2 ->
      if cmp h1 h2 [@bs] > 0
      then rev_merge_rev t1 l2 (h1::accu)
      else rev_merge_rev l1 t2 (h2::accu)
  in
  let rec sort n l =
    match n, l with
    | 2, x1 :: x2 :: _ ->
      if cmp x1 x2 [@bs] <= 0 then [x1; x2] else [x2; x1]
    | 3, x1 :: x2 :: x3 :: _ ->
      if cmp x1 x2 [@bs] <= 0 then begin
        if cmp x2 x3 [@bs] <= 0 then [x1; x2; x3]
        else if cmp x1 x3 [@bs] <= 0 then [x1; x3; x2]
        else [x3; x1; x2]
      end else begin
        if cmp x1 x3 [@bs] <= 0 then [x2; x1; x3]
        else if cmp x2 x3 [@bs] <= 0 then [x2; x3; x1]
        else [x3; x2; x1]
      end
    | n, l ->
      let n1 = n asr 1 in
      let n2 = n - n1 in
      let l2 = chop n1 l in
      let s1 = rev_sort n1 l in
      let s2 = rev_sort n2 l2 in
      rev_merge_rev s1 s2 []
  and rev_sort n l =
    match n, l with
    | 2, x1 :: x2 :: _ ->
      if cmp x1 x2 [@bs] > 0 then [x1; x2] else [x2; x1]
    | 3, x1 :: x2 :: x3 :: _ ->
      if cmp x1 x2 [@bs] > 0 then begin
        if cmp x2 x3 [@bs] > 0 then [x1; x2; x3]
        else if cmp x1 x3 [@bs] > 0 then [x1; x3; x2]
        else [x3; x1; x2]
      end else begin
        if cmp x1 x3 [@bs] > 0 then [x2; x1; x3]
        else if cmp x2 x3 [@bs] > 0 then [x2; x3; x1]
        else [x3; x2; x1]
      end
    | n, l ->
      let n1 = n asr 1 in
      let n2 = n - n1 in
      let l2 = chop n1 l in
      let s1 = sort n1 l in
      let s2 = sort n2 l2 in
      rev_merge s1 s2 []
  in
  let len = length l in
  if len < 2 then l else sort len l
;;

let sort = stable_sort;;
let fast_sort = stable_sort;;

(* Note: on a list of length between about 100000 (depending on the minor
   heap size and the type of the list) and Sys.max_array_size, it is
   actually faster to use the following, but it might also use more memory
   because the argument list cannot be deallocated incrementally.

   Also, there seems to be a bug in this code or in the
   implementation of obj_truncate.

   external obj_truncate : 'a array -> int -> unit = "caml_obj_truncate"

   let array_to_list_in_place a =
   let l = Array.length a in
   let rec loop accu n p =
    if p <= 0 then accu else begin
      if p = n then begin
        obj_truncate a p;
        loop (a.(p-1) :: accu) (n-1000) (p-1)
      end else begin
        loop (a.(p-1) :: accu) n (p-1)
      end
    end
   in
   loop [] (l-1000) l
   ;;

   let stable_sort cmp l =
   let a = Array.of_list l in
   Array.stable_sort cmp a;
   array_to_list_in_place a
   ;;
*)


(** sorting + removing duplicates *)

let sort_uniq cmp l =
  let rec rev_merge l1 l2 accu =
    match l1, l2 with
    | [], l2 -> revAppend l2 accu
    | l1, [] -> revAppend l1 accu
    | h1::t1, h2::t2 ->
      let c = cmp h1 h2 [@bs] in
      if c = 0 then rev_merge t1 t2 (h1::accu)
      else if c < 0
      then rev_merge t1 l2 (h1::accu)
      else rev_merge l1 t2 (h2::accu)
  in
  let rec rev_merge_rev l1 l2 accu =
    match l1, l2 with
    | [], l2 -> revAppend l2 accu
    | l1, [] -> revAppend l1 accu
    | h1::t1, h2::t2 ->
      let c = cmp h1 h2 [@bs] in
      if c = 0 then rev_merge_rev t1 t2 (h1::accu)
      else if c > 0
      then rev_merge_rev t1 l2 (h1::accu)
      else rev_merge_rev l1 t2 (h2::accu)
  in
  let rec sort n l =
    match n, l with
    | 2, x1 :: x2 :: _ ->
      let c = cmp x1 x2 [@bs] in
      if c = 0 then [x1]
      else if c < 0 then [x1; x2] else [x2; x1]
    | 3, x1 :: x2 :: x3 :: _ ->
      let c = cmp x1 x2 [@bs] in
      if c = 0 then begin
        let c = cmp x2 x3 [@bs] in
        if c = 0 then [x2]
        else if c < 0 then [x2; x3] else [x3; x2]
      end else if c < 0 then begin
        let c = cmp x2 x3 [@bs] in
        if c = 0 then [x1; x2]
        else if c < 0 then [x1; x2; x3]
        else let c = cmp x1 x3 [@bs] in
          if c = 0 then [x1; x2]
          else if c < 0 then [x1; x3; x2]
          else [x3; x1; x2]
      end else begin
        let c = cmp x1 x3 [@bs] in
        if c = 0 then [x2; x1]
        else if c < 0 then [x2; x1; x3]
        else let c = cmp x2 x3 [@bs] in
          if c = 0 then [x2; x1]
          else if c < 0 then [x2; x3; x1]
          else [x3; x2; x1]
      end
    | n, l ->
      let n1 = n asr 1 in
      let n2 = n - n1 in
      let l2 = chop n1 l in
      let s1 = rev_sort n1 l in
      let s2 = rev_sort n2 l2 in
      rev_merge_rev s1 s2 []
  and rev_sort n l =
    match n, l with
    | 2, x1 :: x2 :: _ ->
      let c = cmp x1 x2 [@bs] in
      if c = 0 then [x1]
      else if c > 0 then [x1; x2] else [x2; x1]
    | 3, x1 :: x2 :: x3 :: _ ->
      let c = cmp x1 x2 [@bs] in
      if c = 0 then begin
        let c = cmp x2 x3 [@bs] in
        if c = 0 then [x2]
        else if c > 0 then [x2; x3] else [x3; x2]
      end else if c > 0 then begin
        let c = cmp x2 x3 [@bs] in
        if c = 0 then [x1; x2]
        else if c > 0 then [x1; x2; x3]
        else let c = cmp x1 x3 [@bs] in
          if c = 0 then [x1; x2]
          else if c > 0 then [x1; x3; x2]
          else [x3; x1; x2]
      end else begin
        let c = cmp x1 x3 [@bs] in
        if c = 0 then [x2; x1]
        else if c > 0 then [x2; x1; x3]
        else let c = cmp x2 x3 [@bs] in
          if c = 0 then [x2; x1]
          else if c > 0 then [x2; x3; x1]
          else [x3; x2; x1]
      end
    | n, l ->
      let n1 = n asr 1 in
      let n2 = n - n1 in
      let l2 = chop n1 l in
      let s1 = sort n1 l in
      let s2 = sort n2 l2 in
      rev_merge s1 s2 []
  in
  let len = length l in
  if len < 2 then l else sort len l
;;
