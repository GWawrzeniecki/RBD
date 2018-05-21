--Pytania SQL s15429 Grupa 20C  Baza - LOMBARD


--Podaj przelozonego kazdego pracownika

SELECT
  OZ.Imie,
  OZ.Nazwisko,
  (SELECT OW.Nazwisko
   FROM Osoba OW
   WHERE Ow.ID_OSOBY = pr.ID_Szefa) "Przełożony"
FROM Osoba OZ
  INNER JOIN PRACOWNIK pr ON OZ.ID_OSOBY = pr.ID_PRACOWNIKA;

--Podaj jaki pracownik jakiemu podlega szefowi.

SELECT
  a.IMIE || ' ' || a.NAZWISKO       AS Pracownik,
  szef.IMIE || ' ' || szef.NAZWISKO AS Szef
FROM osoba a, osoba szef, Zaleznosci
WHERE ZALEZNOSCI.ID_SZEF = szef.ID_OSOBY AND ZALEZNOSCI.ID_PRACOWNIK = a.ID_OSOBY;


SELECT
  o.IMIE           "Imie Pracownika",
  o.NAZWISKO       "Nazwisko Pracownika",
  PRIOR o.IMIE     "Imie Szefa",
  PRIOR o.NAZWISKO "Nazwisko Szefa",
  LEVEL
FROM Osoba o
  INNER JOIN Pracownik pr ON o.ID_OSOBY = pr.ID_Pracownika
CONNECT BY PRIOR o.ID_OSOBY = pr.ID_Szefa
START WITH pr.ID_Szefa IS NULL;

--Wypisz pracownikow ktorzy nie posiadaja szefów


SELECT o.*
FROM Osoba o
  INNER JOIN Pracownik pr ON pr.ID_PRACOWNIKA = o.ID_OSOBY
WHERE NOT EXISTS(SELECT '1'
                 FROM PRACOWNIK pr2
                 WHERE pr.ID_Szefa = pr2.ID_PRACOWNIKA);

-- Wypisz pracownikow ktorzy posiadaja szefow

SELECT o.*
FROM Osoba o
  INNER JOIN PRACOWNIK pr ON pr.ID_PRACOWNIKA = o.ID_OSOBY
WHERE EXISTS(SELECT '1'
             FROM PRACOWNIK pr2
             WHERE pr.ID_Szefa = pr2.ID_PRACOWNIKA);

--Podaj jaki klient , jakie posiada umowy.

SELECT
  a.IMIE || ' ' || a.NAZWISKO AS Klient,
  U.KWOTA_UMOWY,
  U.DATA_PODPISANIA,
  U.DATA_ZAKONCZENIA,
  NVL(U.KWOTA_PODATKU, 0)        "Kwota Podatku"
FROM Osoba a, Klient k, UMOWA_KUPNA_SPRZEDAZY U
WHERE k.ID_KLIENTA = a.ID_OSOBY AND U.KLIENT_ID_KLIENTA = K.ID_KLIENTA;

--Wypisz rzeczy wystawione na sprzedaż wraz z ich cena, kategorią, oraz z której umowy pochodza.


SELECT
  RZECZ_POD_ZASTAW.NAZWA,
  Kategoria.Kategoria,
  RZECZ_NA_SPRZEDAZ.CENA_SPRZEDAZY "Cena Sprzedazy",
  s.ID_UMOWY                       "ID Umowy"
FROM RZECZ_NA_SPRZEDAZ
  INNER JOIN RZECZ_POD_ZASTAW ON ID_RZECZY = RZECZ_NA_SPRZEDAZ.ID_RZECZ_SPRZED
  INNER JOIN KATEGORIA ON RZECZ_POD_ZASTAW.KATEGORIA_ID_KATEGORII = KATEGORIA.ID_KATEGORII
  INNER JOIN UMOWA_KUPNA_SPRZEDAZY S ON RZECZ_POD_ZASTAW.UMOWA_KUPNA_SPRZEDAZY_ID_UMOWY = S.ID_UMOWY;

