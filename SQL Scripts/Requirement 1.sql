USE lsair;

-- 1.1 QUERY (FETA I VALIDADA) 
-- Query
 (SELECT 'most anticipating country' AS 'Type of country', c.name AS 'country name', AVG(f.date - ft.date_of_purchase) AS 'difference in hours', AVG(ft.price) AS 'Average price'
 FROM person AS pe JOIN passenger AS pa ON pe.personID = pa.passengerID
 JOIN flighttickets AS ft ON pa.passengerID = ft.passengerID
 JOIN country AS c ON pe.countryID = c.countryID
 JOIN flight AS f ON ft.flightID = f.flightID
 GROUP BY c.countryID 
 HAVING (SELECT COUNT(pe2.personID)
		 FROM person AS pe2 JOIN country AS c2 ON pe2.countryID = c2.countryID
         WHERE c.countryID = c2.countryID) > 300
 ORDER BY AVG(f.date - ft.date_of_purchase) DESC
 LIMIT 1)
 UNION
 (SELECT 'least anticipating country' AS 'Type of country', c.name AS 'country name', AVG(f.date - ft.date_of_purchase) AS 'difference in hours', AVG(ft.price) AS 'Average price'
 FROM person AS pe JOIN passenger AS pa ON pe.personID = pa.passengerID
 JOIN flighttickets AS ft ON pa.passengerID = ft.passengerID
 JOIN country AS c ON pe.countryID = c.countryID
 JOIN flight AS f ON ft.flightID = f.flightID
 GROUP BY c.countryID 
 HAVING (SELECT COUNT(pe2.personID)
		 FROM person AS pe2 JOIN country AS c2 ON pe2.countryID = c2.countryID
         WHERE c.countryID = c2.countryID) > 300
 ORDER BY AVG(f.date - ft.date_of_purchase) ASC
 LIMIT 1);
 
 -- Validació
 -- Validació de que al most anticipating country hi ha més de 300 persones
 SELECT DISTINCT c.name AS 'country name', COUNT(pe.personID) AS 'número de persones al país'
 FROM person AS pe JOIN country AS c ON pe.countryID = c.countryID
 WHERE c.name = 'Bolivia';
 
 -- Validació de que al least anticipating country hi ha més de 300 persones
 SELECT DISTINCT c.name AS 'country name', COUNT(pe.personID) AS 'número de persones al país'
 FROM person AS pe JOIN country AS c ON pe.countryID = c.countryID
 WHERE c.name = 'Guam';
 
 -- Validació que Bolivia es el most anticipating country
SELECT c.name AS 'country name', AVG(f.date - ft.date_of_purchase) AS 'difference in hours', AVG(ft.price) AS 'Average price' 
FROM person AS pe JOIN passenger AS pa ON pe.personID = pa.passengerID 
JOIN flighttickets AS ft ON pa.passengerID = ft.passengerID 
JOIN country AS c ON pe.countryID = c.countryID 
JOIN flight AS f ON ft.flightID = f.flightID 
GROUP BY c.countryID  
HAVING (SELECT COUNT(pe2.personID)
		 FROM person AS pe2 JOIN country AS c2 ON pe2.countryID = c2.countryID
         WHERE c.countryID = c2.countryID) > 300
ORDER BY AVG(f.date - ft.date_of_purchase) DESC;

-- Validació que Guam es el least anticipating country
 SELECT c.name AS 'country name', AVG(f.date - ft.date_of_purchase) AS 'difference in hours', AVG(ft.price) AS 'Average price'
 FROM person AS pe JOIN passenger AS pa ON pe.personID = pa.passengerID
 JOIN flighttickets AS ft ON pa.passengerID = ft.passengerID
 JOIN country AS c ON pe.countryID = c.countryID
 JOIN flight AS f ON ft.flightID = f.flightID
 GROUP BY c.countryID 
 HAVING (SELECT COUNT(pe2.personID)
		 FROM person AS pe2 JOIN country AS c2 ON pe2.countryID = c2.countryID
         WHERE c.countryID = c2.countryID) > 300
 ORDER BY AVG(f.date - ft.date_of_purchase) ASC;
 
