OPPGAVE 1


Lagrede funksjoner og prosedyrer Oppgaver 

-- Skriv en lagret funksjon som returnerer navnet (betegnelsen) til en vare. La varenummer være parameter til funksjonen.

-- Test funksjonen fra SQL med et korrekt varenummer.

-- Hva skjer hvis du sender med et varenummer som ikke eksisterer?

-- Test også funksjonen:

-- ved å bruke en SQL brukervariabel som aktuell parameter
-- ved å bruke en SQL brukervariabel som aktuell parameter og en annen for å motta resultatet fra funksjonen
-- for å vise varenavn i en SELECT-spørring mot tabellen Ordrelinje
USE hobbyhuset; 
SET DELIMITER ::
CREATE FUNCTION getVareNavn(in_varenr CHAR(5) ) -- sjekk datatype i databasen
RETURNS VARCHAR(100) -- samme som betegnelse i  vare tabellen 
READS SQL DATA
BEGIN 
	DECLARE varenavn VARCHAR(100) DEFAULT NULL; -- oppretter slik at resultat blir plassert i denne variabelen for å returnere den. 
	SELECT Betegnelse INTO varenavn
		FROM Vare 
		WHERE Vnr = in_varenr; 
	RETURN varenavn; 
END:: -- skriv først 
SET DELIMITER ; 

-- Testing av getVareNavn 
-- Test også funksjonen:

-- ved å bruke en SQL brukervariabel som aktuell parameter
-- ved å bruke en SQL brukervariabel som aktuell parameter og en annen for å motta resultatet fra funksjonen
-- for å vise varenavn i en SELECT-spørring mot tabellen Ordrelinje
SELECT getVareNavn('10820') AS Varenavn; 

SELECT getVareNavn(VNr) FROM Vare; 



OPPGAVE 2

-- I noen tilfeller selges varer fra Hobbyhuset med rabatt. Skriv en lagret funksjon som returnerer prisen på en vare med en gitt rabattprosent.
-- La varenummer og rabattprosent være parametere til funksjonen. Legg inn fornuftige feilsjekker som sikrer at rabattprosent har en fornuftig verdi. 
-- Hvis rabattprosenten har en ugyldig verdi skal funksjonen returnere NULL.

-- Test denne funksjonen fra SQL-vindu:

-- med et korrekt varenummer og en gyldig rabatt
-- med et korrekt varenummer og en ikke-gyldig rabatt
-- ved å bruke SQL-brukervariable som aktuelle parametere og en SQL brukervariabel for å motta resultatet fra funksjonen
-- Skriv en SELECT-setning som bruker begge funksjonene fra oppgave 1 og 2 for å vise alle varer i tabellen Ordrelinje med varenavn og rabattert pris.
USE hobbyhuset; 
SET DELIMITER :: 
DROP FUNCTION IF EXISTS vareRabatt;
CREATE FUNCTION vareRabatt(
	in_vareNr char(5), 
	in_rabatProsent DECIMAL(5, 2) -- nok til en passe rabatkode 
)
RETURNS decimal(8,2)
READS SQL DATA
BEGIN
	DECLARE rabatertPris decimal(8,2) DEFAULT NULL; -- må være øverst
	IF (in_rabatProsent < 0 OR in_rabatProsent > 100) THEN 
		RETURN null; -- feilmelding 
	END IF; -- siden den stoppet ved return null
    SELECT Pris - (Pris*in_rabatProsent / 100) into rabatertPris -- Funker kun med en rad 
		FROM Vare
		WHERE vNr = in_varenr;  
	RETURN rabatertPris;
END::
SET DELIMITER ;  

-- Test denne funksjonen fra SQL-vindu:

-- med et korrekt varenummer og en gyldig rabatt
-- med et korrekt varenummer og en ikke-gyldig rabatt
-- ved å bruke SQL-brukervariable som aktuelle parametere og en SQL brukervariabel for å motta resultatet fra funksjonen
-- Skriv en SELECT-setning som bruker begge funksjonene fra oppgave 1 og 2 for å vise alle varer i tabellen Ordrelinje med varenavn og rabattert pris.

SELECT vareRabatt('10820', 10) AS rabatertPris; 

-- med deklarering: 
SET @Varenr = '10830'; 
SET @rabatt = 50; 
SELECT vareRabatt(@Varenr, @rabatt) AS RabatertPris; 

