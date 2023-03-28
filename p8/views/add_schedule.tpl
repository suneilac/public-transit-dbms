<html>
    <div>
    <a href="/">Home</a></br>
    Back to: <a href="/train-schedule">Search Train Schedule</a>
    <h2>Add Schedule</h2>
        <form action="/train-schedule/add-schedule" method="post">
        <li>Train:
            <select name="train">
                %for item in trains:
                    <option value="{{item[0]}}">{{item[1]}}</option>"
                %end
            </select>
        </li>
        <li>Station:
            <select name="station">
                %for item in stations:
                    <option value="{{item[0]}}">{{item[1]}}</option>"
                %end
            </select>
        </li>
        <li>Time: <input type="text" name="time" value=""></li>    
        <input type="submit" value="Add">
        </form>
        %for message in msg:
            <h4 style="color: red;">{{message}}</h4>
        %end
    </div>
</html>