--Wypisz wszystkie umowy z miesiaca grudzien 2017 roku.

SELECT
  u.ID_UMOWY,
  u.KLIENT_ID_KLIENTA,
  u.KWOTA_UMOWY
FROM UMOWA_KUPNA_SPRZEDAZY u
WHERE EXTRACT(YEAR FROM u.DATA_PODPISANIA) = 2017 AND u.DATA_PODPISANIA LIKE '%/12/%';

--Wypisz sumę wszystkich kwot z umów z miesiąca grudzień.

SELECT sum(u.KWOTA_UMOWY) "Suma umow z miesiaca Grudzien"
FROM UMOWA_KUPNA_SPRZEDAZY u
WHERE EXTRACT(YEAR FROM u.DATA_PODPISANIA) = 2017 AND u.DATA_PODPISANIA LIKE '%/12/%';

--Podaj pensje pracowników wraz z nazwiskiem i imieniem posegregowane rosnąco według pensji.

SELECT
  prac.IMIE,
  prac.NAZWISKO,
  p.PENSJA
FROM Osoba prac
  INNER JOIN PRACOWNIK p ON prac.ID_OSOBY = p.ID_PRACOWNIKA
ORDER BY p.PENSJA;

--Podaj z jakiego miasta ile pochodzi klientow.Podaj tylko te miasta gdzie liczba klientow jest wieksza niz 1.

SELECT
  count(*) " Liczba Klientow",
  m.NAZWA_MIASTA
FROM OSOBA o
  INNER JOIN KLIENT k ON o.ID_OSOBY = k.ID_KLIENTA
  INNER JOIN MIASTO m ON m.ID_MIASTA = o.MIASTO_ID_MIASTA
GROUP BY m.NAZWA_MIASTA
HAVING COUNT(*) > 1;

--Wypisz wszystkie rzeczy pod zastaw, tylko z kategori 'ZLOTO' oraz klienta który jes zastawił

SELECT
  rz.NAZWA "Przedmiot Zastawu ",
  o.IMIE,
  o.NAZWISKO,
  u.KWOTA_UMOWY
FROM RZECZ_POD_ZASTAW rz
  INNER JOIN KATEGORIA K ON rz.KATEGORIA_ID_KATEGORII = K.ID_KATEGORII
  INNER JOIN UMOWA_KUPNA_SPRZEDAZY u ON rz.UMOWA_KUPNA_SPRZEDAZY_ID_UMOWY = u.ID_UMOWY
  INNER JOIN KLIENT kl ON u.KLIENT_ID_KLIENTA = kl.ID_KLIENTA
  INNER JOIN Osoba o ON kl.ID_KLIENTA = o.ID_OSOBY
WHERE K.KATEGORIA = 'Złoto';

--Wypisz dla kazdej kategori ilosc zastawionych rzeczy.Posegreguj malejaco.

SELECT
  K.KATEGORIA,
  count(*) Ilosc
FROM RZECZ_POD_ZASTAW rz
  INNER JOIN KATEGORIA K ON rz.KATEGORIA_ID_KATEGORII = K.ID_KATEGORII
  INNER JOIN UMOWA_KUPNA_SPRZEDAZY u ON rz.UMOWA_KUPNA_SPRZEDAZY_ID_UMOWY = u.ID_UMOWY
  INNER JOIN KLIENT kl ON u.KLIENT_ID_KLIENTA = kl.ID_KLIENTA
  INNER JOIN Osoba o ON kl.ID_KLIENTA = o.ID_OSOBY
GROUP BY KATEGORIA
ORDER BY count(*) DESC;

--Podaj umowy na kwote 2000 zł, Dane personalne klientow tych umow raz rzeczy zawarte w tej umowie.

SELECT
  U.ID_UMOWY,
  rz.NAZWA,
  o.IMIE,
  o.NAZWISKO
FROM UMOWA_KUPNA_SPRZEDAZY u
  INNER JOIN RZECZ_POD_ZASTAW rz ON u.ID_UMOWY = rz.UMOWA_KUPNA_SPRZEDAZY_ID_UMOWY
  INNER JOIN Klient k ON u.KLIENT_ID_KLIENTA = k.ID_KLIENTA
  INNER JOIN Osoba o ON k.ID_KLIENTA = o.ID_OSOBY
