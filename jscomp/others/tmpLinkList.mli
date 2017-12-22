(** List operations.

   Some functions are flagged as not tail-recursive.  A tail-recursive
   function uses constant stack space, while a non-tail-recursive function
   uses stack space proportional to the length of its list argument, which
   can be a problem with very long lists.  When the function takes several
   list arguments, an approximate formula giving stack usage (in some
   unspecified constant unit) is shown in parentheses.

   The above considerations can usually be ignored if your lists are not
   longer than about 10000 elements.
*)
type 'a t 
val length : 'a t -> int
(** Return the length (number of elements) of the given list. *)

val hd : 'a t -> 'a
(** Return the first element of the given list. Raise
   [Failure "hd"] if the list is empty. *)

val tl : 'a t -> 'a t
(** Return the given list without its first element. Raise
   [Failure "tl"] if the list is empty. *)

val nth : 'a t -> int -> 'a
(** Return the [n]-th element of the given list.
   The first element (head of the list) is at position 0.
   Raise [Failure "nth"] if the list is too short.
   Raise [Invalid_argument "List.nth"] if [n] is negative. *)

val rev : 'a t -> 'a t
(** List reversal. *)

val append : 'a t -> 'a t -> 'a t
(** Catenate two lists.  Same function as the infix operator [@].
   Not tail-recursive (length of the first argument).  The [@]
   operator is not tail-recursive either. *)

val rev_append : 'a t -> 'a t -> 'a t
(** [List.rev_append l1 l2] reverses [l1] and concatenates it to [l2].
   This is equivalent to {!List.rev}[ l1 @ l2], but [rev_append] is
   tail-recursive and more efficient. *)

val concat : 'a t t -> 'a t
(** Concatenate a list of lists.  The elements of the argument are all
   concatenated together (in the same order) to give the result.
   Not tail-recursive
   (length of the argument + length of the longest sub-list). *)

val flatten : 'a t t -> 'a t
(** Same as [concat].  Not tail-recursive
   (length of the argument + length of the longest sub-list). *)


(** {6 Iterators} *)


