let wzrostx l =
  let rec _wzrost lista cur_seq cur_len last_n best_seq best_len =
    match lista with
    | [] ->
      if cur_len > best_len then 
        cur_seq 
      else
        best_seq
    | hd :: tl ->
      if hd <= last_n then
        _wzrost tl [hd] 1 hd best_seq best_len
      else if cur_len < best_len then
        _wzrost tl (hd :: cur_seq) (cur_len + 1) hd best_seq best_len
      else
        _wzrost tl (hd :: cur_seq) (cur_len + 1) hd (hd :: cur_seq) (cur_len+1)
  in
  _wzrost l [] 0 min_int [] 0

let wzrost lista =
  let aux acc new_elt =
    let cur_seq, cur_len, last_n, best_seq, best_len = acc
    in
    if new_elt <= last_n then
      ([new_elt],         1,          new_elt, best_seq,          best_len)
    else if cur_len < best_len then
      (new_elt::cur_seq,  cur_len+1,  new_elt, best_seq,          best_len)
    else
      (new_elt::cur_seq,  cur_len+1,  new_elt, new_elt::cur_seq,  cur_len+1)
  in
  let _, _, _, best_seq, _ = List.fold_left aux ([], 0, min_int, [], 0) lista
  in List.rev best_seq

let gorki lista =
  let aux acc new_elt =
    let last, trend, prev = acc
    in
    if new_elt <= last && trend = 1 then
      (new_elt, 0, last :: prev)
    else if new_elt > last && trend = 0 then
      (new_elt, 1, prev)
    else
      (new_elt, trend, prev)
  in
  let _, _, res = List.fold_left aux (min_int, 1, []) lista
  in List.rev res

let f = [3;4;0;-1;2;3;7;6;7;8];;
