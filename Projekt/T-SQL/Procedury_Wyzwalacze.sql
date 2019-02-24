-- PROCEDURY

-- Procedura wypisująca ile Lombard ma klientów
CREATE PROCEDURE howManyClients @amount int OUTPUT
  AS
BEGIN
  select @amount = count(1) from Klient;
end

DECLARE @amount INT;
EXEC howManyClients @amount OUTPUT
PRINT 'Lombard aktualnie ma ' + cast(@amount as VARCHAR) + ' klientow';

-- Procedura która wyświetli umowy wraz z klientami o podanej lub wyższej kwocie jako parametr procedury.
CREATE PROCEDURE getDeals @price int
  AS
BEGIN
  select o.Imie, o.Nazwisko, sp.ID_Umowy,sp.Kwota_Umowy
  from Osoba o
  INNER JOIN Klient K ON o.ID_Osoby = K.ID_Klienta
  INNER JOIN Umowa_Kupna_Sprzedazy sp on K.ID_Klienta = sp.Klient_ID_Klienta
  where sp.Kwota_Umowy >= @price
  order by sp.Kwota_Umowy;
end

EXECUTE getDeals 200;

-- Napisz procedure wstawiajaca klienta do bazy. Jesli osoba o takim imieniu i nazwisku nie istnieję, wstaw ją do tabeli Osoba.
-- ID_Osoby ustaw jako najwyzsze +1 a potem przyporządkuj je odpowiedniemu klientowi. Jesli podane miasto nie znajduje sie
-- w bazie rowniez je dodaj.

CREATE PROCEDURE insertClient @imie VARCHAR(20), @nazwisko varchar(30), @plec as VARCHAR(1), @data DATETIME,
  @nazwaMiasta varchar(20), @ulica VARCHAR(20), @numerDomu varchar(20),@numerMieszk varchar(10),@numerDowodu varchar(20),
  @seriaDowodu varchar(20), @pesel VARCHAR(11)
  AS
BEGIN
  IF NOT EXISTS(select 1 from Miasto where Nazwa_Miasta = @nazwaMiasta)
    BEGIN
      DECLARE @ID int = (select MAX(ID_Miasta) + 1 from Miasto);
      insert into Miasto(ID_Miasta, Nazwa_Miasta) VALUES (@ID,@nazwaMiasta);
    end
  IF exists(select 1 from Osoba where Imie = @imie AND Nazwisko = @nazwisko)
    BEGIN
        DECLARE @idd int = ( select ID_Osoby from Osoba where Imie = @imie and Nazwisko = @nazwisko);
        INSERT INTO Klient(ID_Klienta, Numer_Dowodu, Seria_Dowodu) VALUES (@idd,@numerDowodu,@seriaDowodu);
    end
  ELSE
  begin
    DECLARE @ID_Os int = (SELECT MAX(ID_Osoby) + 1 from Osoba);
    DECLARE @id_Miast int = (select ID_Miasta from Miasto where Nazwa_Miasta = @nazwaMiasta);
    INSERT INTO Osoba (ID_Osoby, Imie, Nazwisko, Plec, Data_Urodzenia, Pesel, Miasto_ID_Miasta, Ulica, Numer_Domu, Numer_Mieszkania)
    VALUES (@ID_Os,@imie,@nazwisko,@plec,@data,@pesel,@id_Miast,@ulica,@numerDomu,@numerMieszk);
    INSERT INTO Klient (ID_Klienta, Numer_Dowodu, Seria_Dowodu) VALUES (@ID_Os,@numerDowodu,@seriaDowodu);
 end
end

select * from Osoba;
select * from Miasto;
select * from Klient;
EXECUTE insertClient 'Hanna','Maslowska','K','1960-08-08','Wiartel','Slomiana','15',null,'14124','1231','123124124';
select * from Osoba;
select * from Miasto;
select * from Klient;


CREATE PROCEDURE insertClient2 @imie varchar(20), @nazwisko varchar(20), @numerDowodu varchar(20), @seriaDowodu varchar(20)
  AS
BEGIN
   IF exists(select 1 from Osoba where Imie = @imie AND Nazwisko = @nazwisko)
    BEGIN
        DECLARE @idd int = ( select ID_Osoby from Osoba where Imie = @imie and Nazwisko = @nazwisko);
        INSERT INTO Klient(ID_Klienta, Numer_Dowodu, Seria_Dowodu) VALUES (@idd,@numerDowodu,@seriaDowodu);
    end
  ELSE
  BEGIN
    PRINT 'Nie istnieje osoba o podanym imieniu i nazwisku';
    PRINT 'Skorzystaj z insertClient';
  end
