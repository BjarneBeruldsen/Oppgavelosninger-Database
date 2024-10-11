DELIMITER :: 

CREATE TRIGGER oppdater_databruk 
AFTER INSERT ON databruk 
FOR EACH ROW 
BEGIN 
    DECLARE gjenstående_data BIGINT; 
    SELECT DataGjenstårByte INTO gjenstående_data 
    FROM abonnement 
    WHERE TlfNr = NEW.TlfNr;  

    IF gjenstående_data IS NOT NULL THEN 
        SET gjenstående_data = gjenstående_data - NEW.DatabrukByte; 

        IF gjenstående_data < 0 THEN 
            SET gjenstående_data = 0; 
            UPDATE abonnement 
            SET RedusertHastighet = TRUE 
            WHERE TlfNr = NEW.TlfNr; 

        END IF; 
        UPDATE abonnement 
        SET DataGjenstårByte = gjenstående_data 
        WHERE TlfNr = NEW.TlfNr; 
    END IF; 
END; 
:: 

DELIMITER ; 