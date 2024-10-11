-- INDEKS
CREATE INDEX BetegnelseIdx ON Vare(Betegnelse);
CREATE INDEX NavnIdx ON Kunde(Etternavn, Fornavn);

-- UNIQUE og CHECK regler CONSTRAINT 

-- Gjør endringer i SQL-skriptet som oppretter tabellene slik at navn og telefon til kioskselgere alltid må
-- legges inn, det skal ikke være mulig å legge inn to badestrender med samme navn, og det skal heller
-- ikke være mulig å legge inn ikke-positive tall i kolonnen Salg.Antall. Vis også ulike teknikker for å
-- sikre at kolonnen Kategori kun vil inneholde verdier fra en liste med lovlige verdier.
(
    KNr INTEGER,
    Fornavn VARCHAR(50) NOT NULL,
	Etternavn VARCHAR(50) NOT NULL,
    Telefon VARCHAR(15) NOT NULL,
	PRIMARY KEY (KNr)
);

CREATE TABLE Badestrand
(
    BNr INTEGER,
    Navn VARCHAR(50) UNIQUE NOT NULL,
    Kommune VARCHAR(50),
	PRIMARY KEY (BNr)
);

CREATE TABLE Salg
(
    SNr INTEGER,
    VNr INTEGER,
	BNr INTEGER,
    Dato DATETIME,
    Antall INTEGER CHECK (Antall > 0) NOT NULL,
    Beløp DECIMAL(8, 2),
	PRIMARY KEY (SNr),
    FOREIGN KEY (VNr) REFERENCES Vare(VNr),
	FOREIGN KEY (BNr) REFERENCES Badestrand(BNr)
);
CREATE TABLE Vare
(
    VNr INTEGER,
    Navn VARCHAR(50),
    Kategori VARCHAR(100) CHECK ('Dessert', 'Snacks', 'Drikke', 'Søtsaker'), NOT NULL 
    Pris DECIMAL(8, 2),
	PRIMARY KEY (VNr)
);

-- Oppretter tabell
--Databasen skal ta vare på opplysninger om sykkelmodeller og (konkrete) sykler – i to forskjellige tabeller:

--Modell(MNr, Fabrikk, Betegnelse, Kategori, Dagpris)
--Sykkel(MNr, KopiNr, Ramme, Farge)

--Databasen skal utvides med informasjon om kunder og utleieforhold:

--Kunde(KNr, Fornavn, Etternavn, Mobil)
--Utleie(KNr, MNr, KopiNr, TidUt, TidInn)
CREATE TABLE Kunde 
(
	KNr INTEGER, 
	Fornavn VARCHAR(50) NOT NULL, 
	Etternavn VARCHAR(50) NOT NULL, 
	Mobil VARCHAR(15) UNIQUE,
	PRIMARY KEY (Knr)
); 


CREATE TABLE Modell
(
	MNr INTEGER, 
	Fabrikk VARCHAR(50), 
	Betegnelse VARCHAR(50), 
	Kategori VARCHAR(20), 
	Dagpris DECIMAL(8, 2), 
	PRIMARY KEY (MNr)
); 

CREATE TABLE Sykkel 
(
	MNr INTEGER, 
	KopiNr INTEGER, 
	Ramme INTEGER, 
	Farge VARCHAR(20),
	PRIMARY KEY (MNr, KopiNr),
	FOREIGN KEY (MNr) REFERENCES Modell(MNr)
); 


CREATE TABLE Utleie
(
	KNr INTEGER, 
	MNr INTEGER, 
	KopiNr INTEGER, 
	TidUt DATETIME, 
	TidInn DATETIME,
	PRIMARY KEY (MNr, KopiNr, TidUt),
	FOREIGN KEY (KNr) REFERENCES Kunde (KNr),
	FOREIGN KEY (MNr, KopiNr) REFERENCES Sykkel (MNr, KopiNr)
);