-- COUNT GROUP BY 
-- Skriv en SQL-spørring som viser alle avtaler som startet i 2019. Kundens navn skal tas med i utskriften, ved at
-- fornavn og etternavn slås sammen i én kolonne adskilt av et blankt tegn og gjort om til store bokstaver, f.eks.
-- slik: PEDER AAS.
SELECT UPPER(CONCAT(Fornavn, ' ', Etternavn)) AS Person, ANr
FROM Avtale AS A
INNER JOIN Kunde AS K ON A.KNr = K.KNr
WHERE Year(FraDato) = 2019;

-- Skriv en SQL-spørring som viser antall rom i hvert lager, men ta kun med lager som har flere enn 5 rom.
-- Sorter utskriften synkende med hensyn på antall rom, altså slik at de største lagrene kommer først.
SELECT COUNT(*) AS Antallrom, LNr
FROM Lagerrom 
GROUP BY LNr
HAVING COUNT(*) > 5
ORDER BY COUNT(*) DESC;

--GRUPPERING OG MENGDEFUNKSJONER

--Prisen på den dyreste varen.
SELECT MAX(PrisPrEnhet) AS Dyreste
FROM Ordrelinje 

--Prisen på dyreste vare i hver enkelt varekategori.
SELECT KatNR, MAX(Pris) AS Dyreste 
FROM Vare
GROUP BY KatNR; 

--Høyeste og laveste månedslønn i hver stillingskategori.
SELECT Stilling, MAX(ROUND(Årslønn/12,2)) AS Høyeste, MIN(ROUND(Årslønn/12,2)) AS Laveste
FROM Ansatt
GROUP BY Stilling; 

--Varekategorier som inneholder flere enn 10 varer.
SELECT KatNr, COUNT(*) AS AntallVarer
FROM Vare 
GROUP BY KatNr
HAVING COUNT(*) >= 10;

--Lag en spørring som teller opp antall ønsker for personer med flere enn 7 ønsker. 
--Spørreresultatet skal vise personnr, fornavn og etternavn i én kolonne, samt antall ønsker. 
--Sorter utskriften etter fødselsår, de yngste først.
SELECT CONCAT(P.PNr, ' ', P.Fornavn, ' ', P.Etternavn) AS Person, COUNT(*) AS AntOnske 
FROM Onske AS O 
INNER JOIN Person AS P ON O.PNr = P.PNr
GROUP BY P.PNr, P.Fornavn, P.Etternavn
HAVING COUNT(*) > 7 
ORDER BY fdato;

-- Skriv en SQL-spørring som viser totalt ladebeløp inneværende år for hver enkelt beboer. Utskriften skal være
-- sortert med hensyn på beboerens navn.
SELECT  B.BeboerNr, B.Fornavn, B.Etternavn, SUM(L.Beløp) AS TotalBeløp
FROM Beboer AS B 
INNER JOIN Lading AS L ON B.BeboerNr = L.BeboerNr
WHERE Year(StartTid) = Year(CURDATE())
GROUP BY B.BeboerNr, B.Fornavn, B.Etternavn;

--Lag en SQL-spørring som viser antall registrerte vakter for hver enkelt kioskselger, men kun de med
--flere enn 1 vakt skal tas med i utskriften.
SELECT K.KNr, K.Fornavn, K.Etternavn, COUNT(*) AS AntVakter
FROM Jobbvakt AS J 
INNER JOIN Kioskselger AS K ON J.KNr = K.KNr
GROUP BY K.KNr, K.Fornavn, K.Etternavn
HAVING COUNT(*) > 1

-- Skriv en SQL-spørring som viser totalt handlebeløp inneværende år for alle kunder. Sorter utskriften med
-- hensyn på kundens navn.

SELECT B.BNr, B.Fornavn, B.Etternavn, SUM(Pris) As TotalBeløp
FROM Tilbud AS T
INNER JOIN Bruker AS B ON B.BNr = T.BNr
INNER JOIN BrukerType AS Bt ON B.Btype = BT.TypeNr
WHERE Betegnelse = 'Kunde' 
AND YEAR(Dato) = YEAR(CURDATE()) 
GROUP BY B.BNr, B.Fornavn, B.etternavn
ORDER BY B.etternavn, B.Fornavn;

-- Skriv en SQL-spørring som viser antall deltakere som har vist interesse for hvert tema.
SELECT T.TemaNr, T.TemaNavn, COUNT(*) AS AntallDeltakere
FROM Deltakertema AS DT INNER JOIN Tema AS T ON DT.TemaNr = T.TemaNr
GROUP BY T.TemaNr, T.TemaNavn;