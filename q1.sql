SET SEARCH_PATH TO Vacationschema, PUBLIC;
-- Gets each luxury and the number of properties that have it.
SELECT service, count(propertyId)
FROM Luxury
GROUP BY service;
