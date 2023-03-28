import sqlite3
from bottle import route, run, debug, template, request, post  # type: ignore
import re
import webbrowser

# Establish connection with the SQLite database
conn = sqlite3.connect("./transit.db")
c = conn.cursor()


def validate_time(time):
    msg = []
    if time == "":
        msg.append("Time cannot be empty")
    elif re.match(r"^\d{2}:\d{2}$", time):
        time = time.split(":")
        hours = int(time[0])
        minutes = int(time[1])
        if hours >= 24:
            msg.append("Hours must be between 0 and 23")
        if minutes >= 60:
            msg.append("Minutes must be between 0 and 59")
    else:
        msg.append("Time must be in the format HH:MM")
    return msg


def parse_time(time):
    time = time.split(":")
    return int(time[0]), int(time[1])


def validate_walking_dist(walking_dist):
    msg = []
    if walking_dist == "":
        msg.append("Walking distance cannot be empty")
    elif not walking_dist.isnumeric():
        msg.append("Walking distance must be an integer >= 0")
    return msg


@route("/")
def main():
    return template("main")


@route("/train-schedule", method=["GET", "POST"])
def train_schedule():
    msg = []

    if request.method == "POST":

        if "schedule_id" in request.forms:
            schedule_id = request.forms.get("schedule_id") if request.forms.get("schedule_id") else None
            query = f"DELETE FROM train_schedule WHERE schedule_id={schedule_id};"
            c.execute(query)

    train_inp = request.params.get("train") if request.params.get("train") else ""
    station_inp = request.params.get("station") if request.params.get("station") else ""
    time = request.params.get("time") if request.params.get("time") else "08:00"
    msg.extend(validate_time(time))
    if len(msg) == 0:
        train = str.lower(train_inp)
        station = str.lower(station_inp)
        hours, minutes = parse_time(time)

        query = f"""SELECT ts.schedule_id, ts.train_id, ts.station_id,
                    t.name as train, s.name as station,
                    SUBSTR("00" || CAST(hours AS TEXT), -2, 2) || ":" ||
                    SUBSTR("00" || CAST(minutes AS TEXT), -2, 2) AS time                
                    FROM train_schedule AS ts JOIN trains AS t ON ts.train_id = t.train_id 
                    JOIN stations AS s ON ts.station_id = s.station_id
                    WHERE LOWER(train) LIKE "%{train}%" AND
                    LOWER(station) LIKE "%{station}%" AND
                    ((hours = {hours} AND minutes >= {minutes}) OR
                    (hours > {hours}))
                    ORDER BY hours, minutes
                    LIMIT 20;"""

        try:
            c.execute(query)
            result = c.fetchall()
            conn.commit()
            # Display message when search result is empty
            if len(result) == 0:
                msg.append("No search result exists for the following conditions:")
                msg.append(f"Train(*): {train_inp}")
                msg.append(f"Station(*): {station_inp}")
                msg.append(f"Time >= {time}")
        except sqlite3.OperationalError as err:
            msg.append(err)
            result = []
        except sqlite3.ProgrammingError as err:
            msg.append(err)
            result = []
    else:
        result = []

    # Generate HTML using a custom template
    return template("train_schedule", train=train_inp, station=station_inp, time=time, rows=result, msg=msg)


@route("/train-schedule/<sched_id>", method=["GET", "POST"])
def schedule_info(sched_id):
    msg = []

    # Handle post request (UPDATE)
    if request.method == "POST":
        train = request.forms.get("train") if request.forms.get("train") else ""
        station = request.forms.get("station") if request.forms.get("station") else ""
        time = request.forms.get("time") if request.forms.get("time") else ""

        msg.extend(validate_time(time))
        if len(msg) == 0:
            try:
                hours, minutes = parse_time(time)
                query = f"""UPDATE train_schedule
                            SET train_id = {train},
                            station_id = {station},
                            hours = {hours},
                            minutes = {minutes}
                            WHERE schedule_id = {sched_id};"""
                c.execute(query)
                conn.commit()
                msg.append("Successfully saved")
            except sqlite3.OperationalError as err:
                msg.append(err.args[0])

    # Query the most recently updated database (VIEW)
    query = f"""SELECT ts.schedule_id, ts.train_id, ts.station_id,
                    t.name as train, s.name as station,
                    SUBSTR("00" || CAST(hours AS TEXT), -2, 2) || ":" ||
                    SUBSTR("00" || CAST(minutes AS TEXT), -2, 2) AS time                
                    FROM train_schedule AS ts JOIN trains AS t ON ts.train_id = t.train_id 
                    JOIN stations AS s ON ts.station_id = s.station_id
                    WHERE ts.schedule_id = {sched_id};"""
    c.execute(query)

    # Prepare a dict of query results to be rendered by the template
    colnames = [desc[0] for desc in c.description]
    result = c.fetchone()
    result = dict(zip(colnames, result))

    query = "SELECT train_id, name FROM trains;"
    c.execute(query)
    trains = c.fetchall()

    query = "SELECT station_id, name FROM stations;"
    c.execute(query)
    stations = c.fetchall()

    conn.commit()

    # Generate HTML using a custom template
    return template("schedule_info", sched_info=result, trains=trains, stations=stations, msg=msg)


