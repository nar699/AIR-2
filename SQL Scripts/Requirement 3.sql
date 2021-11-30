USE lsair;

-- 3.1 QUERY (FETA I VALIDADA)
SELECT DISTINCT c.name AS 'company name', cy.name AS 'country name', c.companyID, cy.countryID AS 'país de la empresa'
FROM company AS c JOIN product AS p ON c.companyID = p.companyID
JOIN food AS f ON f.foodID = p.productID
JOIN country AS cy ON c.countryID = cy.countryID
WHERE ((SELECT COUNT(f2.foodID)
		FROM company AS c2 JOIN product AS p2 ON c2.companyID = p2.companyID
		JOIN food AS f2 ON f2.foodID = p2.productID
		WHERE c.companyID = c2.companyID
        AND c.countryID = f2.countryID) / (SELECT COUNT(f3.foodID)
											FROM company AS c3 JOIN product AS p3 ON c3.companyID = p3.companyID
											JOIN food AS f3 ON f3.foodID = p3.productID
											WHERE c.companyID = c3.companyID)) >= 1/40;
-- GROUP BY c.companyID;

-- Calculem quants productes alimentaris d'una empresa hi ha el seu país de procedencia sigui el mateix que el pais de l'empresa.
SELECT f.foodID, f.countryID AS 'país procedent del producte alimentari', c.countryID AS 'país de la empresa', c.companyID
FROM company AS c JOIN product AS p ON c.companyID = p.companyID
JOIN food AS f ON f.foodID = p.productID
JOIN country AS cy ON c.countryID = cy.countryID 
WHERE c.companyID = 79
AND f.countryID = 108; -- Imposem que el pais procedent del producte alimentari sigui el mateix que el país de la empresa.

-- Calculem el número total de productes alimentaris d'aquella empresa.
SELECT f.foodID, f.countryID AS 'país procedent del producte alimentari', c.countryID AS 'país de la empresa', c.companyID
FROM company AS c JOIN product AS p ON c.companyID = p.companyID
JOIN food AS f ON f.foodID = p.productID
JOIN country AS cy ON c.countryID = cy.countryID 
WHERE c.companyID = 91;

-- Fem el càlcul correspondent
-- 1/31 >= 1/40


-- 3.3 QUERY (FETA I VALIDADA)
SELECT c.name AS 'company name', ROUND(MAX(r.score), 2) AS 'score'
FROM company AS c JOIN waitingarea AS wa ON c.companyID = wa.companyID
JOIN restaurant AS r ON wa.waitingAreaID = r.restaurantID
WHERE c.companyID = (SELECT c2.companyID
					FROM company AS c2 JOIN waitingarea AS wa2 ON c2.companyID = wa2.companyID
                    GROUP BY c2.companyID
                    ORDER BY COUNT(wa2.waitingAreaID) DESC
                    LIMIT 1);

-- Validació
-- Trobem quina es l'empresa que té més waiting areas.
SELECT c.name AS 'company name', COUNT(wa.waitingAreaID) AS 'nombre de waiting areas'
FROM company AS c JOIN waitingarea AS wa ON c.companyID = wa.companyID
GROUP BY c.companyID
ORDER BY COUNT(wa.waitingAreaID) DESC;

-- Mirem quin es el restaurant amb millor puntuació.
SELECT c.name AS 'company name', r.score
FROM company AS c JOIN waitingarea AS wa ON c.companyID = wa.companyID
JOIN restaurant AS r ON wa.waitingAreaID = r.restaurantID
WHERE c.name = 'Zazio'
ORDER BY r.score DESC;

-- 3.4 QUERY (FETA I VALIDADA)
SELECT c.name AS 'company name', c.company_value AS 'company value'
FROM company AS c
WHERE c.companyID IN (SELECT c.companyID
						FROM (SELECT s.storeID, (COUNT(*) / (SELECT COUNT(*)
																FROM store AS s2 JOIN productstore AS ps2 ON s2.storeID = ps2.storeID
																WHERE s2.storeID = s.storeID
																GROUP BY s2.storeID)) AS same_product_ratio
								FROM store AS s JOIN productstore AS ps ON s.storeID = ps.storeID
								JOIN product AS p ON p.productId = ps.productID
								JOIN company AS productcompany ON productcompany.companyID = p.companyID
								GROUP BY p.companyID, s.storeID) AS same_product_ratio_x_store
						JOIN waitingarea AS w ON same_product_ratio_x_store.storeID = w.waitingareaID
						JOIN company AS c ON w.companyID = c.companyID
						WHERE same_product_ratio_x_store.same_product_ratio > 0.2)
