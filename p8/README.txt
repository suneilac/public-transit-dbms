
Train Schedule Database Project:


### PROJECT FILES ### 
The p8 project directory consists of SQL scripts (.sql), input data (.db), 
Python scripts (.py), and Bottle HTML templates (.tpl). Please use the files in the
p8 directory to set up the database and not the ones originally submitted in the
p3 directory. 

p8
├── README.txt
├── create_db.sql
├── drop_tables.sql
├── final.py
├── populate_db.sql
└── views
    ├── add_schedule.tpl
    ├── main.tpl
    ├── schedule_info.tpl
    ├── station_info.tpl
    ├── train_schedule.tpl
    └── update_station_info.tpl


### SET UP DATABASE ###

In the p8 directory, run the following commands:

$ sqlite3 transit.db
sqlite> .read drop_tables.sql
sqlite> .read create_db.sql
sqlite> .read triggers.sql
sqlite> .read populate_db.sql

This will drop preexisting tables, recreate the schema, and populate the database


### SET UP WEB APPLICATION ### 
To set up the web application, run the following command in terminal:

$ python3 final.py

Go to the following link to access the web application:
http://localhost:8080/


### FEATURES ###

Home page:
http://localhost:8080/

Main page - Search Train Schedule:
http://localhost:8080/train-schedule

Return to home -> http://localhost:8080/

Add Schedule: http://localhost:8080/train-schedule/add-schedule
Select a train, station, and input a time (in the format HH:MM) to add this schedule to the database

Search:
Train(*): Wild card attribute, case insensitive
Matches phrases to the names of train lines - for example "orth" -> "Northbound"

Station(*): Wild card attribute, case insensitive
Matches phrases to the names of train stations - for example "d" -> "18th/D"

Time: String in the format HH:MM, default 08:00
Gives the first 20 results >= the time inputted

View/Edit: http://localhost:8080/train-schedule/<schedule_id>
Edit the current row by selecting from the list of trains, stations, and inputting a time (HH:MM)

Delete: deletes the row from the database

View Station Info: http://localhost:8080/station-info/<station_id>
Displays the following information on the station in the given row of the train schedule:

Station name
Nearest bus stop
Walking distance to the bus stop
current trains running at the station

Update Station Info: http://localhost:8080/update-station-info/<station_id>
Edit the walking distance between any station and any bus stop
This updates the information given in the "View Station Info" part of the table