end


EXECUTE insertClient2 'Adam','Ewa','123123','124124';
EXECUTE insertClient2 'Jozef','Wawrzer','123123','124124';
Select * from Klient;

--  Kazdemu klientowi ktory ma wiecej badz tyle samo niz podane w parametrze umów, zmniejsz kapitał każdej umowy (Kwota_Umowy) o 10 % jesli umowa jest na kwote podaną przez parametr lub wyzsza.
-- Przy kazdej zmianie wypisz ID Klienta z informacja o zmniejszeniu kapitału
CREATE PROCEDURE setPrice @ammount int, @price int
  AS
BEGIN
  DECLARE @id_klienta int, @id_umowy int;
  declare cursorex cursor for select ID_Klienta , uu.ID_Umowy
                          from Klient k
                          INNER JOIN Umowa_Kupna_Sprzedazy uu  on k.ID_Klienta = uu.Klient_ID_Klienta
                          where (select count(*) from Umowa_Kupna_Sprzedazy u
                          where  u.Klient_ID_Klienta = k.ID_Klienta AND u.Kwota_Umowy >= @price) >= @ammount;
  open cursorex;
  FETCH NEXT FROM cursorex into @id_klienta, @id_umowy;
  WHILE @@FETCH_STATUS  = 0
  begin
    UPDATE Umowa_Kupna_Sprzedazy  SET Kwota_Umowy = Kwota_Umowy - Kwota_Umowy * 10 / 100 where ID_Umowy = @id_umowy;
    PRINT 'Klientowi o ID ' + cast(@id_klienta as VARCHAR) + ' zmniejszono kapitał o 10 % w umowie o ID ' + cast(@id_umowy as varchar);
    FETCH NEXT FROM cursorex into @id_klienta, @id_umowy;
  end
  CLOSE cursorex;
  DEALLOCATE cursorex;
end

select * from Umowa_Kupna_Sprzedazy;
EXECUTE setPrice 2,900;
select * from Umowa_Kupna_Sprzedazy;


CREATE PROCEDURE setPriceWoCursor @ammount int, @price int
  AS
BEGIN
  UPDATE Umowa_Kupna_Sprzedazy  SET Kwota_Umowy = Kwota_Umowy - Kwota_Umowy * 10 / 100 where ID_Umowy IN (select uu.ID_Umowy
  from Klient k
    INNER JOIN Umowa_Kupna_Sprzedazy uu  on k.ID_Klienta = uu.Klient_ID_Klienta
 where (select count(*) from Umowa_Kupna_Sprzedazy u
        where  u.Klient_ID_Klienta = k.ID_Klienta AND u.Kwota_Umowy >= @price) >= @ammount);
end

select * from Umowa_Kupna_Sprzedazy;
EXECUTE setPriceWoCursor 2,100;
select * from Umowa_Kupna_Sprzedazy;


-- WYZWALACZE

-- Kwota podatku w przypadku umowie na kwote >= 1000 powinna wynosić 2 % kwoty ,a poniżej 1000 powinna wynosic 0

CREATE TRIGGER kwota_Podatku
  ON Umowa_Kupna_Sprzedazy
  FOR INSERT , UPDATE
  AS
  BEGIN
IF exists(select 1 from inserted where inserted.Kwota_Podatku IS NULL OR (Kwota_Podatku > 0 AND Kwota_Umowy < 1000))
BEGIN
UPDATE Umowa_Kupna_Sprzedazy SET Kwota_Podatku = 0 where (Kwota_Podatku IS NULL AND Kwota_Umowy < 1000) OR (Kwota_Podatku > 0 AND Kwota_Umowy < 1000)
AND ID_Umowy IN ( Select ID_Umowy  from inserted)
END
UPDATE Umowa_Kupna_Sprzedazy set Kwota_Podatku = Kwota_Umowy * 2 / 100 where Kwota_Umowy >= 1000 and ID_Umowy IN (SELECT ID_Umowy from inserted);
end

