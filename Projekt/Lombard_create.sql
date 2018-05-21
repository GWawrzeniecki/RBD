-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2018-05-21 20:43:46.19

-- tables
-- Table: Kategoria
CREATE TABLE Kategoria (
    ID_Kategorii integer  NOT NULL,
    Kategoria varchar2(15)  NOT NULL,
    CONSTRAINT Kategoria_pk PRIMARY KEY (ID_Kategorii)
) ;

-- Table: Klient
CREATE TABLE Klient (
    ID_Klienta integer  NOT NULL,
    Numer_Dowodu varchar2(20)  NOT NULL,
    Seria_Dowodu varchar2(20)  NOT NULL,
    CONSTRAINT Klient_pk PRIMARY KEY (ID_Klienta)
) ;

-- Table: Miasto
CREATE TABLE Miasto (
    ID_Miasta integer  NOT NULL,
    Nazwa_Miasta varchar2(20)  NOT NULL,
    CONSTRAINT Miasto_pk PRIMARY KEY (ID_Miasta)
) ;

-- Table: Osoba
CREATE TABLE Osoba (
    ID_Osoby integer  NOT NULL,
    Imie varchar2(20)  NOT NULL,
    Nazwisko varchar2(20)  NOT NULL,
    Plec varchar2(20)  NOT NULL,
    Data_Urodzenia date  NOT NULL,
    Pesel varchar2(25)  NOT NULL,
    Miasto_ID_Miasta integer  NOT NULL,
    Ulica varchar2(20)  NOT NULL,
    Numer_Domu varchar2(20)  NOT NULL,
    Numer_Mieszkania varchar2(20)  NOT NULL,
    CONSTRAINT Osoba_pk PRIMARY KEY (ID_Osoby)
) ;

-- Table: Pracownik
CREATE TABLE Pracownik (
    ID_Pracownika integer  NOT NULL,
    Pensja number(10,1)  NOT NULL,
    Typ_Umowy_ID_Typu integer  NOT NULL,
    ID_Szefa integer  NOT NULL,
    CONSTRAINT Pracownik_ak_1 UNIQUE (ID_Szefa),
    CONSTRAINT Pracownik_pk PRIMARY KEY (ID_Pracownika)
) ;

-- Table: Rzecz_Na_Sprzedaz
CREATE TABLE Rzecz_Na_Sprzedaz (
    ID_Rzecz_Sprzed integer  NOT NULL,
    Cena_Sprzedazy number(100,1)  NOT NULL,
    CONSTRAINT Rzecz_Na_Sprzedaz_pk PRIMARY KEY (ID_Rzecz_Sprzed)
) ;

-- Table: Rzecz_pod_Zastaw
CREATE TABLE Rzecz_pod_Zastaw (
    ID_Rzeczy integer  NOT NULL,
    Kategoria_ID_Kategorii integer  NOT NULL,
    Nazwa varchar2(15)  NOT NULL,
    Umowa_Kupna_Sprzedazy_ID_Umowy integer  NOT NULL,
    Status varchar2(20)  NOT NULL,
    CONSTRAINT Rzecz_pod_Zastaw_pk PRIMARY KEY (ID_Rzeczy)
) ;

-- Table: Typ_Umowy
CREATE TABLE Typ_Umowy (
    ID_Typu integer  NOT NULL,
    Nazwa_Typu_Umowy varchar2(20)  NOT NULL,
    CONSTRAINT Typ_Umowy_pk PRIMARY KEY (ID_Typu)
) ;

-- Table: Umowa_Kupna_Sprzedazy
CREATE TABLE Umowa_Kupna_Sprzedazy (
    ID_Umowy integer  NOT NULL,
    Data_Podpisania date  NOT NULL,
    Data_Zakonczenia date  NOT NULL,
    Kwota_Umowy number(100,1)  NOT NULL,
    Kwota_Podatku number(100,1)  NOT NULL,
    Upowaznienie_Imie varchar2(15)  NOT NULL,
    Upowaznienie_Nazwisko varchar2(15)  NOT NULL,
    Klient_ID_Klienta integer  NOT NULL,
    CONSTRAINT Umowa_Kupna_Sprzedazy_pk PRIMARY KEY (ID_Umowy)
) ;

