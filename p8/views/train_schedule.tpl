<html>
    <td>Return to: <a href="/">Home</a></td><br><br>
    <h2>Search Train Schedule</h2>
    <form action="/train-schedule/add-schedule" method="get">
        <button name="add_sched">Add Schedule</button>
    </form>
    <p><i>The search result only displays 20 schedule timings.</i></p>
    <p><i>The schedule timings are shown in order starting at 8 AM unless otherwise specified.</i></p>
    <form action="/train-schedule" method="get">

        <label for="name">Train(*): </label>
        <input type="text" name="train" value="{{train}}"><br><br>
        <label for="name">Station(*): </label>
        <input type="text" name="station" value="{{station}}"><br><br>
        <label for="time">Time >= </label>
        <input type="text" name="time" value={{time}}><br><br>
        
        <input type="submit" value="Search" name="VIEW"/>
    </form>
    
    % if msg != []:
        %for message in msg:
            <h4 style="color: red;">{{message}}</h4>
        %end
    % else :    
    <table border="1">
        <tr>
            <th>Train</th>
            <th>Station</th>
            <th>Time</th>
            <th>View / Edit</th>
            <th>Delete</th>
            <th>View Station Info</th>
            <th>Update Station Info</th>
        </tr>
    %for row in rows:
        <tr>
            <! --- train schedule --->
            %for col in row[3:]:
                <td style="text-align:center;">{{col}}</td>
            %end

            <! --- view/edit --->
            <td><a href="/train-schedule/{{row[0]}}">View / Edit</a></td>

            <! --- delete tuple --->
            <td style="text-align:center;">
            <form action="/train-schedule" method="post">
                <button name="schedule_id" value="{{row[0]}}">Delete</button>
            </form>
            </td>

            <! --- station_info --->
            <td><a href="/train-schedule/station-info/{{row[2]}}">View Station Info</a></td>

            <! --- update_station_info --->
            <td><a href="/train-schedule/update-station-info/{{row[2]}}">Update Station Info</a></td>
        </tr>
    %end
    </table>
</html>