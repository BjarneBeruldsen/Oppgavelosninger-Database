-- UPDATE, INSERT
-- Skriv en oppdateringsspørring som øker prisen pr. kvadratmeter med 10 % for alle lagre med postnummer
-- 3200.
UPDATE Lager
SET KvmPris = KvmPris * 1.1
WHERE PostNr = 3200;

-- Skriv SQL-kode som oppretter tabellen LagerRom og setter inn en eksempelrad. Sørg for at Kvm alltid må
-- fylles ut. Velg data for den nye raden selv, men pass på at den ikke bryter med fremmednøkkelkrav. 
CREATE TABLE LagerRom
(
  LNr     INTEGER,
  RNr     INTEGER,
  Kvm     DOUBLE(4, 1) NOT NULL,
  PRIMARY KEY (LNr, RNr),
  FOREIGN KEY (LNr) REFERENCES Lager (LNr)
);
INSERT INTO 
	LagerRom(LNr, RNr, Kvm)
VALUES 
	(4, 1, 20);
--Eksempel Sette inn ny kategori. Den første går inn i den første kolonnen og den andre går inni den andre.
--"1" går inn i KatNr "2" Går inn i Navn
INSERT INTO
	Kategori(KatNr, Navn)
VALUES
	(1, 'Blomster'); 
	(2, 'Keramikk'); 

--Eksempel INSERT. Sjekker at fremmed nøkkeler og primærnøkkeler gjør det de skal. 
INSERT INTO 
	Vare(VNr, Navn, Pris, KatNr)
VALUES
	(1, 'Roser', 29.90, 1), 
	(2, 'Tulipaner', 32.00, 1),
	(3, 'Kopp', 59.90, 2); 

--Eksempel UPDATE Bruker primærnøkkel for å identifisere raden. 
UPDATE Vare
SET Pris = 35.00
WHERE VNr = 2; 

--Øke prisen på alle varer med 10%
UPDATE Vare 
SET Pris = Pris * 1,1; 

--Slette varer
DElETE FROM Vare; 
WHERE VNr = 2

--Det er kommet inn en ønskeliste fra en person som ennå ikke er registrert i systemet. 
--Listen inneholder tre ønsker. Skriv spørringer for å legge til personen og ønskelisten. 
--Velg eksempeldata selv, men husk at primærnøkkel i ønskelisten er autonummerert. 
--Tips: Dette må løses med flere spørringer.
INSERT INTO
	Person(pnr, fornavn, etternavn, fdato)
VALUES
	(101, 'Erling', 'Haaland', '2000-9-11'); 

INSERT INTO 
	Onske(Onr, Pnr, Gnr, prioritet, ferdig)
VALUES
 	(497,101, 1, 1, 0),
 	(498,101, 2, 2, 0),
 	(499,101, 3, 3, 0);

--10.Lag en spørring som oppdaterer produksjonstiden til Sjakkbrett. Oppdater tiden til 120 minutter:
UPDATE Gave
SET prod_tid = 120.00
WHERE GNr = 8;

-- Skriv en SQL-spørring som registrerer en ny beboer som eier av en eksisterende leilighet. Velg eksempeldata
-- selv og gjør forutsetninger som gjelder eventuelle fremmednøkler
INSERT INTO 
	beboer(BeboerNr, Fornavn, Etternavn, FødselsDato, EPost)
VALUES
	(16, 'Bjarne', 'Bjarnesen', '2000-11-03', 'Bjarne@gmail.com');
    
INSERT INTO 
	leilighetbeboer(LeilighetNr, BeboerNr)
VALUES 
	(4, 16);

--Prisen på søtsaker skal økes: søtsaker som koster over 10 kr skal økes med 2 kr. 
--og øvrige søtsaker skal økes med 1 kr. Bruk SQL for å gjøre dette. 
UPDATE Vare 
SET Pris = IF(Pris>10, Pris + 2, Pris + 1) 
WHERE Kategori = 'Søtsaker';

-- Bruk SQL for å skru ned prisen på alle dagens tilbud på bakervarer; 10 kroner ned for alle tilbud som koster
-- over 50 kr og 5 kroner ned for resten.
UPDATE Tilbud 
SET Pris = IF(Pris>50,Pris-10,Pris-5)
WHERE Dato = CURDATE()
AND KatNr = (SELECT KatNr FROM Kategori WHERE Navn = 'Bakevarer');

-- Skriv en SQL-spørring som registrerer en ny kunde. Brukeren skal kunne velge passord selv, så dette skal i
-- første omgang bare settes til NULL. Velg andre eksempeldata selv og gjør forutsetninger som gjelder
-- eventuelle fremmednøkler.
INSERT INTO
	Bruker(Fornavn, Etternavn, BType, RegDato, Epost, TlfNr, Passord)
VALUES ('Svein', 'Sveinsen', 1, CURDATE(), 'Svein@Svein.no', '12345678', NULL);

-- Skriv en SQL-spørring som flytter en eksisterende presentasjon til et annet rom med et annet starttidspunkt.
-- Du kan altså forutsette at presentasjonen allerede er registrert. Velg nytt romnummer og nytt starttidspunkt
-- selv.

UPDATE Presentasjon
SET RomNr = 4, StartTid = '2019-03-04 12:30'
WHERE PresNr = 1;

-- Skriv SQL-spørringer for å registrere Peder Aas som deltaker. Han har epost paas@gmail.com, og ønsker
-- lunch alle konferansedager, men middag kun på den siste dagen
INSERT INTO
 Deltaker(DNr, Fornavn, Etternavn, EPost, DeltType)
VALUES
 (1, 'Peder', 'Aas', 'paas@gmail.com', 'P');
INSERT INTO
 MåltidBestilling(DNr, DagNr, Lunch, Middag)
VALUES
 (1, 1, TRUE, FALSE),
 (1, 2, TRUE, FALSE),
 (1, 3, TRUE, TRUE);