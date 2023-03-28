-- Get the number of Purple line trains that pass through all the stations between 6-11 AM (rush hour)

SELECT COUNT(*) AS num_trains
    FROM
        train_schedule AS ts JOIN trains AS t
    WHERE
        hours >= 6 AND hours <= 11
        AND t.name LIKE "%Purple%";

-- Get the number of trains that pass through each station

SELECT s.name, COUNT(*) AS num_trains
    FROM
        stations AS s JOIN train_schedule AS ts 
        ON s.station_id = ts.station_id
    GROUP BY s.name 
    ORDER BY num_trains ASC;

-- Get the top 3 bus stops with the greatest number of train stations within a 10 minute walk

SELECT bus_stop
    FROM (
        SELECT bs.name as bus_stop, COUNT(*) AS num_stations
            FROM
                bus_stops AS bs JOIN train_to_bus AS tb
                ON bs.stop_id = tb.stop_id
            WHERE walking_dist <= 10
            GROUP BY bus_stop
            ORDER BY num_stations DESC
    )
    LIMIT 3;