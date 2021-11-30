USE lsair;

-- 4.1 QUERY (FETA I VALIDADA) 
SELECT DISTINCT p.personID AS 'person id' , p.name, p.surname, e.salary -- , fl.flightID, COUNT(fl.luggagehandlerID)
FROM person as p JOIN employee AS e ON p.personID = e.employeeID
JOIN luggagehandler as l ON e.employeeID = l.luggagehandlerID
JOIN flightluggagehandler AS fl ON l.luggagehandlerID = fl.luggagehandlerID
GROUP BY fl.flightID
HAVING COUNT(fl.luggagehandlerID) = 1 AND e.salary < (SELECT AVG(e2.salary)
														FROM person as p2 JOIN employee AS e2 ON p2.personID = e2.employeeID
														JOIN luggagehandler as l2 ON e2.employeeID = l2.luggagehandlerID)
ORDER BY p.personID ASC;

-- Validació
-- Mateixa query afegint el flightID i canviant el order by
SELECT p.personID AS 'person id' , p.name, p.surname, e.salary, fl.flightID
FROM person as p JOIN employee AS e ON p.personID = e.employeeID
JOIN luggagehandler as l ON e.employeeID = l.luggagehandlerID
JOIN flightluggagehandler AS fl ON l.luggagehandlerID = fl.luggagehandlerID
GROUP BY fl.flightID
HAVING COUNT(fl.luggagehandlerID) = 1 AND e.salary < (SELECT AVG(e2.salary)
FROM person as p2 JOIN employee AS e2 ON p2.personID = e2.employeeID
JOIN luggagehandler as l2 ON e2.employeeID = l2.luggagehandlerID)
ORDER BY fl.flightID ASC;

-- Son els flightID en que sols hi ha un luggageHandler
SELECT flightID
FROM flightluggagehandler
GROUP BY flightID
HAVING COUNT(luggageHandlerID) = 1;

-- Mirem quina és la mitja del salari dels luggagehandlers. (80295.8341)
SELECT AVG(e.salary) AS 'mitja del salari dels luggagehandlers'
FROM person as p JOIN employee AS e ON p.personID = e.employeeID
JOIN luggagehandler as l ON e.employeeID = l.luggagehandlerID;

-- Validació de que tots estan per sota de la mitja del salari.
SELECT DISTINCT p.personID AS 'person id' , p.name, p.surname, e.salary
FROM person as p JOIN employee AS e ON p.personID = e.employeeID
JOIN luggagehandler as l ON e.employeeID = l.luggagehandlerID
JOIN flightluggagehandler AS fl ON l.luggagehandlerID = fl.luggagehandlerID
GROUP BY fl.flightID
HAVING COUNT(fl.luggagehandlerID) = 1 AND e.salary <= (SELECT AVG(e.salary)
FROM person as p JOIN employee AS e ON p.personID = e.employeeID
JOIN luggagehandler as l ON e.employeeID = l.luggagehandlerID)
ORDER BY e.salary DESC;

-- 4.2 QUERY (FETA I VALIDADA) 
SELECT pe.name AS 'passenger name', pe.email, cy.name AS 'country', l.color, l.brand, l.weight, NULL AS 'volume', cl.extra_cost AS 'extra cost', so.fragile AS 'fragility'
FROM person AS pe JOIN luggage AS l ON pe.personID = l.passengerID
JOIN country AS cy ON pe.countryID = cy.countryID
JOIN checkedluggage AS cl ON cl.checkedluggageID = l.luggageID
JOIN specialobjects AS so ON so.specialobjectID = cl.checkedluggageID
WHERE LEFT(pe.name, 4) = LEFT(cy.name, 4)
AND (SELECT COUNT(l2.luggageID)
						FROM luggage AS l2
                        WHERE l2.passengerID = pe.personID) > 1  
AND l.luggageID = (SELECT l2.luggageID
					  FROM luggage AS l2
					  WHERE l2.passengerID = pe.personID
					  ORDER BY l2.weight ASC
					  LIMIT 1)
