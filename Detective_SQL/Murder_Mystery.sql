-- To check the key pointers
SELECT *
FROM crime_scene_report
WHERE type = "murder" AND
      city = "SQL City" AND
      date = "20180115"
;

-- For the first witness
SELECt *
FROM person
WHERE address_street_name = "Northwestern Dr"
ORDER BY address_number DESC
LIMIT 1;

-- For the second witness
SELECT *
FROM person
WHERE name LIKE "Annabel%"
AND  address_street_name = "Franklin Ave";

-- To check the witnesses transcript in the interview table
SELECT p.id,
       p.name,
       i.transcript,
       f.date,
       f.event_name
FROM facebook_event_checkin AS f
JOIN person AS p
ON f.person_id = p.id
JOIN interview AS i
USING (person_id)
WHERE p.id IN (16371, 14887)
;

-- To find who fits the testament of the first witness
SELECT p.id,
       p.name,
       d.plate_number,
       gm.membership_status AS status
FROM person AS p
join get_fit_now_member AS gm 
ON p.id = gm.person_id 
JOIN drivers_license AS d
ON p.license_id = d.id
WHERE d.plate_number LIKE "%H42W%"
AND status = "gold";

-- To confirm with the second witness testament
SELEct gc.membership_id AS member_id,
       gm.name,
       gc.check_in_date AS date,
       gc.check_in_time AS check_in_time,
       gc.check_out_time AS check_out_time
FROM get_fit_now_member AS gm
JOIN get_fit_now_check_in AS gc
ON gm.id = gc.membership_id
WHERE (gm.person_id = 67318 -- jeremy's personal id
OR gm.person_id = 16371 -- Annabel's personal id)
AND gc.check_in_date = "20180109"
;

-- To confirm if he was at the Funky grooves tour event on the day of the murder
SELECT p.name, 
       p.id AS personal_id,
       f.event_name,
       f.date
FROM person AS p
JOIN facebook_event_checkin AS f
ON p.id = f.person_id
WHERE personal_id = 67318
AND date = "20180115"
AND event_name = "The Funky Grooves Tour";

-- To check if he was interviewed and to get his transcript
SELECT *
FROM interview
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
WHERE d.gender = "female" AND -- transcript by gender
      d.hair_color = "red" AND -- transcript by hair colour
      f.event_name = "SQL Symphony Concert" AND -- transcript by event name
      car_model = "Model S" AND -- transcript by car model
      car_make = "Tesla" AND -- transcript by car make
      f.date like "201712%" and -- transcript by date she attended the event
      d.height BETWEEN 65 AND 67 -- transcript by height
;     

-- Personal details about the two culprits
SELECT p.name,
       address_number||" "|| address_street_name AS address,
       gender,
       age,
       height,
       eye_color,
       hair_color,
       i.annual_income,
       ssn AS Social_Security_Number,
       plate_number
FROM person AS p
JOIN drivers_license AS d
ON p.license_id = d.id
JOIN income AS i
USING(ssn)
WHERE p.id IN (67318,99716);
