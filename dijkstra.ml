let search g v =
	let visited = Array.make (size g) false
	and dist = Array.make (size g) infinity
	and q = ref Q.empty
	in begin
		q := Q.put (v, 0.0) !q;
		while not (Q.is_empty !q) do
			let (v, d) = Q.getmax !q
			in begin
				q := Q.removemax !q;
				if not visited.(v) then begin
					List.iter
						(fun (w, l) -> q := Q.put (w, d +. l) !q)
						(neighbours g v);
					dist.(v) <- d;
					visited.(v)<- true
				end;
			end;
		done;
		dist
	end
