USE lsair;

-- 2.1 QUERY (FETA I VALIDADA)
SELECT al.name AS 'airline name', COUNT(r.routeID) AS '# routes', al.airlineID
FROM airline AS al JOIN routeairline AS ral ON ral.airlineID = al.airlineID
JOIN route AS r ON r.routeID = ral.routeID
JOIN airport AS ap ON ap.airportID = r.departure_airportID
JOIN planetype AS pt ON pt.planetypeID = ral.planetypeID
JOIN city AS c ON ap.cityID = c.cityID
JOIN country AS cy ON cy.countryID = c.countryID
JOIN airport AS a2 ON r.destination_airportID = a2.airportID
JOIN city AS c2 ON a2.cityID = c2.cityID
JOIN country AS cy2 ON c2.countryID = cy2.countryID
WHERE r.minimum_petrol > pt.petrol_capacity
AND cy.countryID <> cy2.countryID
GROUP BY al.airlineID
ORDER BY COUNT(r.routeID) DESC;

/*-- Opció 2
SELECT al.name AS 'airline name', COUNT(r.routeID) AS '# routes'
FROM airline AS al JOIN routeairline AS ra ON ra.airlineID = al.airlineID
JOIN route AS r ON r.routeID = ra.routeID
JOIN airport AS ap ON ap.airportID = r.departure_airportID
JOIN planetype AS pt ON pt.planetypeID = ra.planeTypeID
JOIN city AS c ON ap.cityID = c.cityID
JOIN country AS cy ON cy.countryID = c.countryID
WHERE r.minimum_petrol > pt.petrol_capacity
AND cy.countryID <> (SELECT cy2.countryID
						FROM airline AS al2 JOIN routeairline AS ra2 ON ra2.airlineID = al2.airlineID
						JOIN route AS r2 ON r2.routeID = ra2.routeID
						JOIN airport AS ap2 ON ap2.airportID = r2.destination_airportID
						JOIN planetype AS pt2 ON pt2.planetypeID = ra2.planeTypeID
						JOIN city AS c2 ON ap2.cityID = c2.cityID
						JOIN country AS cy2 ON cy2.countryID = c2.countryID
						WHERE al2.airlineID = al.airlineID
						AND r2.routeID = r.routeID)
GROUP BY al.airlineID
ORDER BY COUNT(r.routeID) DESC, al.airlineID DESC;*/

-- Validació de que cumpleix totes les condicions mostrant les rutes d'una aerolínia en concret.
SELECT al.name AS 'airline name', al.airlineID, r.routeID, r.minimum_petrol, pt.petrol_capacity, (r.minimum_petrol - pt.petrol_capacity), cy.name AS 'país aeroport origen', cy2.name AS 'país aeroport destí'
FROM airline AS al JOIN routeairline AS ral ON ral.airlineID = al.airlineID
JOIN route AS r ON r.routeID = ral.routeID
JOIN airport AS ap ON ap.airportID = r.departure_airportID
JOIN planetype AS pt ON pt.planetypeID = ral.planetypeID
JOIN city AS c ON ap.cityID = c.cityID
JOIN country AS cy ON cy.countryID = c.countryID
JOIN airport AS a2 ON r.destination_airportID = a2.airportID
JOIN city AS c2 ON a2.cityID = c2.cityID
JOIN country AS cy2 ON c2.countryID = cy2.countryID
WHERE r.minimum_petrol > pt.petrol_capacity
AND cy.countryID <> cy2.countryID
AND al.airlineID = 2009
ORDER BY (r.minimum_petrol - pt.petrol_capacity) ASC;


-- 2.2 QUERY (FETA I VALIDADA)
SELECT CONCAT(CAST(FLOOR(m.grade) AS CHAR(2)), '-', CAST(FLOOR(m.grade)+1 AS CHAR(2)))  AS 'grade range', AVG(mt.duration) AS 'duration average'
FROM mechanic AS m JOIN maintenance AS mt ON mt.mechanicID = m.mechanicID
JOIN piecemaintenance AS pm ON pm.maintenanceID = mt.maintenanceID
JOIN piece AS p ON p.pieceID = pm.pieceID
where (SELECT COUNT(pm2.pieceID)
          FROM maintenance AS m2 JOIN piecemaintenance AS pm2 ON pm2.maintenanceID = m2.maintenanceID
          WHERE pm.maintenanceID= pm2.maintenanceID
          GROUP BY m2.maintenanceID
          LIMIT 1) < 10
GROUP BY FLOOR(m.grade);


