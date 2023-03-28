
-- Checks tuples before being added to train_schedule and makes sure their hours column
-- is within range (between 0 and 24)

CREATE TRIGGER check_hours
    BEFORE INSERT
    ON train_schedule 
    WHEN NEW.hours < 0 OR NEW.hours >= 24
    BEGIN 
        SELECT RAISE (ABORT, "Hours out of range");
    END;


-- Creates a log of all tuple inserts to bus_schedule

CREATE TRIGGER bus_sched_insert
    AFTER INSERT
    ON bus_schedule 
    FOR EACH ROW
    BEGIN
        INSERT INTO bus_sched_log
        VALUES ("insert", NEW.bus_id, NEW.stop_id, NEW.hours, NEW.minutes);
    END;


-- Prevents adding any more trains to the trains table

CREATE TRIGGER num_trains 
    BEFORE INSERT
    ON trains 
    WHEN (SELECT COUNT(*) FROM trains) = 8
    BEGIN 
        SELECT RAISE (ABORT, "Cannot add any more trains");
    END;