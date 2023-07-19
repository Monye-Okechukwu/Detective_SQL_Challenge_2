-- To check the key pointers
SELECT *
FROM crime_scene_report
where type = "murder" AND
	  city = "SQL City" AND
	  date = "20180115"
;

-- For the first witness
SELECt *
FROM person
where address_street_name = "Northwestern Dr"
order BY address_number DESC
limit 1;

-- For the second witness
SELECT *
FROM person
where name LIKE "Annabel%"
AND  address_street_name = "Franklin Ave";

-- To check the witnesses transcript in the interview table
SELECT p.id,
	   p.name,
       i.transcript,
       f.date,
       f.event_name
FROM facebook_event_checkin as f
JOIN person AS p
ON f.person_id = p.id
JOIN interview as i
USING (person_id)
where p.id in (16371, 14887)
;

-- To find who fits the testament of the first witness
SELECT p.id,
	   p.name,
       d.plate_number,
       gm.membership_status as status
FROM person as p
join get_fit_now_member as gm 
ON p.id = gm.person_id 
JOIN drivers_license as d
on p.license_id = d.id
where d.plate_number LIKE "%H42W%"
AND status = "gold";

-- To confirm with the second witness testament
SELEct gc.membership_id as member_id,
	   gm.name,
       gc.check_in_date as date,
       gc.check_in_time as check_in_time,
       gc.check_out_time as check_out_time
FROM get_fit_now_member as gm
JOIN get_fit_now_check_in as gc
ON gm.id = gc.membership_id
where (gm.person_id = 67318 -- jeremy's personal id
OR gm.person_id = 16371 -- Annabel's personal id)
and gc.check_in_date = "20180109"
;

-- To confirm if he was at the Funky grooves tour event on the day of the murder
SELECT p.name, 
       p.id as personal_id,
       f.event_name,
       f.date
from person as p
join facebook_event_checkin as f
on p.id = f.person_id
where personal_id = 67318
AND date = "20180115"
and event_name = "The Funky Grooves Tour";

-- To check if he was interviewed and to get his transcript
SELECT *
from interview
WHERE person_id = 67318;

 -- To get the person that hired jaremy from his transcript
SELECT name, 
       p.id, 
       COUNT(*) AS times_event_attended
FROM person AS p
JOIN facebook_event_checkin AS f
ON p.id = f.person_id
JOIN drivers_license AS d
ON p.license_id = d.id
where d.gender = "female" AND -- transcript by gender
      d.hair_color = "red" AND -- transcript by hair colour
      f.event_name = "SQL Symphony Concert" AND -- transcript by event name
      car_model = "Model S" AND -- transcript by car model
      car_make = "Tesla" AND -- transcript by car make
      f.date like "201712%" and -- transcript by date she attended the event
      d.height BETWEEN 65 AND 67 -- transcript by height
;     

-- Personal details about the two culprits
SELECT p.name,
       address_number||" "|| address_street_name as address,
       gender,
       age,
       height,
       eye_color,
       hair_color,
       i.annual_income,
       ssn as Social_Security_Number,
       plate_number
from person as p
join drivers_license as d
on p.license_id = d.id
join income as i
USING(ssn)
where p.id in (67318,99716);
