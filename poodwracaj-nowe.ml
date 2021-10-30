type 'a option = None | Some of 'a
type 'a elem = {v: 'a; mutable prev: 'a lista; mutable next: 'a lista}
and 'a lista = 'a elem option;;

(* zlozonosc czasowa: O(m) dla m = dlugosc listy
 * zlozonosc pamieciowa: O(m)
 *)

let poodwracaj (lst: 'a lista) (k: int list) =
    let k_n = List.length k
    and prev = ref None
    and s = Stack.create () 
    and pierwszy = ref None
    and k = Array.of_list k
    (* skopiuj 1. element listy *)
    and v = {v=lst.v; prev=lst.prev; next=lst.next} in
    (* for each k_i in k *)
    (* dzieki warunkowi suma k = m, chyba nie powinienem tutaj nigdzie wyjechac
     * poza liste - ale to by wymagalo przetestowania i ew. sprawdzenia czy
     * element nie jest nullem *)
    begin

    for ki = 0 to (k_n - 1) do
        (* wepchnij k_i elementow listy na stos *)
        for j = 0 to (k.(ki) - 1) do ((* [0, k_i-1) *)
            s.push (!(v.next)).prev; (* wepchnij na stos referencje do prawdziwego 
                                     * elementu, ktorego reprezentuje v*)
            v := !(v.next); (* wez kopie nastepnego elementu listy *)
        );
        done;

        (* posciagaj elementy ze stosu i pozamieniaj referencje *)
        for j = 0 to (k.(ki) - 1) do (
            let u = s.pop(); (* u to referencja na element prawdziwej listy *)
            (
            match !prev with
            | None -> pierwszy := ref u (* to moze tylko raz wystapic *)
            | Some (_) -> !prev.next := u
            );
            (!u).prev := prev;
            prev <- u;
            )
        done;
    done;
    !u.next <- ref None; (* w u wciaz powinien byc ostatni element wynikowej listy *)

    pierwszy
    end

let rec d1  =  Some {v = 4; prev = None; next = d2}
and d2  =  Some {v = 5; prev = d1; next = d3}
and d3  =  Some {v = 6; prev = d2; next = d4}
and d4  =  Some {v = 7; prev = d3; next = d5}
and d5  =  Some {v = 8; prev = d4; next = d6}
and d6  =  Some {v = 9; prev = d5; next = None};;
let d = d1;;
let wynik = poodwracaj d [3; 2; 1];;