-- 1.2 QUERY (FETA I VALIDADA)
-- Query
SELECT DISTINCT pe.personID AS 'person id', pe.name, pe.surname, pe.born_date AS 'born date'
FROM person AS pe JOIN passenger AS pa ON pe.personID = pa.passengerID
JOIN flighttickets AS ft ON pa.passengerID = ft.passengerID
JOIN flight AS f ON ft.flightID = f.flightID
WHERE (SELECT f2.date
		FROM person AS pe2 JOIN passenger AS pa2 ON pe2.personID = pa2.passengerID
		JOIN flighttickets AS ft2 ON pa2.passengerID = ft2.passengerID
		JOIN flight AS f2 ON ft2.flightID = f2.flightID
        WHERE pe.personID = pe2.personID
        ORDER BY f2.date DESC
        LIMIT 1) = (SELECT f3.date
					  FROM flight AS f3 JOIN flighttickets AS ft3 ON ft3.flightID = f3.flightID
					  JOIN passenger AS pa3 ON pa3.passengerID = ft3.passengerID
					  JOIN person AS pe3 ON pe3.personID = pa3.passengerID
					  JOIN status AS s3 ON f3.statusID = s3.statusID
					  WHERE s3.status = "Strong Turbulences" AND pe.personID = pe3.personID
					  GROUP BY pe3.personID
					  HAVING COUNT(s3.statusID) = 1
					  ORDER BY f3.date DESC
					  LIMIT 1)
ORDER BY pe.personID ASC;

-- Validació i anar fent scroll down i mirant que tots compleixen la condició.
SELECT pe.personID AS 'person id', pe.name, pe.surname, pe.born_date AS 'born date', s.status, f.date
FROM person AS pe JOIN passenger AS pa ON pe.personID = pa.passengerID
JOIN flighttickets AS ft ON pa.passengerID = ft.passengerID
JOIN flight AS f ON ft.flightID = f.flightID
JOIN status AS s ON f.statusID = s.statusID
WHERE (SELECT f2.date
		FROM person AS pe2 JOIN passenger AS pa2 ON pe2.personID = pa2.passengerID
		JOIN flighttickets AS ft2 ON pa2.passengerID = ft2.passengerID
		JOIN flight AS f2 ON ft2.flightID = f2.flightID
        WHERE pe.personID = pe2.personID
        ORDER BY f2.date DESC
        LIMIT 1) = (SELECT f3.date
					  FROM flight AS f3 JOIN flighttickets AS ft3 ON ft3.flightID = f3.flightID
					  JOIN passenger AS pa3 ON pa3.passengerID = ft3.passengerID
					  JOIN person AS pe3 ON pe3.personID = pa3.passengerID
					  JOIN status AS s3 ON f3.statusID = s3.statusID
					  WHERE s3.status = "Strong Turbulences" AND pe.personID = pe3.personID
					  GROUP BY pe3.personID
					  HAVING COUNT(s3.statusID) = 1
					  ORDER BY f3.date DESC
					  LIMIT 1)
ORDER BY pe.personID ASC, f.date DESC;

-- Validació de que si posem el COUNT = 2, surten passatgers que han viscut 2 Strong Turbulences.
SELECT pe.personID AS 'person id', pe.name, pe.surname, pe.born_date AS 'born date', s.status, f.date
FROM person AS pe JOIN passenger AS pa ON pe.personID = pa.passengerID
JOIN flighttickets AS ft ON pa.passengerID = ft.passengerID
JOIN flight AS f ON ft.flightID = f.flightID
JOIN status AS s ON f.statusID = s.statusID
WHERE (SELECT f2.date
		FROM person AS pe2 JOIN passenger AS pa2 ON pe2.personID = pa2.passengerID
		JOIN flighttickets AS ft2 ON pa2.passengerID = ft2.passengerID
		JOIN flight AS f2 ON ft2.flightID = f2.flightID
        WHERE pe.personID = pe2.personID
        ORDER BY f2.date DESC
        LIMIT 1) = (SELECT f3.date
					  FROM flight AS f3 JOIN flighttickets AS ft3 ON ft3.flightID = f3.flightID
					  JOIN passenger AS pa3 ON pa3.passengerID = ft3.passengerID
					  JOIN person AS pe3 ON pe3.personID = pa3.passengerID
					  JOIN status AS s3 ON f3.statusID = s3.statusID
					  WHERE s3.status = "Strong Turbulences" AND pe.personID = pe3.personID
					  GROUP BY pe3.personID
					  HAVING COUNT(s3.statusID) = 2
					  ORDER BY f3.date DESC
					  LIMIT 1)
