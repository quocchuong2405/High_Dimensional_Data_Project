SELECT trip_id, start_lat, start_long, ST_SetSRID(ST_MakePoint(start_long, start_lat), 4326), geom
FROM taxi_trips
WHERE timestamp BETWEEN 1380549600 AND 1380636000
ORDER BY ST_DistanceSphere(ST_SetSRID(ST_MakePoint(start_long, start_lat), 4326), ST_SetSRID(ST_MakePoint(-8.6424799, 41.1607172), 4326))
--ORDER BY ST_SetSRID(ST_MakePoint(start_long, start_lat), 4326) <-> ST_SetSRID(ST_MakePoint(-8.6424799, 41.1607172), 4326) -- Other function to calculate distance
LIMIT 10;

