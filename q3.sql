SET SEARCH_PATH TO Vacationschema, PUBLIC;

--Associate hosts with their ratings
DROP VIEW IF EXISTS hostWithRatings CASCADE;
CREATE VIEW hostWithRatings AS
SELECT Host.email as email, HostRating.hostId as hostId, avg(rating) as avgRating
FROM HostRating join Host on HostRating.hostId = Host.hostId
GROUP BY HostRating.hostId, Host.email;

--Associate the rated hosts with their owned property
DROP VIEW IF EXISTS ratedHostWithProperty CASCADE;
CREATE VIEW ratedHostWithProperty AS
SELECT hostWithRatings.email as email, hostWithRatings.avgRating as avgRating, propertyId 
FROM hostWithRatings join Property on hostWithRatings.hostId = Property.owner;

-- Get the highest price host has ever charged for a week
DROP VIEW IF EXISTS ratedHostWithMaxPrice CASCADE;
CREATE VIEW ratedHostWithMaxPrice AS
SELECT ratedHostWithProperty.email as email, ratedHostWithProperty.avgRating as avgRating, max(Rental.price) as maxPrice 
FROM ratedHostWithProperty join Rental on ratedHostWithProperty.propertyId = Rental.propertyId
GROUP BY ratedHostWithProperty.email, ratedHostWithProperty.avgRating;

-- Get the highest average rating of all hosts
DROP VIEW IF EXISTS highestAverage CASCADE;
CREATE VIEW highestAverage AS
SELECT max(avgRating) as highestRating
FROM ratedHostWithMaxPrice;

SELECT ratedHostWithMaxPrice.email, ratedHostWithMaxPrice.avgRating, ratedHostWithMaxPrice.maxPrice
FROM ratedHostWithMaxPrice, highestAverage
WHERE ratedHostWithMaxPrice.avgRating = highestAverage.highestRating;
