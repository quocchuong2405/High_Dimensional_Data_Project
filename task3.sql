
-- approach 1
WITH target_point AS (
	SELECT timestamp, ST_SetSRID(ST_MakePoint(start_long, start_lat), 4326) as point
    FROM taxi_trips
    WHERE trip_id = '1380586075620000431' 
)
SELECT trip_id, ST_DistanceSphere((SELECT point FROM target_point), ST_SetSRID(ST_MakePoint(start_long, start_lat), 4326)) as DistanceFromTargetPoint, timestamp, geom 
FROM taxi_trips
WHERE ST_DWITHIN(
	(SELECT point FROM target_point),
	ST_SetSRID(ST_MakePoint(start_long, start_lat), 4326),
	0.00039
)
AND date_trunc('day', to_timestamp(timestamp)) = (
    SELECT date_trunc('day', to_timestamp(timestamp))
    FROM target_point
)
AND trip_id != '1380586075620000431';


-- approach 2
-- equivalent query but using distance in meter
WITH target_point AS (
    SELECT trip_id, timestamp, ST_SetSRID(ST_MakePoint(start_long, start_lat), 4326) as point
    FROM taxi_trips
    WHERE trip_id = '1380586075620000431'
)
SELECT trip_id, date_trunc('day', to_timestamp(timestamp)) as day_timestamp,
	ST_DistanceSphere((SELECT point FROM target_point), ST_SetSRID(ST_MakePoint(start_long, start_lat), 4326)) as DistanceFromTargetPoint, 
	ST_SetSRID(ST_MakePoint(start_long, start_lat), 4326) as point, timestamp, geom 
FROM taxi_trips
WHERE ST_DistanceSphere((SELECT point FROM target_point), ST_SetSRID(ST_MakePoint(start_long, start_lat), 4326)) <= 50 -- Distance in meters
AND date_trunc('day', to_timestamp(timestamp)) = (
    SELECT date_trunc('day', to_timestamp(timestamp))
    FROM target_point
)
AND trip_id != '1380586075620000431';