WHERE u.KWOTA_UMOWY = 2000;

--Znajdz umowy w ktorych kategoria zastawu byłą taka jak w umowie o ID = 4

SELECT u.*
FROM UMOWA_KUPNA_SPRZEDAZY u
  INNER JOIN RZECZ_POD_ZASTAW rz ON u.ID_UMOWY = rz.UMOWA_KUPNA_SPRZEDAZY_ID_UMOWY
  INNER JOIN KATEGORIA k ON rz.KATEGORIA_ID_KATEGORII = k.ID_KATEGORII
WHERE k.ID_KATEGORII IN (SELECT k2.ID_KATEGORII
                         FROM UMOWA_KUPNA_SPRZEDAZY u2
                           INNER JOIN RZECZ_POD_ZASTAW rz2 ON u2.ID_UMOWY = rz2.UMOWA_KUPNA_SPRZEDAZY_ID_UMOWY
                           INNER JOIN KATEGORIA k2 ON k2.ID_KATEGORII = rz2.KATEGORIA_ID_KATEGORII
                         WHERE u2.ID_UMOWY = 4);

--Podaj pracownika która zarabia najwięcej ze wszystkich

SELECT
  o.*,
  pr.Pensja
FROM OSOBA o
  INNER JOIN Pracownik pr ON o.ID_OSOBY = pr.ID_Pracownika
WHERE pr.Pensja = (SELECT MAX(pr2.Pensja)
                   FROM Pracownik pr2);

--Znajdz kategorie ktora nie wystepuje w zadnej umowie
SELECT
  k.ID_KATEGORII,
  k.KATEGORIA
FROM KATEGORIA k
WHERE k.ID_KATEGORII NOT IN (SELECT k2.ID_KATEGORII
                             FROM UMOWA_KUPNA_SPRZEDAZY u2
                               INNER JOIN RZECZ_POD_ZASTAW rz2 ON u2.ID_UMOWY = rz2.UMOWA_KUPNA_SPRZEDAZY_ID_UMOWY
                               INNER JOIN KATEGORIA k2 ON k2.ID_KATEGORII = rz2.KATEGORIA_ID_KATEGORII
);

--Ile jest umów z każdek kategorii
SELECT
  k2.ID_KATEGORII,
  k2.KATEGORIA,
  count(*)
FROM UMOWA_KUPNA_SPRZEDAZY u2
  INNER JOIN RZECZ_POD_ZASTAW rz2 ON u2.ID_UMOWY = rz2.UMOWA_KUPNA_SPRZEDAZY_ID_UMOWY
  INNER JOIN KATEGORIA k2 ON k2.ID_KATEGORII = rz2.KATEGORIA_ID_KATEGORII
GROUP BY k2.ID_KATEGORII, k2.KATEGORIA;

--Wypisz dane klientow ktorzy posiadaja nastarsze umowy z roku 2017


SELECT
  klient.ID_KLIENTA,
  o.IMIE,
  o.NAZWISKO,
  uu.DATA_PODPISANIA
FROM KLIENT klient, UMOWA_KUPNA_SPRZEDAZY uu, Osoba o
WHERE o.ID_OSOBY = klient.ID_KLIENTA AND
      exists(SELECT '1'
             FROM UMOWA_KUPNA_SPRZEDAZY u
             WHERE u.KLIENT_ID_KLIENTA = klient.ID_KLIENTA AND
                   uu.ID_UMOWY = u.ID_UMOWY
                   AND
                   u.DATA_PODPISANIA IN (SELECT MIN(u2.DATA_PODPISANIA)
                                         FROM UMOWA_KUPNA_SPRZEDAZY u2
                                         WHERE EXTRACT(YEAR FROM u.DATA_PODPISANIA) = 2017 AND
                                               u.DATA_PODPISANIA LIKE '%/12/%'));


