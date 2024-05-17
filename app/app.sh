declare -a TAXI
prijavaSistem() { 
    #login funkcija u kojoj su postavljeni admin, i dva korisnika
    echo "|****************|TAXI|***************|"
    echo "|****Dobrodosli na aplikaciju TAXI****|"
    echo "|Molimo, unesite Vase podatke|"
        BROJACUNOSA=0
        # 3 pokusaja, ukoliko se nakon treceg pokusaja ne unesu pravilne informacije program se terminira
        while [ $BROJACUNOSA -lt 3 ]
        do
            BROJACUNOSA=$((BROJACUNOSA + 1))
            read -p "|Unesite ime: " user
            read -s -p "|Unesite sifru: " password
            echo ""
            if [[ "$user" == "admin" && "$password" == "admin00" ]]; then
                sleepKomanda
                echo "Prijava je uspjesna, dobrodosli u aplikaciju TAXI|ADMINISTRATOR|"
                izbornikAdmin
                exit 0
            elif [[ "$user" == "majra" && "$password" == "majra2019" ]]; then
                sleepKomanda
                KORISNIK=MAJRA
                echo "Prijava je uspjesna, dobrodosli u aplikaciju TAXI|$KORISNIK|"
                izbornikKorisnik
                exit 0
            elif [[ "$user" == "edin" && "$password" == "edin2022" ]]; then
                sleepKomanda
                KORISNIK=EDIN
                echo "|Prijava je uspjesna, dobrodosli u aplikaciju TAXI|$KORISNIK|"
                izbornikKorisnik
                exit 0
            else    
                echo "|Uneseni podaci nisu ispravni, molimo pokusajte ponovo|"
                echo "|Preostali broj pokusaja $((3 - BROJACUNOSA))|"
            fi
        done
    echo "|Prijava nije uspjesna|"
    echo "|Uneseni podaci nisu ispravni|"
}
sleepKomanda() { 
    #sleep komanda koja predstavlja nacin animacije prilikom prijave na sistem od strane korisnika ili admina
    for ((i=0; i<3; i++)); do
        echo -n "." 
        sleep 0.75
        #sleep kljucna rijec pomjeraj svakih 0.75s
    done
    echo "✓"
    echo -e "\n"
}
izbornikAdmin() { 
    #izbornik koji se prikazuje ako su unijeti podaci admina
    echo "|****IZBORNIK ADMINA****| ADMIN |"
    echo "|1. Dodavanje novog taksi vozila|"
    echo "|2. Ispis taksi vozila|"
    echo "|3. Uređivanje informacija o taksi vozilima|"
    echo "|4. Pregled informacija o vožnjama|"
    echo "|5. Brisanje taksi vozila|"
    echo "|6. Odjava|"
    echo "|7. Izlaz|"
    read -p "|Unesite izbor: " UNOSIZBOR
    case $UNOSIZBOR in
        1)
            echo "|Dodavanje novog taksi vozila|"
            dodavanjeNoviTaxi
            izbornikAdmin
            ;;
        2)
            echo "|Ispis taksi vozila|"
            ispisTaxiVozila
            izbornikAdmin
            ;;
        3)
            echo "|Uređivanje informacija o taksi vozilima|"
            promjenaInformacija
            izbornikAdmin
            ;;
        4)
            echo "|Pregled informacija o vožnjama|"
            pregledInformacijaOVoznjama
            izbornikAdmin
            ;;
        5)
            echo "|Brisanje taksi vozila|"
            brisiTaxiVozila
            izbornikAdmin
            ;;
        6)
            echo "|Odjava|"
            sleepKomanda
            prijavaSistem
            ;;
        7)
            echo "|Izlazak iz aplikacije|"
            sleepKomanda
            ;;
        *)
            #default postavka koja se poziva ako korisnik unese vrijednost koja ne odgovara ponudjenim
            echo "|Nepravilan unos, molimo pokusajte ponovo|"
            izbornikAdmin
            ;;
    esac
}
izbornikKorisnik() { 
        #izbornik koji se ucitava ako je prijavio obicni korisnik
        echo "|****IZBORNIK KORISNIKA****| $KORISNIK |"
        echo "|1. Rezervacija taksi vozila|"
        echo "|2. Pregled informacija o voznjama|"
        echo "|3. Odjava|"
        echo "|4. Izlaz|"
        read -p "|Unesite izbor:" UNOSIZBOR
        case $UNOSIZBOR in
        1)
            echo "|Rezervacija taksi vozila|"
            pozivTaxi
            izbornikKorisnik
            ;;
        2)
            echo "|Pregled informacija o voznjama|"
            if [ "$KORISNIK" = "MAJRA" ]; then
            voznjeMajra
            fi
            if [ "$KORISNIK" = "EDIN" ]; then
            voznjeEdin
            fi
            izbornikKorisnik
            ;;
        3)  
            echo "|Odjava|"
            sleepKomanda
            prijavaSistem
            ;;
        4)
            echo "|Izlazak iz aplikacije|"
            exit 0
            ;;
        *)
            echo "|Nepravilan unos, molimo pokusajte ponovo|"
            izbornikKorisnik
            ;;
            #default postavka koja se poziva ako korisnik unese vrijednost koja ne odgovara ponudjenim
        esac
    }
