-- Get the train schedule for all Blue line trains for 18th/L station
-- between 7 and 8 AM

SELECT t.name, s.name, hours, minutes
    FROM
        train_schedule AS ts JOIN trains AS t
        ON ts.train_id = t.train_id
        JOIN stations AS s
        ON s.station_id = ts.station_id
    WHERE
        hours >= 7
        AND hours < 8
        AND t.name LIKE "%Blue%"
        AND s.name LIKE "18th/L"
    ORDER BY hours ASC, minutes ASC;

-- Get the bus stop name and walking distance from 18th/H train station where the walking distance is
-- less than 20 minutes

SELECT bs.name as bus_stop, walking_dist
    FROM
        bus_stops AS bs JOIN train_to_bus AS ttb
        ON bs.stop_id = ttb.stop_id
        JOIN stations AS s
        ON ttb.station_id = s.station_id
    WHERE
        walking_dist < 20 
        AND s.name LIKE "18th/H"
    ORDER BY walking_dist ASC;

-- Get the closest bus stop to home and its walking distance

SELECT bs.name as closest_bus_stop, lb.walking_dist
    FROM
        locations AS l JOIN loc_to_bus AS lb
        ON l.loc_id = lb.loc_id
        JOIN bus_stops AS bs
        ON lb.stop_id = bs.stop_id
    WHERE l.location LIKE "Home"
    ORDER BY walking_dist ASC
    LIMIT 1;    

-- Get the station name with the lowest average walking distance to any location

SELECT station
    FROM (
        SELECT s.name AS station, AVG(lt.walking_dist) AS avg_walk
        FROM
            stations AS s JOIN loc_to_train AS lt 
            ON s.station_id = lt.station_id
        GROUP BY station
        ORDER BY avg_walk ASC
    )
    LIMIT 1;

-- Get the max walking distance between any two locations

SELECT
    start,
    (SELECT location
        FROM locations
        WHERE loc_id = dest) AS dest,
    walking_dist
    FROM (
        SELECT
            l.location as start,
            ll.loc2_id AS dest,
            MAX(ll.walking_dist) as walking_dist
            FROM 
                locations AS l JOIN loc_to_loc AS ll 
                ON l.loc_id = ll.loc1_id
    );
    