-- Test denne funksjonen fra SQL-vindu:

-- Legger svar inn i variabel 
SET @Varenr = '10830'; 
SET @rabatt = 50; 
SELECT vareRabatt(@Varenr, @rabatt) INTO @rabatertPris; 
SELECT @rabatertPris


--Rabat fra alle varer 
SET @Varenr = '10830'; 
SET @rabatt = 50; 
SELECT *, 
	getVareNavn(OrdreLinje.VNr) AS VareNavn, 
	vareRabatt(Ordrelinje.VNr, @rabatt) AS RabatertPris
	FROM OrdreLinje; 


OPPGAVE 3
-- Skriv en lagret prosedyre som returnerer alle data om en gitt vare i form av utparametere. La varenummer være innparameter til prosedyren.
DELIMITER ::
DROP PROCEDURE IF EXISTS getVare ::
CREATE PROCEDURE getVare (
	IN  in_vnr         CHAR(5),
	OUT out_betegnelse  VARCHAR(100),
	OUT out_pris        DECIMAL(8, 2),
	OUT out_katnr       SMALLINT,
	OUT out_antall      INT,
	OUT out_hylle       CHAR(3)
)
BEGIN
	SELECT Betegnelse, Pris, KatNr, Antall, Hylle
		INTO   out_betegnelse, out_pris, out_katnr, out_antall, out_hylle
		FROM   Vare
		WHERE  Vare.VNr = in_vnr;
END ::
DELIMITER ;

-- Test prosedyren med SQL brukervariabler.
SET @Varenr = '10830'; 
CALL getVare(@Varenr, @betegnelse, @pris, @katNr, @antall, @hylle); -- må ha like mange argumenter som finnes i prosedyren 
SELECT @Varenr, @betegnelse, @pris, katNr, @antall, @hylle; 


Oppgave 4
-- Tabellen bompris inneholder priser for å passere de ulike bomstasjonene:

-- bompris(StNr*, TakstGruppeId*, VanligPris, RushtidPris)

-- Hver bomstasjon har sine egne priser, og prisene varierer for ulike takstgrupper.

-- Skriv en lagret prosedyre som endrer prisene for en gitt bomstasjon og takstgruppe. 
-- Prosedyren skal sjekke at prisendringen ikke er mer enn 50% av opprinnelig pris (unntatt hvis prisen er 0 fra før). 
-- Hvis den er det, så skal prosedyren ikke utføre endringen, men returnere en statuskode og en feilmelding i to utparametere. 
-- Bestem parametre selv, og test prosedyren med ulike verdier.
DROP PROCEDURE IF EXISTS endreBomPris; 
SET DELIMITER :: 
CREATE PROCEDURE endreBomPris (
	IN in_StNr TINYINT UNSIGNED,
    IN in_TakstGruppeId CHAR(2), 
    IN in_nyPris SMALLINT, 
    IN in_nyRushPris SMALLINT, 
    OUT ut_statuskode INTEGER,
    OUT ut_feilmelding VARCHAR(100)
) modifies sql data
BEGIN 
	DECLARE gml_Vpris smallint;
    DECLARE gml_Rpris smallint; 
    DECLARE max_endring DECIMAL(6,2) DEFAULT 50; 
    DECLARE antall integer; 
    
    SET ut_statuskode = -1; 
    IF in_nyPris < 0 OR in_nyRushPris < 0 THEN 
		SET ut_feilmelding = 'Ny pris kan ikke være negativ!'; 
	ELSE 
		SELECT VanligPris, RushtidPris INTO gml_Vpris, gml_Rpris   
        FROM bompris WHERE StNr = in_StNr 
        AND TakstGruppeId = in_TakstgruppeId; -- sjekker om bomstasjonen eksisterer
	IF(gml_Vpris IS NULL OR gml_RPris IS NULL) THEN 
		SET ut_feilmelding ='Ukjent bomstasjon og takstid';
	ELSE 
        IF(in_nyPris > (gml_Vpris*(1+(max_endring/100))) AND gml_Vpris > 0) OR
        (in_nyRushPris > (gml_Rpris*(1+(max_endring/100))) AND gml_Rpris > 0)
			THEN 
			SET ut_feilmelding = 
				CONCAT('Prisen kan ikke økes mer enn ', max_endring, ' %.'); 
		ELSE 
			UPDATE bompris SET VanligPris = in_nyPris, 
            RushtidPris = in_nyRushPris WHERE StNr = in_StNr 
            AND TakstGruppeId = in_TakstGruppeId; 
            SET ut_statuskode = 0; 
            SET ut_feilmelding = 
				CONCAT('Bomstasjonen med stnr: ', in_StNr, ' og TakstGruppeId: ', in_TakstGruppeId, 
						' har endret pris!'); 
		END IF; 
	END IF; 
