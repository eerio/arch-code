import java.util.Scanner;
import java.util.Random;
import java.lang.Math;

class Województwo {
    public PunktSzczepień punkty_szczepień[];
    public int kod[];

    public Województwo(PunktSzczepień punkty_szczepień[], int kod[]) {
        this.punkty_szczepień = new PunktSzczepień[punkty_szczepień.length];
        System.arraycopy(punkty_szczepień, 0, this.punkty_szczepień, 0, punkty_szczepień.length);
        this.kod = new int[5];
        System.arraycopy(kod, 0, this.kod, 0, 5);
    }
}

class Kraj {
    public Województwo województwa[];

    public Kraj(Województwo województwa[]) {
        this.województwa = new Województwo[województwa.length];
        System.arraycopy(województwa, 0, this.województwa, 0, województwa.length);
    }

    public static int odleglosc(int kod1[], int kod2[]) {
        // niezmiennik: te tablice powinny miec dlugosc 5
        int num1=0;
        int num2=0;
        for (int i=0; i < 5; ++i) {
            num1 += kod1[i] * Math.pow(10, 5-(i+1));
            num2 += kod2[i] * Math.pow(10, 5-(i+1));
        }

        return abs(num1 - num2);
    }

    public static Województwo województwo_z_kodu(int kod[]) {
        return województwa[kod[0]]; // MSD kodu wyznacza województwo jednoznacznie, z treści zadania
    }
}

class Szczepionka {
    public String nazwa;
    public String nazwa_producenta;
    public int wielkość_dawki;

    public Szczepionka(public String nazwa, public String nazwa_producenta, public int wielkość_dawki) {
        this.nazwa = nazwa;
        this.nazwa_producenta = nazwa_producenta;
        this.wielkość_dawki = wielkość_dawki;
    }
}

class Raport {
    List<Pacjent> lista_zaszczepionych;
    int dzień;

    public Raport() {
        this.lista_zaszczepionych = new List<Pacjent>();
    }

    public dodaj_pacjenta(Pacjent pacjent) {
        this.lista_zaszczepionych.add(pacjent);
    }
}

class PunktSzczepień {
    public int kod[];
    public Szczepionka szczepionka;
    public int łącznie_zaszczepionych;
    public List<Raport> raporty;
    private Raport najświeższy_raport;
    
    private int przepustowość;
    private int najbliższy_dzień;
    private int wypełnienie_dnia;

    public PunktSzczepień(Szczepionka szczepionka, int kod[], int przepustowość) {
        this.szczepionka = szczepionka;
        this.kod = new int[5];
        System.arraycopy(this.kod, 0, kod, 0, 5);
        this.przepustowość = przepustowość;
        this.najbliższy_dzień = 0;
        this.wypełnienie_dnia = 0;

        this.raporty = new List<Raport>();
        this.najświeższy_raport = new Raport(0);
    }

    int obsłuż(Pacjent pacjent) {
        if (this.wypełnienie_dnia == this.przepustowość) {
            this.najbliższy_dzień++;
            this.raporty.add(this.najświeższy_raport);
            this.najświeższy_raport = new Raport(this.najbliższy_dzień);
            this.wypełnienie_dnia = 0;
        } else {
            this.wypełnienie_dnia++;
        }

        this.najświeższy_raport.dodaj_pacjenta(pacjent);
        return this.najbliższy_dzień;
    }
}

class BiuroSzczepień {
    public int liczba_zaszczepionych;
    private Kraj kraj;

    public BiuroSzczepień(Kraj kraj) {
        this.liczba_zaszczepionych = 0;
        this.kraj = kraj;
    }

    PunktSzczepień obsłuż_pacjenta(Pacjent pacjent) {
        Województwo województwo = this.kraj.województwo_z_kodu(pacjent.kod);
        PunktSzczepień punkty_szczepień[] = województwo.punkty_szczepień;
        int n = punkty_szczepień.length;

        PunktSzczepień najlepszy_punkt;
        PunktSzczepień punkt;
        int najlepsza_odleglosc = -1;
        int odleglosc;

        for (int i=0; i < n; ++i) {
            punkt = punkty_szczepień[i];
            if (punkt.szczepionka != pacjent.żądana_szczepionka) continue;

            odleglosc = this.kraj.odleglosc(punkt.kod, pacjent.kod);
            if (odleglosc > pacjent.maksymalna_odległość) continue;
            
            if (najlepsza_odleglosc == -1 || najlepsza_odleglosc > odleglosc) {
                najlepsza_odleglosc = odleglosc;
                najlepszy_punkt = punkt;
            }
        }

        // if (najlepsza_odległość == -1) { błąd(nie da się); };
        // zakładam, że zawsze będzie taki punkt, bo zadanie nie określa
        // co mamy robić w przeciwnym przypadku
        return PunktSzczepień;
    }
}

class Pacjent {
    public int kod[];
    public Szczepionka żądana_szczepionka;
    public int maksymalna_odległość;
    private int data; // data szczepienia żeby przyjść

    public Pacjent(int kod[], Szczepionka żądana_szczepionka,
                    int maksymalna_odległość) {
        this.kod = new int[5];
        System.arraycopy(kod, 0, this.kod, 0, 5);
        this.żądana_szczepionka = żądana_szczepionka;
        this.maksymalna_odległość = maksymalna_odległość;
        this.data = -1;
    }

    private void zgłoś_się(PunktSzczepień punkt_szczepień) {
    }

    private PunktSzczepień znajdź_sam_punkt_szczepień();

    private PunktSzczepień zgłoś_się_do_biura(BiuroSzczepień biuro) {
        return biuro.obsłuż_pacjenta(this);
    }

    abstract public zapisz_się(void);
}

class PacjentSamodzielny extends Pacjent {
    public zapisz_się(BiuroSzczepień biuro) {
        PunktSzczepień punkt = this.zgłoś_się_do_biura(biuro);
        this.data = punkt.obsłuż(this);
    }
}

class PacjentNiesamodzielny extends Pacjent {
    public zapisz_się() {
        PunktSzczepień punkt = this.znajdź_sam_punkt_szczepień();
        this.data = punkt.obsłuż(this);
    }
}

public class Main {
    public static void main (String[] args) {
        Scanner scan = new Scanner(System.in);
        int i = scan.nextInt();
        String name = scan.nextLine();

        System.out.println("Hello, " + name + "age:" + i);
    }

}