AND c.companyID IN (SELECT c.companyID
					FROM restaurant AS r JOIN waitingarea AS w ON r.restaurantID = w.waitingareaID
					JOIN company AS c ON c.companyID = w.companyID
					GROUP BY c.companyID, r.type
					HAVING COUNT(r.type) > 1);

-- Validació, mateixa query però afegint companyID
SELECT c.name AS 'company name', c.company_value AS 'company value', c.companyID
FROM company AS c
WHERE c.companyID IN (SELECT c.companyID
						FROM (SELECT s.storeID, (COUNT(*) / (SELECT COUNT(*)
																FROM store AS s2 JOIN productstore AS ps2 ON s2.storeID = ps2.storeID
																WHERE s2.storeID = s.storeID
																GROUP BY s2.storeID)) AS same_product_ratio
								FROM store AS s JOIN productstore AS ps ON s.storeID = ps.storeID
								JOIN product AS p ON p.productId = ps.productID
								JOIN company AS productcompany ON productcompany.companyID = p.companyID
								GROUP BY p.companyID, s.storeID) AS same_product_ratio_x_store
						JOIN waitingarea AS w ON same_product_ratio_x_store.storeID = w.waitingareaID
						JOIN company AS c ON w.companyID = c.companyID
						WHERE same_product_ratio_x_store.same_product_ratio > 0.2)
AND c.companyID IN (SELECT c.companyID
					FROM restaurant AS r JOIN waitingarea AS w ON r.restaurantID = w.waitingareaID
					JOIN company AS c ON c.companyID = w.companyID
					GROUP BY c.companyID, r.type
					HAVING COUNT(r.type) > 1);

-- Validació vendas
SELECT c.companyID, s.storeID, COUNT(p.productId) AS 'número de productes'
FROM store AS s JOIN productstore AS ps ON s.storeID = ps.storeID
JOIN product AS p ON p.productId = ps.productID
JOIN company AS c ON p.companyID = c.companyID
WHERE c.companyID = 151
GROUP BY c.companyID, s.storeID;

-- Validació restaurants
SELECT c.companyID, r.restaurantID, r.type
FROM company AS c JOIN waitingarea AS w ON c.companyID = w.companyID
JOIN restaurant AS r ON w.waitingareaID = r.restaurantID
WHERE c.companyID = 151;


-- 3.5 QUERY (FETA I VALIDADA) 
SELECT c.name AS 'company name', wa.opening_hour AS 'opening hour', wa.close_hour AS 'close hour', wa.airportID AS 'airport ID', wa.waitingareaID AS 'waiting area ID'
FROM company AS c JOIN waitingarea AS wa ON wa.companyID = c.companyID
WHERE (HOUR(wa.close_hour - wa.opening_hour)) > (SELECT SUM((HOUR(sk2.weekly_hours)/7))
												 FROM company AS c2 JOIN waitingarea AS wa2 ON wa2.companyID = c2.companyID
												 JOIN shopkeeper AS sk2 ON sk2.waitingareaID = wa2.waitingareaID
                                                 WHERE wa.waitingareaID = wa2.waitingareaID)
AND wa.close_hour < '24:00:00' AND wa.close_hour > '06:00:00';


-- Validacio 
-- Hem d'anar mirar que les waiting area ID en que hores que obra al dia > hores totals diaries dels shopkeepers coinidexin amb la query principal.
SELECT c.name AS 'company name', wa.airportID, wa.waitingareaID, HOUR(wa.close_hour - wa.opening_hour) AS 'hores que obra al dia', SUM(HOUR(sk.weekly_hours)/7) 'hores totals diaries dels shopkeepers'
FROM company AS c JOIN waitingarea AS wa ON wa.companyID = c.companyID
JOIN shopkeeper AS sk ON sk.waitingareaID = wa.waitingareaID
AND wa.close_hour < "24:00:00" AND wa.close_hour > '06:00:00'
GROUP BY wa.waitingareaID
ORDER BY wa.waitingareaID ASC;


