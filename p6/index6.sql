

-- This index would speed up query #2 in query6.sql because it would sort the data by the hours column
-- in the train_schedule table, so it would be much faster to get the tuples with hours between 7-11

CREATE INDEX train_sched_idx
ON train_schedule (hours);

-- This index would speed up query #4 in query6.sql because it would sort the data by the walking_dist column
-- in the loc_to_train table, so it would be much faster to get the tuples where the walking distance is <= 5

CREATE INDEX loc_train_walkingdist_idx 
ON loc_to_train (walking_dist);