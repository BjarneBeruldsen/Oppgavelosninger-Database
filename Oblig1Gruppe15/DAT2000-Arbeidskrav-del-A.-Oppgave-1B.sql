DELIMITER :: 

CREATE PROCEDURE GenererTestdata(IN p_TlfNr VARCHAR(10), IN p_Dato DATE) 
BEGIN 
    DECLARE i TINYINT DEFAULT 0;  
    DECLARE v_Databruk BIGINT; 

    -- Håndter feil ved å bruke en handler 
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION 
    BEGIN 
        -- Rull tilbake hvis noe går galt 
        ROLLBACK; 
    END; 

    START TRANSACTION; 
    -- Hold på så lenge i er mindre enn 24 (Så lenge betingelsen er sann) 
    WHILE i < 24 DO 
        -- Set databruk tilfeldig mellom 0 og 20 MB (0 til 20 * 1024 * 1024 bytes) 
        SET v_Databruk = FLOOR(RAND() * (20 * 1024 * 1024));  
        -- INSERT i databruk 
        INSERT INTO databruk (TlfNr, Dato, TimeNr, DatabrukByte) 
        VALUES (p_TlfNr, p_Dato, i, v_Databruk); 
        SET i = i + 1; 

    END WHILE; 
    COMMIT; 
END; 
:: 

DELIMITER ; 