-- PROCEDURY

-- Procedura wypisująca ile Lombard ma klientów

CREATE PROCEDURE howManyClients
AS
ile number;
BEGIN
select count(1) into ile from Klient;
dbms_output.put_line('Lombard aktualnie ma ' || ile || ' klientow');
END;

SET SERVEROUTPUT ON;

EXECUTE howManyClients;
select count(1) into ile from Klient;


-- Procedura która wyświetli umowy wraz z klientami o podanej lub wyższej kwocie jako parametr procedury.
 SET SERVEROUTPUT ON;
 
CREATE OR REPLACE PROCEDURE getDeals (price_in in number)
AS
CURSOR cursorex IS select o.Imie, o.Nazwisko, sp.ID_Umowy,sp.Kwota_Umowy
  from Osoba o
  INNER JOIN Klient K ON o.ID_Osoby = K.ID_Klienta
  INNER JOIN Umowa_Kupna_Sprzedazy sp on K.ID_Klienta = sp.Klient_ID_Klienta
  where sp.Kwota_Umowy >= price_in
  order by sp.Kwota_Umowy;
  dealsRow cursorex%rowtype;
BEGIN
  OPEN cursorex;
  LOOP
  FETCH cursorex into dealsRow;
  EXIT WHEN cursorex%NOTFOUND;
  dbms_output.put_line('Klient ' || dealsRow.imie || ' ' || dealsRow.nazwisko || ' posiada umowe, o numerze ID ' || dealsRow.ID_Umowy || ' na kwote ' || dealsRow.Kwota_Umowy);
  END LOOP;
  CLOSE cursorex;
END;
  
 
  
  EXECUTE getDeals (100);
  
-- Napisz procedure wstawiajaca klienta do bazy. Jesli osoba o takim imieniu i nazwisku nie istnieję, wstaw ją do tabeli Osoba.
-- ID_Osoby ustaw jako najwyzsze +1 a potem przyporządkuj je odpowiedniemu klientowi. Jesli podane miasto nie znajduje sie
-- w bazie rowniez je dodaj.

CREATE OR REPLACE PROCEDURE insertClient (v_imie IN  Osoba.Imie%type, v_nazwisko IN Osoba.Nazwisko%type, v_plec IN Osoba.Plec%type, v_dataa IN Osoba.Data_Urodzenia%type,
  v_nazwaMiasta IN Miasto.Nazwa_Miasta%type, v_ulica IN Osoba.Ulica%type, v_numerDomu IN Osoba.Numer_Domu%type, v_numerMieszk IN Osoba.Numer_Mieszkania%type, v_numerDowodu IN Klient.Numer_Dowodu%type,
  v_seriaDowodu IN Klient.Seria_Dowodu%type, v_pesel IN Osoba.Pesel%type)
  AS
  ilosc number := 0;
  idd number := 0;
  id_miastaa number := 0;
BEGIN
select count(1) into ilosc from Miasto where Nazwa_Miasta = v_nazwaMiasta;
IF ilosc = 0 THEN
      select MAX(ID_Miasta) +1 into idd from Miasto;
      insert into Miasto(ID_Miasta, Nazwa_Miasta) VALUES (idd,v_nazwaMiasta);
END IF;
  select count(1) into ilosc from Osoba where Imie = v_imie AND Nazwisko = V_nazwisko;
  IF ilosc > 0 THEN
        select ID_Osoby into idd from Osoba where Imie = imie and Nazwisko = v_nazwisko;
        INSERT INTO Klient(ID_Klienta, Numer_Dowodu, Seria_Dowodu) VALUES (idd,v_numerDowodu,v_seriaDowodu);
  ELSE
    select MAX(ID_Osoby) + 1 into idd from Osoba;
    select ID_Miasta into id_miastaa from Miasto where Nazwa_Miasta = v_nazwaMiasta;
    INSERT INTO Osoba (ID_Osoby, Imie, Nazwisko, Plec, Data_Urodzenia, Pesel, Miasto_ID_Miasta, Ulica, Numer_Domu, Numer_Mieszkania)
    VALUES (idd,v_imie,v_nazwisko,v_plec,v_dataa,v_pesel,id_miastaa,v_ulica,v_numerDomu,v_numerMieszk);
    INSERT INTO Klient (ID_Klienta, Numer_Dowodu, Seria_Dowodu) VALUES (idd,v_numerDowodu,v_seriaDowodu);
 END IF;
end;


select * from Osoba;
select * from Miasto;
select * from Klient;
CALL insertClient ('Hanna','Maslowska','K','1960-08-08','Wiartel','Slomiana','15',null,'14124','1231','123124124');
select * from Osoba;
select * from Miasto;
select * from Klient;



