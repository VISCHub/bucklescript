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

let () =     
  let (=~) = eq "ZIP"   in 
  
  (N.zip [1;2;3] [3;4]) =~ [1,3; 2,4];
  N.zip [] [1] =~ [];
  N.zip [] [] =~ [];
  N.zip [1;2;3] [] =~ [] ;
  N.zip [1;2;3] [2;3;4] =~ [1,2;2,3;3,4]
let mod2 = (fun[@bs] x -> x mod 2 = 0) 
let () =   
  let (=~) = eq "PARTITION" in 
  
  (N.partition mod2 [1;2;3;2;3;4])
  =~ ([2;2;4], [1;3;3]);
  (N.partition mod2 [2;2;2;4])
  =~ ([2;2;2;4], []);
  (N.partition (fun[@bs] x -> not (mod2 x [@bs] )) [2;2;2;4])
  =~ ([], [2;2;2;4])

let () =   
  let (=~) = eq "UNZIP" in 
  N.unzip [] =~ ([],[]) ; 
  N.unzip [1,2] =~ ([1] ,[2]);
  N.unzip [1,2;3,4] =~ ([1;3], [2;4])

let () = 
  let (=~) = eq "FILTER" in 
  N.filter mod2 [1;2;3;4] =~ [2;4];
  N.filter mod2 [1;3;41] =~ [];
  N.filter mod2 [] =~ [];
  N.filter mod2 [2;2;2;4;6] =~ [2;2;2;4;6]
let id : int -> int [@bs] = fun [@bs] x -> x 

let () =   
  let (=~) = eq "MAP" in 
  N.map (N.init 5 id )(fun [@bs] x -> x * 2 ) 
  =~ [0;2;4;6;8];
  N.map [] id  =~ [];
  N.map [1] (fun [@bs] x-> -x)  =~ [-1]
let add = (fun [@bs] a b -> a + b)
let length_10_id = N.init 10 id  
let length_8_id = N.init 8 id 
let () = 
  let (=~) = eq "MAP2" in   
  let b = length_10_id in
  let c = length_8_id in 
  let d = N.init 10 (fun [@bs] x -> 2 * x ) in     
  N.map2 add length_10_id b =~ d ;
  N.map2 add [] [1] =~ [];
  N.map2 add [1] [] =~ [];
  N.map2 add [] [] =~ [];
  N.map2 add length_10_id b =~  N.(append (map c (fun[@bs] x -> x * 2)) [16;18])

let () =   
  let (=~) = eq "TAKE" in 
  N.takeOpt [1;2;3] 2 =~ Some [1;2];
  N.takeOpt [] 1 =~ None;
  N.takeOpt [1;2] 3 =~ None ; 
  N.takeOpt [1;2] 2 =~ Some [1;2];
  N.takeOpt length_10_id 8 =~ Some length_8_id ;
  N.takeOpt length_10_id 0 =~ Some []

let () =   
  let (=~) = eq "DROP" in 
  N.dropOpt length_10_id 10 =~ Some [];
  N.dropOpt length_10_id 8 =~ Some [8;9];
  N.dropOpt length_10_id 0 =~ Some length_10_id 

let () = 
  let (=~) = eq "SPLIT" in 
  let a = N.init 5 id in 
  N.splitAtOpt a 6 =~ None;
  N.splitAtOpt a 5 =~ Some (a,[]);
  N.splitAtOpt a 4 =~ Some ([0;1;2;3],[4]);
  N.splitAtOpt a 3 =~ Some ([0;1;2],[3;4]);
  N.splitAtOpt a 2 =~ Some ([0;1],[2;3;4]);
  N.splitAtOpt a 1 =~ Some ([0],[1;2;3;4]);
  N.splitAtOpt a 0 =~ Some ([],a);
  N.splitAtOpt a (-1) =~ None;
  

;; Mt.from_pair_suites __FILE__ !suites
