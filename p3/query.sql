
-- Get the train schedule for Purple - Eastbound (train_id = 5) for 2nd/I station (station_id = 2)
-- between 7 and 8 AM

SELECT *
    FROM train_schedule
    WHERE
        hours >= 7
        AND hours < 8
        AND train_id = 5
        AND station_id = 2;

-- Get the bus stop_id and walking distance from 18th/H train station where the walking distance is
-- less than 20 minutes

SELECT stop_id, walking_dist
    FROM train_to_bus
    WHERE walking_dist < 20 and station_id = 7;

-- Get the number of trains that pass through all the stations between 6-11 AM (rush hour)

SELECT COUNT(*) as num_trains
    FROM train_schedule
    WHERE hours >= 6 AND hours <= 11;