-- Table: Zaleznosci
CREATE TABLE Zaleznosci (
    ID_Szef integer  NOT NULL,
    ID_Pracownik integer  NOT NULL,
    CONSTRAINT Zaleznosci_pk PRIMARY KEY (ID_Szef,ID_Pracownik)
) ;

-- foreign keys
-- Reference: ID_Osoba_Miasto (table: Osoba)
ALTER TABLE Osoba ADD CONSTRAINT ID_Osoba_Miasto
    FOREIGN KEY (Miasto_ID_Miasta)
    REFERENCES Miasto (ID_Miasta);

-- Reference: Klient_ID_Osoba (table: Klient)
ALTER TABLE Klient ADD CONSTRAINT Klient_ID_Osoba
    FOREIGN KEY (ID_Klienta)
    REFERENCES Osoba (ID_Osoby);

-- Reference: Na_Sprzed_Pod_Zastaw (table: Rzecz_Na_Sprzedaz)
ALTER TABLE Rzecz_Na_Sprzedaz ADD CONSTRAINT Na_Sprzed_Pod_Zastaw
    FOREIGN KEY (ID_Rzecz_Sprzed)
    REFERENCES Rzecz_pod_Zastaw (ID_Rzeczy);

-- Reference: Pod_Zastaw_Umowa_Kup (table: Rzecz_pod_Zastaw)
ALTER TABLE Rzecz_pod_Zastaw ADD CONSTRAINT Pod_Zastaw_Umowa_Kup
    FOREIGN KEY (Umowa_Kupna_Sprzedazy_ID_Umowy)
    REFERENCES Umowa_Kupna_Sprzedazy (ID_Umowy);

-- Reference: Pracownik_ID_Osoba (table: Pracownik)
ALTER TABLE Pracownik ADD CONSTRAINT Pracownik_ID_Osoba
    FOREIGN KEY (ID_Pracownika)
    REFERENCES Osoba (ID_Osoby);

-- Reference: Pracownik_Pracownik (table: Pracownik)
ALTER TABLE Pracownik ADD CONSTRAINT Pracownik_Pracownik
    FOREIGN KEY (ID_Szefa)
    REFERENCES Pracownik (ID_Pracownika);

-- Reference: Pracownik_Typ_Umowy (table: Pracownik)
ALTER TABLE Pracownik ADD CONSTRAINT Pracownik_Typ_Umowy
    FOREIGN KEY (Typ_Umowy_ID_Typu)
    REFERENCES Typ_Umowy (ID_Typu);

-- Reference: Rzecz_pod_Zastaw_Kategoria (table: Rzecz_pod_Zastaw)
ALTER TABLE Rzecz_pod_Zastaw ADD CONSTRAINT Rzecz_pod_Zastaw_Kategoria
    FOREIGN KEY (Kategoria_ID_Kategorii)
    REFERENCES Kategoria (ID_Kategorii);

-- Reference: Umowa_Kupna_Sprzedazy_Klient (table: Umowa_Kupna_Sprzedazy)
ALTER TABLE Umowa_Kupna_Sprzedazy ADD CONSTRAINT Umowa_Kupna_Sprzedazy_Klient
    FOREIGN KEY (Klient_ID_Klienta)
    REFERENCES Klient (ID_Klienta);

-- Reference: Zaleznosci_Pracownik (table: Zaleznosci)
ALTER TABLE Zaleznosci ADD CONSTRAINT Zaleznosci_Pracownik
    FOREIGN KEY (ID_Szef)
    REFERENCES Pracownik (ID_Pracownika);

-- Reference: Zaleznosci_Pracownik2 (table: Zaleznosci)
ALTER TABLE Zaleznosci ADD CONSTRAINT Zaleznosci_Pracownik2
    FOREIGN KEY (ID_Pracownik)
    REFERENCES Pracownik (ID_Pracownika);

-- End of file.