UNION
SELECT pe.name, pe.email, cy.name, NULL, NULL, NULL, NULL, NULL, NULL
FROM person AS pe JOIN country AS cy ON pe.countryID = cy.countryID
WHERE LEFT(pe.name, 4) = LEFT(cy.name, 4)
AND (SELECT COUNT(l2.luggageID)
						FROM luggage AS l2
                        WHERE l2.passengerID = pe.personID) = 0
UNION
SELECT pe.name, pe.email, cy.name, l.color, l.brand, l.weight, (hl.size_x*hl.size_y*hl.size_z) AS 'volume', NULL, NULL
FROM person AS pe JOIN luggage AS l ON pe.personID = l.passengerID
JOIN country AS cy ON pe.countryID = cy.countryID
JOIN handluggage AS hl ON hl.handluggageID = l.luggageID
WHERE LEFT(pe.name, 4) = LEFT(cy.name, 4)
AND (SELECT COUNT(l2.luggageID)
						FROM luggage AS l2
                        WHERE l2.passengerID = pe.personID) > 1  
AND l.luggageID = (SELECT l2.luggageID
					  FROM luggage AS l2
					  WHERE l2.passengerID = pe.personID
					  ORDER BY l2.weight ASC
					  LIMIT 1);


-- 4.4 QUERY (FETA I VALIDADA)
USE lsair;
SELECT '0' AS 'hazardous level', ROUND(AVG(c.extra_cost), 2) AS 'average extra cost'
FROM checkedluggage as c JOIN specialobjects as s ON s.specialobjectID = c.checkedluggageID
WHERE (s.fragile + s.corrosive + s.flammable) = 0
UNION
SELECT '1' AS 'hazardous level', ROUND(AVG(c.extra_cost), 2)
FROM checkedluggage as c JOIN specialobjects as s ON s.specialobjectID = c.checkedluggageID
WHERE (s.fragile + s.corrosive + s.flammable) = 1
UNION
SELECT '2' AS 'hazardous level', ROUND(AVG(c.extra_cost), 2)
FROM checkedluggage as c JOIN specialobjects as s ON s.specialobjectID = c.checkedluggageID
WHERE (s.fragile + s.corrosive + s.flammable) = 2
UNION
SELECT '3' AS 'hazardous level', ROUND(AVG(c.extra_cost), 2)
FROM checkedluggage as c JOIN specialobjects as s ON s.specialobjectID = c.checkedluggageID
WHERE (s.fragile + s.corrosive + s.flammable) = 3;

-- Validació
USE lsair;
SELECT '0' AS 'hazardous level', c.extra_cost, s.fragile, s.corrosive, s.flammable
FROM checkedluggage as c JOIN specialobjects as s ON s.specialobjectID = c.checkedluggageID
WHERE (s.fragile + s.corrosive + s.flammable) = 0;
SELECT '1' AS 'hazardous level', c.extra_cost, s.fragile, s.corrosive, s.flammable
FROM checkedluggage as c JOIN specialobjects as s ON s.specialobjectID = c.checkedluggageID
WHERE (s.fragile + s.corrosive + s.flammable) = 1;
SELECT '2' AS 'hazardous level', c.extra_cost, s.fragile, s.corrosive, s.flammable
FROM checkedluggage as c JOIN specialobjects as s ON s.specialobjectID = c.checkedluggageID
WHERE (s.fragile + s.corrosive + s.flammable) = 2;
SELECT '3' AS 'hazardous level', c.extra_cost, s.fragile, s.corrosive, s.flammable
FROM checkedluggage as c JOIN specialobjects as s ON s.specialobjectID = c.checkedluggageID
WHERE (s.fragile + s.corrosive + s.flammable) = 3;


-- 4.6 TRIGGER (FET I VALIDAT)  
DROP TABLE IF EXISTS RefundsAlterations;
CREATE TABLE RefundsAlterations(
	personID BIGINT(20),
    ticketID BIGINT(20),
    comment TEXT
);

DELIMITER $$
DROP TRIGGER IF EXISTS refundedTickets $$
CREATE TRIGGER refundedTickets
	AFTER INSERT 
	ON refund
	FOR EACH ROW
