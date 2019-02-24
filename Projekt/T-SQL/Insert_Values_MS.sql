INSERT INTO Kategoria VALUES
  (1, 'Złoto');
INSERT INTO Kategoria VALUES
  (2, 'Telefon');
INSERT INTO Kategoria VALUES
  (3, 'Tablet');
INSERT INTO Kategoria VALUES
  (4, 'Laptop');
INSERT INTO Kategoria VALUES
  (5, 'Zegarek');
INSERT INTO Kategoria VALUES
  (6, 'Aparat');
  
INSERT INTO Miasto VALUES
  (1, 'Warszawa');
INSERT INTO Miasto VALUES
  (2, 'Radom');
INSERT INTO Miasto VALUES
  (3, 'Gdansk');
INSERT INTO Miasto VALUES
  (4, 'Pisz');

INSERT INTO Osoba VALUES
  (1, 'Adam', 'Nowak', 'M', CONVERT(DATETIME, '1996-10-20'), '97121715971', 1, 'Norweska', '20', NULL); --pracownik1
INSERT INTO Osoba VALUES
  (2, 'Elzbieta', 'Zareb', 'K', CONVERT(DATETIME, '1880-12-01'), '97121715234', 1, 'Szamotel', 20, NULL); --pracownik2
INSERT INTO Osoba VALUES
  (3, 'Robert', 'Pietrzyk', 'M', CONVERT(DATETIME, '1990-11-20'), '34221715971', 2, 'Komandosow', '15', NULL); --klient1
INSERT INTO Osoba VALUES
  (4, 'Ilona', 'Walewicz', 'K', CONVERT(DATETIME, '1985-2-13'), '85121713471', 3, 'Sternika', '20', '3'); --klient2
INSERT INTO Osoba VALUES
  (5, 'Kamila', 'Kalcer', 'K', CONVERT(DATETIME, '1997-12-13'), '21221713471', 2, 'Karmzynow', '15', '5'); --klient3
INSERT INTO Osoba VALUES
  (6, 'Jozef', 'Wawrzer', 'M', CONVERT(DATETIME, '1960-03-12'), '12376543876', 1, 'Krucza', '12', '23'); -- szef 1
INSERT INTO Osoba VALUES
  (7, 'Krzysztof', 'Piotras', 'M', CONVERT(DATETIME, '1975-03-12'), '98734561234', 1, 'Mozdzierzy', '2', NULL); -- szef2

  INSERT INTO Klient VALUES
  (3, '123456', 'XFYZ');
INSERT INTO Klient VALUES
  (4, '321654', 'JHGF');
INSERT INTO Klient VALUES
  (5, '768023', 'JNDV');
  INSERT INTO Klient VALUES
  (1,'863493','KDAZ');
  
  INSERT INTO Typ_Umowy VALUES
  (1, 'Umowa na czas nieokreslony');

INSERT INTO Pracownik VALUES
  (6,5000,1,NULL);
INSERT INTO Pracownik VALUES
  (7,4000,1,NULL);
  
INSERT INTO Pracownik VALUES
  (1, 2000, 1, 6 );
INSERT INTO Pracownik VALUES
  (2, 2200, 1,7);

INSERT INTO Umowa_Kupna_Sprzedazy VALUES
  (1, convert(DATETIME, '2017-12-01'), convert(DATETIME, '2018-01-01'), 990, NULL, NULL, NULL, 3);
INSERT INTO Umowa_Kupna_Sprzedazy VALUES
  (2, convert(DATETIME, '2017-12-10'), convert(DATETIME, '2017-12-24'), 2000, 40, 'Janina', 'Kowalska', 4);
INSERT INTO Umowa_Kupna_Sprzedazy VALUES
  (3, convert(DATETIME, '2017-12-01'), convert(DATETIME, '2017-12-8'), 350, NULL, NULL, NULL, 4);
INSERT INTO Umowa_Kupna_Sprzedazy VALUES
  (4, convert(DATETIME, '2017-12-01'), convert(DATETIME, '2017-12-02'), 560, NULL, NULL, NULL, 5);
 INSERT INTO Umowa_Kupna_Sprzedazy VALUES 
  (5,'2018-06-25','2018-07-25',1300,26,null ,null,1);
 INSERT INTO Umowa_Kupna_Sprzedazy VALUES 
  (6,'2018-06-25','2018-07-25',9000,180,null ,null,1);
 INSERT INTO Umowa_Kupna_Sprzedazy VALUES 
  (7,'2018-06-25','2018-07-25',2000,40,null ,null,1);

 INSERT INTO Rzecz_pod_Zastaw VALUES
 (1, 1, 'Pierscionek', 1, 'Zastaw');

INSERT INTO Rzecz_pod_Zastaw VALUES
  (2, 2, 'Iphone X', 2, 'Zastaw');

INSERT INTO Rzecz_pod_Zastaw VALUES
  (3, 6, 'Nicon', 2, 'Zastaw');

INSERT INTO Rzecz_pod_Zastaw VALUES
  (4, 4, 'Laptop HP G5', 3, 'Na_Sprzedaz');

INSERT INTO Rzecz_pod_Zastaw VALUES
  (5, 1, 'Obraczka', 4, 'Zastaw');
  

 INSERT INTO Rzecz_Na_Sprzedaz VALUES
  (4, 790);
  INSERT INTO Rzecz_pod_Zastaw VALUES
  (6, 4, 'Imac 21.5 4K', 5, 'Zastaw');
  INSERT INTO Rzecz_pod_Zastaw VALUES
  (7, 4, 'DELL XPS 15 4K', 6, 'Zastaw');
  INSERT INTO Rzecz_pod_Zastaw VALUES
  (8, 4, 'Macbook pro 15', 7, 'Zastaw');
  
INSERT INTO Zaleznosci VALUES
  (6, 1);
  INSERT INTO Zaleznosci VALUES
  (6,2);
  INSERT INTO Zaleznosci VALUES
  (7,1);
INSERT INTO Zaleznosci VALUES
  (7, 2);