-- 2.3 QUERY (FETA I VALIDADA)
SELECT a.airportID AS 'airport id', cy.countryID AS 'country id', AVG(r.distance) AS 'average distance' 
FROM airport AS a JOIN route AS r ON r.departure_airportID = a.airportID 
JOIN city AS c ON c.cityID = a.cityID 
JOIN country AS cy ON cy.countryID = c.countryID 
GROUP BY a.airportID  
HAVING AVG(r.distance) > (SELECT AVG(r2.distance) 
FROM airport AS a2 JOIN route AS r2 ON r2.departure_airportID = a2.airportID 
JOIN city AS c2 ON c2.cityID = a2.cityID 
JOIN country AS cy2 ON cy2.countryID = c2.countryID 
WHERE cy.countryID = cy2.countryID); 

-- Validacio
SELECT a.airportID, cy.countryID, AVG(distance)
FROM airport AS a JOIN route AS r ON r.departure_airportID = a.airportID
JOIN city AS c ON c.cityID = a.cityID
JOIN country AS cy ON cy.countryID = c.countryID
WHERE a.airportID = 5;

-- Comprovem la mitja de la distancia entre rutes en que el seu aeroport es del mateix país.
SELECT cy2.countryID, AVG(r2.distance) 
FROM airport AS a2 JOIN route AS r2 ON r2.departure_airportID = a2.airportID 
JOIN city AS c2 ON c2.cityID = a2.cityID 
JOIN country AS cy2 ON cy2.countryID = c2.countryID 
WHERE cy2.countryID = 1; 


-- 2.4 QUERY (FETA I VALIDADA)
SELECT a.name AS "airline name", a.airlineID AS "airline id", cy.name AS "country name", MAX(r.time) AS "longest route duration"
FROM airline AS a JOIN routeairline AS ra ON a.airlineID = ra.airlineID
JOIN route AS r ON ra.routeID = r.routeID
JOIN country AS cy ON cy.countryID = a.countryID
WHERE a.active = 'Y' 
AND cy.countryID NOT IN (SELECT DISTINCT cy2.countryID
					  FROM route AS r2 JOIN airport AS a2 ON r2.destination_airportID = a2.airportID
					  JOIN city AS c2 ON c2.cityID = a2.cityID
					  JOIN country AS cy2 ON cy2.countryID = c2.countryID
                      JOIN routeairline AS ra2 ON ra2.routeID = r2.routeID
					  WHERE a.airlineID = ra2.airlineID)
AND cy.countryID NOT IN (SELECT DISTINCT cy3.countryID
					  FROM route AS r3 JOIN airport AS a3 ON r3.departure_airportID = a3.airportID
					  JOIN city AS c3 ON c3.cityID = a3.cityID
					  JOIN country AS cy3 ON cy3.countryID = c3.countryID
                      JOIN routeairline AS ra3 ON ra3.routeID = r3.routeID
                      WHERE a.airlineID = ra3.airlineID)
GROUP BY a.airlineID
ORDER BY MAX(r.time) DESC;

-- Query que mostra, d'una aerolínia en concret, el seu país origen, si és activa o no i totes les seves rutes 
SELECT al.name AS 'airline name', al.airlineID, al.active AS "activa?", r.routeID, r.time AS 'duració', cy3.name AS 'pais aerolinia', cy.name AS 'país aeroport origen', cy2.name AS 'país aeroport destí'
FROM airline AS al JOIN routeairline AS ral ON ral.airlineID = al.airlineID
JOIN route AS r ON r.routeID = ral.routeID
JOIN airport AS ap ON ap.airportID = r.departure_airportID
JOIN city AS c ON ap.cityID = c.cityID
JOIN country AS cy ON cy.countryID = c.countryID
JOIN airport AS ap2 ON ap2.airportID = r.destination_airportID
JOIN city AS c2 ON ap2.cityID = c2.cityID
JOIN country AS cy2 ON cy2.countryID = c2.countryID
JOIN country AS cy3 ON al.countryID = cy3.countryID
WHERE al.airlineID = 4091
-- AND (cy3.countryID = cy.countryID OR cy3.countryID = cy2.countryID)
GROUP BY r.routeID DESC
ORDER BY r.time DESC;


-- 2.5 QUERY (EN PROCÉS)
SELECT pl.planeID AS 'plane id', pi.name AS 'piece name', COUNT(pm.maintenanceID) AS '# pieces replaced'
FROM plane AS pl JOIN maintenance AS m ON pl.planeID = m.planeID
JOIN piecemaintenance as pm ON pm.maintenanceID = m.maintenanceID
JOIN piece as pi ON pm.pieceID = pi.pieceID
GROUP BY pl.planeID, pi.pieceID, pi.cost
HAVING COUNT(pm.maintenanceID) > 1 AND (pi.cost * COUNT(pm.maintenanceID) > (((SELECT SUM(pi2.cost)
FROM plane AS p2 JOIN maintenance AS m2 ON p2.planeID = m2.planeID
JOIN piecemaintenance as pm2 ON pm2.maintenanceID = m2.maintenanceID
JOIN piece as pi2 ON pm2.pieceID = pi2.pieceID
WHERE p2.planeID = pl.planeID
GROUP BY p2.planeID)- pi.cost * COUNT(pi.pieceID))/2));

