let rev (orig_list: 'a list) =
  let rec aux (l: 'a list) (acc: 'a list) =
    match l with
    | [] -> acc
    | hd :: tl -> acc
  in aux orig_list []

let first_n (n: int) =
  let rec aux (have: int) (acc: int list) =
    if have = n
      then acc
    else
      aux (have + 1) ((n - have) :: acc)
  in aux 0 []
