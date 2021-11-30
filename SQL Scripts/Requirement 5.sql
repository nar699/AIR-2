USE lsair;

-- 5.3 QUERY
SELECT pe.name AS 'passenger name', pe.surname, pe.phone_number AS 'Phone number', COUNT(lp.languageID) AS '# languages spoken'
FROM person AS pe JOIN passenger AS pa ON pe.personID = pa.passengerID
JOIN languageperson AS lp ON lp.personID = pe.personID
JOIN flighttickets AS ft ON pa.passengerID = ft.passengerID
JOIN flight AS f ON f.flightID = ft.flightID
JOIN route AS r ON f.flightID  = r.routeID
JOIN airport AS ar ON r.departure_airportID = ar.airportID
JOIN city AS cy ON cy.cityID = ar.cityID
WHERE (SELECT COUNT(lp2.languageID)  -- Mirem que el passatger parla més de 2 o més idiomes
		FROM person AS pe2 JOIN passenger AS pa2 ON pe2.personID = pa2.passengerID
		JOIN languageperson AS lp2 ON lp2.personID = pe2.personID
        WHERE pe2.personID = pe.personID
        GROUP BY pe2.personID) >= 2
AND (SELECT l4.languageID   -- Mirem que almneys un d'aquests idiomes sigui Chavacano
	 FROM language AS l4
	 WHERE l4.name = "Chavacano") IN (SELECT lp3.languageID
										FROM person AS pe3 JOIN passenger AS pa3 ON pe3.personID = pa3.passengerID
										JOIN languageperson AS lp3 ON lp3.personID = pe3.personID
										WHERE pe3.personID = pe.personID)
AND ABS(cy.timezone - (SELECT cy2.timezone    -- Que la diferencia horaria de la ciutat origen respecte la ciutat destí de la ruta és major o igual a 3 
						FROM person AS pe2 JOIN passenger AS pa2 ON pe2.personID = pa2.passengerID
						JOIN flighttickets AS ft2 ON pa2.passengerID = ft2.passengerID
						JOIN flight AS f2 ON f2.flightID = ft2.flightID
						JOIN route AS r2 ON f2.flightID = r2.routeID
						JOIN airport AS ar2 ON r2.destination_airportID = ar2.airportID
						JOIN city AS cy2 ON cy2.cityID = ar2.cityID
						WHERE pe2.personID = pe.personID
						AND r.routeID = r2.routeID
						GROUP BY cy2.cityID)) >= 3
GROUP BY pe.personID;

-- Validació
-- Mateixa query però afegint-li el personID per fer comprovacions a posteriori
SELECT pe.name AS 'passenger name', pe.surname, pe.phone_number AS 'Phone number', COUNT(lp.languageID) AS '# languages spoken', pe.personID
FROM person AS pe JOIN passenger AS pa ON pe.personID = pa.passengerID
JOIN languageperson AS lp ON lp.personID = pe.personID
JOIN flighttickets AS ft ON pa.passengerID = ft.passengerID
JOIN flight AS f ON f.flightID = ft.flightID
JOIN route AS r ON f.flightID  = r.routeID
JOIN airport AS ar ON r.departure_airportID = ar.airportID
JOIN city AS cy ON cy.cityID = ar.cityID
WHERE (SELECT COUNT(lp2.languageID)  -- Mirem que el passatger parla més de 2 o més idiomes
		FROM person AS pe2 JOIN passenger AS pa2 ON pe2.personID = pa2.passengerID
		JOIN languageperson AS lp2 ON lp2.personID = pe2.personID
        WHERE pe2.personID = pe.personID
        GROUP BY pe2.personID) >= 2
AND (SELECT l4.languageID   -- Mirem que almneys un d'aquests idiomes sigui Chavacano
	 FROM language AS l4
	 WHERE l4.name = "Chavacano") IN (SELECT lp3.languageID
										FROM person AS pe3 JOIN passenger AS pa3 ON pe3.personID = pa3.passengerID
										JOIN languageperson AS lp3 ON lp3.personID = pe3.personID
										WHERE pe3.personID = pe.personID)
AND ABS(cy.timezone - (SELECT cy2.timezone    -- Que la diferencia horaria de la ciutat origen respecte la ciutat destí de la ruta és major o igual a 3 
						FROM person AS pe2 JOIN passenger AS pa2 ON pe2.personID = pa2.passengerID
						JOIN flighttickets AS ft2 ON pa2.passengerID = ft2.passengerID
						JOIN flight AS f2 ON f2.flightID = ft2.flightID
						JOIN route AS r2 ON f2.flightID = r2.routeID
						JOIN airport AS ar2 ON r2.destination_airportID = ar2.airportID
						JOIN city AS cy2 ON cy2.cityID = ar2.cityID
						WHERE pe2.personID = pe.personID
						AND r.routeID = r2.routeID
						GROUP BY cy2.cityID)) >= 3
GROUP BY pe.personID;

-- Validació de que persona parla 2 o més idiomes i un d'ells el Chavacano
SELECT lp.personID, l.languageID, l.name AS 'nom del idioma'
FROM languageperson AS lp JOIN language AS l ON lp.languageID = l.languageID
WHERE personID = 2002;

-- Mostrem tots els vols que ha agafat el passatger i mirem 
SELECT pe.personID, f.flightID, cy.timezone, cy2.timezone, ABS((cy.timezone) - (cy2.timezone)) AS 'diferència horària'
FROM person AS pe JOIN passenger AS pa ON pe.personID = pa.passengerID
JOIN flighttickets AS ft ON pa.passengerID = ft.passengerID
JOIN flight AS f ON f.flightID = ft.flightID
JOIN route AS r ON f.flightID = r.routeID
JOIN airport AS ar2 ON r.destination_airportID = ar2.airportID
JOIN airport AS ar ON r.departure_airportID = ar.airportID
JOIN city AS cy2 ON cy2.cityID = ar2.cityID
JOIN city AS cy ON cy.cityID = ar.cityID
WHERE pe.personID = 2002;

