

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

external mutableCell : 'a -> 'a t = "%makemutable"

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

(* return the tail *)  
let rec copyAux cellX prec =
  match cellX with
  | [] -> prec
  | h::t ->
    let next = mutableCell h in
    Obj.set_field (Obj.repr prec) 1 (Obj.repr next);
    copyAux t next

let rec copyAuxWithMap f cellX prec =
  match cellX with
  | [] -> Obj.set_field (Obj.repr prec) 1 (Obj.repr [])
  | h::t ->
    let next = mutableCell (f h [@bs]) in
    Obj.set_field (Obj.repr prec) 1 (Obj.repr next);
    copyAuxWithMap f t next

let rec copyAuxWithMapI f i cellX prec =
  match cellX with
  | [] -> Obj.set_field (Obj.repr prec) 1 (Obj.repr [])
  | h::t ->
    let next = mutableCell (f i h [@bs]) in
    Obj.set_field (Obj.repr prec) 1 (Obj.repr next);
    copyAuxWithMapI f (i + 1) t next
    
let append xs ys =
  match xs with
  | [] -> ys
  | h::t ->
    let cell = mutableCell h in       
    Obj.set_field (Obj.repr @@ copyAux t cell) 1 (Obj.repr ys);
    cell

let map xs f =
  match xs with
  | [] -> []
  | h::t ->
    let cell = mutableCell (f h [@bs]) in
    copyAuxWithMap f t cell;
    cell


let rec mapi  f = function
    [] -> []
  | h::t -> 
    let cell = mutableCell (f 0 h [@bs]) in 
    copyAuxWithMapI f 1 t cell;
    cell 




let init n f =
  if n < 0 then [%assert "Invalid_argument"]
  else
  if n = 0 then []
  else
    let headX = mutableCell (f 0 [@bs]) in
    let cur = ref headX in
    let i = ref 1 in
    while !i < n do
      let v = mutableCell (f !i [@bs]) in
      Obj.set_field (Obj.repr !cur) 1 (Obj.repr v) ;
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
  | [] -> Obj.set_field (Obj.repr prec) 1 (Obj.repr [])
  | h::r -> flattenAux (copyAux h prec) r
  

let rec flatten xs =     
  match xs with 
  | [] -> []
  | []::xs -> flatten xs
  | (h::t):: r ->  
    let cell = mutableCell h in 
    flattenAux (copyAux t cell) r ;
    cell 






let rev_map f l =
  let rec rmap_f accu = function
    | [] -> accu
    | a::l -> rmap_f (f a [@bs] :: accu) l
  in
  rmap_f [] l
;;

let rec iter f = function
    [] -> ()
  | a::l -> f a [@bs]; iter f l

let rec iteri i f = function
    [] -> ()
  | a::l -> f i a [@bs]; iteri (i + 1) f l

let iteri f l = iteri 0 f l

let rec fold_left f accu l =
  match l with
    [] -> accu
  | a::l -> fold_left f (f accu a [@bs]) l

let rec fold_right f l accu =
  match l with
    [] -> accu
  | a::l -> f a (fold_right f l accu) [@bs]

let rec map2 f l1 l2 =
  match (l1, l2) with
    ([], []) -> []
  | (a1::l1, a2::l2) -> let r = f a1 a2 [@bs] in r :: map2 f l1 l2
  | (_, _) -> invalid_arg "List.map2"

let rev_map2 f l1 l2 =
  let rec rmap2_f accu l1 l2 =
    match (l1, l2) with
    | ([], []) -> accu
    | (a1::l1, a2::l2) -> rmap2_f (f a1 a2 [@bs]:: accu) l1 l2
    | (_, _) -> invalid_arg "List.rev_map2"
  in
  rmap2_f [] l1 l2
;;

let rec iter2 f l1 l2 =
  match (l1, l2) with
    ([], []) -> ()
  | (a1::l1, a2::l2) -> f a1 a2 [@bs]; iter2 f l1 l2
  | (_, _) -> invalid_arg "List.iter2"

let rec fold_left2 f accu l1 l2 =
  match (l1, l2) with
    ([], []) -> accu
  | (a1::l1, a2::l2) -> fold_left2 f (f accu a1 a2 [@bs]) l1 l2
  | (_, _) -> invalid_arg "List.fold_left2"

let rec fold_right2 f l1 l2 accu =
  match (l1, l2) with
    ([], []) -> accu
  | (a1::l1, a2::l2) -> f a1 a2 (fold_right2 f l1 l2 accu) [@bs]
  | (_, _) -> invalid_arg "List.fold_right2"

let rec for_all p = function
    [] -> true
  | a::l -> p a [@bs] && for_all p l

let rec exists p = function
    [] -> false
  | a::l -> p a [@bs] || exists p l

let rec for_all2 p l1 l2 =
  match (l1, l2) with
    ([], []) -> true
  | (a1::l1, a2::l2) -> p a1 a2 [@bs] && for_all2 p l1 l2
  | (_, _) -> invalid_arg "List.for_all2"

let rec exists2 p l1 l2 =
  match (l1, l2) with
    ([], []) -> false
  | (a1::l1, a2::l2) -> p a1 a2 [@bs] || exists2 p l1 l2
  | (_, _) -> invalid_arg "List.exists2"

let rec mem eq x = function
    [] -> false
  | a::l -> eq a x [@bs] || mem eq x l

let rec memq x = function
    [] -> false
  | a::l -> a == x || memq x l

let rec assoc eq x = function
    [] -> raise Not_found
  | (a,b)::l -> if eq a x [@bs] then b else assoc eq x l

let rec assq x = function
    [] -> raise Not_found
  | (a,b)::l -> if a == x then b else assq x l

let rec mem_assoc eq x = function
  | [] -> false
  | (a, b) :: l -> eq a x [@bs] || mem_assoc eq x l

let rec mem_assq x = function
  | [] -> false
  | (a, b) :: l -> a == x || mem_assq x l

let rec remove_assoc eq x = function
  | [] -> []
  | (a, b as pair) :: l ->
    if eq a x [@bs] then l else pair :: remove_assoc eq x l

let rec remove_assq x = function
  | [] -> []
  | (a, b as pair) :: l -> if a == x then l else pair :: remove_assq x l

let rec find p = function
  | [] -> raise Not_found
  | x :: l -> if p x [@bs] then x else find p l

let find_all p =
  let rec find accu = function
    | [] -> rev accu
    | x :: l -> if p x [@bs] then find (x :: accu) l else find accu l in
  find []

let filter = find_all

let partition p l =
  let rec part yes no = function
    | [] -> (rev yes, rev no)
    | x :: l -> if p x [@bs] then part (x :: yes) no l else part yes (x :: no) l in
  part [] [] l

let rec split = function
    [] -> ([], [])
  | (x,y)::l ->
    let (rx, ry) = split l in (x::rx, y::ry)

let rec combine l1 l2 =
  match (l1, l2) with
    ([], []) -> []
  | (a1::l1, a2::l2) -> (a1, a2) :: combine l1 l2
  | (_, _) -> invalid_arg "List.combine"

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
