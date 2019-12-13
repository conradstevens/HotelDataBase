-- All Propertys and the average number of guests staying at
-- a given property
SET SEARCH_PATH TO Vacationschema, PUBLIC;

-- Parties and properties
DROP VIEW IF EXISTS ListingProperties CASCADE;
CREATE VIEW ListingProperties AS
SELECT listingId, propertyId, partyId
FROM Rental;

-- Properties and party members
DROP VIEW IF EXISTS PartyProperties CASCADE;
CREATE VIEW PartyProperties AS
SELECT ListingProperties.propertyId, 
   CAST(COUNT(PartyMembers.guestId) as float) / 
   CAST(COUNT(DISTINCT(PartyMembers.partyId)) as float) as avgGuest
FROM ListingProperties INNER JOIN PartyMembers
ON ListingProperties.partyID = PartyMembers.partyId
GROUP BY ListingProperties.propertyId;

-- The average number of people who stay at city properties
DROP VIEW IF EXISTS AvgCityProperty CASCADE;
CREATE VIEW AvgCityProperty AS
SELECT
    CAST(SUM(p.avgGuest) as float) /
    CAST(COUNT(DISTINCT(cp.propertyId)) as float) as avgCity
FROM PartyProperties p INNER JOIN CityProperty cp
ON p.propertyId = cp.propertyId;

-- The average number of people who stay at water properties
DROP VIEW IF EXISTS AvgWaterProperty CASCADE;
CREATE VIEW AvgWaterProperty AS
SELECT
    CAST(SUM(p.avgGuest) as float) /
    CAST(COUNT(DISTINCT(wp.propertyId)) as float) as avgWater
FROM PartyProperties p INNER JOIN WaterProperty wp
ON p.propertyId = wp.propertyId;

-- Properties that are neither city or water properties
DROP VIEW IF EXISTS OtherProperty CASCADE;
CREATE VIEW OtherProperty AS
SELECT propertyId
FROM Property
EXCEPT
(
    (SELECT propertyId
    FROM CityProperty)
    UNION
    (SELECT propertyId
    FROM WaterProperty)
);
    
-- The average number of people who stay at Other properties
DROP VIEW IF EXISTS AvgOtherProperty CASCADE;
CREATE VIEW AvgOtherProperty AS
SELECT
    CAST(SUM(p.avgGuest) as float) /
    CAST(COUNT(DISTINCT(op.propertyId)) as float) as avgOther
FROM PartyProperties p INNER JOIN OtherProperty op
ON p.propertyId = op.propertyId;

-- Answer
-- Averages of number of poeple who stayed at water, city and other properties
SELECT avgCity, avgWater, avgOther
FROM AvgCityProperty, AvgWaterProperty, AvgOtherProperty;
