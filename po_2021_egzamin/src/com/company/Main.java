package com.company;
import java.util.*;

class SystemSądowniczy {
    private final Sąd sądNajwyższy;

    public SystemSądowniczy() {
        this.sądNajwyższy = new Sąd(null);
        this.sądNajwyższy.generujLosowePodsądy();
    }

    public List<Sąd> getSądyNajniższe() {
        List<Sąd> sądy = new ArrayList<>();

        Stack<Sąd> stack = new Stack<Sąd>();

        Sąd currentSąd = this.sądNajwyższy;
        stack.push(currentSąd);

        while (!stack.isEmpty()) {
            currentSąd = stack.pop();
            if (currentSąd.podrzędneSądy.isEmpty()) {
                sądy.add(currentSąd);
            } else {
                for (Sąd sąd : currentSąd.podrzędneSądy) {
                    stack.push(sąd);
                }
            }
        }

        return sądy;
    }
}

enum Werdykt {
    Umorzenie,
    PrzyznanieWiny,
    Uniewinnienie
}

class Sąd {
    static protected Random rand = new Random();

    private final Sąd nadzorca;
    public List<Sąd> podrzędneSądy;
    private final List<Sędzia> sędziowie;
    private final Map<Sędzia, Integer> ileRozstrzygniętychSpraw;

    public Sąd (Sąd nadzorca) {
        this.nadzorca = nadzorca;
        this.podrzędneSądy = new ArrayList<>();
        this.sędziowie = new ArrayList<>();
        this.ileRozstrzygniętychSpraw = new HashMap<>();
        // w tym miejscu przypisz sędziów do sądu spośród wolnych sędziów wśród mieszkańców
    }

    public void generujLosowePodsądy() {
        for (int i=0; i < Sąd.rand.nextInt(4); ++i) {
            Sąd sąd = new Sąd(this);
            this.podrzędneSądy.add(sąd);
            sąd.generujLosowePodsądy();
        }
    }

    public void rozwiążSprawę(SprawaSądowa sprawa) {
        Sędzia bestSędzia = this.sędziowie.get(0);
        Integer minRozstrzygnięte=Integer.MAX_VALUE, currentRozstrzygnięte;

        for (Sędzia sędzia: this.sędziowie) {
            currentRozstrzygnięte = this.ileRozstrzygniętychSpraw.get(sędzia);
            if (currentRozstrzygnięte < minRozstrzygnięte) {
                minRozstrzygnięte = currentRozstrzygnięte;
                bestSędzia = sędzia;
            }
        }

        sprawa.stanowiskoSkarżącego = sprawa.skarżący.getStanowisko(sprawa);
        sprawa.stanowiskoOskarżonego = sprawa.oskarżany.getStanowisko(sprawa);
        sprawa.żądanie = sprawa.skarżący.getŻądanie(sprawa);
        sprawa.werdykt = bestSędzia.wydajWerdykt(sprawa);

        if (this.nadzorca != null && sprawa.skarżący.czySięOdwołuje(sprawa)) {
            this.nadzorca.rozwiążSprawę(sprawa);
        }
    }
}

class SprawaSądowa {
    public final Mieszkaniec skarżący;
    public final Mieszkaniec oskarżany;
    public int żądanie;
    public String stanowiskoOskarżonego;
    public String stanowiskoSkarżącego;
    public Werdykt werdykt;

    public SprawaSądowa(Mieszkaniec skarżący, Mieszkaniec oskarżany) {
        this.skarżący = skarżący;
        this.oskarżany = oskarżany;
    }

    public boolean czyKtośMaImmunitet() {
        return this.skarżący.maImmunitet || this.oskarżany.maImmunitet;
    }

    public Mieszkaniec getSkarżący () {
        return this.skarżący;
    }

    public Mieszkaniec getOskarżany () {
        return this.oskarżany;
    }

    public int getŻądanie () {
        return this.żądanie;
    }

    public String getStanowiskoOskarżonego () {
        return this.stanowiskoOskarżonego;
    }

    public String getStanowiskoSkarżącego () {
        return this.stanowiskoSkarżącego;
    }

