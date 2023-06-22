-- replace start/end timestamp and bounding box (xmin, ymin, xmax, ymax) you want -- 
WITH points AS (
    SELECT trip_id, (timestamp + generate_series(0, ST_NPoints(geom)-1)*15) AS ts, (ST_DumpPoints(geom)).geom AS point
    FROM taxi_trips
)
SELECT trip_id, ts, ST_X(point) AS lon, ST_Y(point) AS lat, point
FROM points
WHERE ts BETWEEN 1380585600 AND 1380589200
AND ST_Within(point, ST_MakeEnvelope(-8.6424799, 41.1607172, -8.627035, 41.1636687, 4326))

-- get distinct value -- 
WITH points AS (
    SELECT trip_id, (timestamp + generate_series(0, ST_NPoints(geom)-1)*15) AS ts, (ST_DumpPoints(geom)).geom AS point
    FROM taxi_trips
)
SELECT DISTINCT trip_id
FROM points
WHERE ts BETWEEN 1380585600 AND 1380589200
AND ST_Within(point, ST_MakeEnvelope(-8.6424799, 41.1607172, -8.627035, 41.1636687, 4326))

-- reduce execution time by using created points table but the space cost is much much larger
SELECT DISTINCT trip_id
FROM points
WHERE ts BETWEEN 1380585600 AND 1380589200
AND ST_Within(ST_SetSRID(ST_MakePoint(lon, lat), 4326), ST_MakeEnvelope(-8.6424799, 41.1607172, -8.627035, 41.1636687, 4326))



	
	