ORDER BY pe.personID ASC, f.date DESC;

-- 1.3 QUERY (FETA I VALIDADA)
-- Query
SELECT p.flying_license AS 'flying license', COUNT(f.pilotID) AS '# times she/he was pilot', p.grade
FROM pilot AS p JOIN flight AS f ON p.pilotID = f.pilotID
WHERE p.grade - (SELECT AVG(grade) 
				 FROM pilot) > 2
GROUP BY f.pilotID
HAVING COUNT(f.pilotID) < (SELECT COUNT(p2.copilotID)
						   FROM pilot AS p2
						   WHERE f.pilotID = p2.copilotID) 
ORDER BY COUNT(f.pilotID) DESC;

-- Validació
-- Sols afegim el pilotID per després validar les diferents condicions utilitzant el pilotID
SELECT p.flying_license AS 'flying license', COUNT(f.pilotID) AS '# times she/he was pilot', p.grade, p.pilotID
FROM pilot AS p JOIN flight AS f ON p.pilotID = f.pilotID
WHERE p.grade - (SELECT AVG(grade) 
				 FROM pilot) > 2
GROUP BY f.pilotID
HAVING COUNT(f.pilotID) < (SELECT COUNT(p2.copilotID)
						   FROM pilot AS p2
						   WHERE f.pilotID = p2.copilotID) -- el mateix pilot ha estat menys cops pilot que copilot
ORDER BY COUNT(f.pilotID) DESC;

-- Calculem el valor numèric exacte de la mitja del grade dels pilots. (Dóna 7.399)
SELECT AVG(p.grade) 
FROM pilot AS p;

-- Mirem quants cops ha exercit de pilot
SELECT f.pilotID, COUNT(f.pilotID) AS 'vegades que ha estat pilot'
FROM flight AS f
WHERE f.pilotID = 136388;

-- Mirem quants cops ha exercit de copilot
SELECT p.pilotID, COUNT(p.copilotID) AS 'vegades que ha estat copilot'
FROM pilot AS p
WHERE p.copilotID = 136388;


-- 1.4 QUERY (FETA I VALIDADA)
SELECT DISTINCT pe.name AS 'passenger name', pe.surname, pe.born_date AS 'born date'
FROM person AS pe JOIN passenger AS pa ON pe.personID = pa.passengerID
JOIN languageperson AS lp ON pe.personID = lp.personID
JOIN language AS l ON lp.languageID = l.languageID
JOIN flighttickets AS ft ON pa.passengerID = ft.passengerID
WHERE NOT EXISTS (SELECT *  -- posem * perquè vaig llegir per internet que al NOT EXISTS posavem * al SELECT
				  FROM language AS l2 JOIN languageperson AS lp2 ON l2.languageID = lp2.languageID
				  JOIN person AS pe2 ON lp2.personID = pe2.personID
				  JOIN employee AS e ON pe2.personID = e.employeeID
				  JOIN flight_attendant AS fa ON e.employeeID = fa.flightattendantID
				  JOIN flight_flightattendant AS ffa ON fa.flightattendantID = ffa.flightAttendantID
				  WHERE l.languageID = l2.languageID AND ft.flightID = ffa.flightID)
-- AND pe.born_date < '1921-%'
AND TIMESTAMPDIFF(YEAR, pe.born_date,  NOW()) >= 100
ORDER BY pe.born_date DESC; -- no cal el order by

