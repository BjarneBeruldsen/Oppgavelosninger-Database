-- Enkel spørring ORDER BY og AND
--Oppgave A
--1. Etternavn og årslønn for ansatte som tjener mer enn 700.000 kroner i året. Tips: Resultatet skal altså ha 2 kolonner
SELECT Lønn, Etternavn 
FROM Ansatt 
WHERE Lønn > 700000; 

--2. Etternavn, stilling og årslønn for alle som ikke er sekretærer og tjener mindre enn 500.000 kroner i året.
SELECT Etternavn, Stilling, Lønn
FROM Ansatt
WHERE NOT(Stilling='Sekretær') AND lønn<500000; 

--3. Alle stillingsbetegnelser som er i bruk, og slik at ingen stillingsbetegnelser kommer flere ganger.
SELECT DISTINCT Stilling
FROM Ansatt; 

--4. Listen av ansatte sortert først på stilling, og deretter på etternavn.
SELECT *
FROM Ansatt
ORDER BY Stilling, Etternavn; 

--5. Ansattnummer og navn for alle ansatte født i 1982. Fornavn og etternavn skal stå i én kolonne adskilt av ett blankt tegn. 
--Utskriften skal dessuten inneholde årstall for ansettelse.Tips: Bruk funksjonen CONCAT for å sette sammen tekster. 
--Prøv først å skrive SELECT CONCAT('a','b','c') i SQL-vinduet. Svaret blir 'abc'. Bruk funksjonen YEAR for å trekke ut årstallet fra en dato. 
--Se SQL-dokumentasjonen til MySQL for eksempler.
SELECT AnsattNr, CONCAT(Fornavn," ",Etternavn)AS Navn, Year(Ansattdato) AS AnsattÅr
FROM Ansatt
WHERE Year(Fødselsdato) = 1982; 

--6. Etternavn og månedslønn for ansatte i markedsavdelingen. 
--Tips: Bruk funksjonen ROUND for å avrunde månedslønn til to desimaler, f.eks. vil ROUND(123.456, 1) gi 123.5.
SELECT Etternavn, ROUND(Lønn/12,2)AS MånedsLønn
FROM Ansatt
WHERE Avdeling='Marked'; 

--7. Personer ansatt før 2010 sortert på lønn, de som tjener mest først. 
--Tips: Skriv konkrete datoer slik: '2018-12-24' (julaften 2018). Du kan alternativt bruke funksjonen YEAR.
SELECT CONCAT(Etternavn, " ", Fornavn) AS Personer, Lønn, AnsattDato 
FROM Ansatt
WHERE year(Ansattdato) < '2010-01-01'
ORDER BY Lønn DESC; 

--8. All informasjon om ansatte som har "sekretær" i tittelen. Tips: Bruk "jokernotasjon"!
SELECT *
FROM Ansatt
WHERE stilling LIKE '%sekretær%'; 

--9. Ansattnr og stilling til alle ansatte som er eldre enn 40 år og tjener mindre enn 450.000 kroner i året.
--	Tips: Funksjonen DATE_ADD legger et tidsintervall til en dato. 
--F.eks. vil DATE_ADD('2018-12-24', INTERVAL 3 DAY) returnere datoen '2018-12-27'. 
--Intervallet kan angis i ulike måleenheter, f.eks. WEEK, MONTH eller YEAR. CURDATE gir dagens dato. 
--Du må bruke den slik: CURDATE() – altså med tomme parenteser!
SELECT AnsattNR, stilling, Fødselsdato, Lønn 
FROM Ansatt 
WHERE DATE_ADD(Fødselsdato,Interval 40 YEAR) < CURDATE() AND Lønn < 450000;

--1.a All informasjon om filmer produsert i 1988
SELECT *
FROM Film 
WHERE År = 1988; 

--1.b Tittel på amerikanske filmer produsert på 1980-tallet
SELECT Tittel 
FROM Film 
WHERE År BETWEEN 1979 AND 1990 AND Land='USA'; 

