<html>
    <div>
    <a href="/">Home</a></br>
    Back to: <a href="/train-schedule">Search Train Schedule</a>
    <h2>Schedule Info</h2>
        <form action="/train-schedule/{{sched_info["schedule_id"]}}" method="post">
        <li>Train:
            <select name="train">
                <option value="{{sched_info["train_id"]}}" SELECTED>{{sched_info["train"]}}</option>"
                %for item in trains:
                    <option value="{{item[0]}}">{{item[1]}}</option>"
                %end
            </select>
        </li>
        <li>Station:
            <select name="station">
                <option value="{{sched_info["station_id"]}}" SELECTED>{{sched_info["station"]}}</option>"
                %for item in stations:
                    <option value="{{item[0]}}">{{item[1]}}</option>"
                %end
            </select>
        </li>
        <li>Time: <input type="text" name="time" value="{{sched_info["time"]}}"></li>    
        <input type="submit" value="Save Changes">
        </form>
        %for message in msg:
            <h4 style="color: red;">{{message}}</h4>
        %end
    </div>
</html>