-- Validació
-- Mostrem els idiomes que parlen els passatgers per cada vol, treiem el distinct per mostrar tots els idiomes que parlen
SELECT pe.name AS 'passenger name', pe.surname, pe.born_date AS 'born date', l.name, ft.flightID
FROM person AS pe JOIN passenger AS pa ON pe.personID = pa.passengerID
JOIN languageperson AS lp ON pe.personID = lp.personID
JOIN language AS l ON lp.languageID = l.languageID
JOIN flighttickets AS ft ON pa.passengerID = ft.passengerID
WHERE NOT EXISTS (SELECT *  -- posem * perquè vaig llegir per internet que al NOT EXISTS posavem * al SELECT
				  FROM language AS l2 JOIN languageperson AS lp2 ON l2.languageID = lp2.languageID
				  JOIN person AS pe2 ON lp2.personID = pe2.personID
				  JOIN employee AS e ON pe2.personID = e.employeeID
				  JOIN flight_attendant AS fa ON e.employeeID = fa.flightattendantID
				  JOIN flight_flightattendant AS ffa ON fa.flightattendantID = ffa.flightAttendantID
				  WHERE l.languageID = l2.languageID AND ft.flightID = ffa.flightID)
AND TIMESTAMPDIFF(YEAR, pe.born_date,  NOW()) >= 100
ORDER BY ft.flightID DESC;

-- Mostrem els idiomes que parlen els flighttattendants agafant un flightID de la query anterior.
SELECT ffa.flightID, fa.flightattendantID, l.name AS 'idioma/es parlats'
FROM flight_attendant AS fa JOIN employee AS e ON fa.flightattendantID = e.employeeID
JOIN person AS pe ON e.employeeID = pe.personID
JOIN languageperson AS lp ON pe.personID = lp.personID
JOIN language AS l ON lp.languageID = l.languageID
JOIN flight_flightattendant AS ffa ON fa.flightattendantID = ffa.flightAttendantID
WHERE ffa.flightID = 19938;



-- 1.7 TRIGGER (FET I VALIDAT) 
DROP TABLE IF EXISTS CrimeSuspect;
CREATE TABLE CrimeSuspect(		
				passengerID BIGINT(20),
                name VARCHAR(255),
                surname VARCHAR(255),
                passport VARCHAR(11),
                phone VARCHAR(20),
                PRIMARY KEY (passengerID)
);

DELIMITER $$
DROP TRIGGER IF EXISTS card_criminals $$
CREATE TRIGGER card_criminals 
	AFTER INSERT
	ON passenger 
    FOR EACH ROW 
BEGIN

   IF (SELECT COUNT(*) 
		FROM passenger AS pa
        WHERE pa.creditCard = NEW.creditCard) > 1 THEN
		
        INSERT INTO CrimeSuspect(passengerID, name, surname, passport, phone)
        SELECT pe.personID, pe.name, pe.surname, pe.passport, pe.phone_number
        FROM person AS pe
        WHERE pe.personID = NEW.passengerID;
       
    END IF;
    
END $$

DELIMITER ;

-- Validació
INSERT INTO person(personID, name, surname, countryID, passport, email, phone_number, born_date, sex)
VALUES(98113, "Lluis", "Gumbau", 71, "821-29-2356", "lluis.gumbau@students.salle.url.edu", "+34 673 956 294", "1999-05-26", "M");

INSERT INTO person(personID, name, surname, countryID, passport, email, phone_number, born_date, sex)
VALUES(98114, "Narcís", "Cisquella", 71, "751-34-7321", "narcis.cisquella@students.salle.url.edu", "+34 623 562 211", "1999-02-09", "M");

INSERT INTO person(personID, name, surname, countryID, passport, email, phone_number, born_date, sex)
VALUES(98115, "Joan", "Llobet", 71, "341-35-5855", "joan.llobet@students.salle.url.edu", "+34 622 344 788", "1999-06-13", "M");

