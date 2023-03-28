
-- 18th/A train station schedule from 7 AM - 11 AM

CREATE VIEW rush_hour_18thA AS 
    SELECT t.name, s.name, hours, minutes
    FROM
        train_schedule AS ts JOIN trains AS t
        ON ts.train_id = t.train_id
        JOIN stations AS s
        ON s.station_id = ts.station_id
    WHERE
        hours >= 7
        AND hours < 11
        AND s.name LIKE "18th/A"
    ORDER BY hours ASC, minutes ASC;


-- 151 Westbound schedule and stops

CREATE VIEW west_151 AS 
    SELECT hours, minutes, bstop.name
    FROM 
        buses AS b JOIN bus_schedule AS bs
        ON b.bus_id = bs.bus_id 
        JOIN bus_stops as bstop ON bs.stop_id = bstop.stop_id
    WHERE 
        b.name LIKE "151 - Westbound";


-- loc_to_train table with location names instead of ids

CREATE VIEW loc_train AS 
    SELECT location, name, walking_dist 
    FROM 
        locations as l JOIN loc_to_train AS lt
        ON l.loc_id = lt.loc_id 
        JOIN stations AS s ON lt.station_id = s.station_id;