@route("/train-schedule/add-schedule", method=["GET", "POST"])
def add_schedule():
    msg = []

    # Handle post request (UPDATE)
    if request.method == "POST":
        train = request.forms.get("train") if request.forms.get("train") else ""
        station = request.forms.get("station") if request.forms.get("station") else ""
        time = request.forms.get("time") if request.forms.get("time") else ""

        msg.extend(validate_time(time))
        if len(msg) == 0:
            try:
                hours, minutes = parse_time(time)
                query = f"""INSERT INTO train_schedule VALUES
                            ((SELECT MAX(schedule_id) FROM train_schedule) + 1,
                            {train}, {station}, {hours}, {minutes});"""
                c.execute(query)
                conn.commit()
                msg.append("Successfully added")
            except sqlite3.OperationalError as err:
                msg.append(err.args[0])

    query = "SELECT train_id, name FROM trains;"
    c.execute(query)
    trains = c.fetchall()

    query = "SELECT station_id, name FROM stations;"
    c.execute(query)
    stations = c.fetchall()

    conn.commit()

    # Generate HTML using a custom template
    return template("add_schedule", trains=trains, stations=stations, msg=msg)


@route("/train-schedule/station-info/<station_id>")
def station_info(station_id):
    # Query the most recently updated database (VIEW)
    query = f"""SELECT s.station_id, s.name AS station, bs.name AS bus_stop, MIN(tb.walking_dist) AS min_dist
                FROM stations AS s JOIN train_to_bus AS tb ON s.station_id = tb.station_id 
                JOIN bus_stops AS bs ON tb.stop_id = bs.stop_id
                WHERE s.station_id = {station_id}
                GROUP BY s.station_id;"""

    c.execute(query)
    colnames = [desc[0] for desc in c.description]
    result = c.fetchone()
    result = dict(zip(colnames, result))
    conn.commit()

    query = f"""SELECT DISTINCT ts.station_id, ts.train_id, t.name AS train
                FROM train_schedule AS ts JOIN trains AS t ON ts.train_id = t.train_id
                WHERE ts.station_id = {station_id};"""
    c.execute(query)
    trains = c.fetchall()

    # Generate HTML using a custom template
    return template("station_info", station_info=result, trains=trains)


@route("/train-schedule/update-station-info/<station_id>", method=["GET", "POST"])
def update_station_info(station_id):
    msg = []

    # Handle POST request (INSERT)
    if request.method == "POST":
        station = request.forms.get("station") if request.forms.get("station") else ""
        bus_stop = request.forms.get("bus_stop") if request.forms.get("bus_stop") else ""
        walking_dist = request.forms.get("walking_dist") if request.forms.get("walking_dist") else ""

        msg.extend(validate_walking_dist(walking_dist))

        if len(msg) == 0:
            try:
                query = f"""UPDATE train_to_bus
                            SET walking_dist = {walking_dist}
                            WHERE station_id = {station} AND stop_id = {bus_stop}
                """
                c.execute(query)
                conn.commit()
                msg.append("Successfully changed the walking distance")
            except sqlite3.OperationalError as err:
                msg.append(err.args[0])

    # Handle GET request (VIEW)
    query = f"""SELECT s.station_id, s.name AS station, bs.name AS bus_stop, MIN(tb.walking_dist) AS min_dist
                FROM stations AS s JOIN train_to_bus AS tb ON s.station_id = tb.station_id 
                JOIN bus_stops AS bs ON tb.stop_id = bs.stop_id
                WHERE s.station_id = {station_id}
                GROUP BY s.station_id;"""
    c.execute(query)
    colnames = [desc[0] for desc in c.description]
    result = c.fetchone()
    result = dict(zip(colnames, result))
    conn.commit()

    query = "SELECT station_id, name FROM stations;"
    c.execute(query)
    stations = c.fetchall()

    query = "SELECT stop_id, name FROM bus_stops;"
    c.execute(query)
    bus_stops = c.fetchall()

    # Generate HTML using a custom template
    return template("update_station_info", station_info=result, stations=stations, bus_stops=bus_stops, msg=msg)

if __name__ == "__main__":
    debug(True)
    run(host="localhost", port=8080, reloader=True)
