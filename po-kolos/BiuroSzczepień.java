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
