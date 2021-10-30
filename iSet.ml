(* projekt zaliczeniowy "modyfikacja drzew" na WPF 2020 @ MIMUW
 * autor: Pawel Balawender
 * reviewer: Mateusz Malinowski, gr.
 * data: grudzien 2020
 *
 * Copyright (C) 1996-2003 Xavier Leroy, Nicolas Cannasse, Markus Mottl, 
 *			Jacek Chrzaszcz, Pawel Balawender, Mateusz Malinowski
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version,
 * with the special exception on linking described in file LICENSE.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *)

(* int interval *)
type interv = int * int

(* interval set: Empty | (left, value, right, height, size *)
type iset =
  | Empty
  | Node of iset * interv * iset * int * int

(* less descriptive alias for the interface *)
type t = iset

(* t constructor *)
let empty = Empty

(* t selector *)
let is_empty (tree: iset) = 
  tree = Empty

(* sum without overflow *)
let isum (a: int) (b: int) =
  if a >= 0 && b > max_int - a then max_int
  else if a < 0 && b < min_int - a then min_int
  else a + b

(* interval comparison function
 * it treats overlapping intervals as equal, which need special handling *)
let compare (a: interv) (b: interv) =
  let (amin, amax) = a
  and (bmin, bmax) = b in
  if amax < bmin
    then -1
  else if bmax < amin 
    then 1
  else
    0

(* alias *)
let cmp = compare

(* get tree height *)
let height (iset: iset) =
  match iset with
  | Node (_, _, _, h, _) -> h
  | Empty -> 0

(* fetch tree size if it has already been calculated *)
let size (iset: iset) =
  match iset with
  | Node (_, _, _, _, s) -> s
  | Empty -> 0

(* calculate tree's size, not just fetch it *)
let acc_size l (lv, rv) r =
  let s = size l + size r + rv - lv + 1 in
  if s < max (size l) (size r) then max_int
  else s

(* interval length *)
let length ((x, y): interv) =
  (* we cant just take -min_int like we do further; -min_int = min_int*)
  if x = min_int then
    if y > (-2) then max_int
    else isum 2 (max_int + y)
  else
    isum 1 (isum y (-x))
    
(* contruct new tree from subtrees and the root interval *)
let make (left: iset) (value: interv) (right: iset) = 
  let new_height = max (height left) (height right) + 1
  and new_size = acc_size left value right in
  Node (left, value, right, new_height, new_size)

(* balance the tree
 * invariant:
 * initial condition:
 * final condition:
 *)
let bal (l: iset) (k: interv) (r: iset) =
  let hl = height l in
  let hr = height r in
  if hl > hr + 2 then
    match l with
    | Node (ll, lk, lr, _, _) ->
        if height ll >= height lr then make ll lk (make lr k r)
        else
          (match lr with
          | Node (lrl, lrk, lrr, _, _) ->
              make (make ll lk lrl) lrk (make lrr k r)
          | Empty -> assert false)
    | Empty -> assert false
  else if hr > hl + 2 then
    match r with
    | Node (rl, rk, rr, _, _) ->
        if height rr >= height rl then make (make l k rl) rk rr
        else
          (match rl with
          | Node (rll, rlk, rlr, _, _) ->
              make (make l k rll) rlk (make rlr rk rr)
          | Empty -> assert false)
    | Empty -> assert false
  else 
    make l k r

(* get minimal element 
 * invariant:
 * initial condition:
 * final condition:
 *)
let rec min_elt (iset: iset) =
  match iset with
  | Node (Empty, k, _, _, _) -> k
  | Node (l, _, _, _, _) -> min_elt l
  | Empty -> raise Not_found

(* remove minimal element 
 * invariant:
 * initial condition:
 * final condition:
 *)
let rec remove_min_elt (iset: iset) =
  match iset with
  | Node (Empty, _, r, _, _) -> r
  | Node (l, k, r, _, _) -> bal (remove_min_elt l) k r
  | Empty -> invalid_arg "PSet.remove_min_elt"

(* get maximal element 
 * invariant:
 * initial condition:
 * final condition:
 *)
let rec max_elt (iset: iset) =
  match iset with
  | Node (_, k, Empty, _, _) -> k
  | Node (_, _, r, _, _) -> max_elt r
  | Empty -> raise Not_found

(* remove maximal element
 * invariant:
 * initial condition:
 * final condition:
 *)
let rec remove_max_elt (iset: iset) =
  match iset with
  | Node (l, _, Empty, _, _) -> l
  | Node (l, k, r, _, _) -> bal l k (remove_max_elt r)
  | Empty -> invalid_arg "PSet.remove_max_elt"

(* merge two trees
 * invariant:
 * initial condition:
 * final condition:
 *)
let merge (tree1: iset) (tree2: iset) =
  match tree1, tree2 with
  | Empty, _ -> tree2
  | _, Empty -> tree1
  | _, _ ->
      let k = min_elt tree2 in
      bal tree1 k (remove_min_elt tree2)


(* add an interval to a tree; interval has to be disjoint with
 * the tree's intervals
 * invariant:
 * initial condition:
 * final condition:
 *)
let rec add_one_disj cmp (x: interv) (iset: iset) =
  match iset with
  | Node (l, k, r, _, _) ->
      let c = cmp x k in
      if c > 0 then
        let nr = add_one_disj cmp x r in
        bal l k nr
      else if c < 0 then
        let nl = add_one_disj cmp x l in
        bal nl k r
      else
        invalid_arg "should be disjoint"
  | Empty -> Node (Empty, x, Empty, 1, length x)

(* alias; if interval is wrong, don't add it *)
let add_one (x, y) tree = 
  if y < x then tree
  else add_one_disj compare (x, y) tree

(* join two trees to a common root
 * invariant:
 * initial condition:
 * final condition:
 *)
let rec join cmp (l: iset) (v: interv) (r: iset) =
  match (l, r) with
  | (Empty, _) -> add_one v r
  | (_, Empty) -> add_one v l
  | (Node(ll, lv, lr, lh, _), Node(rl, rv, rr, rh, _)) ->
      if lh > rh + 2 then bal ll lv (join cmp lr v r) else
      if rh > lh + 2 then bal (join cmp l v rl) rv rr else
      make l v r

(* split tree to its subtrees with elements lower and greater than x
 * invariant:
 * initial condition:
 * final condition:
 *)
let split (x: int) tree =
  let rec loop (x: int) (set: iset) =
    match set with
    | Empty ->
        (Empty, false, Empty)
    | Node (l, ((vstart, vend) as v), r, _, _) ->
        let c = cmp (x, x) (vstart, vend) in
        if c = 0 then
          if x = min_int then (Empty, true, add_one ((x+1), vend) r)
          else if x = max_int then (add_one (vstart, (x-1)) l, true, Empty)
          else (add_one (vstart, (x-1)) l, true, add_one ((x+1), vend) r)
        else if c < 0 then
          let (ll, pres, rl) = loop x l in
          (ll, pres, join cmp rl v r)
        else
          let (lr, pres, rr) = loop x r in
          (join cmp l v lr, pres, rr)
  in
  loop x tree

(* remove interval from tree
 * invariant:
 * initial condition:
 * final condition:
 *)
let remove (x: interv) (tree: iset) =
  let xstart, xend = x in
  let (new_left, _, _) = split xstart tree
  and (_, _, new_right) = split xend tree
  in merge new_left new_right

(* add: remove sum of intervals intersecting with (x, y), then add (x, y)
 * invariant:
 * initial condition:
 * final condition:
 *)
let add (x, y) (tree: iset) =
  let (left, _, _) = split x tree
  and (_, _, right) = split y tree
  in
  let (newleft, newx) =
    if left = Empty then (left, x)
    else
      let (maxl, maxr) = max_elt left in
      if maxr + 1 = x then ((remove_max_elt left), maxl)
      else (left, x)
  and (newright, newy) =
    if right = Empty then (right, y)
    else
      let (minl, minr) = min_elt right in
      if minl - 1 = y then ((remove_min_elt right), minr)
      else (right, y)
  in
  add_one (newx, newy) (merge newleft newright)

(* check if tree contains an integer
 * invariant:
 * initial condition:
 * final condition:
 *)
let mem (x: int) (tree: iset) =
  let rec loop = function
    | Node (left, root, right, _, _) ->
        let c = compare (x, x) root in
        c = 0 || loop (if c < 0 then left else right)
    | Empty -> false
  in
  loop tree

(* apply f to all intervals of tree
 * invariant:
 * initial condition:
 * final condition:
 *)
let iter f (tree: iset) =
  let rec loop = function
    | Node (left, root, right, _, _) -> 
      loop left; f root; loop right
    | Empty -> ()
  in
  loop tree

(* accumulate f along tree
 * invariant:
 * initial condition:
 * final condition:
 *)
let fold f (tree: iset) acc =
  let rec loop acc = function
    | Empty -> acc
    | Node (left, root, right, _, _) ->
          loop (f root (loop acc left)) right
  in
  loop acc tree

(* convert tree to a sorted list of its nodes
 * invariant:
 * initial condition:
 * final condition:
 *)
let elements (tree: iset) = 
  let rec loop acc = function
    | Node(l, k, r, _, _) -> loop (k :: loop acc r) l
    | Empty -> acc
  in
  loop [] tree

(* get # of numbers lower than x that belong to the tree's intervals
 * invariant:
 * initial condition:
 * final condition:
 *)
let below (x: int) (tree: iset) =
  let (left, pres, _) = split x tree in
  let blw = size left in
  if pres then
    isum 1 blw
  else
    blw

