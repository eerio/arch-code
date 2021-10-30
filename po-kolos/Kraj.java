class Kraj {
    private Województwo województwa[];

    public Kraj(Województwo województwa[]) {
        this.województwa = new Województwo[województwa.length];
        System.arraycopy(województwa, 0, this.województwa, 0, województwa.length);
        // w tej implementacji nie uwzgledniam ze wojewodztwa moga miec inne kody
        // niz indeks w tablicy; jakby bylo wymagane to by mozna bylo dopisac
        // bardziej zaawansowane mapowanie kodu na województwo
    }

    public int odleglosc(int kod1[], int kod2[]) {
        // niezmiennik: te tablice powinny miec dlugosc 5
        // zamien tablice intow na liczby w zapisie dziesietnym
        int num1=0;
        int num2=0;
        for (int i=0; i < 5; ++i) {
            num1 += kod1[i] * Math.pow(10, 5-(i+1));
            num2 += kod2[i] * Math.pow(10, 5-(i+1));
        }
        // zwroc abs roznicy
        return abs(num1 - num2);
    }

    public Województwo województwo_z_kodu(int kod[]) {
        return województwa[kod[0]]; // MSD kodu wyznacza województwo jednoznacznie, z treści zadania
    }
}
