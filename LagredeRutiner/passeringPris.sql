SET DELIMITER :: 
DROP FUNCTION IF EXISTS passeringPris:: 
CREATE FUNCTION passeringPris(
in_regNr VARCHAR(10), 
in_stNr tinyint, 
in_DatoTid timestamp
)
RETURNS SMALLINT 
READS SQL DATA 
BEGIN 
	DECLARE v_PrisRush SMALLINT; 
    DECLARE v_PrisVanlig SMALLINT; 
    DECLARE v_Pris SMALLINT; 
    DECLARE v_brikke SMALLINT; 
    DECLARE v_rabatt TINYINT UNSIGNED DEFAULT 20; 
    
    -- Henter priser 
	SELECT VanligPris, RushtidPris 
    INTO v_PrisVanlig, v_PrisRush
    FROM bompris AS b INNER JOIN kjoretoy AS kj
    WHERE b.StNr = in_stNr AND 
    b.TakstGruppeId = kj.TakstGruppeId AND
    kj.RegNr = in_regNr;
    
    -- Sjekker om regnr har brikke 
    SELECT COUNT(*) into v_brikke
    FROM brikke 
    WHERE RegNr = in_RegNr; 
    
	-- sjekker om passering er i rushtid og legger til riktig pris 
    IF(HOUR(in_DatoTid) IN (7, 8, 15, 16) AND DAYOFWEEK(in_DatoTid) NOT IN (1, 7)) THEN 
		SET v_Pris = v_PrisRush; 
	ELSE 
		SET v_Pris = v_PrisVanlig; 
	END IF; 
	
    -- legger til evt. rabatt 
    IF(v_brikke > 0) THEN 
		SET v_Pris = ROUND(v_Pris - (v_Pris * (v_rabatt / 100))); 
	END IF; 
    RETURN v_Pris; 
END ::
SET DELIMITER ; 

-- tester funksjon
SELECT passeringPris('KT53981', '1', '2024-10-20 16:14:07') AS pris; 
