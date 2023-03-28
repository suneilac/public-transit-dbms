
-- Get the closest bus stop(s) to location l0 and its walking distance

SELECT bs.name as closest_bus_stop, lb.walking_dist
    FROM
        locations AS l JOIN loc_to_bus AS lb
        USING (loc_id)
        JOIN bus_stops AS bs
        USING (stop_id)
    WHERE
        l.location LIKE "l0"
        AND lb.walking_dist = (SELECT MIN(walking_dist) FROM loc_to_bus)
    ORDER BY walking_dist ASC;


-- Get the number of t2 line trains that pass through all stations s50-s59 between 7-11 AM (rush hour)

SELECT COUNT(*) AS num_trains
    FROM
        trains AS t INNER JOIN train_schedule AS ts
        ON t.train_id = ts.train_id
        INNER JOIN stations AS s
        ON ts.station_id = s.station_id        
    WHERE
        ts.hours >= 7 AND ts.hours <= 11
        AND t.name LIKE "t2"
        AND s.name LIKE "s5%";


-- Get the train schedule for s0 station between 3-5 PM

SELECT t.name, hours, minutes
    FROM
        train_schedule AS ts JOIN trains AS t
        ON ts.train_id = t.train_id
        JOIN stations AS s
        ON s.station_id = ts.station_id
    WHERE
        hours >= 15
        AND hours < 17
        AND s.name LIKE "s0"
    ORDER BY hours ASC, minutes ASC;


-- Get the 5 locations that have the greatest number of train stations within a 10 minute walking distance

SELECT l.location as name, COUNT(*) AS num_stations
    FROM
        locations AS l JOIN loc_to_train AS lt
        USING (loc_id)
        JOIN stations as s
        USING (station_id)  
    WHERE lt.walking_dist <= 10
    GROUP BY name
    ORDER BY num_stations DESC
    LIMIT 5;
