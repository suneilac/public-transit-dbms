
-- FROM P4
-- Get the bus stop name and walking distance from 18th/H train station and whether or not
-- the station is too far (>= 20 min) or nearby (< 20 min)

SELECT bs.name as bus_stop, walking_dist,
    CASE
        WHEN walking_dist < 20 THEN "nearby"
        ELSE "too far"
    END AS description
    FROM
        bus_stops AS bs NATURAL JOIN train_to_bus AS ttb
        JOIN stations AS s
        ON ttb.station_id = s.station_id
    WHERE s.name LIKE "18th/H"
    ORDER BY walking_dist ASC;


-- FROM P4
-- Get the names of the stations that have more than 400 trains passing through it

SELECT s.name, COUNT(*) AS num_trains
    FROM
        stations AS s JOIN train_schedule AS ts 
        ON s.station_id = ts.station_id
    GROUP BY s.name
    HAVING num_trains > 400
    ORDER BY num_trains;


-- FROM P4
-- Get the top 3 bus stops with the greatest number of train stations within a 10 minute walk
-- using a temp table


CREATE TABLE #nearby_stops
(
    station_id INTEGER NOT NULL,
    stop_id INTEGER NOT NULL,
    walking_dist NUMERIC(7,3),
);

INSERT INTO #nearby_stops
    SELECT * FROM train_to_bus
    WHERE walking_dist <= 10;

SELECT bus_stop
    FROM (
        SELECT bs.name as bus_stop, COUNT(*) AS num_stations
            FROM
                bus_stops AS bs JOIN #nearby_stops AS nb
                ON bs.stop_id = nb.stop_id
            GROUP BY bus_stop
            ORDER BY num_stations DESC
    )
    LIMIT 3;

DROP TABLE #nearby_stops;


-- Get the closest train station from work

SELECT s.name as closest_station, lt.walking_dist
    FROM
        locations AS l JOIN loc_to_train AS lt
        USING (loc_id)
        JOIN stations AS s
        USING (station_id)
    WHERE l.location LIKE "Work"
    ORDER BY walking_dist ASC
    LIMIT 1;  


-- Get the bus stop name with the greatest average walking distance to any location 

SELECT bus_stop
    FROM (
        SELECT bs.name AS bus_stop, AVG(lb.walking_dist) AS avg_walk
        FROM
            bus_stops AS bs JOIN loc_to_bus AS lb 
            ON bs.stop_id = lb.stop_id
        GROUP BY bus_stop
        ORDER BY avg_walk DESC
    )
    LIMIT 1;


-- Get the location with the greatest number of bus stops within a 10 minute walk

SELECT loc
    FROM (
        SELECT l.location as loc, COUNT(*) AS num_stops
            FROM
                locations AS l JOIN loc_to_bus AS lb
                ON l.loc_id = lb.loc_id
            WHERE walking_dist <= 10
            GROUP BY loc
            ORDER BY num_stops DESC
    )
    LIMIT 1;