--Adniminstrasjon 
-- Inne som DBA 
--Opprett to brukere per og kari, samt to tilhørende databaser perdb og karidb. 
--Tips CREATE USER

CREATE USER 'per'@'%' IDENTIFIED BY 'hemmelig'; 
CREATE USER 'kari'@'%' IDENTIFIED BY 'hemmelig'; 

CREATE DATABASE perdb;  
CREATE DATABASE karidb;  

-- Gi så de to brukerne alle rettigheter på hver sin database. Tips: GRANT.
--Bruker per bør også settes i stand til å gi rettigheter vider

GRANT ALL PRIVILEGES ON perdb.* to 'per' WITH GRANT OPTION; 
GRANT ALL PRIVILEGES ON karidb.* to 'kari'; 

-- Forberedelse: Bruker per lager eksempeltabell Film (se under kapittel 2).

-- Bruker per gir bruker kari lesetilgang til eksempeltabellen. 
--Tips: GRANT. Sjekk at kari kan kjøre SELECT-spørringer, 
--men ikke INSERT, UPDATE eller DELETE.

GRANT SELECT ON perdb.Film TO 'kari'@'%'; 

--La per gi kari rett også til å sette inn og oppdatere
--men ikke å slette. Test at tildelingen var vellykket.
GRANT ALL PRIVILEGES ON perdb.Film to 'kari'; 
REVOKE DELETE ON perdb.Film FROM 'kari';

-- Lager ny bruker som heter Ola
CREATE USER 'ola' IDENTIFIED BY 'hemmelig';
--Lager bruker som kan logge på fra en bestemt maskin. localhost er den fysiske maskinen. 
-- % er alle datamaskiner 
CREATE USER 'ola'@'localhost' IDENTIFIED BY 'hemmelig'; 
CREATE DATABASE oladb; 

-- Gir Ola alle privilegier 
GRANT ALL PRIVILEGES ON OLADB*. to 'ola'; 

--Ola kan gi tilgang videre til kari 
GRANT USER 'kari'

-- Slett databasen db hvis den finnes:
DROP DATABASE IF EXISTS db;
 
-- Opprett databasen db med Unicode tegnsett:
CREATE DATABASE db DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
 
-- SLett brukeren ola:
DROP USER ola;
 
-- Opprett bruker ola med passord hemmelig
-- slik at han kan logge på fra alle maskiner
-- (% står for alle maskiner - host name):
CREATE USER 'ola'@'%' IDENTIFIED BY 'hemmelig';
 
-- Her er en variant der ola bare kan logge på
-- fra localhost:
CREATE USER 'ola'@'localhost' IDENTIFIED BY 'hemmelig';
 
-- Studentbrukere på itfag.usn.no er opprettet
-- med % som host name, for at man skal kunne
-- jobbe både fra phpMyAdmin og MySQL Workbench.
 
-- Gi ola lese-rettigheter på alle tabeller
-- i databasen db:
GRANT SELECT ON db.* TO 'ola'@'%';
 
-- Gi ola lese-rettigheter på tabell tab1 i database db
-- slik at han kan videreformidle rettigheten til andre:
GRANT SELECT ON db.tab1 TO 'ola'@'%' WITH GRANT OPTION;
 
-- Gi ola alle privilegier på alle tabeller
-- i databasen db:
GRANT ALL PRIVILEGES ON db.* TO 'ola'@'%';
 
-- Frata ola slette-rettigheter på alle tabeller
-- i databasen db:
REVOKE DELETE ON db.* FROM 'ola'@'%';
 
-- Endre ditt eget passord på MariaDB:
SET PASSWORD = PASSWORD('nyttpassord'); 
 
-- Endre passordet til bruker ola på MariaDB:
SET PASSWORD FOR 'ola' = PASSWORD('nyttpassord'); 
 
-- Endre passord for bruker ola på MySQL:
ALTER USER 'ola' IDENTIFIED BY 'nyttpassord';
 
-- Opprette rolle
CREATE ROLE 'innsyn'@'%';
 
-- Tildele leserettighet i database db til rolle
GRANT SELECT ON db.* TO 'innsyn'@'%';
 
-- Tildele rolle til bruker ola
GRANT 'innsyn'@'%' TO 'ola'@'%';
 
-- Aktivere tildelte roller ved pålogging for bruker ola
SET DEFAULT ROLE ALL TO 'ola'@'%';

-- Bruk SQL for å opprette en ny bruker med brukernavn svein og et passord som du velger. Denne
-- brukeren skal ha svært begrensede rettigheter på databasen, kun lesetilgang på tabellen Vare. Bruk
-- SQL for å få til dette.

CREATE USER 'svein'@'%' IDENTIFIED BY 'svein123'; 

GRANT SELECT ON Vare TO 'svein'@'%';