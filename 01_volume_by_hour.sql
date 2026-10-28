SELECT
  EXTRACT(HOUR FROM trip_start_timestamp) AS hour_of_day,
  COUNT(*) AS trips,
  ROUND(AVG(fare), 2) AS avg_fare,
  ROUND(AVG(trip_miles), 2) AS avg_miles
FROM `bigquery-public-data.chicago_taxi_trips.taxi_trips`
WHERE trip_start_timestamp >= '2023-01-01'
  AND fare > 0
  AND trip_miles > 0
GROUP BY hour_of_day
ORDER BY hour_of_day;
