-- Add a capacity column to the trains table to indicate how many passengers each train can hold

ALTER TABLE trains
ADD capacity INTEGER DEFAULT 1000;

-- Drop minutes from the train schedule

ALTER TABLE train_schedule
DROP COLUMN minutes;