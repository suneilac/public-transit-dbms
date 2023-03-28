<html>
    <div>
    <a href="/">Home</a></br>
    Back to: <a href="/train-schedule">Search Train Schedule</a>
    <h2>Station Info</h2>
        <form action="/train-schedule/station-info/{{station_info["station_id"]}}">
        <li>Station Name: {{station_info["station"]}}</li>
        <li>Nearest Bus Stop: {{station_info["bus_stop"]}}</li>
        <li>Walking distance: {{station_info["min_dist"]}} min</li>
        <li>Current trains running:</li>
        %for item in trains:
            <p>{{item[2]}}</p>
        %end
    </div>
</html>