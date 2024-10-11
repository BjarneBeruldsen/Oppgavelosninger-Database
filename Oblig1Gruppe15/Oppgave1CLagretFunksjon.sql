SET DELIMITER ::
DROP FUNCTION IF EXISTS NyDatamengdeBytes::
CREATE FUNCTION NyDatamengdeBytes(in_tlf VARCHAR(10))
RETURNS BIGINT 
READS SQL DATA 
BEGIN 
	DECLARE v_data BIGINT; 
    DECLARE v_inkludertData DECIMAL(7,2); 
    DECLARE v_maxRollover DECIMAL(7,2); 
    
    SELECT aType.InkludertDataGB, aType.MaxRolloverGB, a.DataGjenstårByte
    INTO v_inkludertData, v_maxRollover, v_data
    FROM abonnementtype aType
    INNER JOIN abonnement a ON aType.TypeNavn=a.TypeNavn
    WHERE a.TlfNr = in_tlf; 
    
    -- skal returnere null visst inkludert data og max rollover er NULL. 
    IF(v_inkludertData IS NULL OR v_maxRollover IS NULL) THEN 
		RETURN NULL; 
	ELSE 
		SET v_data = v_inkludertData * POW(10, 9) + v_data; 
	END IF;
    -- Sjekker om v_data er større en max rollover 
    IF(v_data > v_maxRollover * POW(10, 9)) THEN 
		SET v_data = v_maxRollover * POW(10, 9); 
	END IF; 
	RETURN v_data; 
END :: 
SET DELIMITER ; 

-- SQL kommando som oppdaterer datamengden for alle abonnementer 
UPDATE abonnement SET DataGjenstårByte = NyDatamengdeBytes(TlfNr); 
