-- VIEW 
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
--Endringer i den opprinnelige tabellen skjer i view. 
--Endringer skjer i begge tabellene. 
--Det er bare en kopi. 
CREATE VIEW DyreVarer AS 
SELECT * FROM VARE WHERE Pris > 500;

--Noen view er ikke oppdaterbare 
CREATE VIEW KategoriAntall AS
	SELECT KatNr, COUNT(*) AS AntVarer 
	FROM Vare
	GROUP BY KatNr;
-- Lag et view som viser totalt beløp solgt av hver vare i 2019. 
-- Ta med varekode, betegnelse, kategorinavn og beløp.
CREATE VIEW Salg2019(VNr, Varenavn, Betegnelse, Kategori, Salg) AS 
	SELECT V.VNr, V.Betegnelse, K.Navn, SUM(Ol.PrisPrEnhet*Ol.Antall) 
	FROM Vare AS V 
	INNER JOIN Kategori AS K ON K.KatNr = V.KatNr
	INNER JOIN Ordrelinje AS Ol ON Ol.VNr = V.VNr
	INNER JOIN Ordre AS O ON O.OrdreNR = Ol.OrdreNR 
	WHERE YEAR(OrdreDato) = 2019
    GROUP BY V.VNr, V.Betegnelse, K.Navn;
-- Lag en spørring mot viewet du laget i oppgave A. Spørringen skal vise salgsbeløp pr. kategori.


SELECT Kategori, SUM(Salg) AS Totalt 
FROM Salg2019 
GROUP BY Kategori;

--Hva skjer dersom du føyer til WITH CHECK OPTION til slutt i CREATE VIEW kommandoen?
CREATE VIEW OpplysningKat1 AS
	SELECT*
	FROM Vare 
    WHERE KatNr = 1
    WITH CHECK OPTION; 
--Tabellen over avviser INSERT setninger som bryter med WHERE
SELECT G.navn, O.prioritet, G.Prod_tid
FROM Onske AS O
INNER JOIN Person AS P ON P.PNr = O.PNr 
INNER JOIN Gave AS G ON G.GNr = O.GNr
WHERE P.PNr = 23
ORDER BY Prioritet;

--Lag en spørring som viser hvilke deler som inngår i produksjonen av gave nr. 4, og hvor mange enheter av hver del. Ta med navn på hver enkelt del i utskriften.
SELECT D.Dnr, D.Lager_ant, D.navn 
FROM Oppbygging AS O
INNER JOIN Del AS D ON O.DNr = D.DNr
WHERE O.GNr = 4;

-- Lag et view som viser samlet salg for hver varekategori så langt denne måneden
CREATE VIEW SalgDenneMåned AS
	SELECT V.Kategori, SUM(Beløp) AS Totalt 
    FROM Salg AS S
    INNER JOIN Vare AS V ON S.VNr = V.VNr
    WHERE YEAR(Dato) = YEAR(CURDATE())
    AND MONTH(Dato) = MONTH(CURDATE())    
    GROUP BY V.Kategori;

-- Lag et view som viser som viser antall tilbud i hvert fylke for hver kjede.
CREATE VIEW AntTilbud AS 
	SELECT COUNT(*) AS AntTilbud, F.FyNr, Kj.OrgNr 
    FROM Utsalg AS U 
    INNER JOIN Tilbud AS T ON U.OrgNr = T.OrgNr
    INNER JOIN Kommune AS K ON U.KoNr = K.KoNr
    INNER JOIN Fylke AS F ON K.FyNr = K.FyNr
    INNER JOIN Kjede AS Kj ON Kj.OrgNr = U.Kjede
    GROUP BY F.FyNr, Ut.Kjede;

-- Dette spørsmålet tester bruk av views og også litt mer kompleks bruk av gruppering,
-- mengdefunksjoner og «formler», særlig hvis man har laget en normalisert datamodell der beløpene
-- for lunch og middag må regnes ut og summeres. Oppgaven kan nok variere i vanskelighetsgrad
-- avhengig av hvordan datamodellen ser ut, noe man må ta særlig høyde for under vurdering.
CREATE VIEW Faktura AS
SELECT D.DNr, D.Fornavn, D.Etternavn, KA.Beløp +
SUM(MB.Lunch*MP.LunchPris + MB.Middag*MP.MiddagPris) AS Beløp
FROM Deltaker AS D, KonferanseAvgift AS KA,
 MåltidPris AS MP, MåltidBestilling AS MB
WHERE D.DNr = MB.DNr AND MP.DagNr = MB.DagNr
GROUP BY D.DNr, D.Fornavn, D.Etternavn;