# Chicago Taxi Demand Analysis (BigQuery)

Hourly demand and trip-length analysis across 211,942,746 taxi trips, written to
test whether a fare pattern had the cause it appeared to have.

## Source
`bigquery-public-data.chicago_taxi_trips.taxi_trips`, a Google BigQuery public
dataset mirroring the City of Chicago's open taxi trip records. Queried in place;
no data was downloaded or stored locally. Analysis restricted to 2023 onwards,
with zero-fare and zero-distance trips excluded.

## Question
Average fare peaks at 04:00 and 05:00 ($31.53 and $31.79) while trip volume sits
at its floor, and bottoms out at 08:00 ($20.08) near peak volume. Why?

## Method
1. `01_volume_by_hour.sql` — trips, average fare and average distance by hour.
2. `02_airport_hypothesis.sql` — share of trips touching O'Hare (community area 76).
3. `03_airport_vs_other.sql` — trip length split into airport and non-airport,
   adding Midway (community area 56).

## Finding
Fare tracks distance rather than time of day, so the question is really about trip
length. Two separate effects drive it:

- **The airport mix shifts across the day.** O'Hare's share of trips swings from
  17.5% at 08:00 to 43.4% at 05:00, with a second peak of 39.4% at 20:00 — early
  departures and evening arrivals.
- **Non-airport trips independently get longer overnight.** Excluding both airports,
  average distance runs 3.61 miles at 18:00 against 7.32 at 04:00. Short city hops
  stop existing overnight.

The airport explanation alone is incomplete: 04:00 has the second-longest trips of
any hour but only 30.4% O'Hare share, below midnight's 39.6%.

A consistency check supports the split. Airport trip length is near-constant at 12
to 15 miles, since the airports do not move, but dips to 11.84 miles at 02:00 —
exactly when Midway's share peaks at 10.0% against 3.9% at 17:00. Midway sits
closer to the city, so a heavier Midway mix shortens the average.

## Cost
BigQuery bills on bytes read from referenced columns, not rows returned, so filters
do not reduce cost unless the table is partitioned. Query 1 processes 4.74 GB.
All three run inside the 1 TB monthly free allowance.
