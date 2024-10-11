-- DELSPØRRING NOT IN
-- Skriv SQL-kode som oppretter en visning (view) med navn LedigeRom. Visningen skal inneholde alle ledige
-- lagerrom. Det innebærer at hvis man kjører spørringen SELECT * FROM LedigeRom, så vil utskriften vise alle
-- rom der det ikke finnes avtaler slik at dagens dato er mellom startdato og sluttdato.
CREATE VIEW LedigeRom AS
	SELECT *
    FROM LagerRom AS Lr
    WHERE Lr.RNr NOT IN 
    (
    SELECT A.RNr FROM Avtale AS A WHERE A.LNr = Lr.LNr
    AND CURDATE() BETWEEN FraDato AND TilDato
    );
--Finner de som tjener mer en snittet. (Kan løses med views)
SELECT *
FROM Ansatt
WHERE Årslønn > (SELECT AVG(Årslønn) FROM Ansatt);

--Delspørringer og kvantorer
--Stilling er en av de tre (NOT IN) er at det ikke er de kolonnene 
SELECT *
FROM Ansatt
WHERE Stilling IN ('Skretær', 'Selger', 'Direktør');

-- Finn kudner so IKKE har handlet noe enda.
SELECT *
FROM Kunde
WHERE KNr NOT IN (SELECT DISTINCT KNr FROM Ordre);

--Finn alle som tjener mer enn snittet 
--I sin stillingskategori 
SELECT *
FROM Ansatt AS A1
WHERE Årslønn > 
(
	SELECT AVG(Årslønn) 
	FROM Ansatt AS A2
	WHERE A1.Stilling = A2.Stilling
);
--Delspørringer i SELECT 
--Vis alt fra varetabellen + navn på kategori. 
--Uten JOIN.

SELECT *, 
	(SELECT Navn FROM Kategori 
		WHERE Vare.KatNr = Kategori.KatNr)
FROM Vare;

--Lag en spørring som for hver avlagte eksamen viser år, semester, kurskode, 
--navn på studenten og karakter, men slik at "F" blir vist som "ikke bestått".

SELECT k.aar, k.semester, k.kode, s.fornavn, s.etternavn,IF(k.karakter = 'F', 'ikke bestått', k.karakter)
FROM karakter AS k
INNER JOIN student AS s ON s.snr = k.snr; 


--Lag en spørring som viser alle kurs på det høyeste registrerte nivået, som svarer til den høyeste verdien i kolonnen nivaa.
SELECT navn, nivaa
FROM Kurs
WHERE nivaa = (SELECT max(nivaa) FROM Kurs);

-- Lag en spørring som finner gjennomsnittsprisen hvert borettslage bruker på å leie
-- av transport midler 
SELECT Borettslag.Navn, 
       (SELECT AVG(TotalPris) 
        FROM Utleie
        WHERE Borettslag.OrgNr = Utleie.OrgNr) AS GjennomsnittPris
FROM Borettslag;

-- Skriv en SQL-spørring som viser navn på beboere i Løkka borettslag som ikke har benyttet seg av muligheten
-- for lading.
SELECT B.Fornavn, B.Etternavn
FROM Beboer AS B, Borettslag AS BL, Leilighet AS L, Leilighetbeboer AS LB
WHERE B.BeboerNr = LB.BeboerNr 
AND L.OrgNr = BL.OrgNr 
AND L.LeilighetNr = LB.LeilighetNr
AND BL.Navn = 'Løkka'
AND B.BeboerNr NOT IN 
(
SELECT DISTINCT L.BeboerNr FROM Lading AS L 
);

-- Lag en SQL-spørring som viser kioskselgere som ikke har vært på vakt i 2023.
SELECT *
FROM Kisokselger AS K 
WHERE K.KNr NOT IN 
(
SELECT KNr FROM JobbVakt WHERE YEAR(Dato) = 2023; 
)

-- Returner alle kunder som har handlet 
SELECT * 
FROM Bruker AS B  
WHERE B.BNr IN (SELECT T.BNr FROM Tilbud AS T);

-- Lag en SQL-oppgave mot databasen du har laget som tester evne til å bruke delspørringer, og løs deretter
-- denne oppgaven. Prøv å lage en oppgave som er naturlig og nyttig. Legg vekt på at du formulerer spørsmålet
-- så presist som mulig. Krevende SQL-oppgaver vil gi mer uttelling enn enkle.
-- Løsningsforslaget bruker to delspørringer med bruk av IN og NOT IN, som gjør at vi får tak i alle
-- deltakere som er med i Forfatter-tabellen, men ikke i Presentasjon-tabellen
SELECT *
FROM Deltaker AS D
WHERE D.DNr IN (SELECT F.DNr FROM Forfatter AS F)
AND D.DNr NOT IN (SELECT P.DNr FROM Presentasjon AS P);