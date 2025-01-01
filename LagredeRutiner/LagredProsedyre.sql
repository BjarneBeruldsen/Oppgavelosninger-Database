SET DELIMITER :: 
DROP PROCEDURE IF EXISTS endrePris:: 
CREATE PROCEDURE endrePris (
	IN in_StNr TINYINT, 
    IN in_TakstGruppeId CHAR(2), 
    IN in_VanligPris SMALLINT,  
    IN in_RushtidPris SMALLINT, 
    OUT ut_statuskode TINYINT, 
    OUT ut_statusmelding VARCHAR(100)
) MODIFIES SQL DATA
BEGIN 
	DECLARE v_RushtidPris DECIMAL(8,2); 
    DECLARE v_VanligPris DECIMAL(8,2); 
    DECLARE v_endringProVanlig DECIMAL(4, 2); 
    DECLARE v_endringProRush DECIMAL(4, 2); 
    DECLARE v_maxEndring DECIMAL(6,2) DEFAULT 50; 
    
    START TRANSACTION; 
	SELECT VanligPris, RushtidPris
    INTO v_VanligPris, v_RushtidPris
    FROM bompris
    WHERE StNr = in_StNr AND TakstGruppeId = in_TakstGruppeId; 
    
    
    SET ut_statuskode = 1; 
    
    IF(v_VanligPris = 0 OR v_RushtidPris = 0) THEN 
       SET ut_statuskode = -1; 
         SET ut_statusmelding = "Prisen er lik 0"; 
         ROLLBACK; 
	ELSE
		-- Sjekker endringsprosent i vanligpris 
		SET v_endringProVanlig = (in_VanligPris - v_VanligPris) / v_VanligPris * 100; 
		-- Sjekker endringsprosent i rushtud 
		SET v_endringProRush = (in_RushtidPris - v_RushtidPris) / v_RushtidPris * 100; 
    
		IF(v_endringProVanlig > v_maxEndring OR v_endringProRush > v_maxEndring) THEN 
			SET ut_statuskode = -1; 
			SET ut_statusmelding = "Endringen er over max prosent for endring"; 
			ROLLBACK; 
		ELSE
    
			UPDATE bompris SET RushtidPris = in_RushtidPris WHERE StNr = in_StNr AND TakstGruppeId = in_TakstGruppeId; 
			UPDATE bompris SET VanligPris = in_VanligPris WHERE StNr = in_StNr AND TakstGruppeId = in_TakstGruppeId;  
		
		END IF; 
		IF(ut_statuskode = 1) THEN 
			SET ut_statusmelding = "Endringen er godkjent"; 
			COMMIT; 
		ELSE 
			SET ut_statuskode = "-1"; 
			ROLLBACK;
		END IF; 
	END IF; 
END:: 
SET DELIMITER ; 

-- testing 
SET @StNr = 1; 
SET @TakstGruppeId = 'D'; 
SET @NyVanligPris = 151; 
SET @NyRushPris = 151; 
CALL endrePris(@StNr, @TakstGruppeId, @NyVanligPris, @NyRushPris, @statuskode, @statusmelding);
SELECT @statuskode, @statusmelding;  




