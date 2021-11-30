-- CASE STUDY 2
-- Dataset 1
DROP TABLE IF EXISTS Dataset2_1 CASCADE;
CREATE TABLE Dataset2_1(
	pilotID BIGINT(20),
    name VARCHAR(255),
    surname  VARCHAR(255),
    email  VARCHAR(255),
    sex  CHAR(1),
    salary INT(11),
    years_working INT(11),
    languages VARCHAR(255),
    PRIMARY KEY(pilotID)
);

INSERT INTO Dataset2_1 (pilotID, name, surname, email, sex, salary, years_working, languages)
SELECT pi.pilotID, p.name, p.surname, p.email, p.sex, e.salary, e.years_working, GROUP_CONCAT(l.name SEPARATOR ', ') AS 'Lenguages she/he speaks'
FROM pilot AS pi JOIN person AS p ON pi.pilotID = p.personID
JOIN employee AS e ON e.employeeID = p.personID
JOIN languageperson AS lp ON lp.personID = p.personID
JOIN language AS l ON lp.languageID = l.languageID
WHERE (SELECT COUNT(lp2.languageID)
		FROM  languageperson AS lp2 
		WHERE lp2.personID = p.personID
		GROUP BY lp2.personID)>3 AND e.salary > 100000
GROUP BY pi.pilotID
ORDER BY pi.pilotID ASC;



-- Dataset 2
DROP TABLE IF EXISTS Dataset2_2;
CREATE TABLE Dataset2_2(
		 flightattendantID  BIGINT(20),
		 name  VARCHAR(255),
		 surname VARCHAR(255), 
		 sex CHAR(1), 
		 salary INT(11),
		 years_working INT(11),
		 languages  VARCHAR(255),
         PRIMARY KEY (flightattendantID )
 );
 
INSERT INTO Dataset2_2 (flightattendantID, name, surname, sex, salary, years_working, languages)
SELECT  fa.flightattendantID, p.name, p.surname, p.sex, e.salary, e.years_working, GROUP_CONCAT(l.name SEPARATOR ', ') AS 'Lenguages she/he speaks'
FROM flight_attendant AS fa JOIN person AS p ON fa.flightattendantID = p.personID
JOIN employee AS e ON e.employeeID = p.personID
JOIN languageperson AS lp ON lp.personID = p.personID
JOIN language AS l ON lp.languageID = l.languageID
JOIN flight_flightattendant as ffa ON fa.flightattendantID = ffa.flightattendantID
JOIN flight as f ON f.flightID = ffa.flightID
WHERE f.pilotID IN (SELECT pilotID FROM Dataset2_1)
GROUP BY fa.flightattendantID; 


DROP TABLE IF EXISTS Dataset2_12;
CREATE TABLE Dataset2_12(
		 pilotID BIGINT(20),
		 flightattendantID  BIGINT(20),
         flightID BIGINT(20),
		 date  DATE,
         destination_airportID BIGINT(20),
         departure_airportID BIGINT(20),
         PRIMARY KEY (flightattendantID, pilotID, flightID),
         FOREIGN KEY (pilotID) REFERENCES Dataset2_1(pilotID),
         FOREIGN KEY (flightattendantID) REFERENCES Dataset2_2(flightattendantID)
 );

 INSERT INTO Dataset2_12 (pilotID, flightattendantID, flightID, date, destination_airportID, departure_airportID)
 SELECT d1.pilotID, d2.flightattendantID, f.flightID, f.date, r.destination_airportID, r.departure_airportID
 FROM Dataset2_1 AS d1 JOIN flight as f ON d1.pilotID=f.pilotID
 JOIN flight_flightattendant as ffa ON ffa.flightID=f.flightID
 JOIN Dataset2_2 as d2 ON d2.flightattendantID = ffa.flightattendantID
 JOIN route as r ON r.routeID = f.routeID;