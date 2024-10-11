-- Logisk sikkerhetskopi
mysqldump --user=root -p PlingMe > plingme_backup.sql

--sletter data i databruk 
mysql --user=root -p -e "DELETE FROM PlingMe.databruk;"

--Gjennoppbygger datbasen fra backupfil 
mysql --user=root --p < plingme_backup.sql
