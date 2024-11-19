-- SELECT * FROM trips;
SELECT * FROM trips_details4;

/*
-- To find total trips
SELECT COUNT(DISTINCT tripid) FROM trips_details4;

-- To find if there are any duplicate trip ids
SELECT tripid, COUNT(tripid) AS any_duplicates FROM trips_details4
GROUP BY tripid
HAVING COUNT(tripid) > 1;

-- Total number of distinct drivers
SELECT COUNT(DISTINCT driverid) AS total_distinct_drivers FROM trips;

-- Total earnings
SELECT SUM(fare) AS total_fare FROM trips;

-- Total number of searches that took place
SELECT SUM(searches) AS total_searches FROM trips_details4;

-- Total number of searches that got an estimated fare
SELECT SUM(searches_got_estimate) AS total_searches_estimation FROM trips_details4;

-- Total number of searches for quotations
SELECT SUM(searches_for_quotes) AS total_searches_for_quotes FROM trips_details4;

-- Total number of searches that got quotations
SELECT SUM(searches_got_quotes) AS total_searches_got_quotes FROM trips_details4;

-- Total number of trips cancelled by drivers
SELECT COUNT(tripid) AS total_trips FROM trips_details4;  

SELECT SUM(driver_not_cancelled) AS driver_not_cancelled_trips FROM trips_details4;  

SELECT 
    COUNT(tripid) AS total_trips, -- Total count of trips
    SUM(driver_not_cancelled) AS driver_not_cancelled_trips, -- Driver not cancelled trips
    COUNT(tripid) - SUM(driver_not_cancelled) AS driver_cancelled_trips  -- Driver cancelled trips
FROM trips_details4;

-- Total OTP entered rides
SELECT SUM(otp_entered) FROM trips_details4;

-- Total rides that ended
SELECT SUM(end_ride) FROM trips_details4;

-- Average distance to be travelled by trips
SELECT AVG(distance) AS avg_distance FROM trips;

-- Average of fares from the trips
SELECT AVG(fare) AS avg_fare FROM trips;

-- Total distance travelled from all the rides
SELECT SUM(distance) AS total_distance FROM trips;

-- LEVEL TWO PROBLEM SET -- 

-- The most used payment method
SELECT fm.method FROM payment AS fm
INNER JOIN 
    (SELECT TOP 4 faremethod, COUNT(DISTINCT tripid) AS count FROM trips
     GROUP BY faremethod
     ORDER BY COUNT(DISTINCT tripid) DESC) AS t
ON fm.id = t.faremethod;

-- The highest payment made through which medium
SELECT method FROM payment AS p
INNER JOIN
    (SELECT TOP 1 * FROM trips
     ORDER BY fare DESC) AS t
ON p.id = t.faremethod;

-- Other way to do the same query
SELECT p.method FROM payment AS p
INNER JOIN
    (SELECT TOP 1 faremethod, SUM(fare) AS total_fares FROM trips
     GROUP BY faremethod
     ORDER BY SUM(fare) DESC) AS t
ON p.id = t.faremethod;

-- Finding the two locations that had most of the trips
SELECT * 
FROM
    (SELECT *, DENSE_RANK() OVER (ORDER BY count_of_trips DESC) AS rnk
     FROM
         (SELECT loc_from, loc_to, COUNT(DISTINCT tripid) AS count_of_trips FROM trips
          GROUP BY loc_from, loc_to) AS t) AS h
WHERE rnk = 1;

-- Top five earning drivers
SELECT *
FROM
    (SELECT *, DENSE_RANK() OVER (ORDER BY earnings DESC) AS rnk
     FROM
         (SELECT driverid, SUM(fare) AS earnings FROM trips
          GROUP BY driverid) AS t) AS r
WHERE rnk < 6;

-- Top trips duration wise
SELECT * 
FROM
    (SELECT *, RANK() OVER (ORDER BY total_duration DESC) AS rnk 
     FROM
         (SELECT duration, COUNT(DISTINCT tripid) AS total_duration FROM trips
          GROUP BY duration) AS t) AS r
WHERE rnk = 1;

-- Driver and Customer pairs having more number of ride requests
SELECT * 
FROM
    (SELECT *, RANK() OVER (ORDER BY total_trips DESC) AS rnk 
     FROM
         (SELECT driverid, custid, COUNT(DISTINCT tripid) AS total_trips FROM trips
          GROUP BY driverid, custid) AS t) AS r
WHERE rnk = 1;

-- Total Searches to estimate_rates calculation
SELECT SUM(searches_got_estimate) * 100.0 / SUM(searches) AS est_rates FROM trips_details4;

-- Total Searches to got_quote_rates calculation
SELECT SUM(searches_for_quotes) * 100.0 / SUM(searches) AS got_quotes FROM trips_details4;

-- Total Searches to quote_acceptance_rates calculation
SELECT SUM(searches_got_quotes) * 100.0 / SUM(searches) AS quote_accept FROM trips_details4;

-- Total Searches to booking_acceptance_rates calculation
SELECT SUM(customer_not_cancelled) * 100.0 / SUM(searches) AS booking_accept FROM trips_details4;

-- Total Searches to booking_cancellation_rates calculation
SELECT (SUM(searches) - SUM(driver_not_cancelled)) * 100.0 / SUM(searches) AS booking_declined FROM trips_details4;

-- LEVEL 3 problem set

-- Areas that got highest trips in a particular duration
SELECT * 
FROM
    (SELECT *, RANK() OVER (PARTITION BY duration ORDER BY trips DESC) AS rnk 
     FROM 
         (SELECT duration, loc_from, COUNT(DISTINCT tripid) AS trips FROM trips
          GROUP BY duration, loc_from) AS t) AS r
WHERE rnk = 1;

-- Areas that got highest trips from a particular location
SELECT * 
FROM
    (SELECT *, RANK() OVER (PARTITION BY loc_from ORDER BY trips DESC) AS rnk 
     FROM 
         (SELECT duration, loc_from, COUNT(DISTINCT tripid) AS trips FROM trips
          GROUP BY duration, loc_from) AS t) AS r
WHERE rnk = 1;

-- Areas that got the highest fares and cancellations of trips

-- Highest fare query
SELECT * 
FROM
    (SELECT *, RANK() OVER (ORDER BY highest_fare DESC) AS rnk 
     FROM 	
         (SELECT loc_from, SUM(fare) AS highest_fare FROM trips
          GROUP BY loc_from) AS t) AS r
WHERE rnk = 1;

-- Driver cancelled rides query
SELECT * 
FROM
    (SELECT *, RANK() OVER (ORDER BY driver_cancelled_trips DESC) AS rnk 
     FROM
         (SELECT loc_from, COUNT(searches) - SUM(driver_not_cancelled) AS driver_cancelled_trips FROM trips_details4
          GROUP BY loc_from) AS t) AS r
WHERE rnk = 1; 

-- Customer cancelled rides query
SELECT * 
FROM
    (SELECT *, RANK() OVER (ORDER BY customer_cancelled_trips DESC) AS rnk 
     FROM
         (SELECT loc_from, COUNT(searches) - SUM(customer_not_cancelled) AS customer_cancelled_trips FROM trips_details4
          GROUP BY loc_from) AS t) AS r
WHERE rnk = 1; 
*/

/* Durations that got the highest trips and fares */

-- Highest fare by durations
SELECT * 
FROM
    (SELECT *, RANK() OVER (ORDER BY highest_fare DESC) AS rnk 
     FROM 	
         (SELECT duration, SUM(fare) AS highest_fare FROM trips
          GROUP BY duration) AS t) AS r
WHERE rnk = 1; 

-- Highest trip counts by durations
SELECT * 
FROM
    (SELECT *, RANK() OVER (ORDER BY highest_trip_count DESC) AS rnk 
     FROM 	
         (SELECT duration, COUNT(DISTINCT tripid) AS highest_trip_count FROM trips
          GROUP BY duration) AS t) AS r
WHERE rnk = 1;

---- END ---------