CREATE OR REPLACE PROCEDURE insertClient2 (v_imie IN Osoba.imie%type, v_nazwisko Osoba.nazwisko%type, v_numerDowodu IN Klient.Numer_Dowodu%type, v_seriaDowodu IN Klient.Seria_Dowodu%type)
  AS
  ilosc number := 0;
  idd number := 0;
BEGIN
   select count(1) into ilosc from Osoba where Imie = v_imie AND Nazwisko = v_nazwisko;
   IF ilosc > 0 THEN
         select ID_Osoby into idd from Osoba where Imie = v_imie and Nazwisko = v_nazwisko;
        INSERT INTO Klient(ID_Klienta, Numer_Dowodu, Seria_Dowodu) VALUES (idd,v_numerDowodu,v_seriaDowodu);
  ELSE
    dbms_output.put_line('Nie istnieje osoba o podanym imieniu i nazwisku');
    dbms_output.put_line('Skorzystaj z insertClient');
  END IF;
END;

EXECUTE insertClient2 ('Adam','Ewa','123123','124124');
EXECUTE insertClient2 ('Jozef','Wawrzer','123123','124124');
Select * from Klient;

--  Kazdemu klientowi ktory ma wiecej badz tyle samo niz podane w parametrze umów, zmniejsz kapitał każdej umowy (Kwota_Umowy) o 10 % jesli umowa jest na kwote podaną przez parametr lub wyzsza.
-- Przy kazdej zmianie wypisz ID Klienta z informacja o zmniejszeniu kapitału    
CREATE OR REPLACE PROCEDURE setPrice (ammount number, price number )
  AS
  Cursor cursorex IS select ID_Klienta , uu.ID_Umowy
                          from Klient k
                          INNER JOIN Umowa_Kupna_Sprzedazy uu  on k.ID_Klienta = uu.Klient_ID_Klienta
                          where (select count(*) from Umowa_Kupna_Sprzedazy u
                          where  u.Klient_ID_Klienta = k.ID_Klienta AND u.Kwota_Umowy >= price) >= ammount for update of Kwota_Umowy;
v_row cursorex%rowtype;                          
BEGIN
  open cursorex;
  LOOP
  fetch cursorex into v_row;
  EXIT WHEN cursorex%NOTFOUND;
  UPDATE Umowa_Kupna_Sprzedazy  SET Kwota_Umowy = Kwota_Umowy * 0.9 where current of cursorex;
  dbms_output.put_line( 'Klientowi o ID ' || v_row.ID_Klienta || ' zmniejszono kapitał o 10 % w umowie o ID ' || v_row.ID_Umowy);
  END LOOP; 
  CLOSE cursorex;
END;

SET SERVEROUTPUT ON;
select * from Umowa_Kupna_Sprzedazy;
EXECUTE setPrice(2,100);
select * from Umowa_Kupna_Sprzedazy;

CREATE OR REPLACE PROCEDURE setPriceWoCursor (ammount number,price number)
AS
BEGIN
  UPDATE Umowa_Kupna_Sprzedazy  SET Kwota_Umowy = Kwota_Umowy * 0.9 where ID_Umowy IN (select uu.ID_Umowy
  from Klient k
    INNER JOIN Umowa_Kupna_Sprzedazy uu  on k.ID_Klienta = uu.Klient_ID_Klienta
 where (select count(*) from Umowa_Kupna_Sprzedazy u
        where  u.Klient_ID_Klienta = k.ID_Klienta AND u.Kwota_Umowy >= price) >= ammount);
end;

select * from Umowa_Kupna_Sprzedazy;
EXECUTE setPriceWoCursor(2,200);
select * from Umowa_Kupna_Sprzedazy;

-- WYZWALACZE

-- Kwota podatku w przypadku umowie na kwote >= 1000 powinna wynosić 2 % kwoty ,a poniżej 1000 powinna wynosic 0

CREATE OR REPLACE TRIGGER kwota_Podatkuu
 after INSERT OR UPDATE of Kwota_Umowy
 ON Umowa_Kupna_Sprzedazy
 FOR EACH ROW
 BEGIN
 IF (:NEW.Kwota_Umowy < 1000 AND (:NEW.Kwota_Podatku IS NULL OR :NEW.Kwota_Podatku > 0)) THEN
 raise_application_error(-20500,'Kwota_Podatku powinna wynosic 0');
 ELSE
 raise_application_error(-20500,'Kwota_Podatku powinna wynosic 2% Kwoty_Umowy');
 END IF;
 END;

