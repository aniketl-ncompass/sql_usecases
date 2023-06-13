show databases;
use aniketlodh;

select * from uc;

--  Q2 Find all the duplicate time entries for respective devices.				
SELECT TIME, DEVICE, COUNT(TIME) as REPEATED FROM uc GROUP BY TIME, DEVICE HAVING COUNT(time) > 1;

--  Q5 Find the peak consumption reached in a given time range for all the devices.						

select DEVICE, max(CONSUMPTION) AS PEAK , TIME from uc WHERE TIME  between "2020-01-01 09:54:00" AND "2020-01-01 15:29:00"  GROUP BY DEVICE;

-- Q4 Find the hour-wise cumulative consumption of each device.					

select DEVICE, HOUR(TIME), sum(CONSUMPTION) AS "TOTAL CONSUMPTION" FROM uc where DEVICE ="D3" GROUP BY HOUR(TIME),DEVICE;


-- Q3 Find all the duplicate time entries for respective devices.				

SELECT D1.DEVICE, T.TIME
FROM (SELECT DISTINCT DEVICE FROM uc) D1
CROSS JOIN (SELECT DISTINCT TIME FROM uc) T
LEFT JOIN uc D2 ON D1.DEVICE = D2.DEVICE AND T.TIME = D2.TIME
WHERE D2.DEVICE IS NULL;
