SELECT
  EXTRACT(HOUR FROM trip_start_timestamp) AS hour_of_day,
  COUNT(*) AS trips,
  ROUND(100 * COUNTIF(pickup_community_area = 76 OR dropoff_community_area = 76) / COUNT(*), 1) AS pct_ohare,
  ROUND(100 * COUNTIF(pickup_community_area = 56 OR dropoff_community_area = 56) / COUNT(*), 1) AS pct_midway,
  ROUND(AVG(IF(pickup_community_area IN (76,56) OR dropoff_community_area IN (76,56), trip_miles, NULL)), 2) AS miles_airport,
  ROUND(AVG(IF(pickup_community_area IN (76,56) OR dropoff_community_area IN (76,56), NULL, trip_miles)), 2) AS miles_other
FROM `bigquery-public-data.chicago_taxi_trips.taxi_trips`
WHERE trip_start_timestamp >= '2023-01-01'
  AND fare > 0
  AND trip_miles > 0
GROUP BY hour_of_day
ORDER BY hour_of_day;
