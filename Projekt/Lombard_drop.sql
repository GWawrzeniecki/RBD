-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2018-05-21 20:43:46.19

-- foreign keys
ALTER TABLE Osoba
    DROP CONSTRAINT ID_Osoba_Miasto;

ALTER TABLE Klient
    DROP CONSTRAINT Klient_ID_Osoba;

ALTER TABLE Rzecz_Na_Sprzedaz
    DROP CONSTRAINT Na_Sprzed_Pod_Zastaw;

ALTER TABLE Rzecz_pod_Zastaw
    DROP CONSTRAINT Pod_Zastaw_Umowa_Kup;

ALTER TABLE Pracownik
    DROP CONSTRAINT Pracownik_ID_Osoba;

ALTER TABLE Pracownik
    DROP CONSTRAINT Pracownik_Pracownik;

ALTER TABLE Pracownik
    DROP CONSTRAINT Pracownik_Typ_Umowy;

ALTER TABLE Rzecz_pod_Zastaw
    DROP CONSTRAINT Rzecz_pod_Zastaw_Kategoria;

ALTER TABLE Umowa_Kupna_Sprzedazy
    DROP CONSTRAINT Umowa_Kupna_Sprzedazy_Klient;

ALTER TABLE Zaleznosci
    DROP CONSTRAINT Zaleznosci_Pracownik;

ALTER TABLE Zaleznosci
    DROP CONSTRAINT Zaleznosci_Pracownik2;

-- tables
DROP TABLE Kategoria;

DROP TABLE Klient;

DROP TABLE Miasto;

DROP TABLE Osoba;

DROP TABLE Pracownik;

DROP TABLE Rzecz_Na_Sprzedaz;

DROP TABLE Rzecz_pod_Zastaw;

DROP TABLE Typ_Umowy;

DROP TABLE Umowa_Kupna_Sprzedazy;

DROP TABLE Zaleznosci;

-- End of file.

