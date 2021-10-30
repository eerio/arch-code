type expr = Add of expr * expr | Var of string

let rec fold_expr f_add f_var = function
  | Add (l, r) -> f_add (fold_expr f_add f_var l) (fold_expr f_add f_var r)
  | Var z -> f_var z

let rec st = function 
  | Add(l, r) -> max (st l) (1 + st r)
  | Var _ -> 1
(*
let optymalizuj_z_wysokoscia tree =
  let fvar z = (Var(z), 1)
  and fadd left_sub right_sub =
    let l, hl = left_sub
    and r, hr = right_sub in
    let new_height = (max hl hr + 1) in
    if hr > hl then
      Add(r, l), new_height
    else
      Add(l, r), new_height
  in
  fold_expr fadd fvar (tree, st tree)
*)


(* dla n liczby wierzcholkow drzewa expr:
  czasowa: O(nlogn), pamieciowa: O(n) 
  czemu powinno dzialac? mozemy myslec rekurencyjnie - przyjmujemy drzewo binarne.
  jesli jego obaj synowie to Var to wysokosc = max 1 (1+1) = 2,
  wiec nic nie zoptymalizujemy. jesli mamy drzewo z lewej i var z prawej,
  to wysokosc drzewa z lewej bedzie przynajmniej 2, zatem wysokosc = max (>=2) (1 + 1) >= 2
  czyli tez nie zoptyamlizujemy - jesli damy drzewo na prawo to bedzie >=3.
  jesli drzewo jest z prawej, a z lewej var - wtedy chcemy je przesunac na lewo z tego samego powodu.
  jesli natomiast obaj synowie to drzewa - chcemy wyzsze miec z lewej, by sprobowac
  uzyskac chociaz te 'jedynke' dodawana do wysokosci z prawje strony.
  taka rekurencje owijamy w fold i wychodzi cos podobnego do:
  *)
let optymalizuj tree =
  let fvar z = Var(z)
  and fadd l r =
    if (st r) > (st l) then
      Add(r, l)
    else
      Add(l, r)
  in
  fold_expr fadd fvar tree


let drzewo = (Add (Var "a", Add (Var "b", Var "c")))


let moje_comp a b =
    let x, y = (fst (fst a)), (fst (fst b))
    in
    if x = y then 0
    else if x > y then 1
    else (-1)

let overlap a b =
  let a1, a2 = a
  and b1, b2 = b
  in
  if a2 <= b1 
    then false
  else if b2 <= a1
    then false
  else
    true

let how_many interv dane =
  let rec _how_many odc lista acc =
    match lista with
    | [] -> acc
    | hd :: tl -> 
      if overlap odc hd
        then _how_many odc tl (acc + 1)
      else
        _how_many odc tl acc
  in _how_many interv dane 0


(* zwroc n pierwszych liczb naturalnych, czas: O(n), pamiec: O(n) *)
let first_n n =
  let rec _first left acc =
    if left = 0 then 
      acc
    else 
      _first (left - 1) ((n - left) :: acc)
  in List.rev (_first n [])


(* czasowa: O(n2), pamieciowa: O(n) 
  czemu dziala? po prostu dla kazdego pasazera sprawdzamy ile odcinkow ma z nim punkt wspolny z calej listy
  *)
let wirus dane =
    let rec _wirus odcinki acc =
      match odcinki with
      | [] -> acc
      | hd :: tl ->
        _wirus tl (((how_many hd dane) - 1) :: acc)
    in
    List.rev (_wirus dane [])


(* czasowa: O(n log n),, pamieciowa: O(n) 
  algorytm i czemu dziala: 

  najpierw z listy danych wejsciowych tworzymy  liste par (odcinek, numer_pasazera)
  i sortujemy ja po poczatku odcinka - O(nlogn) i po koncu odcinka (dostajemy dwie rozne posortowane listy)
  nastepnie tworzymy liste akcji dla danej chwili - czyli 
  tworzymy liste [ (t, wsiadajacy: [numery pasazerow], wysiadajacy: [numery pasazerow]) ]
  dzieki dwom posortowanym listom mnozemy zrobic to w O(n)
  nastepnie robimy rekurencje po numerze przystanku od 0 do najwyzszego wystepujacego:
  w kazdym wywolaniu zapamietujmy ile lacznie pasazerow juz sie przewinelo przez tramwaj.
  jak ktos dosiada to wrzucamy na pewna liste pomocnicza (numer dosiadajacego, current_max)
  czyli zapamietujemy stan kumulatora pasazerow jak on dosiada.
  jak wysiada to na druga liste pomocnicza wruzcamy (numer wysiadajacego, current_max, current_ile_jedzie)
  i tak do konca listy.
  jak rekurencja sie zakonczy to sortujemy obie listy pomocnicze po numerze do/wy -siadajacego
  to jest znowu O(nlogn)
  i wtedy iterujac jednoczesnie po tych listach znajdujemy roznice maxx_jak_wysiadal - maxx_jak_dosiadal 
  i dodajemyt to to current_ile_jedzie - w ten sposob juz w O(n) znajdujemy z iloma pasazerami mial kotnakt.
  i to ytyel
  *)
let wirus_lepszy dane =
    let z_indeksem = List.combine dane (first_n (List.length dane))
    in
    let posortowane = List.sort moje_comp z_indeksem
    in
    let poczatki, konce = List.split posortowane
    in
    let rec _wirus pocz kon czas maxx jedzie offsety gotowe =
      let p = List.hd pocz
      and k = List.hd kon
      in
      let mniejsze_jedzie = if k = czas then jedzie - 1 else jedzie
      in let nowe_jedzie = if p = czas then mniejsze_jedzie + 1 else mniejsze_jedzie
      and
      let nowe_maxx = max (jedzie, nowe_jedzie)
      in
      if k = czas then 
        _wirus pocz (List.tl kon) czas maxx jedzie offsety ( :: gotowe)
    in
    _wirus poczatki konce 0 0 [] []

let f = [(1,8); (2,5); (4,7); (3,4); (4,5); (6,7); (8,9)]
