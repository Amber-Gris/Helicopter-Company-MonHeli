--****PLEASE ENTER YOUR DETAILS BELOW****
--mh-queries.sql

--Student ID: 31336825
--Student Name: Xin Li
--Tutorial No: 22

/* Comments for your marker:




*/


/*
    Q1
*/
-- PLEASE PLACE REQUIRED SQL STATEMENT FOR THIS PART HERE
-- ENSURE your query has a semicolon (;) at the end of this answer
Select ht_nbr,em.emp_nbr,emp_lname,emp_fname, 
to_char(end_last_annual_review,'Dy dd Mon yyyy') as review_date
from MH.ENDORSEMENT en join MH.EMPLOYEE em on em.emp_nbr = en.emp_nbr
where end_last_annual_review > to_date('31 March 2020','dd Month yyyy')
order by end_last_annual_review asc;

/*
    Q2
*/
-- PLEASE PLACE REQUIRED SQL STATEMENT FOR THIS PART HERE
-- ENSURE your query has a semicolon (;) at the end of this answer
select charter_nbr,cl.client_nbr,client_lname,client_fname,charter_special_reqs
from MH.CLIENT cl join MH.CHARTER ch on cl.client_nbr = ch.client_nbr
where charter_special_reqs is not null
order by charter_nbr asc;

/*
    Q3
*/
-- PLEASE PLACE REQUIRED SQL STATEMENT FOR THIS PART HERE
-- ENSURE your query has a semicolon (;) at the end of this answer
select ch.charter_nbr, client_fname || ' ' || client_lname as fullname, charter_cost_per_hour
from MH.charter ch join MH.client cl on cl.client_nbr = ch.client_nbr
join MH.charter_leg l on l.charter_nbr = ch.charter_nbr
join MH.location lo on lo.location_nbr = l.location_nbr_destination
where location_name = 'Mount Doom'
and (charter_cost_per_hour < 1000 or charter_special_reqs is null)
order by fullname desc;

/*
    Q4
*/
-- PLEASE PLACE REQUIRED SQL STATEMENT FOR THIS PART HERE
-- ENSURE your query has a semicolon (;) at the end of this answer
select t.ht_nbr, ht_name, count(heli_callsign) as number_of_helicopters
from MH.helicopter_type t join MH.helicopter h on h.ht_nbr = t.ht_nbr
group by t.ht_nbr, ht_name
having count(heli_callsign) >= 2
order by number_of_helicopters desc;

/*
    Q5
*/
-- PLEASE PLACE REQUIRED SQL STATEMENT FOR THIS PART HERE
-- ENSURE your query has a semicolon (;) at the end of this answer
select lo.location_nbr, location_name, count(cl_leg_nbr) as number_of_times
from MH.charter_leg l join MH.location lo on lo.location_nbr = l.location_nbr_destination
group by lo.location_nbr, location_name
having count(cl_leg_nbr) > 1
order by number_of_times;

/*
    Q6
*/
-- PLEASE PLACE REQUIRED SQL STATEMENT FOR THIS PART HERE
-- ENSURE your query has a semicolon (;) at the end of this answer
select t.ht_nbr, ht_name, NVL(sum(HELI_HRS_FLOWN),0) as total_hours
from MH.helicopter_type t left outer join MH.helicopter h on t.ht_nbr = h.ht_nbr
group by t.ht_nbr, ht_name
order by total_hours;

/*
    Q7
*/
-- PLEASE PLACE REQUIRED SQL STATEMENT FOR THIS PART HERE
-- ENSURE your query has a semicolon (;) at the end of this answer
select ch.charter_nbr, to_char(cl_atd,'dd-mm-yyyy HH:MI') as deparyre_time
from MH.charter_leg l join MH.charter ch on ch.charter_nbr = l.charter_nbr
join mh.employee e on e.emp_nbr = ch.emp_nbr
where emp_fname = 'Frodo'
and emp_lname = 'Baggins'
and l.cl_leg_nbr = 1
and ch.charter_nbr in
(select charter_nbr 
from MH.charter_leg 
where cl_ata is not null);

/*
    Q8
*/
-- PLEASE PLACE REQUIRED SQL STATEMENT FOR THIS PART HERE
-- ENSURE your query has a semicolon (;) at the end of this answer
select ch.charter_nbr,cl.client_nbr,client_lname,nvl(client_fname,'-') as client_fname,
lpad(to_char(sum((cl_ata-cl_atd) *24* charter_cost_per_hour),'$990.00'),17,' ') as totalchartercost
from MH.charter_leg l join MH.charter ch on ch.charter_nbr = l.charter_nbr
join MH.client cl on cl.client_nbr = ch.client_nbr
where ch.charter_nbr in
(select charter_nbr
from MH.charter_leg
where cl_ata is not null)
group by ch.charter_nbr,cl.client_nbr,client_lname,client_fname
having sum((cl_ata-cl_atd) *24* charter_cost_per_hour) <
(select sum((cl_ata-cl_atd) *24* charter_cost_per_hour)/count(distinct ch.charter_nbr)
from MH.charter_leg l join MH.charter ch on ch.charter_nbr = l.charter_nbr)
order by totalchartercost desc;

/*
    Q9
*/
-- PLEASE PLACE REQUIRED SQL STATEMENT FOR THIS PART HERE
-- ENSURE your query has a semicolon (;) at the end of this answer
select charter_nbr,emp_fname || ' ' || emp_lname as pilotname,
ltrim(client_fname || ' ' || client_lname) as clientname
from MH.charter ch join MH.employee em on em.emp_nbr = ch.emp_nbr
join MH.client cl on cl.client_nbr = ch.client_nbr
where charter_nbr not in
(select charter_nbr
from MH.charter_leg
where cl_atd != cl_etd)
order by charter_nbr;

/*
    Q10
*/
-- PLEASE PLACE REQUIRED SQL STATEMENT FOR THIS PART HERE
-- ENSURE your query has a semicolon (;) at the end of this answer
select cl.client_nbr,client_fname|| ' ' || client_lname as fullname,location_name,
count(location_nbr_destination) as times
from MH.charter ch join MH.client cl on cl.client_nbr = ch.client_nbr
join MH.charter_leg le on le.charter_nbr = ch.charter_nbr
join MH.location lo on lo.location_nbr = le.location_nbr_destination
where ch.charter_nbr in
(select charter_nbr
from MH.charter_leg
where cl_ata is not null)

group by cl.client_nbr,cl.client_nbr,client_fname|| ' ' || client_lname,location_name
having count (location_nbr_destination) =
(select max(count(location_nbr_destination))
from MH.charter chl join MH.client cll on cll.client_nbr = chl.client_nbr
join MH.charter_leg lel on lel.charter_nbr = chl.charter_nbr
join MH.location lol on lol.location_nbr = lel.location_nbr_destination
where cll.client_nbr = cl.client_nbr
group by cll.client_nbr,location_name)
order by cl.client_nbr,location_name;
