--Datentypen ganze Zahlen, Fließkommazahlen, Datum, Zeichenkette
--mit fester Länge und Zeichenkette mit einer variablen Länge vorkommen

-- Adresse sprengt evtl. Rahmen, da am besten alles in einzelene Spalten
-- oder neue Tabelle eingetragen werden sollte

ALTER TABLE IF EXISTS person DROP CONSTRAINT IF EXISTS person_pk;

ALTER TABLE IF EXISTS bewohner 
    DROP CONSTRAINT IF EXISTS bewohner_pk, 
    DROP CONSTRAINT IF EXISTS bewohner_fk1;

ALTER TABLE IF EXISTS arzt 
    DROP CONSTRAINT IF EXISTS arzt_pk,
    DROP CONSTRAINT IF EXISTS arzt_fk1;

ALTER TABLE IF EXISTS pfleger 
    DROP CONSTRAINT IF EXISTS pfleger_pk,
    DROP CONSTRAINT IF EXISTS pfleger_fk1;

ALTER TABLE IF EXISTS medikament DROP CONSTRAINT IF EXISTS medikament_pk;

ALTER TABLE IF EXISTS medikamentenverordnung 
    DROP CONSTRAINT IF EXISTS medikamentenverordnung_pk,
    DROP CONSTRAINT IF EXISTS medikamentenverordnung_fk1,
    DROP CONSTRAINT IF EXISTS medikamentenverordnung_fk2;

ALTER TABLE IF EXISTS doku_medivergabe 
    DROP CONSTRAINT IF EXISTS doku_medivergabe_pk,
    DROP CONSTRAINT IF EXISTS doku_medivergabe_fk1,
    DROP CONSTRAINT IF EXISTS doku_medivergabe_fk2;

DROP TABLE IF EXISTS person;
DROP TABLE IF EXISTS bewohner;
DROP TABLE IF EXISTS arzt;
DROP TABLE IF EXISTS pfleger;
DROP TABLE IF EXISTS medikament;
DROP TABLE IF EXISTS medikamentenverordnung;
DROP TABLE IF EXISTS doku_medivergabe;

CREATE TABLE person(
    person_id SERIAL,
    vorname VARCHAR(100) NOT NULL,
    nachname VARCHAR(100) NOT NULL,
    geburtstag DATE NOT NULL,
    telefonnr VARCHAR(20),
    email VARCHAR(320)
);

CREATE TABLE bewohner(
    bewohner_id SERIAL,
    person_id INT NOT NULL,
    zimmernr CHAR(4) NOT NULL,
    Diagnose TEXT,
    bemerkung TEXT
);

CREATE TABLE arzt(
    arzt_id SERIAL,
    person_id INT NOT NULL,
    fachrichtung VARCHAR(100)
);

CREATE TABLE pfleger(
    pfleger_id SERIAL,
    person_id INT NOT NULL
);

CREATE TABLE medikament(
    medikament_id SERIAL,
    bezeichnung VARCHAR(100) NOT NULL,
    SN CHAR(20) NOT NULL, --Seriennummer Packung
    verfallsdatum DATE NOT NULL,
    wirkstoff VARCHAR(100),
    hersteller VARCHAR(100),
    bemerkung TEXT
);

CREATE TABLE medikamentenverordnung(
    medikamentenverordnung_id SERIAL,
    bewohner_id INT NOT NULL,
    medikament_id INT NOT NULL,
    dosierung VARCHAR(100) NOT NULL,
    dosierungsintervall VARCHAR(100), --z.B. "alle 4h", "jede 4, 6, 4h"
    bemerkung TEXT
);

CREATE TABLE doku_medivergabe(
    doku_medivergabe_id SERIAL,
    medikamentenverordnung_id INT NOT NULL,
    pfleger_id INT NOT NULL,
    tagesgabe_nr INT NOT NULL, -- Wievielte Vergabe ist es heute?
    vergabestatus CHAR NOT NULL,
    zeitpunkt TIMESTAMP, --Wenn "nicht gegeben", dann keine Zeit
    begründung TEXT --Bei Abweichungen
);

-- PRIMARY KEYS
ALTER TABLE person
  ADD CONSTRAINT person_pk
  PRIMARY KEY (person_id);

ALTER TABLE bewohner
  ADD CONSTRAINT bewohner_pk
  PRIMARY KEY (bewohner_id);

ALTER TABLE arzt
  ADD CONSTRAINT arzt_pk
  PRIMARY KEY (arzt_id);

ALTER TABLE pfleger
  ADD CONSTRAINT pfleger_pk
  PRIMARY KEY (pfleger_id);

ALTER TABLE medikament
  ADD CONSTRAINT medikament_pk
  PRIMARY KEY (medikament_id);

ALTER TABLE medikamentenverordnung
  ADD CONSTRAINT medikamentenverordnung_pk
  PRIMARY KEY (medikamentenverordnung_id);

ALTER TABLE doku_medivergabe
  ADD CONSTRAINT doku_medivergabe_pk
  PRIMARY KEY (doku_medivergabe_id);


-- FOREIGN KEYS
ALTER TABLE bewohner
  ADD CONSTRAINT bewohner_fk1
  FOREIGN KEY (person_id) REFERENCES person (person_id);

ALTER TABLE arzt
  ADD CONSTRAINT arzt_fk1
  FOREIGN KEY (person_id) REFERENCES person (person_id);

ALTER TABLE pfleger
  ADD CONSTRAINT pfleger_fk1
  FOREIGN KEY (person_id) REFERENCES person (person_id);

ALTER TABLE medikamentenverordnung
  ADD CONSTRAINT medikamentenverordnung_fk1
  FOREIGN KEY (bewohner_id) REFERENCES bewohner (bewohner_id);

ALTER TABLE medikamentenverordnung
  ADD CONSTRAINT medikamentenverordnung_fk2
  FOREIGN KEY (medikament_id) REFERENCES medikament (medikament_id);

ALTER TABLE doku_medivergabe
  ADD CONSTRAINT doku_medivergabe_fk1
  FOREIGN KEY (medikamentenverordnung_id)
  REFERENCES medikamentenverordnung (medikamentenverordnung_id);

ALTER TABLE doku_medivergabe
  ADD CONSTRAINT doku_medivergabe_fk2
  FOREIGN KEY (pfleger_id) REFERENCES pfleger (pfleger_id);
