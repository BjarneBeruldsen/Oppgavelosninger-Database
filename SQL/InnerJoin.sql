-- INNER JOIN + Funksjoner, (Flere tabeller)
-- Skriv en SQL-spørring som viser alle avtaler som startet i 2019. Kundens navn skal tas med i utskriften, ved at
-- fornavn og etternavn slås sammen i én kolonne adskilt av et blankt tegn og gjort om til store bokstaver, f.eks.
-- slik: PEDER AAS.
SELECT UPPER(CONCAT(Fornavn, ' ', Etternavn)) AS Person, ANr
FROM Avtale AS A
INNER JOIN Kunde AS K ON A.KNr = K.KNr
WHERE Year(FraDato) = 2019;

--JOIN, Likekoblinger
--Vis hele Vare-tabellen, men erstatt katnr med navn på kategorien.
SELECT VNr, Betegnelse, Pris, Kategori.Navn, Antall, Hylle 
FROM Vare
INNER JOIN Kategori ON Vare.KatNR = Kategori.KatNR; 

--Vis alle ordrelinjer, men ta dessuten med varenavn (Betegnelse) og ordredato i utskriften 
SELECT Ol.*, V.Betegnelse, O.OrdreDato
FROM Ordrelinje AS Ol
INNER JOIN Vare AS V ON Ol.VNr = V.VNr 
INNER JOIN Ordre AS O ON Ol.OrdreNr = O.OrdreNr; 

--Utvid SQL-koden fra oppgave 1c med en ny kolonne som viser totalbeløp for hver ordrelinje 
SELECT Ol.*, V.Betegnelse, O.OrdreDato, Ol.Antall * Ol.PrisPrEnhet AS TotalBeløp
FROM Ordrelinje AS Ol
INNER JOIN Vare AS V ON Ol.VNr = V.VNr 
INNER JOIN Ordre AS O ON Ol.OrdreNr = O.OrdreNr; 

--Vis ordrenr, ordredato og kundens etternavn for alle ordrer, sortert på etternavn.
SELECT O.OrdreNr, O.OrdreDato, K.Etternavn
FROM Ordre AS O
INNER JOIN Kunde AS K ON O.KNr = K.KNr
ORDER BY K.Etternavn;

-- Skriv en SQL-spørring som viser navn på alle beboere som har en leilighet med postnummer 3200. Sorter
-- utskriften etter navn på borettslag og deretter navn på beboere.
SELECT BL.Navn, B.Fornavn, B.Etternavn
FROM Beboer AS B, Borettslag AS BL, Leilighet AS L, Leilighetbeboer AS LB
WHERE B.BeboerNr = LB.BeboerNr 
AND L.OrgNr = BL.OrgNr 
AND L.LeilighetNr = LB.LeilighetNr
AND BL.Poststed_PostNummer = 3200
ORDER BY BL.Navn, B.Fornavn, B.Etternavn;

--Lag en SQL-spørring som viser alle jobbvakter på badestranden Solsiden i 2023. Vis dato samt
--etternavn og telefon på kioskselgeren.
SELECT J.Dato, K.Etternavn, K.Telefon 
FROM Badestrand AS B 
INNER JOIN Kioskselger AS K ON J.KNr = K.KNr 
INNER JOIN JobbVakt AS J ON B.BNr = J.BNr
WHERE B.Navn = 'Solsiden'
AND Year(J.Dato) = 2023;

-- Skriv en SQL-spørring som viser alle kundebrukere med etternavn som slutter på sen, opprettet i tidsrommet
-- fra og med september 2019 og til og med januar 2020. Vis navn og antall dager som kunde. Bruk AntDager
-- som navn («overskrift») på kolonnen som viser antall dager
SELECT BNr, Fornavn, Etternavn, DAY(CURDATE()-RegDato) AS AntDager
FROM Bruker AS B
INNER JOIN brukertype AS Bt ON B.BType = Bt.TypeNr
WHERE RegDato BETWEEN 2019-09-01 AND 2020-01-31
AND Etternavn LIKE '%sen' AND Betegnelse = 'Kunde';

-- Skriv en SQL-spørring som viser alle utsalgene til kjeden Brimi 100, sortert først på fylke, deretter på
-- kommune (innen samme fylke) og til slutt utsalgsnavn (innen samme kommune).
SELECT U.Navn, U.Kjede, F.FyNr, K.KoNr
FROM Utsalg AS U 
INNER JOIN Kommune AS K ON U.KoNr = K.KoNr
INNER JOIN Fylke AS F ON F.FyNr = K.FyNr
INNER JOIN Kjede AS Kj ON U.Kjede = Kj.OrgNr
WHERE Kj.Navn = 'Brimi 100'
ORDER BY F.Navn, K.Navn, U.Navn;

-- Skriv en SQL-spørring som viser alle artikkeltitler som inneholder et bestemt ord (velg ordet selv), sammen
-- med navn på alle forfattere av artikkelen. Vis både fornavn og etternavn til forfatterne i én kolonne adskilt av
-- et blankt tegn.
SELECT P.Tittel, CONCAT(D.Fornavn, ' ', D.Etternavn) AS Navn
FROM Deltaker AS D, Forfatter AS F, Presentasjon AS P
WHERE D.DNr = F.DNr
AND F.PresNr = P.PresNr
AND P.Tittel LIKE '%solsikke%';