-- Skriv et SQL-skript som inneholder en transaksjon som registrerer en ny ordre med 2-3 ordrelinjer 
-- og som teller ned varebeholdningen med antall bestilte varer på ordren
-- Deklarer variabler 
SET @kundenr = 5011;  


START TRANSACTION; 
	SELECT MAX(OrdreNr) + 1 INTO @neste_ordrenr FROM ordre FOR UPDATE; 
    INSERT INTO Ordre(OrdreNr, Ordredato, KNr) 
		VALUES(@neste_ordrenr, current_date(), @kundenr); 
	
    SET @Antall = 2; 
    SET @VNr = 10830; 
    INSERT INTO ordrelinje(OrdreNr, VNr, PrisPrEnhet, Antall)
		VALUES(@neste_ordrenr, @VNr, (SELECT Pris FROM Vare WHERE VNr = @VNr), @Antall); 
        
	SET @Antall = 5; 
    SET @VNr = 44939; 
    INSERT INTO ordrelinje(OrdreNr, VNr, PrisPrEnhet, Antall)
		VALUES(@neste_ordrenr, @VNr, (SELECT Pris FROM Vare WHERE VNr = @VNr), @Antall); 
        
	SET @Antall = 8; 
    SET @VNr = 41020; 
    INSERT INTO ordrelinje(OrdreNr, VNr, PrisPrEnhet, Antall)
		VALUES(@neste_ordrenr, @VNr, (SELECT Pris FROM Vare WHERE VNr = @VNr), @Antall); 
	
    UPDATE Vare v, ordrelinje ol 
		SET v.Antall = v.Antall - ol.Antall
		WHERE ol.ordrenr = @neste_ordrenr AND v.vnr = ol.vnr; 
COMMIT; 

/*
Oppgave 2: Lagre prosedyre for å slette en takstgruppe.
Denne prosedyren sjekker om takstgruppen eksisterer og om den er tilknyttet et kjøretøy.
Hvis det er trygt, slettes takstgruppen og dens tilknyttede priser.
*/


OPPGAVE 2
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
            START TRANSACTION; 
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
    IF(ut_statuskode = 1) THEN
		COMMIT; 
	ELSE 
		ROLLBACK; 
	END IF; 
END::
SET DELIMITER ; 

/*
Oppgave 3: Prosedyre for overføring mellom to kontoer.
Denne prosedyren overfører et gitt beløp mellom to kontoer, oppdaterer saldoene og loggfører transaksjonen.
*/

OPPGAVE 3  
SET DELIMITER :: 
DROP PROCEDURE IF EXISTS sp_overforBelop :: 
CREATE PROCEDURE sp_overforBelop (
	IN belop DECIMAL (15,2), 
	IN fraKontonr VARCHAR(11), 
    IN tilKontoNr VARCHAR(11), 
    OUT resultatKode int, 
    OUT melding VARCHAR(100)
)
BEGIN 
	DECLARE v_frakontoID int; 
    DECLARE v_tilkontoID int; 
    DECLARE v_saldoEtter DECIMAL(15,2); 
    
    SET resultatKode = -1;  
    START TRANSACTION; 
    -- Sjekk om nok penger på konto 
    SELECT KontoID, (Saldo-belop) INTO v_frakontoID, v_saldoEtter 
		FROM konto 
		WHERE KontoNummer = fraKontoNr; 
        
	IF (v_frakontoID IS NULL) THEN 
		SET melding="Fra konto finnes ikke."; 
        
	ELSEIF (v_saldoEtter < 0) THEN 
		SET melding = "Ikke nok penger på frakonto."; 
	
    ELSE     
        SELECT KontoID INTO v_tilkontoID
        FROM konto 
		WHERE KontoNummer = tilKontoNr; 
        
		IF(v_tilkontoID IS NULL) THEN 
			SET melding="Til konto finnes ikke."; 
		ELSE
			UPDATE konto SET Saldo = Saldo - belop 
				WHERE kontoNummer = fraKontoNr;  
                
			UPDATE konto SET Saldo = Saldo + belop 
				WHERE kontoNummer = tilKontoNr; 
                
			INSERT INTO postering (KontoID, PosteringDato, PosteringTekst, Belop, SaldoEtter)
				VALUES(v_fraKontoId, CURDATE(), "Overføring ut", (0-belop), v_saldoEtter); 
			
		SELECT Saldo INTO v_saldoEtter 
		FROM konto
		WHERE KontoNummer = tilKontoNr;
            
		INSERT INTO postering (KontoID, PosteringDato, PosteringTekst, Belop, SaldoEtter)
			VALUES(v_fraKontoId, CURDATE(), "Overføring inn", (belop), v_saldoEtter); 
            SET resultatKode = 1; 
            SET melding = "Overføring vellykket"; 
		END IF; 
    END IF; 
    IF (resultatKode = 1) THEN  
		COMMIT; 
	else 
		ROLLBACK; 
	END IF; 
END ::
SET DELIMITER ; 


-- Test 
SET @fraKonto="1234567890";
SET @belop=5500; 
SET @tilKonto="0987654321";

CALL sp_overforBelop(@belop, @fraKonto, @tilKonto, @resultatKode, @melding);
SELECT @resultatKode, @melding;

-- OPPGAVE 7: Opprett en trigger for å oppdatere saldo etter en postering

OPPGAVE 7: Triggere
DROP TRIGGER IF EXISTS tr_oppdaterSaldo; 
SET DELIMITER :: 
CREATE TRIGGER tr_oppdaterSaldo
	AFTER INSERT ON Postering
    FOR EACH ROW 
BEGIN 
	UPDATE Konto SET konto.Saldo = konto.Saldo + NEW.belop 
    WHERE konto.kontoID = NEW.kontoID; 
END::
CREATE DELIMITER ; 


									