BEGIN
    IF (SELECT COUNT(*)
		FROM refund AS r
		WHERE r.flightTicketID = NEW.flightTicketID AND r.accepted = 1) > 1 THEN
        
		INSERT INTO RefundsAlterations(personID, ticketID, comment)
        SELECT c.passengerID, NEW.flightTicketID, "Refund of a ticket already processed correctly"
        FROM claims AS c JOIN refund AS r ON c.claimID = r.refundID
        WHERE r.flightTicketID = NEW.flightTicketID AND r.refundID = NEW.refundID;
	END IF;
    
    IF (SELECT COUNT(flightTicketID)
		FROM refund AS r
        WHERE flightTicketID = NEW.flightTicketID AND r.accepted = 0) >= 3 THEN -- Si ens han rebutjat la refund  o més vegades...
        
        INSERT INTO RefundsAlterations(personID, ticketID, comment)
        SELECT c.passengerID, NEW.flightTicketID, "Excessive Attempts"
        FROM claims AS c JOIN refund AS r ON c.claimID = r.refundID
        WHERE r.flightTicketID = NEW.flightTicketID AND r.refundID = NEW.refundID;
	END IF;
    
END $$

-- Inserim aquests refunds i claim per a que ens surti el missatge "Refund of a ticket already processed correctly".
INSERT INTO refund(refundID, flightTicketID, argument, accepted, amount) 
VALUES (10000, 74970, 'Flight Delayed', 1, 750);

INSERT INTO claims(claimID, passengerID, date)
VALUES (10001, 73488, CURRENT_DATE());

INSERT INTO refund(refundID, flightTicketID, argument, accepted, amount) 
VALUES (10001, 74970, 'Flight Delayed', 1, 750);

-- Inserim aquests refunds i claims per a que ens surti el missatge "Excessive attempts".
INSERT INTO claims(claimID, passengerID, date)
VALUES (10002, 44253, '2018-01-20');

INSERT INTO claims(claimID, passengerID, date)
VALUES (10003, 44253, '2018-02-23');

INSERT INTO refund(refundID, flightTicketID, argument, accepted, amount) 
VALUES (10002, 33520, 'Other', 0, 53);

INSERT INTO refund(refundID, flightTicketID, argument, accepted, amount) 
VALUES (10003, 33520, 'Other', 0, 53);



-- 4.7 TRIGGER (FET I VALIDAT)
DROP TABLE IF EXISTS LostObjectsDays;
CREATE TABLE LostObjectsDays(
	lostObjectID BIGINT(20),
    num_days INTEGER,
    avg_num_days FLOAT,
    PRIMARY KEY (lostObjectID)
);

DELIMITER $$
DROP TRIGGER IF EXISTS lost_object_days $$
CREATE TRIGGER lost_object_days
	AFTER UPDATE
	ON lostobject
    FOR EACH ROW
BEGIN
	IF OLD.founded = 0 AND NEW.founded = 1 THEN
		INSERT INTO LostObjectsDays(lostObjectID, num_days, avg_num_days)
        SELECT NEW.lostObjectID, DATEDIFF(CURRENT_DATE(), c.date), (SELECT COALESCE(AVG(num_days), 0)
																	FROM LostObjectsDays AS lod JOIN lostobject AS lo ON lod.lostObjectID = lo.lostObjectID
                                                                    WHERE lo.description = NEW.description)
        FROM claims AS c
        WHERE c.claimID = NEW.lostObjectID;

	END IF;
    
END $$

DELIMITER ;

-- Validació
INSERT INTO lostobject(lostObjectID, luggageID, description, color, founded)
VALUES (9995, NULL, 'Synchronization architected', 'Blue', 0);

INSERT INTO lostobject(lostObjectID, luggageID, description, color, founded)
VALUES (9996, NULL, 'Synchronization architected', 'Red', 0);

INSERT INTO lostobject(lostObjectID, luggageID, description, color, founded)
VALUES (9997, NULL, 'Synchronization architected', 'Green', 0);

INSERT INTO lostobject(lostObjectID, luggageID, description, color, founded)
VALUES (9998, NULL, 'Optimization powered', 'Red', 0);


UPDATE lostobject SET founded = 1 WHERE lostObjectID = 9995;
SELECT DATEDIFF(CURRENT_DATE(), '2002-08-08') AS 'diferència en dies';

