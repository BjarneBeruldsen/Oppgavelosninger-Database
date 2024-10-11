/*
Denne SQL-filen oppretter en lagret prosedyre for å overføre et beløp mellom to kontoer. 
Den sjekker at det er nok saldo, oppdaterer saldoene og loggfører transaksjonen. 
Prosedyren avsluttes med enten commit eller rollback avhengig av resultatet.
*/


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
	DECLARE v_KontoID int; 
    DECLARE v_saldoEtter DECIMAL(15,2); 
    
    SET resultatKode = -1;  
    START TRANSACTION; 
    -- Sjekk om nok penger på konto 
    SELECT KontoID, (konto.Saldo-belop) INTO v_saldoEtter FROM konto 
		WHERE KontoNummer = fraKontoNr; -- gjennbruker 
	IF (v_kontoID IS NULL) THEN 
		SET melding="Fra konto finnes ikke."; 
	ELSE IF (v_saldoEtter < 0) THEN 
		SET melding("Ikke nok penger på frakonto."); 
        
        SELECT KontoID INTO v_kontoId FROM konto 
			WHERE KontoNummer = tilKontoNr; 
		IF(v_kontoID IS NULL) THEN 
			SET melding="Til konto finnes ikke."; 
		UPDATE konto SET Saldo = Saldo - belop 
			WHERE kontoNummer = fraKontoNr;  
		UPDATE konto SET Saldo = Saldo + belop 
			WHERE kontoNummer = tilKontoNr; 
		SELECT KontoID, Saldo INTO v_kontoID, v_saldoEtter FROM konto
			WHERE KontoNummer = fraKontoNr;
		INSERT INTO postering (KontoID, PosteringDato, PosteringTekst, Belop, SaldoEtter)
			VALUES(v_kontoId, CURDATE(), "Overføring ut", (0-belop), v_saldoEtter); 
			
		SELECT KontoID, Saldo-belop INTO v_kontoID, v_saldoEtter 
			FROM konto
			WHERE KontoNummer = fraKontoNr;
		INSERT INTO postering (KontoID, PosteringDato, PosteringTekst, Belop, SaldoEtter)
			VALUES(v_kontoId, CURDATE(), "Overføring inn", (belop), v_saldoEtter); 
            SET resultatKode = 1; 
            SET melding = "Overføring vellykket"; 
            End if; 
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
SET @belop=1000; 
SET @tilKonto="0987654321";
CALL sp_overforBelop(@belop, @fraKonto, @tilKode, @statuskode, @melding); 
SELECT @statuskode, @melding; 