    public Werdykt getWerdykt () {
        return this.werdykt;
    }
}

class Państwo {
    public SystemSądowniczy systemSądowniczy;
    public List<Mieszkaniec> mieszkańcy;

    public Państwo (SystemSądowniczy systemSądowniczy) {
        this.systemSądowniczy = systemSądowniczy;
        this.mieszkańcy = new ArrayList<>();
    }

    public void addMieszkaniec(Mieszkaniec mieszkaniec) {
        this.mieszkańcy.add(mieszkaniec);
    }
}

class Mieszkaniec {
    static protected Random rand = new Random();
    private final Państwo państwo;
    public boolean maImmunitet = false;
    public List<SprawaSądowa> historiaSądowa;
    private int kasa;

    public Mieszkaniec(Państwo państwo) {
        this.państwo = państwo;
        this.historiaSądowa = new ArrayList<>();
        this.kasa = rand.nextInt(1000); // niektórzy się po prostu rodzą bogatsi
    }

    public void inicjujSpór() {
        List<Sąd> liście = this.państwo.systemSądowniczy.getSądyNajniższe();
        List<Mieszkaniec> mieszkańcy = this.państwo.mieszkańcy;

        // przeprowadź strategię wybierania sądu
        Sąd sąd = liście.get(0);

        // przeprowadź strategię wybierania oponenta
        Mieszkaniec oponent = mieszkańcy.get(0);

        // przygotuj sprawę
        SprawaSądowa sprawa = new SprawaSądowa(this, oponent);

        // pozwij oponenta
        sąd.rozwiążSprawę(sprawa);

        // zastosuj się do werdyktu
        switch (sprawa.werdykt) {
            case Umorzenie:
                break;
            case PrzyznanieWiny:
                this.kasa += sprawa.żądanie;
                break;
            case Uniewinnienie:
                this.kasa -= sprawa.żądanie;
                break;
        }

        // zapamiętaj sprawę
        this.historiaSądowa.add(sprawa);
    }

    public String getStanowisko(SprawaSądowa sprawa) {
        return "nie pamiętam tej sprawy już";
    }

    public int getŻądanie(SprawaSądowa sprawa) {
        return rand.nextInt(500); // nie więcej niż 500zł żądaj
    }

    public boolean czySięOdwołuje(SprawaSądowa sprawa) {
        return sprawa.werdykt != Werdykt.PrzyznanieWiny;
    }
}

abstract class Sędzia extends Mieszkaniec {
    static protected Random rand = new Random();
    private Sąd sąd;

    public Sędzia(Państwo państwo, Sąd sąd) {
        super(państwo);
        this.maImmunitet = true;
        this.sąd = sąd;
    }

    abstract protected Werdykt _rozstrzygnijSprawę(SprawaSądowa sprawa);

    public Werdykt wydajWerdykt(SprawaSądowa sprawa) {
        if (sprawa.czyKtośMaImmunitet()) return Werdykt.Umorzenie;
        return this._rozstrzygnijSprawę(sprawa);
    }
}

class SędziaDyslektyk extends Sędzia {
    public SędziaDyslektyk(Państwo państwo, Sąd sąd) {
        super(państwo, sąd);
    }

    @Override
    public Werdykt _rozstrzygnijSprawę(SprawaSądowa sprawa) {
        int scoreSkarżący = sprawa.getStanowiskoSkarżącego().length();
        int scoreOskarżony = sprawa.getStanowiskoOskarżonego().length();

        if (scoreSkarżący > scoreOskarżony) return Werdykt.PrzyznanieWiny;
        else if (scoreSkarżący == scoreOskarżony) return Werdykt.Umorzenie;
        else return Werdykt.Uniewinnienie;
    }
}

class SędziaFrequency extends Sędzia {
    public SędziaFrequency(Państwo państwo, Sąd sąd) {
        super(państwo, sąd);
    }

