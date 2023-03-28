<html>
    <div>
    <a href="/">Home</a></br>
    Back to: <a href="/train-schedule">Search Train Schedule</a>
    <h2>Update Walking Distance</h2>
        <form action="/train-schedule/update-station-info/{{station_info["station_id"]}}" method="post">
        <li>Station:
            <select name="station">
                %for item in stations:
                    <option value="{{item[0]}}">{{item[1]}}</option>"
                %end
            </select>
        </li>
        <li>Bus Stops:
            <select name="bus_stop">
                %for item in bus_stops:
                    <option value="{{item[0]}}">{{item[1]}}</option>"
                %end
            </select>
        </li>
        <li>Walking Distance: <input type="text" name="walking_dist" value=""> min</li> 
        <br>
        <input type="submit" value="Confirm">
        </form>
        %for message in msg:
            <h4 style="color: red;">{{message}}</h4>
        %end
    </div>
</html>