--1.c Komedier med aldersgrense under 10 år og spilletid på under 130 minutter
SELECT *
FROM Film 
WHERE Sjanger = 'Komedie' AND Alder < 10 AND Tid < 130; 

--1.d Tittel på alle action- og westernfilmer 
SELECT Tittel 
FROM Film 
WHERE Sjanger = 'Western' OR Sjanger = 'Action'; 

--1.e Alle produksjonsland, sortert og uten gjentakelser
SELECT DISTINCT Land 
FROM Film 
ORDER BY Land ASC; 

--1.i Filmer med tittel som slutter med 'now'
SELECT * 
FROM Film 
WHERE Tittel LIKE '%now%'; 

--1.m Antall år siden utgivelse for filmer eldre enn 60 år.
--Tips: Dato funksjoner vedlegg. 
SELECT FNr, YEAR(CURDATE())-År AS AntÅr 
FROM Film 
WHERE YEAR(CURDATE())-År > 60;

--Lag en spørring som viser alle personer født mellom år 2000 og 2010 med et etternavn som begynner på "H". Listen skal være sortert på navn.
SELECT *
FROM Person 
WHERE YEAR(fdato) BETWEEN 2000 AND  2010 AND etternavn LIKE 'H%'; 

--Lag en spørring som viser alle modellfly.
SELECT * 
FROM Gave
WHERE navn LIKE '%Modellfly%';

-- Skriv en SQL-spørring som viser alle rom mellom 5 og 10 kvm i lager nr. 1.
SELECT *
FROM LagerRom 
WHERE LNr = 1 
AND Kvm BETWEEN 5 AND 10;

-- Skriv en SQL-spørring som viser alle ladepunkter av type hurtiglader med pris pr. kWt mellom 5 og 8 kr.
-- Utskriften skal være sortert synkende med hensyn på pris (de dyreste først).
SELECT Nr, Navn
FROM Ladepunkt 
WHERE Navn = 'hurtiglader' 
AND kWPris BETWEEN 5.0 AND 8.0
ORDER BY kWPris DESC;

-- Bruk SQL for å øke ladepris pr. kWt med 10 % for alle hurtigladere.
UPDATE ladepunkt
SET kWPris = KWPris * 1.1
WHERE Navn = 'Hurtiglader';

-- Skriv en SQL-spørring som viser alle utsalg av type konditori i kommunene 0619 (Ål) og 0710 (Sandefjord).
-- Sorter utskriften med hensyn på kommune og navn på utsalg.

SELECT OrgNr, Navn, KoNr
FROM Utsalg
WHERE UtsType = 2 AND KoNr = '0619' OR KoNr = '0710'
ORDER BY KoNr, Navn;

-- Skriv en SQL-spørring som viser listen med presentasjoner i ett bestemt rom på én bestemt dag, f.eks. den
-- første dagen av konferansen. Ta kun med klokkeslett og tittel på foredraget i utskriften, og sorter utskriften
-- med hensyn på tittel.

SELECT TIME(StartTid) AS KlSlett, Tittel
FROM Presentasjon
WHERE RomNr = 101 AND DATE(StartTid) = '2019-03-04'
ORDER BY Tittel;

SELECT A.*, L.KvmPris * Lr.Kvm * DATEDIFF(TilDato, FraDato) AS Totalpris 
FROM Avtale AS A, LagerRom AS Lr, Lager AS L 
WHERE A.LNr = L.Lnr AND A.LNr = Lr.LNr AND A.RNr = Lr.RNr
AND A.LNr = 1;

-- Substring 
-- Skriv en SQL-spørring som viser beboere med epostadresse som slutter med gmail.com eller gmail.no.
-- Beboerens navn skal vises i én kolonne med fornavnet forkortet, f.eks. skal Arne Hansen bli vist som A.
-- Hansen. Du kan anta at ingen har flere fornavn eller sammensatte fornavn. Ta også med beboerens fødselsår
-- i utskriften
SELECT CONCAT(SUBSTRING('Fornavn', 1, 1), '.', 'Etternavn') AS Beboer, FødselsDato
FROM Beboer
WHERE EPost LIKE '%gmail.com' OR EPost LIKE '%gmail.no';