select * from Umowa_Kupna_Sprzedazy;
UPDATE Umowa_Kupna_Sprzedazy set Kwota_Umowy = 1000 where ID_Umowy = 1;
UPDATE Umowa_Kupna_Sprzedazy set Kwota_Umowy = 900 where ID_Umowy = 1;
INSERT INTO Umowa_Kupna_Sprzedazy VALUES
(8, ('2017-12-01'), ('2017-12-02'), 560, null, NULL, NULL, 5);


-- Nie mozna wystawic przedmiotu na sprzedaz jesli umowa jeszcze trwa
-- Cena wystawianego przedmiotu musi byc wyzsza niz kwota w umowie z ktorej pochodzi
-- Nie mozna skasowac rzeczy na sprzedaz jesli jej status jest 'Na_Sprzedaz'

CREATE TRIGGER sprzedaz
  ON Rzecz_Na_Sprzedaz
  FOR INSERT,UPDATE,DELETE
  AS
  begin
    IF EXISTS(select 1 from inserted
              INNER JOIN Rzecz_pod_Zastaw rz ON inserted.ID_Rzecz_Sprzed = rz.ID_Rzeczy
              INNER JOIN Umowa_Kupna_Sprzedazy Sprzedazy on rz.Umowa_Kupna_Sprzedazy_ID_Umowy = Sprzedazy.ID_Umowy
              where Sprzedazy.Data_Zakonczenia >= GETDATE())
      BEGIN
        ROLLBACK;
      end
    IF EXISTS(select 1 from inserted
              INNER JOIN Rzecz_pod_Zastaw rz ON inserted.ID_Rzecz_Sprzed = rz.ID_Rzeczy
              INNER JOIN Umowa_Kupna_Sprzedazy Sprzedazy on rz.Umowa_Kupna_Sprzedazy_ID_Umowy = Sprzedazy.ID_Umowy
              where inserted.Cena_Sprzedazy < Sprzedazy.Kwota_Umowy)
      BEGIN
      ROLLBACK ;
      end

    IF EXISTS(select 1 from deleted
             INNER JOIN Rzecz_pod_Zastaw rz ON deleted.ID_Rzecz_Sprzed = rz.ID_Rzeczy
              where rz.Status = 'Na_Sprzedaz')
      BEGIN
ROLLBACK ;
      end
  end

            select *  from Umowa_Kupna_Sprzedazy;
            select * from Rzecz_Pod_Zastaw;
            select * from Rzecz_Na_Sprzedaz ;
            INSERT INTO  Rzecz_Na_Sprzedaz (ID_Rzecz_Sprzed,Cena_Sprzedazy) VALUES (6,6800); -- Pochodzi z umowy numer 5 a ta umowa jeszcze trwa
            INSERT INTO  Rzecz_Na_Sprzedaz (ID_Rzecz_Sprzed,Cena_Sprzedazy) VALUES (1,910); -- Cena umowy jest na kwote 900 pln
            DELETE FROM Rzecz_Na_Sprzedaz where ID_RZECZ_SPRZED =  4; -- Nie mozna skasowac rzeczy na sprzedaz jesli jej status jest 'Na_Sprzedaz'

-- Nie pozwoli zmienic nazwiska praownika
-- Nie pozwoli dodac pracownika z takim samym nazwiskiem


CREATE TRIGGER pracownicy
  ON Osoba
  FOR INSERT,UPDATE
  AS
  BEGIN
IF EXISTS(select 1 from inserted
          INNER JOIN deleted ON  inserted.ID_Osoby = deleted.ID_Osoby
          where  deleted.Nazwisko != inserted.Nazwisko AND deleted.ID_Osoby IN (Select ID_Pracownika from Pracownik))
          BEGIN
            ROLLBACK ;
          end

IF EXISTS(select 1 from inserted
              INNER JOIN Osoba o ON inserted.Nazwisko = o.Nazwisko
              where inserted.ID_Osoby != o.ID_Osoby AND inserted.Nazwisko  IN (select Nazwisko from Pracownik p inner JOIN Osoba o ON p.ID_Pracownika = o.ID_Osoby))
          BEGIN
            ROLLBACK ;
          end
  end

Select * from osoba;
Select * from Osoba o
INNER JOIN Pracownik ON o.ID_Osoby = Pracownik.ID_Pracownika;
UPDATE OSOBA set Nazwisko = 'Ala' where ID_Osoby = 1;
INSERT INTO Osoba VALUES
  (9, 'Krzysztof', 'Zareb', 'M',  '1975-03-12', '98734561234', 1, 'Mozdzierzy', '2', NULL);
