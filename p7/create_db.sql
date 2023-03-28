
CREATE TABLE IF NOT EXISTS bus_sched_log (
    action VARCHAR(100),
    bus_id INTEGER NOT NULL,.q
    stop_id INTEGER NOT NULL,
    hours INTEGER NOT NULL,
    minutes INTEGER NOT NULL,
    FOREIGN KEY (bus_id) REFERENCES buses(bus_id),
    FOREIGN KEY (stop_id) REFERENCES bus_stops(stop_id)
);

CREATE TABLE IF NOT EXISTS locations (
    loc_id INTEGER NOT NULL,
    location VARCHAR(100),
    PRIMARY KEY (loc_id)
);

CREATE TABLE IF NOT EXISTS loc_to_bus (
    loc_id INTEGER NOT NULL,
    stop_id INTEGER NOT NULL,
    walking_dist NUMERIC(7,3),
    FOREIGN KEY (loc_id) REFERENCES locations(loc_id),
    FOREIGN KEY (stop_id) REFERENCES bus_stops(stop_id),
    PRIMARY KEY (loc_id, stop_id)
);

CREATE TABLE IF NOT EXISTS loc_to_train (
    loc_id INTEGER NOT NULL,
    station_id INTEGER NOT NULL,
    walking_dist NUMERIC(7,3),
    FOREIGN KEY (loc_id) REFERENCES locations(loc_id),
    FOREIGN KEY (station_id) REFERENCES stations(station_id),
    PRIMARY KEY (loc_id, station_id)
);

CREATE TABLE IF NOT EXISTS loc_to_loc (
    loc1_id INTEGER NOT NULL,
    loc2_id INTEGER NOT NULL,
    walking_dist NUMERIC(7,3),
    FOREIGN KEY (loc1_id) REFERENCES locations(loc_id),
    FOREIGN KEY (loc2_id) REFERENCES locations(loc_id),
    PRIMARY KEY (loc1_id, loc2_id)
);

CREATE TABLE IF NOT EXISTS stations(
    station_id INTEGER NOT NULL,
    name VARCHAR(100),
    PRIMARY KEY (station_id)
);

CREATE TABLE IF NOT EXISTS train_schedule(
    train_id INTEGER NOT NULL,
    station_id INTEGER NOT NULL,
    hours INTEGER NOT NULL,
    minutes INTEGER NOT NULL,
    FOREIGN KEY (train_id) REFERENCES trains(train_id),
    FOREIGN KEY (station_id) REFERENCES stations(station_id)
);

CREATE TABLE IF NOT EXISTS trains(
    train_id INTEGER NOT NULL,
    name VARCHAR(100),
    PRIMARY KEY (train_id)
);

CREATE TABLE IF NOT EXISTS bus_stops(
    stop_id INTEGER NOT NULL,
    name VARCHAR(100),
    PRIMARY KEY (stop_id)
);

CREATE TABLE IF NOT EXISTS bus_schedule(
    bus_id INTEGER NOT NULL,
    stop_id INTEGER NOT NULL,
    hours INTEGER NOT NULL,
    minutes INTEGER NOT NULL,
    FOREIGN KEY (bus_id) REFERENCES buses(bus_id),
    FOREIGN KEY (stop_id) REFERENCES bus_stops(stop_id)
);

CREATE TABLE IF NOT EXISTS buses(
    bus_id INTEGER NOT NULL,
    name VARCHAR(100),
    PRIMARY KEY (bus_id)
);

CREATE TABLE IF NOT EXISTS train_to_bus (
    station_id INTEGER NOT NULL,
    stop_id INTEGER NOT NULL,
    walking_dist NUMERIC(7,3),
    FOREIGN KEY (station_id) REFERENCES stations(station_id),
    FOREIGN KEY (stop_id) REFERENCES bus_stops(stop_id),
    PRIMARY KEY (station_id, stop_id)
);

CREATE TABLE IF NOT EXISTS train_to_train (
    station1_id INTEGER NOT NULL,
    station2_id INTEGER NOT NULL,
    walking_dist NUMERIC(7,3),
    FOREIGN KEY (station1_id) REFERENCES stations(station_id),
    FOREIGN KEY (station2_id) REFERENCES stations(station_id),
    PRIMARY KEY (station1_id, station2_id)
);

CREATE TABLE IF NOT EXISTS bus_to_bus (
    stop1_id INTEGER NOT NULL,
    stop2_id INTEGER NOT NULL,
    walking_dist NUMERIC(7,3),
    FOREIGN KEY (stop1_id) REFERENCES bus_stops(stop_id),
    FOREIGN KEY (stop2_id) REFERENCES bus_stops(stop_id),
    PRIMARY KEY (stop1_id, stop2_id)
);