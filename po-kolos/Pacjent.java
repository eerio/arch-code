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

class PacjentNiesamodzielny extends Pacjent {
    public zapisz_się() {
        PunktSzczepień punkt = this.znajdź_sam_punkt_szczepień();
        this.data = punkt.obsłuż(this);
    }
}

class PacjentSamodzielny extends Pacjent {
    public zapisz_się(); // znajdź sobie sam punkt itd.
}

