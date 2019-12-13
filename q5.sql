-- Gets all the max and min prices from rentals and property
DROP VIEW IF EXISTS propertyPrices CASCADE;
CREATE VIEW propertyPrices AS
SELECT p.propertyId, MAX(r.price) as maxPrice, MIN(r.price) as minPrice
FROM Property p INNER JOIN Rental r
ON p.propertyId = r.propertyId
GROUP BY p.propertyId;

-- Gets the sigple most expensive price
DROP VIEW IF EXISTS absolutemaxPrice CASCADE;
CREATE VIEW absolutemaxPrice AS
SELECT MAX(price) as absMax
FROM Rental;

-- Returns the absolute max with ever instance in table propertyPrices
DROP VIEW IF EXISTS allPriceInfo CASCADE;
CREATE VIEW allPriceInfo AS
SELECT p.propertyId, p.maxPrice, p.minPrice, m.absMax 
FROM propertyPrices p, absolutemaxPrice m;

-- returns the max price, min price, range(***which is redundant***) 
-- and returns if the max price is = to the absolute max price form the MaxPriceTable
SELECT propertyId, minPrice, maxPrice, CONCAT(minPrice, '-', maxPrice) as range, 
    CASE WHEN 
        maxPrice = absMax 
        THEN '*' 
        ELSE NULL
    END as highestRange
FROM allPriceInfo;

