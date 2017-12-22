

type 'a cell = {
  mutable head : 'a;
  mutable tail : 'a opt_cell
}

and 'a opt_cell = 'a cell Js.null

and 'a t = {
  length : int ;
  data : 'a opt_cell
} [@@bs.deriving abstract]


external assertAsNonNull : 'a Js.null -> 'a = "%identity"
external tailOption : 'a cell -> 'a cell option = "tail" [@@bs.get] [@@bs.return null_to_opt] 

let toOpt  =  Js.nullToOption
let return = Js.Null.return 
let empty = Js.Null.empty

let headOpt ( x  : _ t) = 
  toOpt (data x)

let tailOpt (x : _ t) =
  match toOpt (data x ) with 
  | None -> None
  | Some x -> tailOption x 

let rec lengthCellAux (x : _ opt_cell) acc =   
  match toOpt x with 
  | None -> acc 
  | Some x -> lengthCellAux (tail x) (acc + 1)

let checkInvariant (x : _ t) : unit =  
  [%assert length x = lengthCellAux ( data x ) 0]

let rec nextAuxAssert (opt_cell : 'a opt_cell) n =   
  let cell = (assertAsNonNull opt_cell) in 
  if n = 0 then 
    (head cell)
  else 
    nextAuxAssert (tail cell) (n - 1)

let nthOpt x n =   
  if n < 0 then None 
  else if n < (length x) then  
    Some (nextAuxAssert  (data x) n)
  else 
    None

let nthAssert  x n =
  if n < 0 then [%assert "Neg"]
  else nextAuxAssert (data x) n 

let rec copyAux (cellX : _ opt_cell)  (prec : _ cell) = 
  match toOpt cellX with 
  | None -> prec
  | Some cellX -> 
    let h, t = head cellX, tail cellX in 
    let next = cell ~head:h ~tail:empty in 
    tailSet prec (return next);
    copyAux t next 

let copyNonEmptyTo xs  ys = 
  let cell = cell ~head:(head xs) ~tail:empty in 
  let newTail = copyAux (tail xs) cell in 
  tailSet newTail ys; 
  cell 

let append (x : 'a t) (y : 'a t) : 'a t =      
  let lenX = length x in  
  if lenX = 0 then y 
  else 
    let lenY = length y in 
    if lenY = 0 then x
    else 
      let h =  assertAsNonNull (data x)  in 
      (* let cell = cell ~head:(head h) ~tail:empty in 
      let newTail = copyAux (tail h) cell  in 
      tailSet newTail (data y) ;  *)
      let cell = copyNonEmptyTo h (data y) in 
      t ~length:(lenX + lenY) ~data:(return cell )


let init n f = 
  if n < 0 then [%assert "Invalid_argument"]
  else 
  if n = 0 then 
    t ~length:0 ~data:empty (* TODO could be shared *)
  else 
    let headX = (cell ~head:(f 0 [@bs]) ~tail:empty) in 
    let  cur = ref headX in 
    let i = ref 1 in 
    while !i < n do 
      let v = cell ~head:(f !i [@bs]) ~tail:empty in 
      tailSet !cur (return v);
      cur := v;
      incr i; 
    done ;
    t ~length:n ~data:(return headX)

let rec fillAux arr i (cell_opt : _ opt_cell) =       
  match toOpt cell_opt with 
  | None -> ()
  | Some x ->
    Bs_Array.unsafe_set arr i (head x) ; 
    fillAux arr (i + 1) (tail x)

let toArray (x : _ t) = 
  let len = length x in 
  let arr = Bs.Array.makeUninitializedUnsafe len in 
  fillAux arr 0 (data x);
  arr