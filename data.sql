
INSERT INTO Guest VALUES
(1, 'Darth Vader', '1985-12-06',   'Death Star'), -- Only young guest too young to rent
(2, 'Leia, Princess',    '2001-10-05',   'Alderaan'),
(3, 'Romeo Montague',    '1988-05-11',   'Verona'),
(4, 'Juliet Capulet',     '1991-07-24',   'Verona'),
(5, 'Mercutio',   '1988-03-03',   'Verona'),
(6, 'Chewbacca',   '1998-09-15',   'Kashyyyk');

INSERT INTO Renter VALUES
(1, 3466704824219330),
(2, 6011253896008199),
(3, 5446447451075463),
(5, 4666153163329984),
(6, 6011624297465933);

INSERT INTO Host VALUES
(1, 'luke@gmail.com'),
(2, 'leia@gmail.com'),
(3, 'han@gmail.com');

INSERT INTO Property VALUES
(1, 'Tatooine', 1, 6, 3, 1),
(2, 'Alderaan', 2, 2, 1, 1),
(3, 'Corellia',  3, 3, 2, 1),
(4, 'Verona', 2, 2, 2, 1),
(5, 'Florence', 3, 4, 2, 2),
(6, 'Toronto', 1,2,1,1);

INSERT INTO Luxury VALUES
(1, 'hot tub'),
(1, 'daily cleaning'),
(2, 'hot tub'),
(2, 'sauna'),
(2, 'daily cleaning'),
(3, 'daily breakfast delivery'),
(3, 'concierge service'),
(4, 'laundry service'),
(5, 'hot tub'),
(6, 'hot tub'),
(6, 'sauna'),
(6, 'laundry service'),
(6, 'daily cleaning'),
(6, 'concierge service');

INSERT INTO CityProperty VALUES 
(3, 20, 'bus');

INSERT INTO WaterProperty VALUES
(2, FALSE, 'lake');

INSERT INTO Party VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 5),
(5, 6);

INSERT INTO PartyMembers VALUES
(1, 2),
(2, 3),
(2, 4),
(3, 4),
(4, 3),
(4, 1),
(5, 2);

INSERT INTO Rental VALUES
(1, 2, 1, '2019-01-05', 1, 580),
(2, 3, 2, '2019-01-12', 2, 750),
(3, 2, 3, '2019-01-12', 1, 600),
(4, 5, 4, '2019-01-05', 1, 1000),
(5, 5, 5, '2019-01-12', 1, 1220);

INSERT INTO PropertyRating VALUES 
(1, 2, 2, 5),
(2, 2, 1, 2),
(3, 3, 3, 5),
(4, 3, 4, 5),
(5, 3, 2, 1),
(6, 2, 4, 5),
(7, 5, 5, 1),
(8, 5, 3, 1),
(9, 5, 6, 3);

INSERT INTO HostRating VALUES
(2, 1, 1, 2),
(3, 2, 2, 5), 
(2, 3, 3, 3),
(3, 4, 5, 4),
(3, 5, 6, 4);

INSERT INTO Comments VALUES
(2, 'Looks like she hides rebel scum here.'),
(5, 'A bit scruffy, could do with more regular housekeeping'),
(9, 'Fantasic, arggg');