select * from Umowa_Kupna_Sprzedazy;
UPDATE Umowa_Kupna_Sprzedazy set Kwota_Umowy = 1000 where ID_Umowy = 1;
UPDATE Umowa_Kupna_Sprzedazy set Kwota_Umowy = 900 where ID_Umowy = 1;
INSERT INTO Umowa_Kupna_Sprzedazy VALUES
  (8, to_date('2017-12-01'), to_date('2017-12-02'), 560, null, NULL, NULL, 5);
  
-- Nie mozna wystawic przedmiotu na sprzedaz jesli umowa jeszcze trwa
-- Cena wystawianego przedmiotu musi byc wyzsza niz kwota w umowie z ktorej pochodzi
-- Nie mozna skasowac rzeczy na sprzedaz jesli jej status jest 'Na_Sprzedaz'

CREATE  OR REPLACE TRIGGER sprzedaz
  BEFORE INSERT OR UPDATE OR DELETE
  ON Rzecz_Na_Sprzedaz
  FOR EACH ROW
DECLARE
  tmp number := 0;
  begin
  select count(1) into tmp  from Rzecz_pod_Zastaw rz
            INNER JOIN Umowa_Kupna_Sprzedazy Sprzedazy on rz.Umowa_Kupna_Sprzedazy_ID_Umowy = Sprzedazy.ID_Umowy
            where :NEW.ID_Rzecz_Sprzed = rz.ID_Rzeczy AND Sprzedazy.Data_Zakonczenia >= CURRENT_DATE;
            
         IF tmp > 0 THEN
        raise_application_error(-20500,'Nie mozna wystawic przedmiotu na sprzedaz jesli umowa jeszcze trwa');
        END IF;    
      
       select count(1) into tmp from  Rzecz_pod_Zastaw rz 
              INNER JOIN Umowa_Kupna_Sprzedazy Sprzedazy on rz.Umowa_Kupna_Sprzedazy_ID_Umowy = Sprzedazy.ID_Umowy
              where :NEW.Cena_Sprzedazy < Sprzedazy.Kwota_Umowy AND :NEW.ID_Rzecz_Sprzed = rz.ID_Rzeczy;
              
              IF tmp > 0 THEN
                raise_application_error(-20500,'Cena wystawianego przedmiotu musi byc wyzsza niz kwota w umowie z ktorej pochodzi');
                END IF;

   select count(1)into tmp from  Rzecz_pod_Zastaw rz 
              where rz.Status = 'Na_Sprzedaz' AND :OLD.ID_Rzecz_Sprzed = rz.ID_Rzeczy;

            IF tmp > 0 THEN
             raise_application_error(-20500,'Nie mozna skasowac rzeczy na sprzedaz jesli jej status jest Na_Sprzedaz');
             END IF;
             END;
             
             select *      from Umowa_Kupna_Sprzedazy;
            select * from Rzecz_Pod_Zastaw;  
            select * from Rzecz_Na_Sprzedaz ;
            INSERT INTO  Rzecz_Na_Sprzedaz (ID_Rzecz_Sprzed,Cena_Sprzedazy) VALUES (6,6800);
            INSERT INTO  Rzecz_Na_Sprzedaz (ID_Rzecz_Sprzed,Cena_Sprzedazy) VALUES (6,1000);
            DELETE FROM Rzecz_Na_Sprzedaz where ID_RZECZ_SPRZED =  4;

-- Nie pozwoli zmienic nazwiska praownika
-- Nie pozwoli dodac pracownika z takim samym nazwiskiem


CREATE OR REPLACE TRIGGER pracownicy
BEFORE INSERT OR UPDATE of Nazwisko
ON Osoba
FOR EACH ROW
DECLARE 
tmp number := 0;
BEGIN
IF UPDATING THEN
select 1 into tmp from Pracownik where :OLD.ID_Osoby = Pracownik.ID_Pracownika;
IF tmp > 0 THEN
raise_application_error(-20500,'Nie wolno zmieniac nazwiska pracownika');
END IF;
END IF;
IF INSERTING THEN
SELECT count(1) into tmp from Osoba where :NEW.Nazwisko IN (Select Nazwisko From Osoba INNER JOIN Pracownik p ON Osoba.ID_Osoby = p.ID_Pracownika);
IF tmp > 0 THEN
raise_application_error(-20500,'Pracownik o takim nazwisku juz istnieje');
END IF;
END IF;
END;

Select * from Osoba o
INNER JOIN Pracownik ON o.ID_Osoby = Pracownik.ID_Pracownika;
UPDATE OSOBA set Nazwisko = 'Ala' where ID_Osoby = 1;
INSERT INTO Osoba VALUES
  (9, 'Krzysztof', 'Zareb', 'M',  '1975-03-12', '98734561234', 1, 'Mozdzierzy', '2', NULL); 
   