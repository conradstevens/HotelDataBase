/*
What constraints from the domain could not be enforced, if any?
1. Renter may be younger than 18 years of age (requires cross table check)
    1.2 as a consequence party hosts may be younger than 18 years of age
2. The number of people in the party may exceed the capacity of property (requires cross table check)
3. Guests in propertyRating may have not stayed at the property (requires cross table check)
    3.2 By extension, people who left comments may not have stayed at the property
4. Renters in hostRating may not have stayed with that host (requires cross table check)

What constraints that could have been enforced were not enforced, if any?  Why not?
1. We could not enforce Saturday check because it needed a subquery.
*/

-- This Defines the Schema for the entire Luxury Rentals Data Base
drop schema if exists vacationschema cascade;
create schema vacationschema;
set search_path to vacationschema, public;

/* *******************************************************************************
   **************************  PEOPLE IN DATA BASE *******************************
   *******************************************************************************/
-- A Guest in the Data Base
CREATE TABLE Guest (
    guestId     integer PRIMARY KEY,
    name        text NOT NULL,
    dateOfBirth date NOT NULL,
    adress      text NOT NULL
);
    -- A Guest that can rent
    CREATE TABLE Renter (
        guestId     integer REFERENCES Guest PRIMARY KEY,
        creditCard  bigint NOT NULL
    );

-- A host in the data base 
CREATE TABLE Host (
    hostId integer PRIMARY KEY,
    email  text NOT NULL
);

/* *******************************************************************************
   *********************** PROPERTIES IN DATA BASE *******************************
   *******************************************************************************/
-- A property owned by a Host
CREATE TABLE Property (
    propertyId      integer PRIMARY KEY,
    address         varchar UNIQUE,
    owner           integer NOT NULL REFERENCES Host(hostId),
    capacity        integer CHECK (capacity >= numBedrooms),
    numBedrooms     integer,
    numBathrooms    integer
);
    -- Luxury amenities included with a house
    CREATE TABLE Luxury (
        propertyId  integer NOT NULL REFERENCES Property(propertyId),
        service     text,
            CHECK(service = 'hot tub' or 
                service = 'sauna' or
                service = 'laundry service' or
                service = 'daily cleaning' or
                service = 'daily breakfast delivery' or
                service = 'concierge service')
    );

    -- Details of a city Property
    CREATE TABLE CityProperty (
        propertyID      integer PRIMARY KEY REFERENCES Property,
        walkScore       integer, 
            CHECK(walkScore >= 0 and walkScore <=100),
        closestTransit text,
            CHECK(closestTransit = 'bus' OR
                closestTransit = 'LRT' OR
                closestTransit = 'subway' OR
                closestTransit IS NULL)
    );

    -- Deatails of a water property
    CREATE TABLE WaterProperty (
        propertyID  integer PRIMARY KEY NULL REFERENCES Property,
        lifeGuard   Boolean NOT NULL,
        waterType   text, 
                check(waterType = 'beach' or waterType = 'lake' or waterType = 'pool')
    );

/* *******************************************************************************
   ****************************** TRANSACTIONS ***********************************
   *******************************************************************************/

-- A party of people who are interested in renting 
CREATE TABLE Party (
    partyId integer PRIMARY KEY,
    partyHost integer NOT NULL REFERENCES Renter(guestId)
);

-- The guests of the Party who are not renters
-- REMARK the party renter is considered a party member
CREATE TABLE PartyMembers (
    partyId integer NOT NULL REFERENCEs Party,
    guestId integer NOT NULL REFERENCES Guest
);

-- A rental agreement for 1 or multiple weeks
CREATE TABLE Rental (
    listingId   integer PRIMARY KEY NOT NULL ,
    propertyId  integer NOT NULL REFERENCES Property(propertyId),    
    partyId     integer NOT NULL REFERENCES Party,
    startDate   Date NOT NULL,
    numWeeks    integer NOT NULL,
    price       integer NOT NULL
);

/* *******************************************************************************
   ********************************* RATINGS *************************************
   *******************************************************************************/

-- The rating of a property by a guest
CREATE TABLE propertyRating (
    propertyRatingId    integer NOT NULL PRIMARY KEY,
    propertyId          integer NOT NULL REFERENCES Property,
    guestId             integer NOT NULL REFERENCES Guest(guestId),
    rating              integer NOT NULL, CHECK(rating >=0 and rating <= 5)
);

CREATE TABLE Comments(
    propertyRatingId    integer REFERENCES propertyRating PRIMARY KEY,
    comment              text NOT NULL
);

-- The rating of a host by a guest
CREATE TABLE hostRating (
    hostId      integer NOT NULL REFERENCES Host,
    partyId     integer NOT NULL REFERENCES Party,
    renterId    integer NOT NULL REFERENCES Renter,
    rating      integer NOT NULL, CHECK(rating >=0 and rating <= 5)
);
