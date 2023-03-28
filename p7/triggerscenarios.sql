
-- Trigger 1: check_hours

-- Trigger prevents this tuple from being added into train_schedule because
-- the hours column is greater than 24
INSERT INTO train_schedule VALUES (1, 2, 100, 4);

-- Trigger allows this tuple to be added to train_schedul because the hours
-- column is within range
INSERT INTO train_schedule VALUES (1, 2, 3, 4);


-- Trigger 2: bus_sched_insert

-- Trigger adds this data to the bus_sched_log table
INSERT INTO bus_schedule VALUES (1, 2, 3, 4);

-- Trigger does not add this update to the bus_sched_log table because the trigger is only
-- effected on INSERT, not UPDATE
UPDATE bus_schedule 
SET minutes = 4
WHERE bus_id = 1 AND stop_id = 2 AND hours = 3 AND minutes = 4;


-- Trigger 3: num_trains

-- Trigger prevents this tuple from being added into the trains table
INSERT INTO trains VALUES (9, "A");

-- Trigger not effected because the trigger is only effected on INSERT, not UPDATE
UPDATE trains 
SET name = "A"
WHERE train_id = 4;