from sqlalchemy import create_engine
import pandas as pd

# Read data from CSV into a Pandas DataFrame
csv_file = 'taxi_preprocessed2.csv'
df = pd.read_csv(csv_file, nrows= 100)

# Connect to database
engine = create_engine('postgresql://postgres:123456@localhost:5432/taxi_trajectory')

#['trip_id', 'call_type', 'origin_call', 'origin_stand', 'taxi_id',
#       'timestamp', 'day_type', 'missing_data', 'polyline', 'distance', 'year',
#       'month', 'day', 'hour', 'week_day', 'start_lat', 'start_long',
#       'end_lat', 'end_long', 'geom', 'total_time', 'isnotvalid']

# Create PostGIS table
create_table_query = '''
CREATE TABLE IF NOT EXISTS taxi_trips (
    trip_id BIGINT PRIMARY KEY,
    call_type VARCHAR(1),
    origin_call BIGINT,
    origin_stand BIGINT,
    taxi_id BIGINT,
    timestamp BIGINT,
    day_type VARCHAR(1),
    missing_data BOOLEAN,
    polyline TEXT,
    distance FLOAT,
    year INTEGER,
    month INTEGER,
    day INTEGER,
    hour INTEGER,
    week_day INTEGER,
    start_lat FLOAT,
    start_long FLOAT,
    end_lat FLOAT,
    end_long FLOAT,
    geom GEOMETRY(LINESTRING, 4326),
    total_time BIGINT,  
    isnotvalid BOOLEAN
);
'''

#with engine.connect() as connection:
#    connection.execute(create_table_query)

# Insert data into table
table_name = 'taxi_trips'
df.to_sql(table_name, engine, if_exists='append', index=False, method='multi', chunksize=100)
