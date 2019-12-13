SET SEARCH_PATH TO Vacationschema, PUBLIC;

--Gets the capacity of each rental property
DROP VIEW IF EXISTS rentalCapacities CASCADE;
CREATE VIEW rentalCapacities AS
SELECT Rental.propertyId as propertyId, listingId, capacity
FROM Rental join Property on Rental.propertyId = Property.propertyId;

-- Gets the size of each party
DROP VIEW IF EXISTS realPartySize CASCADE;
CREATE VIEW realPartySize AS
SELECT Party.partyId as partyId, count(Party.partyId) as partySize
FROM PartyMembers join Party on PartyMembers.partyId = Party.partyId
GROUP BY Party.partyId;

-- Gets the party associated with each listingId
DROP VIEW IF EXISTS rentalPartySize CASCADE;
CREATE VIEW rentalPartySize AS
SELECT listingId, realPartySize.partySize
FROM Rental join realPartySize on Rental.partyId = realPartySize.partyId;

-- Gets the rentals that are full
DROP VIEW IF EXISTS fullRentals CASCADE;
CREATE VIEW fullRentals AS
SELECT rentalCapacities.propertyId, count(rentalCapacities.listingId)
FROM rentalCapacities join rentalPartySize on rentalCapacities.listingId = rentalPartySize.listingId
WHERE capacity = partySize+1
GROUP BY rentalCapacities.propertyId;

-- Gets the ratings of each full rental
DROP VIEW IF EXISTS fullRentalsWithRatings CASCADE;
CREATE VIEW fullRentalsWithRatings AS
SELECT fullRentals.propertyId as propertyId, avg(propertyRating.rating) as averageRating, 'at capacity' as capacity
FROM fullRentals join propertyRating on fullRentals.propertyId = propertyRating.propertyId
GROUP BY fullRentals.propertyId;

-- Gets the rentals that were not at capacity
DROP VIEW IF EXISTS underCapacityRentals CASCADE;
CREATE VIEW underCapacityRentals AS
SELECT rentalCapacities.propertyId, count(rentalCapacities.listingId)
FROM rentalCapacities join rentalPartySize on rentalCapacities.listingId = rentalPartySize.listingId
WHERE capacity > partySize+1
GROUP BY rentalCapacities.propertyId;

-- Gets the ratings of the rentals that were not at capacity
DROP VIEW IF EXISTS underCapacityRentalsWithRatings CASCADE;
CREATE VIEW underCapacityRentalsWithRatings AS
SELECT underCapacityRentals.propertyId as propertyId, avg(propertyRating.rating) as averageRating, 'under capacity' as capacity
FROM underCapacityRentals join propertyRating on underCapacityRentals.propertyId = propertyRating.propertyId
GROUP BY underCapacityRentals.propertyId;

-- Get the under capacity and full capacity ratings into one table
(SELECT count(propertyId) as propertyCount, avg(averageRating) as averageRating, capacity FROM fullRentalsWithRatings GROUP BY capacity)
UNION 
(SELECT count(propertyId) as propertyCount, avg(averageRating) as averageRating, capacity FROM underCapacityRentalsWithRatings GROUP BY capacity);
