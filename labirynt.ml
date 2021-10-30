
let nolabel = .. (* jakikolwiek label dla modulu GRAPH z pliku grafy.ml Pana Kubicy *)


(* zlozonosc czasowa: O(e^2), bo z kazdego wierzcholka puszczam dfs
 * zlozonosc pamieciowa: O(e) dla e=O(nm) = liczba krawedzi w grafie
 *)
let labirynt m n segmenty =
    let result = mutable []

    (* ze wspolrzednych punktu kratowego wez numer odpowiadajacego wierzcholka *)
    and get_node x y =
        y * m + x
    and get_xy n =
        (n % m, n // m) (* // - dzielenie calkowite *)
    
    (* z segmentu z zadania znajdz poczatek i koniec odpowiadajacej sciany *)
    and parse_seg seg =
        let x0, y0, dir = seg in;
        let x1, y1 = ((x0 + 1), y0) if dir else (x0, (y0 + 1))
        (x0, y0, x1, y1)
    in
    
    (* zainicjalizuj ramke labiryntu *)
    and border = mutable [] in
    begin
    for y = 0 to n-1 do
        border := ((get_node 0 y), (get_node 0 (y+1))) :: border;
        border := ((get_node m y), (get_node m (y+1))) :: border;
    done;
    for x = 0 to m-1 do
        border := ((get_node x 0), (get_node (x+1) 0)) :: border;
        border := ((get_node x n), (get_node (x+1) n)) :: border;
    done
    end
    
    (* bedziemy trzymac sciany w grafie. jego wierzcholki odpowiadaja
     * 'skrzyzowaniom' miedzy polami labiryntu, tj. jest ich (m+1) * (n+1)
     * natomiast krawedzie - scianom. kazde 'skrzyzowanie' odpowiadajace
     * punktowi kratowemu (x, y) jest reprezentowane jednoznacznie przez
     * wierzcholek o numerze (y * szerokosc_labiryntu + x)
     *)
    let g = mutable Graph.init (m+1)*(n+1) border in
    
    (* sprawdz czy krawedz odpowiadajaca scianie po dodaniu jej do grafu
     * spowoduje ze odpowiadajacy grafowi labirynt sie rozspojni. procedura
     * jest oparta na nastepujacym spostrzezeniu: labirynt jest niespojny wtw.
     * gdy istnieje taki zbior pol, ze jest on otoczony z kazdej strony scianami
     * i nie jest on pelnym zbiorem pol. ale oznacza to, ze krawedzie odpowiadajace
     * scianom, ktore otaczaja ten obszar, tworza cykl. cykl ten musi byc
     * nietrywialny, bo jesli do labiryntu dodamy te sama sciane dwa razy to
     * nie stanie sie nic zlego. no i na poczatku labirynt jest oczywiscie spojny.
     * czyli dla kazdej sciany chcemy sprawdzic czy graf sie rozspojni. czyli
     * dla kazdej krawedzi chcemy sprawdzic, czy nie powstanie w grafie cykl inny
     * niz ten, ktorego obecnosc jest w oczywisty sposob spowodowana ramka
     *)
    let rozspojnia seg =
        let x0, y0, x1, y1 = parse_seg seg in
        (* sprawdz czy moge dotrzec z x0, y0 do x1, y1, jesli tak - bedzie cykl *)
        let rec dfs node =
            let x, y = get_xy node in
            if (x = x1) && (y = y1) then
                true
            else
                let neigh = Graph.neighbours g node in
                (* jesli moge dotrzec z ktoregokolwiek sasiada, to moge
                 * tez dotrzec z siebie samego *)
                List.exists dfs neigh
        in dfs (get_node x0 y0)

    (* przejdz krawedzie po kolei i zrob z kazda po kolei co trzeba *)
    let rec _labirynt todo =
        match todo with
        | [] -> ()
        | seg :: tl ->
            if rozspojnia seg then
                ()
            else
                result := seg :: result;
                let x0, y0, x1, y1 = parse_seg seg in
                insert_edge g (get_node x0 y0) (get_node x1 y1) nolabel
            _labirynt tl
    in
    begin
        _labirynt segmenty;
        result;
    end
