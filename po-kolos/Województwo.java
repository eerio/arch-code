
class Województwo {
    public PunktSzczepień punkty_szczepień[];
    public int kod;

    public Województwo(PunktSzczepień punkty_szczepień[], int kod) {
        this.punkty_szczepień = new PunktSzczepień[punkty_szczepień.length];
        System.arraycopy(punkty_szczepień, 0, this.punkty_szczepień, 0, punkty_szczepień.length);
        this.kod = kod;
    }
}

