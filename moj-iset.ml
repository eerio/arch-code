(* projekt zaliczeniowy "modyfikacja drzew" na WPF 2020 @ MIMUW
 * autor: Pawel Balawender
 * para do code review: Mateusz Malinowski, gr.
 * data: listopad 2020
 *)

(* int interval *)
type interv = int * int

(* interval set: Empty | (left, value, right, height, n of ints in tree *)
type t =
  | Empty
  | Node of t * interv * t * int * int

(* ------------------------------------------------------------------------- *)
(* sum without overflow *)
let isum (a: int) (b: int) =
  if a >= 0 && b >= 0 && a >= max_int - b
    then max_int
  else if a <= 0 && b <= 0 && a <= min_int - b
    then min_int
  else
    a + b

(* interval comparison function
 * it treats overlapping intervals as equal, which need special handling *)
let compare (a: interv) (b: interv) =
  let (amin, amax) = a
  and (bmin, bmax) = b in
  if amax < bmin
    then -1
  else if
    bmax < amin then 1
  else
    0
let cmp = compare

(* t constructor *)
let empty = Empty

(* t selector *)
let is_empty (tree: t) =
  tree = Empty

(* get tree height *)
let height (tree: t) =
  match tree with
  | Node (_, _, _, h, _) -> h
  | Empty -> 0

(* get interval length *)
let length (root: interv) =
  let x, y = root
  in isum (isum y (-x)) 1

(* get tree size *)
let rec get_size (tree: t) =
  match tree with
  | Node (_, _, _, _, s) -> s
  | Empty -> 0

(* not select the tree size, but calculate it *)
let rec calc_size (left: t) (root: interv) (right: t) =
  isum (length root) (isum (get_size left) (get_size right))

(* contruct new tree from subtrees and the root interval *)
let make (left: t) (root: interv) (right: t) = 
  let new_height = max (height left) (height right) + 1
  and new_size = calc_size left root right in
  Node (left, root, right, new_height, new_size)

(* tree balancer *)
let bal (left: t) (root: interv) (right: t) =
  let hl = height left in
  let hr = height right in
  if hl > hr + 2 then
    match left with
    | Node (ll, lk, lr, _, _) ->
        if height ll >= height lr then make ll lk (make lr root right)
        else
          (match lr with
          | Node (lrl, lrk, lrr, _, _) ->
              make (make ll lk lrl) lrk (make lrr root right)
          | Empty -> assert false)
    | Empty -> assert false
  else if hr > hl + 2 then
    match right with
    | Node (rl, rk, rr, _, _) ->
        if height rr >= height rl then make (make left root rl) rk rr
        else
          (match rl with
          | Node (rll, rlk, rlr, _, _) ->
              make (make left root rll) rlk (make rlr rk rr)
          | Empty -> assert false)
    | Empty -> assert false
  else 
    make left root right

(* get minimal element *)
let rec min_elt (t: t) =
  match t with
  | Node (Empty, root, _, _, _) -> root
  | Node (left, _, _, _, _) -> min_elt left
  | Empty -> raise Not_found

(* remove minimal element *)
let rec remove_min_elt (t: t) =
  match t with
  | Node (Empty, _, right, _, _) -> right
  | Node (left, root, right, _, _) -> bal (remove_min_elt left) root right
  | Empty -> invalid_arg "PSet.remove_min_elt"

(* get maximal element *)
let rec max_elt (t: t) =
  match t with
  | Node (_, root, Empty, _, _) -> root
  | Node (_, _, r, _, _) -> max_elt r
  | Empty -> invalid_arg "PSet.remove_max_elt"

(* remove maximal element *)
let rec remove_max_elt (t: t) =
  match t with
  | Node (l, _, Empty, _, _) -> l
  | Node (l, root, r, _, _) -> bal l root (remove_max_elt r)
  | Empty -> failwith "no max elt"

(* merge two trees *)
let merge (left: t) (right: t) =
  match left, right with
  | Empty, _ -> right
  | _, Empty -> left
  | _, _ ->
      let root = min_elt right in
      bal left root (remove_min_elt right)

(* add an interval to a tree; interval has to be disjoint with
 * the tree's intervals *)
let rec add_one_disj cmp (x: interv) (t: t) =
  match t with
  | Node (left, root, right, _, _) ->
      let c = cmp x root in
      if c < 0 then
        let new_left = add_one_disj cmp x left in
        bal new_left root right
      else if c > 0 then
        let new_right = add_one_disj cmp x right in
        bal left root new_right
      else
        failwith "should be disjoint"
  | Empty -> Node (Empty, x, Empty, 1, length x)

(* alias *)
let add_one = add_one_disj compare

(* join two trees to a common root *)
let rec join (left: t) (root: interv) (right: t) =
  match (left, right) with
  | (Empty, _) -> add_one root right
  | (_, Empty) -> add_one root left
  | (Node(ll, lv, lr, lh, _), Node(rl, rv, rr, rh, _)) ->
      if lh > rh + 2 then 
        bal ll lv (join lr root right)
      else if rh > lh + 2 then
        bal (join left root rl) rv rr
      else
        make left root right



(* split tree to its subtrees with elements lower and greater than x *)
let split (x: int) (tree: t) =
  let rec loop (x: int) (set: t) =
    match set with
    | Empty ->
        (Empty, false, Empty)
    | Node (left, ((vstart, vend) as root), right, _, _) ->
        let c = cmp (x, x) root in
        if c = 0 then
          let new_left = 
            if x = min_int then Empty
            else add_one (vstart, x-1) left
          and new_right = 
            if x = max_int then Empty
            else add_one (x+1, vend) right
          in 
          (new_left, true, new_right)
        else if c < 0 then
          let (ll, pres, rl) = loop x left in
          (ll, pres, join rl root right)
        else
          let (lr, pres, rr) = loop x right in
          (join left root lr, pres, rr)
  in
  let setl, pres, setr = loop x tree in
  (setl, pres, setr)

(* remove interval from tree *)
let remove (x: interv) (tree: t) =
  let xstart, xend = x in
  let (new_left, _, _) = split xstart tree
  and (_, _, new_right) = split xend tree
  in merge new_left new_right

(* add interval to a tree *)
let add (xstart, xend) (tree: t) =
  if xend < xstart
    then failwith "invalid interval"
  else
    let (left, _, right) = split xstart tree in
    let (l2, x2) =
      if (is_empty left) then (left, xstart)
      else
        let (maxl, maxr) = max_elt left in
        if maxr + 1 = xstart then (remove_max_elt left, maxl)
        else (left, xstart)
    and (r2, y2) =
      let (_, _, rtemp) = split xend right in
      if (is_empty rtemp) then (rtemp, xend)
      else
        let (minl, minr) = min_elt rtemp in
        if xend + 1 = minl then (remove_min_elt rtemp, minr)
        else (rtemp, xend)
  in
  add_one (x2, y2) (merge l2 r2)

(* check if tree contains an integer *)
let mem (x: int) (tree: t) =
  let rec loop = function
    | Node (left, root, right, _, _) ->
        let c = cmp (x, x) root in
        c = 0 || loop (if c < 0 then left else right)
    | Empty -> false
  in
  loop tree

(* apply f to all intervals of tree *)
let iter f (tree: t) =
  let rec loop = function
    | Node (left, root, right, _, _) -> loop left; f root; loop right
    | Empty -> ()
  in
  loop tree

(* accumulate f along tree *)
let fold f (tree: t) acc =
  let rec loop acc = function
    | Node (left, root, right, _, _) -> loop (f root (loop acc left)) right
    | Empty -> acc
  in
  loop acc tree

(* convert tree to a sorted list of its nodes *)
let elements (tree: t) = 
  let rec loop acc = function
    | Node(left, root, right, _, _) -> loop (root :: loop acc right) left
    | Empty -> acc
  in
  loop [] tree

(* get n of ints below x *)
let below (x: int) (tree: t) =
  let (left, pres, _) = split x tree in
  let left_size = get_size left in
  if
  let s = get_size left in
  if s = max_int then s
  else if pres then (s + 1)
  else s
