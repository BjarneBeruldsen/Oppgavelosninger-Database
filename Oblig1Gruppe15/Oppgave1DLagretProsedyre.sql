SET DELIMITER ::
DROP PROCEDURE IF EXISTS nyPakke ::
CREATE PROCEDURE nyPakke (
	IN in_Tlf VARCHAR(10), 
    IN in_PakkeNavn VARCHAR(10), 
    OUT ut_statuskode int,
    OUT ut_statusmelding VARCHAR(100)
) MODIFIES SQL DATA
BEGIN 
	DECLARE v_utløper DATE;
    DECLARE v_pris DECIMAL(8,2); 
    DECLARE v_dataKjøpt DECIMAL(7,2); 
    DECLARE v_antall INTEGER; 
    DECLARE v_gjenstår BIGINT; 
    DECLARE v_redusert TINYINT; 
    DECLARE v_nestePakkeid SMALLINT; 
    SET ut_statuskode = 1; 
    
    START TRANSACTION; 
    -- Sjekker om gitt tlfnummer eller pakkenavn eksisterer 
    SELECT COUNT(*) INTO v_antall 
    FROM abonnement 
    INNER JOIN pakketype ON PakkeNavn = in_PakkeNavn  
    WHERE  TlfNr = in_Tlf FOR SHARE; 
    
    IF(v_antall = 0) THEN 
		SET ut_statusmelding = 'Gitt TlfNr eller pakkenavn eksisterer ikke!'; 
        SET ut_statuskode = -1; 
        ROLLBACK; 
	ELSE 
		SELECT CURDATE() + INTERVAL p.VarighetDager DAY, p.Pris, p.DataMengdeGB, p.DataMengdeGB * POW(10, 9), a.RedusertHastighet  
        INTO v_utløper, v_pris, v_dataKjøpt, v_gjenstår, v_redusert
        FROM pakketype AS p 
        INNER JOIN abonnement AS a
        WHERE p.PakkeNavn = in_PakkeNavn AND a.TlfNr = in_Tlf FOR UPDATE;
        
        SELECT MAX(PakkeId) + 1 INTO v_nestePakkeId FROM datakjøp FOR UPDATE;
        INSERT INTO datakjøp(PakkeId, TlfNr, DatoKjøpt, DatoUtløper, Pris, DataKjøptGB)
        VALUES(v_nestePakkeId, in_Tlf, CURDATE(), v_utløper, v_pris, v_dataKjøpt); 
        
        UPDATE abonnement SET DataGjenstårByte = DataGjenstårByte + v_gjenstår WHERE TlfNr = in_Tlf;
        
        IF(v_redusert = 1) THEN 
			UPDATE abonnement SET RedusertHastighet = 0 WHERE TlfNr = in_Tlf;
		END IF; 
        
    END IF; 
    IF (ut_statuskode = 1) THEN 
		SET ut_statusmelding = 'Kjøp av datapakke vellykket registrert!'; 
		COMMIT; 
	ELSE 
		ROLLBACK; 
	END IF; 
END::   
SET DELIMITER ; 



-- Testing av prosedyren
SET @tlf = '92345678';
SET @pakkeType = '10 GB'; 
CALL nyPakke(@tlf, @pakkeType, @statuskode, @statusmelding); 
SELECT @statuskode, @statusmelding; 