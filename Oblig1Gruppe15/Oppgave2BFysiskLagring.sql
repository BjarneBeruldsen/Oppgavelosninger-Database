-- Beregner ca. nødvendig lagringsplass for databruk 5 år i tid
-- Plassbehov per datatype
TlfNr = 10/2*2B
Dato = 3B
TimeNr = 1B
DatabrukByte = 8B

--Ca.plassbehov per rad i tabellen 
10/2*2B+3B+1B+8B = 22B


--Finner antall rader i tabellen ved å bruke antall abonnementer 
24(timer)*365(dager)*600.000(abonnement)*5(år) = 26.280.000.000 B

--Finner antall bytes som trengs og runder av til mb
22B * 26.280.000.000 B = 578.160.000.000 B = 578.160 MB = ca. 578,16 GB
