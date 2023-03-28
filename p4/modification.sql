-- Insert a 12:30 AM time for bus 1, stop 2

INSERT INTO bus_schedule VALUES (1, 2, 0, 30);

-- Insert a new line in the trains table

INSERT INTO trains VALUES (10, "Green - Northbound");

-- Insert a new bus stop into the bus_to_bus table

INSERT INTO bus_to_bus
    SELECT DISTINCT stop1_id, 9 AS stop2_id, 30 AS walking_dist
        FROM bus_to_bus;

-- Insert a new Jewel Osco in the locations table

INSERT INTO locations
    SELECT MAX(loc_id) + 1 as loc_id, "Jewel Osco 2" as location
        FROM locations;

-- Delete all Blue lines from the train_schedule table

DELETE FROM train_schedule
    WHERE
        train_id = 1
        OR train_id = 2;

-- Delete the indian restaurant from the locations table

DELETE FROM locations
    WHERE location LIKE "Indian Restaurant";
        
-- Change the location of a bus stop in the bus_stops table

UPDATE bus_stops
    SET name = "19th/D"
    WHERE stop_id = 5;

-- Change the time that train 3 arrives at station 5 from 10:05 to 10:07

UPDATE train_schedule
    SET minutes = 7
    WHERE
        train_id = 3 AND
        station_id = 5 AND
        hours = 10;