ispisTaxiVozila() {
     #ispis svih vozila u sistemu koja se nalaze u sistemu
    if [ ${#TAXI[@]} -eq 0 ]; then 
        # ako u sistemu nema vozila, daje se mogucnost adminu da odma unese novo vozilo
        echo "|U sistemu trenutno nema vozila|"
        echo "|Da li zelite unijeti vozilo|"
        echo "|1. DA|"
        echo "|2. NE|"
        read UNOSVOZILO
        case $UNOSVOZILO in
        1)
            dodavanjeNoviTaxi
            izbornikAdmin
            ;;
        2)
            izbornikAdmin
            ;;
        *)
            echo "Unos nije ispravan"
            izbornikAdmin
        esac
        if [ "$UNOSVOZILO" -eq 1 ]; then
            dodavanjeNoviTaxi
        else
            izbornikAdmin
        fi
    else
        echo "|Lista taksi vozila|"
        for ((i=0; i<${#TAXI[@]}; i++)); do
            echo "-${TAXI[$i]}-"
            # for petlja koja nam omogucava ispis svih taksi vozila
        done
    fi
}
dodavanjeNoviTaxi() { 
    #dodavanje vozila
    echo "|Molimo, unesite informacije o taksi vozilu|"
    read -p "-|Redni broj vozila: " BROJTAKSI
    read -p "-|Marka vozila: " MARKATAKSI
    read -p "-|Model vozila: " MODELTAKSI
    read -p "-|Registarske tablice vozila: " REGISTARSKETABLICE
    read -p "-|Dostupnost vozila (dostupno/nedostupno): " DOSTUPNOSTVOZILA
    read -p "-|Broj sjedista vozila: " BROJSJEDISTA
    read -p "-|Boja vozila: " BOJAVOZILA
    taksiInformacije="-| Redni broj:$BROJTAKSI | Marka:$MARKATAKSI | Model:$MODELTAKSI | Registarske tablice:$REGISTARSKETABLICE | Dostupnost:$DOSTUPNOSTVOZILA | Broj sjedista:$BROJSJEDISTA | Boja vozila:$BOJAVOZILA-"
    TAXI+=("$taksiInformacije")
    # nakon unosa informacija o vozilu, informacije se senimaju u niz TAXI
    echo "|Novo vozilo je uspješno dodano u sistem.|"
    ispisTaxiVozila
}
promjenaInformacija() { 
    #promjena informacija svih vozila
    read -p "Unesite redni broj vozila koje želite promijeniti: " REDNIBROJ
    for ((tx=0; tx<${#TAXI[@]}; tx++)); do
        VOZILO="${TAXI[$tx]}"
        if [[ $VOZILO == *"Redni broj:$REDNIBROJ"* ]]; then
            # provjerava se da li u tom sistemu ima odgovarajuci taksi pod unesenim rednim brojem
            echo "|Molimo, unesite nove informacije|"
            read -p "-|Marka vozila: " MARKATAKSI
            read -p "-|Model vozila: " MODELTAKSI
            read -p "-|Registarske tablice vozila: " REGISTARSKETABLICE
            read -p "-|Dostupnost vozila (dostupno/nedostupno): " DOSTUPNOSTVOZILA
            read -p "-|Broj sjedista vozila: " BROJSJEDISTA
            read -p "-|Boja vozila: " BOJAVOZILA
            noviTaksiInformacije="-| Redni broj:$REDNIBROJ | Marka:$MARKATAKSI | Model:$MODELTAKSI | Registarske tablice:$REGISTARSKETABLICE | Dostupnost:$DOSTUPNOSTVOZILA | Broj sjedista:$BROJSJEDISTA | Boja vozila:$BOJAVOZILA-"
            TAXI[$tx]="$noviTaksiInformacije"
            # nakon promjene informacija, informacije se unose u niz, slicno kao i kada smo kreirali vozilo
            # samo sada se informacije mijenjaju, i spremaju u niz na isti nacin
            echo "|Informacije taxi vozila su uspjesno sacuvane|"
            ispisTaxiVozila
        fi
    done
    echo "|Unesni broj se ne nalazi u sistemu taksi vozila|"
}
pregledInformacijaOVoznjama() { 
    #pregled svih informacija o voznjama
    if [ ${#TAXI[@]} -eq 0 ]; then
        echo "|U sistemu se ne nalaze podaci o voznjama.|"
    else
    voznjeMajra
     # ispis svih voznji korisnika Majra
    voznjeEdin
     # ispis svih voznji korisnika Edin
    fi
}
brisiTaxiVozila() { 
    #funkcija koja omogucava brisanje vozila
    echo "|Unesite broj taksi vozila koje želite izbrisati:"
    read -p "|Broj vozila: " REDNIBROJ
    if [ "$REDNIBROJ" -eq 0 ] || [ "$REDNIBROJ" -gt ${#TAXI[@]} ]; then
        echo "|Uneseni taksi se ne nalazi u sistemu.|"
        izbornikAdmin
        return
    fi
    unset TAXI[$((REDNIBROJ-1))]
    TAXI=("${TAXI[@]}") 
    echo "|Taksi vozilo broj $REDNIBROJ je izbrisano.|"
}
brisiPrethodno() {
    #funkcija koja omogucava brisanje prethodnog sadrzaja na ekranu
    printf "\033[H\033[J"  
}
kretanjeVozila() { 
    #funkcija koja omogucava animaciju kretanja vozila
    brisiPrethodno
    for ((i=1; i<=10; i++)); do
        brisiPrethodno
        printf "%${i}s"
        printf "___/""TAXI""\___ "
        sleep 0.3
    done
    echo "| $ODREDISTETAXI"
}
pozivTaxi() { 
    #omogucava poziv taksija, naravno uz prethodno kreiranje taksija u sistemu od strance admina
    dostupnost="dostupan"
    echo "|Odabrali ste opciju pozivanja taxi vozila|"
    read -p "|Unesite zeljeno polaziste: " POLAZISTETAXI
    read -p "|Unesite zeljeno odrediste:" ODREDISTETAXI
    read -p "|Unesite vrijeme:" VRIJEME
    read -p "|Unesite broj putnika:" BROJPUTNIKA
    echo "|Dostupna taksi vozila|"
    for taxi in "${TAXI[@]}"; do
        if [[ $taxi == *"Dostupnost:$dostupnost"* ]] && [ "$BROJPUTNIKA" -le "$BROJSJEDISTA" ]; then
            echo "*$taxi*"
        fi
    done
    read -p "|Molimo izaberite zeljeni taxi:" UNOS
    if [ "$UNOS" -eq 0 ] || [ "$UNOS" -gt ${#TAXI[@]} ]; then
        echo "|Uneseni taksi se ne nalazi u sistemu.|"
        izbornikKorisnik
    fi
        echo "|Uspjesno ste izabrali vozilo pod rednim brojem $UNOS |"
        echo "|Molimo pricekajte, vozilo je na putu|"
        sleepKomanda
        kretanjeVozila
        CIJENA=$((RANDOM % 25 + 1)) #omogucava nam formirati cijene voznje
        vozacTaxi #poziv funkcije, nakon cega se random izabere vozac koji ce obaviti voznju
        echo "|Uspjesno ste stigli na odrediste $ODREDISTETAXI| Cijena voznje je: $CIJENA KM |"
        if [ "$KORISNIK" = "MAJRA" ]; then
            VOZNJAMAJRA="| Polaziste: $POLAZISTETAXI | Odrediste: $ODREDISTETAXI | Vrijeme: $VRIJEME | Broj putnika: $BROJPUTNIKA | Vozac: $IME | Cijena: $CIJENA KM |"
            VOZNJEMAJRA+=("$VOZNJAMAJRA")
            unosOcjene
        fi
        if [ "$KORISNIK" = "EDIN" ]; then
            VOZNJAEDIN="| Polaziste: $POLAZISTETAXI | Odrediste: $ODREDISTETAXI | Vrijeme: $VRIJEME | Broj putnika: $BROJPUTNIKA | Vozac: $IME | Cijena: $CIJENA KM |"
            VOZNJEEDIN+=("$VOZNJAEDIN")
            unosOcjene
        fi

}
voznjeMajra() { 
    #ispis svih voznji korisnik Majra
    echo "|Sve vožnje| MAJRA |"
  for ((i=0; i<${#VOZNJEMAJRA[@]}; i++)); do
    echo -n "${VOZNJEMAJRA[$i]} Ocjena: "
    for ((j=0; j<${#OCJENEMAJRA[@]}; j++)); do
        echo -n "${OCJENEMAJRA[$j]} "
        #ispis ocjene
    done
    echo
done
}
voznjeEdin() { 
    #ispis svih voznji korisnik Edin
    echo "|Sve vožnje| EDIN |"
  for ((i=0; i<${#VOZNJEEDIN[@]}; i++)); do
    echo -n "${VOZNJEEDIN[$i]} Ocjena: "
    for ((j=0; j<${#OCJENEEDIN[@]}; j++)); do
        echo -n "${OCJENEEDIN[$j]} "
        #ispis ocjene
    done
    echo
done
}
vozacTaxi() { 
    #funkcija koja omogucava random izbor jednog od vozaca iz niza VOZACI
    VOZACI=("Amir" "Suad" "Marko")
    IME=${VOZACI[$RANDOM % ${#VOZACI[@]}]}
    # random opcija omogucava nausmican odabir jednog od vozaca iz niza
}
unosOcjene() {
    read -p "|Unesite ocjenu (1-5): " OCJENA
    if [ "$OCJENA" -lt 1 ] || [ "$OCJENA" -gt 5 ]; then
    #provjera da li je uneseni broj od 1 do 5
        echo "|Neispravan unos.Unesite ocjenu (1-5)|"
        unosOcjene
        return
    fi
    if [ "$KORISNIK" = "MAJRA" ]; then
    OCJENEMAJRA=()
    OCJENEMAJRA+=("$OCJENA")
    echo "|Uspjesno ste unijeli ocjenu|"
    # ocjene se spremaju u niz
    fi
    if [ "$KORISNIK" = "EDIN " ]; then
    OCJENEEDIN=()
    OCJENEEDIN+=("$OCJENA")
    echo "|Uspjesno ste unjeli ocjenu|"
    fi
}
prijavaSistem