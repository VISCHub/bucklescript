let suites :  Mt.pair_suites ref  = ref []
let test_id = ref 0
let eq loc x y = 
  incr test_id ; 
  suites := 
    (loc ^" id " ^ (string_of_int !test_id), (fun _ -> Mt.Eq(x,y))) :: !suites

let b loc x  = 
  incr test_id ; 
  suites := 
    (loc ^" id " ^ (string_of_int !test_id), 
     (fun _ -> Mt.Ok x)) :: !suites

(* module N = Bs.LinkList     *)
module N = Bs.List
module A = Bs.Array 

let () = 
  let u = (N.init 5 (fun[@bs] i -> i * i )) in 

  (* N.checkInvariant u ; *)
  let f i = 
    eq __LOC__ (N.nthAssert u i) (i * i) in 
  for i = 0 to 4 do 
    f i 
  done ;
  eq __LOC__  (N.map u (fun [@bs] i -> i + 1)) [1;2;5;10;17]

let () =
  eq __LOC__
    N.(flatten
        [[1]; [2]; [3];[]; init 4 (fun [@bs] i -> i )]
      )
    [1;2;3; 0;1;2;3]
    
let () = 
  eq __LOC__
    (N.
       (append 
          (init 100 (fun [@bs] i -> i) )
          (init 100 (fun [@bs] i -> i)))
     |> N.toArray
    )

    (A.
       (append 
          (init 100 (fun [@bs] i -> i) )
          (init 100 (fun [@bs] i -> i)))
    )

;; Mt.from_pair_suites __FILE__ !suites