    @Override
    public Werdykt _rozstrzygnijSprawę(SprawaSądowa sprawa) {
        List<SprawaSądowa> historiaSkarżący = sprawa.getSkarżący().historiaSądowa;
        List<SprawaSądowa> historiaOskarżany = sprawa.getOskarżany().historiaSądowa;

        int scoreSkarżący = 0;
        int scoreOskarżony = 0;

        for (SprawaSądowa histSprawa: historiaSkarżący) {
            if (histSprawa.getOskarżany().equals(sprawa.getSkarżący())
                    && histSprawa.getWerdykt() == Werdykt.PrzyznanieWiny) {
                scoreSkarżący -= 1;
            }
        }

        for (SprawaSądowa hisSprawa: historiaOskarżany) {
            if (hisSprawa.getOskarżany().equals(sprawa.getOskarżany())
                    && hisSprawa.getWerdykt() == Werdykt.PrzyznanieWiny) {
                scoreOskarżony -= 1;
            }
        }

        if (scoreSkarżący > scoreOskarżony) return Werdykt.PrzyznanieWiny;
        else if (scoreSkarżący == scoreOskarżony) return Werdykt.Umorzenie;
        else return Werdykt.Uniewinnienie;
    }
}

class SędziaPieniądze extends Sędzia {
    public SędziaPieniądze(Państwo państwo, Sąd sąd) {
        super(państwo, sąd);
    }

    @Override
    public Werdykt _rozstrzygnijSprawę(SprawaSądowa sprawa) {
        List<SprawaSądowa> historiaSkarżący = sprawa.getSkarżący().historiaSądowa;
        List<SprawaSądowa> historiaOskarżany = sprawa.getOskarżany().historiaSądowa;

        int scoreSkarżący = 0;
        int scoreOskarżony = 0;

        for (SprawaSądowa histSprawa: historiaSkarżący) {
            if (histSprawa.getSkarżący().equals(sprawa.getSkarżący())
                    && histSprawa.getWerdykt() == Werdykt.Umorzenie) {
                scoreSkarżący -= histSprawa.getŻądanie();
            }
        }

        for (SprawaSądowa histSprawa: historiaSkarżący) {
            if (histSprawa.getSkarżący().equals(sprawa.getOskarżany())
                    && histSprawa.getWerdykt() == Werdykt.Umorzenie) {
                scoreOskarżony -= histSprawa.getŻądanie();
            }
        }

        if (scoreSkarżący > scoreOskarżony) return Werdykt.PrzyznanieWiny;
        else if (scoreSkarżący == scoreOskarżony) return Werdykt.Umorzenie;
        else return Werdykt.Uniewinnienie;
    }
}

class SędziaLosowy extends Sędzia {
    private final int rozkład_a; // w procentach, rozkład_a,b \in [0, 100]
    private final int rozkład_b;

    public SędziaLosowy(Państwo państwo, Sąd sąd) {
        super(państwo, sąd);
        this.rozkład_a = Sędzia.rand.nextInt(75); // max 75%
        this.rozkład_b = Sędzia.rand.nextInt(100 - this.rozkład_a);
    }

    @Override
    public Werdykt _rozstrzygnijSprawę(SprawaSądowa sprawa) {
        int rnd = Sędzia.rand.nextInt(100);
        if (rnd <= this.rozkład_a) return Werdykt.PrzyznanieWiny;
        else if (rnd <= this.rozkład_a + this.rozkład_b) return Werdykt.Uniewinnienie;
        else return Werdykt.Umorzenie;
    }
}

public class Main {
    public static void main(String[] args) {
        SystemSądowniczy system = new SystemSądowniczy();
        List<Mieszkaniec> mieszkańcy = new ArrayList<>();

        Państwo państwo = new Państwo(system);

        Random rand = new Random();
        int max_mieszkańców = 15; // liczba > 0
        for (int i=0; i < 1 + rand.nextInt(max_mieszkańców - 1); ++i) {
            państwo.addMieszkaniec(new Mieszkaniec(państwo));
        }

        // weź losowego mieszkańca
        Mieszkaniec mieszkaniec = państwo.mieszkańcy.get(0);
        mieszkaniec.inicjujSpór();
    }
}
