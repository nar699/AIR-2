-- CASE STUDY 1
-- Dataset 1
USE lsair;

DROP TABLE IF EXISTS Dataset1 CASCADE;
CREATE TABLE Dataset1(
   planeID BIGINT(20),
   retirement_year bigint(20),
   type_plane VARCHAR(255),
   name VARCHAR(255),
   maintenance_count INTEGER,
   piece_count INTEGER,
   cost_sum BIGINT(20),

   PRIMARY KEY (planeID)
);
INSERT INTO Dataset1(planeID, retirement_year, type_plane, name, maintenance_count, piece_count, cost_sum)
SELECT p.planeID, p.retirement_year, pt.type_name, a.name, COUNT(m.maintenanceID), COUNT(pm.maintenanceID), SUM(pc.cost)
FROM plane AS p JOIN planetype AS pt ON pt.planetypeID = p.planetypeId
JOIN airline AS a ON p.airlineID = a.airlineID
JOIN maintenance AS m ON m.planeID = p.planeID
JOIN piecemaintenance AS pm ON m.maintenanceID = pm.maintenanceID
JOIN piece AS pc ON pc.pieceID = pm.pieceID
JOIN country AS cy ON a.countryID = cy.countryID
WHERE cy.name LIKE 'S%'
AND (EXTRACT(YEAR FROM current_date()) - p.retirement_year) < 3
GROUP BY planeID
UNION
SELECT p.planeID, p.retirement_year, pt.type_name, a.name, 0, 0, 0
FROM plane AS p JOIN planetype AS pt ON pt.planetypeID = p.planetypeId
JOIN airline AS a ON p.airlineID = a.airlineID
JOIN country AS cy ON a.countryID = cy.countryID
WHERE cy.name LIKE 'S%' AND NOT EXISTS(SELECT * FROM  maintenance AS m WHERE  m.planeID = p.planeID)
AND (EXTRACT(YEAR FROM current_date()) - p.retirement_year) < 3
GROUP BY planeID;

-- Dataset 12
DROP TABLE IF EXISTS Dataset12 CASCADE;
CREATE TABLE Dataset12(
	planeID BIGINT(20),
    departure BIGINT(20),
    destination BIGINT(20),
    PRIMARY KEY(planeID,departure,destination),
    FOREIGN KEY (planeID) REFERENCES Dataset1(planeID)
);
INSERT INTO Dataset12(planeID,departure, destination)
SELECT DISTINCT f.planeID,r.departure_airportID, r.destination_airportID
FROM  flight as f JOIN route AS r ON r.routeID=f.routeID
WHERE f.planeID IN (select planeID from dataset1);


-- Dataset2
DROP TABLE IF EXISTS Dataset2 CASCADE;
CREATE TABLE Dataset2(
	airportID BIGINT(20),
    airport_name VARCHAR(255),
    airport_altitude INT(11),
    cityID BIGINT(20),
    city_name VARCHAR(255),
    city_timezone INT(11),
    country_name VARCHAR(255),

    PRIMARY KEY(airportID)
);

INSERT INTO Dataset2(airportID, airport_name, airport_altitude, cityID, city_name, city_timezone, country_name)
SELECT DISTINCT ap.airportID, ap.name, ap.altitude, c.cityID, c.name, c.timezone, cy.name
FROM Dataset12 AS d12 JOIN airport AS ap ON ap.airportID = d12.destination
JOIN city AS c ON ap.cityID = c.cityID
JOIN country AS cy ON c.countryID = cy.countryID
UNION
SELECT DISTINCT ap.airportID, ap.name, ap.altitude, c.cityID, c.name, c.timezone, cy.name
FROM Dataset12 AS d12 JOIN airport AS ap ON ap.airportID = d12.departure
JOIN city AS c ON ap.cityID = c.cityID
JOIN country AS cy ON c.countryID = cy.countryID; 


-- INSERT per fer les querys
-- insert all routes lagos south korea query 5
INSERT INTO dataset2(airportID, airport_name, airport_altitude, cityID, city_name, city_timezone, country_name) VALUES(2272,'Gimpo International Airport',59,2175,'Seoul',9,'South Korea');
INSERT INTO dataset2(airportID, airport_name, airport_altitude, cityID, city_name, city_timezone, country_name) VALUES(2265,'Jeju International Airport',118,2168,'Cheju',9,'South Korea');
INSERT INTO Dataset12(planeID, departure, destination) VALUES(1259,2272,2957);
INSERT INTO Dataset12(planeID, departure, destination) VALUES(1259,2265,2957);

-- QUERY4
INSERT INTO dataset2(airportID, airport_name, airport_altitude, cityID, city_name, city_timezone, country_name) VALUES(5195,'Sembawang Air Base',86,2997,'Sembawang',8,'Singapore');
INSERT INTO dataset2(airportID, airport_name, airport_altitude, cityID, city_name, city_timezone, country_name) VALUES(1430,'Limnos Airport',14,1373,'Limnos',2,'Greece');


INSERT INTO Dataset1(planeID, retirement_year, type_plane, name, maintenance_count, piece_count, cost_sum) VALUES(1,2020,'Spain AM','NGM',5,5,2195297);
INSERT INTO Dataset1(planeID, retirement_year, type_plane, name, maintenance_count, piece_count, cost_sum) VALUES(2,2020,'Spain AM2','NGM',6,6,2995297);

INSERT INTO Dataset12(planeID, departure, destination) VALUES(1344,5195,1430);
INSERT INTO Dataset12(planeID, departure, destination) VALUES(1,5195,1473);
INSERT INTO Dataset12(planeID, departure, destination) VALUES(2,1473,1430);
