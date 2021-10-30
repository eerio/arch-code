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

    void raportuj_kolejny_dzień() {
        raport = raporty.get(0);
        raporty.pop();
        łącznie_zaszczepionych += raport.łącznie_pacjentów;
        // print raport
    }
}