-- 3.7 TRIGGER (FET I VALIDAT) 
DROP TABLE IF EXISTS PriceUpdates;
CREATE TABLE PriceUpdates(	
				productID bigint(20),
				product_name VARCHAR(255),
                companyID bigint(20),
                previous_price VARCHAR(255),
                later_price VARCHAR(255),
                date_of_change DATETIME, -- al posar-lo a la memòria posar DATE. DATETIME al fer probes.
                comentari TEXT,
                PRIMARY KEY (productID, date_of_change)
);


DELIMITER $$
DROP TRIGGER IF EXISTS updated_products $$
CREATE TRIGGER updated_products
	AFTER UPDATE 
	ON product
	FOR EACH ROW
BEGIN
	IF NEW.price <> OLD.price THEN
		SET @Comment = " ";
       
		IF (SELECT COUNT(*) 
		   FROM PriceUpdates
		   WHERE productID = OLD.productID 
           AND date_of_change <> CURRENT_TIMESTAMP()) > 0 THEN -- al posar-lo a la memòria posar CURRENT_DATE(). CURRENT_TIMESTAMP() per fer probes.
           
           IF (SELECT later_price 
		   FROM PriceUpdates
           WHERE productID = OLD.productID 
		   ORDER BY date_of_change DESC
           LIMIT 1) > NEW.price THEN
           
			SET @Comment =  "This product has been changing over time, it is possible that it is a strategy of the company.";
            
            END IF;
            
		END IF;
         
		INSERT INTO PriceUpdates(productID, product_name, companyID, previous_price, later_price, date_of_change, comentari)
        VALUES (OLD.productId, OLD.name, OLD.companyID, OLD.price, NEW.price, NOW(), @Comment);
        
	END IF;
		
END $$

DELIMITER ;

-- Validació
INSERT INTO product (productId, companyID, name, weight, price)
VALUES (17001, 110, "Standoff", 17.5, 53.9);

INSERT INTO product (productId, companyID, name, weight, price)
VALUES (17002, 116, "Raid", 34.1, 77.4);


UPDATE product SET price = 40 WHERE productId = 17001;

UPDATE product SET price = 45 WHERE productId = 17001;

UPDATE product SET price = 43 WHERE productId = 17001;

UPDATE product SET price = 47 WHERE productId = 17001;

UPDATE product SET price = 80 WHERE productId = 17002;

UPDATE product SET price = 70 WHERE productId = 17002;



-- 3.9 EVENT (FET I VALIDAT)
DROP TABLE IF EXISTS ExpiredProducts;
CREATE TABLE ExpiredProducts(
	productID BIGINT(20),
    expiry_date DATE,
    dia DATE,
    PRIMARY KEY (productID)
);

DELIMITER $$
DROP PROCEDURE IF EXISTS food_check $$
CREATE PROCEDURE food_check()
BEGIN
	INSERT INTO ExpiredProducts(productID, expiry_date, dia)
    SELECT foodID, expiration_date, CURRENT_DATE() 
    FROM food JOIN product AS p ON foodID = p.productID
    JOIN productstore AS ps ON p.productID = ps.productID
    WHERE expiration_date < CURRENT_DATE()
    GROUP BY foodID
    ON DUPLICATE KEY UPDATE productID = productID;
END $$

DELIMITER ;
DROP EVENT IF EXISTS expired_food;
CREATE EVENT expired_food 
ON SCHEDULE EVERY 24 HOUR
	STARTS '2021-01-01 23:59:59' -- La data es indiferent
    ON COMPLETION PRESERVE
    DO CALL  
		 food_check();
         

-- Validació
INSERT INTO product(productId, companyID, name, weight, price)  -- Insertem a product.
VALUES (17003, 116, "Pringles", 20.5, 2);

INSERT INTO productstore(storeID, productID)  -- Insertem a productestore.
VALUES (601, 17003);  

INSERT INTO food(foodID, expiration_date, countryID)  -- Insertem producte ja caducat a food..
VALUES (17003, "2021-01-04", 125); 


INSERT INTO product(productId, companyID, name, weight, price)  -- Insertem a product.
VALUES (17004, 27, "Lays", 15.2, 3);

INSERT INTO productstore(storeID, productID)  -- Insertem a productestore.
VALUES (8, 17004);  

INSERT INTO food(foodID, expiration_date, countryID)  -- Insertem producte que encara no ha caducat
VALUES (17004, "2022-03-11", 81); 


-- SET GLOBAL event_scheduler = 1;
-- SELECT @@GLOBAL.event_scheduler

