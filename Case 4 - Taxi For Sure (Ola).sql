create database olcabs;

/*Q.1. Find hour of 'pickup' and 'confirmed_at' time, 
and make a column of weekday as "Sun,Mon, etc"next to pickup_datetime*/

select * from data;
select * from localities;
desc data;
set sql_safe_updates=0;
select hour(str_to_date(pickup_time,"%H:%i:%s")) as Pickup, dayname(str_to_date(pickup_date, "%d-%m-%Y"))as Date_time 
FROM data;


/*Q.2. Make a table with count of bookings with booking_type = p2p 
catgorized by booking mode as 'phone', 'online','app',etc*/

SELECT Booking_mode, Count(*) as Cnt
FROM data 
WHERE booking_type = "p2p"
Group by Booking_mode;

/* Q.3. Create columns for pickup and drop ZONES 
(using Localities data containing Zone IDs against each area) and 
fill corresponding values against pick-area and drop_area, using Sheet'Localities'*/

select * from localities;
select * from data;
select l.zone_id, d.pickuparea, d.droparea from data d inner join localities l on l.area=d.PickupArea;  

/* Q.4. Find top 5 drop zones in terms of  average revenue*/

SELECT Zone_id, avg(fare) as AverageFare
FROM Localities as L INNER JOIN Data as D 
ON L.Area = d.droparea
Group by Zone_id
Order By Avg(Fare) DESC
Limit 5;

/* Q.5. Find all unique driver numbers grouped by top 5 pickzones*/

select * from data;
SELECT  zone_id, Sum(fare) as SumRevenue
FROM Data as D, Localities as L
WHERE D.pickuparea = L.Area
Group By 1
Order By 2 DESC
Limit 5;

/* Q.6. Make a list of top 10 driver by driver numbers in terms of 
fare collected where service_status is done, done-issue*/

SELECT driver_number, sum(fare) as `Fare collected` 
FROM  data
WHERE Service_status in ("Done","Done_issue")
GROUP BY 1
order by 2 desc
limit 10;

/*Q.7. Make a hourwise table of bookings for week between Nov01-Nov-07 
and highlight the hours with more than average no.of bookings day wise*/

SELECT Hour(str_To_date(pickup_time,"%H:%i:%s")) as Hr, Count(*) as TotalBookings
FROM Data 
WHERE str_to_date(pickup_date,"%d-%m-%Y") between '2013-11-01' and '2013-11-07'
Group By Hour(str_to_date(pickup_time,"%H:%i:%s"))
Order by 1;

SELECT Avg(NoOfBookingsDaily)
FROM (
SELECT Day(str_to_date(pickup_date,"%d-%m-%Y")), count(*) as NoOfBookingsDaily
FROM data 
Group By Day(str_to_date(pickup_date,"%d-%m-%Y"))) as tt;