UPDATE lostobject SET founded = 1 WHERE lostObjectID = 9996;
SELECT DATEDIFF(CURRENT_DATE(), '2007-05-20') AS 'diferència en dies';

UPDATE lostobject SET founded = 1 WHERE lostObjectID = 9997;
SELECT DATEDIFF(CURRENT_DATE(), '2019-08-23') AS 'diferència en dies';

UPDATE lostobject SET founded = 1 WHERE lostObjectID = 9998;
SELECT DATEDIFF(CURRENT_DATE(), '2009-11-21') AS 'diferència en dies';

        
-- 4.8 EVENT (MAL)
DROP TABLE IF EXISTS DailyLuggageStatistics;
CREATE TABLE DailyLuggageStatistics(
	date DATE,
    number_of_kg FLOAT,
    number_of_danger INTEGER,
    acc_returned_claims INTEGER,
    PRIMARY KEY (date)
);

DROP TABLE IF EXISTS MonthlyLuggageStatistics;
CREATE TABLE MonthlyLuggageStatistics(
	year DATE,
    month DATE,
    number_of_kg FLOAT,
    number_of_danger INTEGER,
    acc_returned_claims INTEGER,
    PRIMARY KEY (year, month)
);

DROP TABLE IF EXISTS YearlyLuggageStatistics;
CREATE TABLE YearlyLuggageStatistics(
	year DATE,
    number_of_kg FLOAT,
    number_of_danger INTEGER,
    acc_returned_claims INTEGER,
    PRIMARY KEY (year)
);

DELIMITER $$
DROP PROCEDURE IF EXISTS luggage_check $$
CREATE PROCEDURE luggage_check()
BEGIN 
	INSERT INTO DailyLuggageStatistics(date, number_of_kg, number_of_danger, acc_returned_claims)
	SELECT c.date, SUM(l.weight), COUNT(cl.checkedluggageID), COUNT(accepted)
    FROM luggage AS l JOIN lostobject AS lo ON l.luggageID = lo.luggageID 
    JOIN claims AS c ON lo.lostobjectID = c.claimID
    JOIN checkedluggage AS cl ON cl.checkedluggageID = l.luggageID
    JOIN refund AS r ON c.claimID = r.refundID
    WHERE accepted = 1;
    
	INSERT INTO MonthlyFlights(average_of_flights, month)
    SELECT AVG(number_of_flights), 
		   STR_TO_DATE(CONCAT(YEAR(CURRENT_DATE()),'-', MONTH(CURRENT_DATE()),'-', '1'), '%Y-%m-%d')
    FROM DailyFlights
    WHERE MONTH(CURRENT_DATE()) = MONTH(date) AND YEAR(CURRENT_DATE()) = YEAR(date)
    GROUP BY month(date)
    ON DUPLICATE KEY UPDATE average_of_flights = (SELECT AVG(number_of_flights) 
												  FROM DailyFlights
												  WHERE month(CURRENT_DATE()) = month(date) AND year(CURRENT_DATE()) = year(date)
												  GROUP BY month(date));
END $$

DELIMITER ;
DROP EVENT IF EXISTS flight_statistics;
CREATE EVENT flight_statistics 
ON SCHEDULE EVERY 24 HOUR
	STARTS '2021-01-01 12:18:00' -- La data es indiferent
    ON COMPLETION PRESERVE
    DO CALL  
		 flight_check();
         
SELECT f.date, ROUND(SUM(l.weight), 2)
FROM luggage AS l JOIN flight as f ON f.flightID=l.flightID
GROUP BY f.date;

SELECT l.weight -- 217.5
FROM luggage AS l JOIN flight as f ON f.flightID=l.flightID 
WHERE f.date='1950-01-15';

SELECT *FROM luggage;

SELECT f.date, SUM(l.weight), COUNT(cl.checkedluggageID), COUNT(accepted)
FROM luggage AS l LEFT JOIN flight as f ON f.flightID = l.flightID
JOIN checkedluggage AS cl ON cl.checkedluggageID = l.luggageID
JOIN claims AS c ON c.passengerID = l.passengerID
JOIN refund AS r ON c.claimID = r.refundID
WHERE accepted = 1 
GROUP BY f.date
LIMIT 10;