INSERT INTO person(personID, name, surname, countryID, passport, email, phone_number, born_date, sex)
VALUES(98116, "Marc", "Postils", 71, "441-86-6577", "marc.postils@students.salle.url.edu", "+34 673 040 646", "1999-03-27", "M");

INSERT INTO passenger(passengerID, creditCard) 
VALUES (98113, 3543138936988290);  -- credit card ja existent a la taula passenger

INSERT INTO passenger(passengerID, creditCard) 
VALUES (98114, 8543138933982290);  -- credit card nova

INSERT INTO passenger(passengerID, creditCard) 
VALUES (98115, 8543138933982290);   -- credit card existent

INSERT INTO passenger(passengerID, creditCard) 
VALUES (98116, 8543138933982290);   -- credit card existent


-- 1.9 EVENT (FET I VALIDAT)
DROP TABLE IF EXISTS DailyFlights;
CREATE TABLE DailyFlights(		
				date DATE,
                number_of_flights INTEGER,
                PRIMARY KEY (date)
);

DROP TABLE IF EXISTS MonthlyFlights;
CREATE TABLE MonthlyFlights(		
				average_of_flights FLOAT,
                month DATE,
                PRIMARY KEY (month)
);

DELIMITER $$
DROP PROCEDURE IF EXISTS flight_check $$
CREATE PROCEDURE flight_check()
BEGIN 
	INSERT INTO DailyFlights(date, number_of_flights)
	SELECT CURRENT_DATE(), COUNT(*) 
    FROM flight
    WHERE date = CURRENT_DATE();
    
	INSERT INTO MonthlyFlights(average_of_flights, month)
    SELECT AVG(number_of_flights), 
		   STR_TO_DATE(CONCAT(YEAR(CURRENT_DATE()), '-', MONTH(CURRENT_DATE()),'-', '1'), '%Y-%m-%d')
    FROM DailyFlights
    WHERE MONTH(CURRENT_DATE()) = MONTH(date) AND YEAR(CURRENT_DATE()) = YEAR(date)
    GROUP BY month(date)
    ON DUPLICATE KEY UPDATE average_of_flights = (SELECT AVG(number_of_flights)  -- Fem el duplicate key al mes ja que cada mes hem d'anar actualitzant els vols. 
												  FROM DailyFlights
												  WHERE month(CURRENT_DATE()) = month(date) AND year(CURRENT_DATE()) = year(date)
												  GROUP BY month(date));
END $$

DELIMITER ;
DROP EVENT IF EXISTS flight_statistics;
CREATE EVENT flight_statistics 
ON SCHEDULE EVERY 24 HOUR
	STARTS '2021-01-01 23:59:59' -- La data es indiferent
    ON COMPLETION PRESERVE
    DO CALL  
		 flight_check();
         
-- Validació
INSERT INTO flight(flightID, pilotID, planeID, routeID, date, gate, fuel, departure_hour, statusID) VALUES (21001, 136372, 2245, 1324, DATE(NOW()), 'I5', 2424, '00:23:00', 4);
INSERT INTO flight(flightID, pilotID, planeID, routeID, date, gate, fuel, departure_hour, statusID) VALUES (21002, 136372, 2245, 1324, DATE(NOW()), 'I5', 2424, '00:23:00', 4);
INSERT INTO flight(flightID, pilotID, planeID, routeID, date, gate, fuel, departure_hour, statusID) VALUES (21003, 136372, 2245, 1324, DATE(NOW()), 'I5', 2424, '00:23:00', 4);
INSERT INTO flight(flightID, pilotID, planeID, routeID, date, gate, fuel, departure_hour, statusID) VALUES (21004, 136372, 2245, 1324, DATE(NOW()), 'I5', 2424, '00:23:00', 4);
INSERT INTO flight(flightID, pilotID, planeID, routeID, date, gate, fuel, departure_hour, statusID) VALUES (21005, 136372, 2245, 1324, DATE(NOW()), 'I5', 2424, '00:23:00', 4);
         
-- SET GLOBAL event_scheduler = 1;
-- SELECT @@GLOBAL.event_scheduler






    