-- Validació
-- Suma del cost de totes les peces d'un avió en particular.
SELECT SUM(pi2.cost)
FROM plane AS p2 JOIN maintenance AS m2 ON p2.planeID = m2.planeID
JOIN piecemaintenance as pm2 ON pm2.maintenanceID = m2.maintenanceID
JOIN piece as pi2 ON pm2.pieceID = pi2.pieceID
 WHERE p2.planeID = 80
GROUP BY p2.planeID;

-- Query que mostra quantes i quines peces té cada avió i número de vegades que s'han canviat.
SELECT pl.planeID AS 'plane id', pi.name AS 'piece name', pm.pieceID, COUNT(pm.maintenanceID) AS "vegades que s'ha reemplaçat", pi.cost
FROM plane AS pl JOIN maintenance AS m ON pl.planeID = m.planeID
JOIN piecemaintenance as pm ON pm.maintenanceID = m.maintenanceID
JOIN piece as pi ON pm.pieceID = pi.pieceID
WHERE pl.planeID = 80
GROUP BY pl.planeID, pi.pieceID;


-- 2.8 TRIGGER (FET I VALIDAT)
DROP TABLE IF EXISTS EnvironmentalReductions;
CREATE TABLE EnvironmentalReductions(
	route VARCHAR(255),
    difference FLOAT,
    date DATE,
    PRIMARY KEY (route, date)
);

DELIMITER $$
DROP TRIGGER IF EXISTS petrol_updates $$
CREATE TRIGGER petrol_updates
	AFTER UPDATE
	ON route
	FOR EACH ROW
BEGIN
	INSERT INTO EnvironmentalReductions(route, difference, date)
    SELECT CONCAT(departure_airportID, " ", destination_airportID), NEW.minimum_petrol - OLD.minimum_petrol, CURRENT_DATE()
	FROM route
    WHERE routeID = NEW.routeID;
END $$

DELIMITER ;

-- Validació
UPDATE route SET minimum_petrol = 6000 -- Update 6000 a 5000 (5000 - 6000 = -1000)
WHERE routeID = 37016;

UPDATE route SET minimum_petrol = 3061 -- Update de 3061 a 4050 (4050 - 3061 = 989)
WHERE routeID = 37015;

UPDATE route SET minimum_petrol = 8492 -- Update de 8492 a 10734 (10734 - 8492 = 2242)
WHERE routeID = 37014;


-- 2.9 EVENT (NO RULA)
DROP TABLE IF EXISTS MaintenanceCost;
CREATE TABLE MaintenanceCost(
	planeID BIGINT(20),
    cost_maintenance FLOAT
    -- PRIMARY KEY (planeID)
);

DELIMITER $$
DROP PROCEDURE IF EXISTS cost_maintenance $$
CREATE PROCEDURE cost_maintenance()
BEGIN
	
	DECLARE done int default 0;
	DECLARE plane_id BIGINT(20);
    
	DECLARE maintenance_cursor CURSOR FOR SELECT DISTINCT planeID
									FROM maintenance  
									WHERE YEAR(date) = 1992; -- YEAR(CURRENT_DATE());
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;
    OPEN maintenance_cursor;
    
    planes_loop: LOOP
		FETCH maintenance_cursor INTO plane_id;
		
        IF done=1 THEN
             LEAVE planes_loop;
        END IF;
        SET @aux = CONCAT('SELECT SUM(pi.cost) INTO @suma_cost ',
							'FROM maintenance AS m JOIN piecemaintenance AS pm ON m.maintenanceID = pm.maintenanceID ',
                            'JOIN piece AS pi ON pm.pieceID = pi.pieceID ',
                            'WHERE YEAR(m.date) = 1992 ',
                            'AND m.planeID = ', plane_id);
                            
        PREPARE stmt_suma_cost FROM @aux;
        EXECUTE stmt_suma_cost;
        
        SET @aux = CONCAT('INSERT INTO MaintenanceCost(planeID, cost_maintenance) VALUES(', plane_id, ', 1.0)');
                            
        PREPARE stmt_maintenance FROM @aux;
        EXECUTE stmt_maintenance;
	END LOOP;
END $$

DELIMITER ;
DROP EVENT IF EXISTS maintenance_cost;
CREATE EVENT maintenance_cost 
ON SCHEDULE EVERY 1 YEAR
	STARTS '2021-06-30 22:20:00' -- La data es indiferent
    ON COMPLETION PRESERVE
    DO CALL  
		 cost_maintenance();




