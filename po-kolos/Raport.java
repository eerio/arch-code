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