val iter : ('a -> unit) -> 'a t -> unit
(** [List.iter f [a1; ...; an]] applies function [f] in turn to
   [a1; ...; an]. It is equivalent to
   [begin f a1; f a2; ...; f an; () end]. *)

val iteri : (int -> 'a -> unit) -> 'a t -> unit
(** Same as {!List.iter}, but the function is applied to the index of
   the element as first argument (counting from 0), and the element
   itself as second argument.
   @since 4.00.0
*)

val map : ('a -> 'b) -> 'a t -> 'b t
(** [List.map f [a1; ...; an]] applies function [f] to [a1, ..., an],
   and builds the list [[f a1; ...; f an]]
   with the results returned by [f].  Not tail-recursive. *)

val mapi : (int -> 'a -> 'b) -> 'a t -> 'b t
(** Same as {!List.map}, but the function is applied to the index of
   the element as first argument (counting from 0), and the element
   itself as second argument.  Not tail-recursive.
   @since 4.00.0
*)

val rev_map : ('a -> 'b) -> 'a t -> 'b t
(** [List.rev_map f l] gives the same result as
   {!List.rev}[ (]{!List.map}[ f l)], but is tail-recursive and
   more efficient. *)

val fold_left : ('a -> 'b -> 'a) -> 'a -> 'b t -> 'a
(** [List.fold_left f a [b1; ...; bn]] is
   [f (... (f (f a b1) b2) ...) bn]. *)

val fold_right : ('a -> 'b -> 'b) -> 'a t -> 'b -> 'b
(** [List.fold_right f [a1; ...; an] b] is
   [f a1 (f a2 (... (f an b) ...))].  Not tail-recursive. *)


(** {6 Iterators on two lists} *)


val iter2 : ('a -> 'b -> unit) -> 'a t -> 'b t -> unit
(** [List.iter2 f [a1; ...; an] [b1; ...; bn]] calls in turn
   [f a1 b1; ...; f an bn].
   Raise [Invalid_argument] if the two lists have
   different lengths. *)

val map2 : ('a -> 'b -> 'c) -> 'a t -> 'b t -> 'c t
(** [List.map2 f [a1; ...; an] [b1; ...; bn]] is
   [[f a1 b1; ...; f an bn]].
   Raise [Invalid_argument] if the two lists have
   different lengths.  Not tail-recursive. *)

val rev_map2 : ('a -> 'b -> 'c) -> 'a t -> 'b t -> 'c t
(** [List.rev_map2 f l1 l2] gives the same result as
   {!List.rev}[ (]{!List.map2}[ f l1 l2)], but is tail-recursive and
   more efficient. *)

val fold_left2 : ('a -> 'b -> 'c -> 'a) -> 'a -> 'b t -> 'c t -> 'a
(** [List.fold_left2 f a [b1; ...; bn] [c1; ...; cn]] is
   [f (... (f (f a b1 c1) b2 c2) ...) bn cn].
   Raise [Invalid_argument] if the two lists have
   different lengths. *)

val fold_right2 : ('a -> 'b -> 'c -> 'c) -> 'a t -> 'b t -> 'c -> 'c
(** [List.fold_right2 f [a1; ...; an] [b1; ...; bn] c] is
   [f a1 b1 (f a2 b2 (... (f an bn c) ...))].
   Raise [Invalid_argument] if the two lists have
   different lengths.  Not tail-recursive. *)


(** {6 List scanning} *)


val for_all : ('a -> bool) -> 'a t -> bool
(** [for_all p [a1; ...; an]] checks if all elements of the t
   satisfy the predicate [p]. That is, it returns
   [(p a1) && (p a2) && ... && (p an)]. *)

val exists : ('a -> bool) -> 'a t -> bool
(** [exists p [a1; ...; an]] checks if at least one element of
   the list satisfies the predicate [p]. That is, it returns
   [(p a1) || (p a2) || ... || (p an)]. *)

val for_all2 : ('a -> 'b -> bool) -> 'a t -> 'b t -> bool
(** Same as {!List.for_all}, but for a two-argument predicate.
   Raise [Invalid_argument] if the two lists have
   different lengths. *)

val exists2 : ('a -> 'b -> bool) -> 'a t -> 'b t -> bool
(** Same as {!List.exists}, but for a two-argument predicate.
   Raise [Invalid_argument] if the two lists have
   different lengths. *)

val mem : 'a -> 'a t -> bool
(** [mem a l] is true if and only if [a] is equal
   to an element of [l]. *)

val memq : 'a -> 'a t -> bool
(** Same as {!List.mem}, but uses physical equality instead of structural
   equality to compare list elements. *)


(** {6 List searching} *)


val find : ('a -> bool) -> 'a t -> 'a
(** [find p l] returns the first element of the list [l]
   that satisfies the predicate [p].
   Raise [Not_found] if there is no value that satisfies [p] in the
   list [l]. *)

val filter : ('a -> bool) -> 'a t -> 'a t
(** [filter p l] returns all the elements of the list [l]
   that satisfy the predicate [p].  The order of the elements
   in the input list is preserved.  *)

val find_all : ('a -> bool) -> 'a t -> 'a t
(** [find_all] is another name for {!List.filter}. *)

val partition : ('a -> bool) -> 'a t -> 'a t * 'a t
(** [partition p l] returns a pair of lists [(l1, l2)], where
   [l1] is the list of all the elements of [l] that
   satisfy the predicate [p], and [l2] is the list of all the
   elements of [l] that do not satisfy [p].
   The order of the elements in the input list is preserved. *)


(** {6 Association lists} *)


val assoc : 'a -> ('a * 'b) t -> 'b
(** [assoc a l] returns the value associated with key [a] in the list of
   pairs [l]. That is,
   [assoc a [ ...; (a,b); ...] = b]
   if [(a,b)] is the leftmost binding of [a] in list [l].
   Raise [Not_found] if there is no value associated with [a] in the
   list [l]. *)

val assq : 'a -> ('a * 'b) t -> 'b
(** Same as {!List.assoc}, but uses physical equality instead of structural
   equality to compare keys. *)

val mem_assoc : 'a -> ('a * 'b) t -> bool
(** Same as {!List.assoc}, but simply return true if a binding exists,
   and false if no bindings exist for the given key. *)

val mem_assq : 'a -> ('a * 'b) t -> bool
(** Same as {!List.mem_assoc}, but uses physical equality instead of
   structural equality to compare keys. *)

val remove_assoc : 'a -> ('a * 'b) t -> ('a * 'b) t
(** [remove_assoc a l] returns the list of
   pairs [l] without the first pair with key [a], if any.
   Not tail-recursive. *)

val remove_assq : 'a -> ('a * 'b) t -> ('a * 'b) t
(** Same as {!List.remove_assoc}, but uses physical equality instead
   of structural equality to compare keys.  Not tail-recursive. *)


(** {6 Lists of pairs} *)


val split : ('a * 'b) t -> 'a t * 'b t
(** Transform a list of pairs into a pair of lists:
   [split [(a1,b1); ...; (an,bn)]] is [([a1; ...; an], [b1; ...; bn])].
   Not tail-recursive.
*)

val combine : 'a t -> 'b t -> ('a * 'b) t
(** Transform a pair of lists into a list of pairs:
   [combine [a1; ...; an] [b1; ...; bn]] is
   [[(a1,b1); ...; (an,bn)]].
   Raise [Invalid_argument] if the two lists
   have different lengths.  Not tail-recursive. *)