END IF; 
END ::
SET DELIMITER ; 

 -- Testskript for prosedyren endreBomPris


-- Testskript for prosedyren endreBomPris

-- Tester prosedyren med ugyldig stasjonsnr
CALL endreBomPris(99, 'A', 20, 30, @kode, @melding) ;
SELECT @kode, @melding  ;

-- Resultat:
-- @kode  @melding
-- -1     Ingen priser for denne bomstasjonen eller takstgruppen.

-- Tester prosedyren med ugyldig takstgruppe
CALL endreBomPris(1, 'XX', 20, 30, @kode, @melding) ;
SELECT @kode, @melding  ;

-- Resultat:
-- @kode  @melding
-- -1     Ingen priser for denne bomstasjonen eller takstgruppen.

-- Tester prosedyren med negativ pris
CALL endreBomPris(1, 'A', 20, -30, @kode, @melding) ;
SELECT @kode, @melding  ;

-- Resultat:
-- @kode  @melding
-- -1     Ny pris kan ikke være negativ.

-- Tester prosedyren med lovlige inndata
CALL endreBomPris(1, 'A', 20, 30, @kode, @melding) ;
SELECT @kode, @melding  ;

-- Resultat:
-- @kode  @melding
-- 1      Prisene for taktsgruppe A på bomstasjon nr 1 er endret!

-- Tester prosedyren med for høye priser
CALL endreBomPris(1, 'A', 40, 60, @kode, @melding) ;
SELECT @kode, @melding  ;

-- Resultat:
-- @kode  @melding
-- -1     Prisen kan ikke økes med mer enn 50.00 %.


OPPGAVE 5
-- Tabellen taktsgruppe ser slik ut:

-- takstgruppe(TakstGruppeId, TakstGruppeNavn)

-- Skriv en lagret prosedyre som sletter en taktsgruppe med et gitt takstnummer. 
-- Bestem parametre selv. Hvis det finnes kjøretøy med den gitte takstgruppen, 
-- kan taktsgruppen ikke slettes, og prosedyren må gi fornuftige returverdier. 
-- Hvis det finnes bompriser for den gitte takstgruppen, må prosedyren slette disse før takstgruppen kan slettes. 
-- Hvis takstgruppen ikke finnes, må prosedyren håndtere dette fornuftig. Test prosedyren.

DROP PROCEDURE IF EXISTS slett_takst_gruppe; 
SET DELIMITER :: 
CREATE PROCEDURE slett_takst_gruppe (
	IN in_takstGruppeId CHAR(2), 
    OUT ut_statuskode INTEGER, 
    OUT ut_statusmelding VARCHAR(100)
)
BEGIN 
	DECLARE antall SMALLINT; 
	DECLARE harTakst CHAR(2); 
			SET ut_statuskode = -1; -- negativ betyr feil 
			SELECT COUNT(*) INTO antall FROM takstgruppe WHERE in_takstGruppeId = takstGruppeId; 
			IF (antall = 0) THEN 
				SET ut_statusmelding = CONCAT('TakstGruppeId finnes ikke!'); 
			ELSE 
				SELECT COUNT(*) INTO antall 
				FROM kjoretoy WHERE in_takstGruppeId = TakstGruppeId; 
			IF (antall != 0) THEN 
				SET ut_statusmelding = CONCAT('Takst gruppe er registrert for kjøretøy!'); 
			ELSE 
			DELETE FROM bompris WHERE in_takstGruppeId = takstGruppeId;
				DELETE FROM takstgruppe WHERE in_takstGruppeId = takstGruppeId;
				SET ut_statuskode = 1; 
				SET ut_statusmelding = CONCAT('Takst med TakstGruppeId: ', in_takstGruppeId, ' er slettet!'); 
		END IF;
	END IF;
END::
SET DELIMITER ; 

-- Testing: 
CALL slett_takst_gruppe('', @kode, @melding); 
SELECT @kode, @melding; 


