SET DELIMITER :: 
DROP PROCEDURE IF EXISTS slettTakstGruppe:: 
CREATE PROCEDURE slettTakstGruppe (
IN in_TakstGruppeId CHAR(2), 
OUT ut_statuskode TINYINT, 
OUT ut_statusmelding VARCHAR(100)
)
BEGIN
	DECLARE v_antall TINYINT; 
	DECLARE v_antallK TINYINT; 
    DECLARE v_antallB TINYINT; 
    
    SET ut_statuskode = -1; 
	START TRANSACTION; 
    -- sjekker om taksgruppeid eksisterer 
    SELECT COUNT(*) INTO v_antall
    FROM takstgruppe
    WHERE in_TakstGruppeId = TakstGruppeId; 
    
    
    -- select spørring som sjekker om takstgruppe eksisterer 
    -- og at den ikke er reg. på kjøretøy
    SELECT COUNT(*) INTO v_antallK
    FROM kjoretoy AS k 
    WHERE TakstGruppeId = in_TakstGruppeId; 
    
    
    -- skriver feilmelding visst den er reg på kjøretøy 
    IF(v_antall = 0) THEN 
		SET ut_statusmelding = 'Gitt TakstGruppeId finnes ikke!'; 
        ROLLBACK;
	ELSE 
		IF(v_antallK > 0) THEN 
			SET ut_statusmelding = 'TakstGruppeId kan ikke være reg. på kjøretøy!'; 
			ROLLBACK; 
		ELSE 
			DELETE FROM bompris WHERE TakstGruppeId = in_TakstGruppeId;
			DELETE FROM takstgruppe WHERE TakstGruppeId = in_TakstGruppeId; 
			SET ut_statuskode = 1; 
			SET ut_statusmelding = 'Sletting gjennomført!'; 
			COMMIT; 
		END IF; 
    END IF; 
END::
SET DELIMITER ;  

-- tester prosedyren 
SET @TakstGruppeId = 'E6'; 
CALL slettTakstGruppe(@TakstGruppeId, @statuskode, @statusmelding); 
SELECT @statusmelding, @statuskode; 