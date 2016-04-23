-- ========================================================== MOH 731 Care and Treatment ====================================================================
-- ========================================================   currently on CTX ==============================================================================

select visit_month,
(select count(distinct x.person_id)
from (
select o.person_id,p.gender, p.birthdate, date_format(o.obs_datetime, '%Y-%m') as ctx_month, date(o.obs_datetime) as ctx_date,
active_status.*
from obs o
join person p on p.person_id=o.person_id and p.voided=0
join patient_program pp on pp.patient_id = o.person_id and pp.voided = 0 and pp.program_id=2
left outer join (
-- subquery to transfer out and death status
select 
o.person_id as id,
max(if(o.concept_id=1543, o.value_datetime,null)) as date_died,
max(if(o.concept_id=160649, o.value_datetime,null)) as to_date,
max(if(o.concept_id=161555, o.value_coded,null)) as dis_reason
from obs o
where o.concept_id in (1543, 161555, 160649) and o.voided = 0 -- concepts for date_died, date_transferred out and discontinuation reason
group by person_id
) active_status on active_status.id =o.person_id
where o.concept_id in (162229, 1282) and o.voided=0 and o.value_coded in (1065,105281,74250)
group by o.person_id, month(o.obs_datetime)
) x
where ctx_date between startDate and endDate and (if(date_died is not null, date_died, if(to_date is not null, to_date,null)) >endDate
or (if(date_died is null, to_date,date_died) is null)) and datediff(endDate,birthdate) div 365.25 <15 and gender='M') as 'HV03-03',
(select count(distinct x.person_id)
from (
select o.person_id,p.gender, p.birthdate, date_format(o.obs_datetime, '%Y-%m') as ctx_month, date(o.obs_datetime) as ctx_date,
active_status.*
from obs o
join person p on p.person_id=o.person_id and p.voided=0
join patient_program pp on pp.patient_id = o.person_id and pp.voided = 0 and pp.program_id=2
left outer join (
-- subquery to transfer out and death status
select 
o.person_id as id,
max(if(o.concept_id=1543, o.value_datetime,null)) as date_died,
max(if(o.concept_id=160649, o.value_datetime,null)) as to_date,
max(if(o.concept_id=161555, o.value_coded,null)) as dis_reason
from obs o
where o.concept_id in (1543, 161555, 160649) and o.voided = 0 -- concepts for date_died, date_transferred out and discontinuation reason
group by person_id
) active_status on active_status.id =o.person_id
where o.concept_id in (162229, 1282) and o.voided=0 and o.value_coded in (1065,105281,74250)
group by o.person_id, month(o.obs_datetime)
) x
where ctx_date between startDate and endDate and (if(date_died is not null, date_died, if(to_date is not null, to_date,null)) >endDate
or (if(date_died is null, to_date,date_died) is null)) and datediff(endDate,birthdate) div 365.25 <15 and gender='F') as 'HV03-04',
(select count(distinct x.person_id)
from (
select o.person_id,p.gender, p.birthdate, date_format(o.obs_datetime, '%Y-%m') as ctx_month, date(o.obs_datetime) as ctx_date,
active_status.*
from obs o
join person p on p.person_id=o.person_id and p.voided=0
join patient_program pp on pp.patient_id = o.person_id and pp.voided = 0 and pp.program_id=2
left outer join (
-- subquery to transfer out and death status
select 
o.person_id as id,
max(if(o.concept_id=1543, o.value_datetime,null)) as date_died,
max(if(o.concept_id=160649, o.value_datetime,null)) as to_date,
max(if(o.concept_id=161555, o.value_coded,null)) as dis_reason
from obs o
where o.concept_id in (1543, 161555, 160649) and o.voided = 0 -- concepts for date_died, date_transferred out and discontinuation reason
group by person_id
) active_status on active_status.id =o.person_id
where o.concept_id in (162229, 1282) and o.voided=0 and o.value_coded in (1065,105281,74250)
group by o.person_id, month(o.obs_datetime)
) x
where ctx_date between startDate and endDate and (if(date_died is not null, date_died, if(to_date is not null, to_date,null)) >endDate
or (if(date_died is null, to_date,date_died) is null)) and datediff(endDate,birthdate) div 365.25 >=15 and gender='M') as 'HV03-05',
(select count(distinct x.person_id)
from (
select o.person_id,p.gender, p.birthdate, date_format(o.obs_datetime, '%Y-%m') as ctx_month, date(o.obs_datetime) as ctx_date,
active_status.*
from obs o
join person p on p.person_id=o.person_id and p.voided=0
join patient_program pp on pp.patient_id = o.person_id and pp.voided = 0 and pp.program_id=2
left outer join (
-- subquery to transfer out and death status
select 
o.person_id as id,
max(if(o.concept_id=1543, o.value_datetime,null)) as date_died,
max(if(o.concept_id=160649, o.value_datetime,null)) as to_date,
max(if(o.concept_id=161555, o.value_coded,null)) as dis_reason
from obs o
where o.concept_id in (1543, 161555, 160649) and o.voided = 0 -- concepts for date_died, date_transferred out and discontinuation reason
group by person_id
) active_status on active_status.id =o.person_id
where o.concept_id in (162229, 1282) and o.voided=0 and o.value_coded in (1065,105281,74250)
group by o.person_id, month(o.obs_datetime)
) x
where ctx_date between startDate and endDate and (if(date_died is not null, date_died, if(to_date is not null, to_date,null)) >endDate
or (if(date_died is null, to_date,date_died) is null)) and datediff(endDate,birthdate) div 365.25 >=15 and gender='F') as 'HV03-06',
(select count(distinct x.person_id)
from (
select o.person_id,p.gender, p.birthdate, date_format(o.obs_datetime, '%Y-%m') as ctx_month, date(o.obs_datetime) as ctx_date,
active_status.*
from obs o
join person p on p.person_id=o.person_id and p.voided=0
join patient_program pp on pp.patient_id = o.person_id and pp.voided = 0 and pp.program_id=2
left outer join (
-- subquery to transfer out and death status
select 
o.person_id as id,
max(if(o.concept_id=1543, o.value_datetime,null)) as date_died,
max(if(o.concept_id=160649, o.value_datetime,null)) as to_date,
max(if(o.concept_id=161555, o.value_coded,null)) as dis_reason
from obs o
where o.concept_id in (1543, 161555, 160649) and o.voided = 0 -- concepts for date_died, date_transferred out and discontinuation reason
group by person_id
) active_status on active_status.id =o.person_id
where o.concept_id in (162229, 1282) and o.voided=0 and o.value_coded in (1065,105281,74250)
group by o.person_id, month(o.obs_datetime)
) x
where ctx_date between startDate and endDate and (if(date_died is not null, date_died, if(to_date is not null, to_date,null)) >endDate
or (if(date_died is null, to_date,date_died) is null))) as 'HV03-07'
from (
select date_sub(date_add(LAST_DAY(e.encounter_datetime),interval 1 DAY),interval 3 MONTH) as startDate,
LAST_DAY(e.encounter_datetime) as endDate,
date_format(e.encounter_datetime, '%Y-%m') as visit_month
from encounter e
where voided =0
group by year(e.encounter_datetime), month(e.encounter_datetime) 
order by year(e.encounter_datetime), month(e.encounter_datetime)
) as mm


-- ========================================================================================================================================================
-- ======================================================== Enrolments ==================================================================================

select 'indicator 1' as ind, date_format(enroll_date, '%Y-%m') as cohort_month,
count(if(datediff(enroll_date,birthdate) div 365.25 <1,1,null)) as 'HV03-08',
count(if(gender='M' and datediff(enroll_date,birthdate) div 365.25 <15,1,null)) as 'HV03-09',
count(if(gender='F' and datediff(enroll_date,birthdate) div 365.25 <15,1,null)) as 'HV03-10',
count(if(gender='M' and datediff(enroll_date,birthdate) div 365.25 >=15,1,null)) as 'HV03-11',
count(if(gender='F' and datediff(enroll_date,birthdate) div 365.25 >=15,1,null)) as 'HV03-12',
count(person_id) as 'HV03-13'
from (
select o.person_id,p.gender, p.birthdate, min(date_format(o.obs_datetime, '%Y-%m')) as enrolled_month, min(date(o.obs_datetime)) as enroll_date
from obs o
join person p on p.person_id=o.person_id and p.voided=0
where o.concept_id = 160540 and o.voided=0 and o.value_coded not in (160563) -- ignore TIs
group by o.person_id) x
group by year(enroll_date), month(enroll_date) 
order by year(enroll_date), month(enroll_date);


-- ========================================================================================================================================================
-- ============================================================  Currently on ART =========================================================================


select mm.visit_month,
(select  count(distinct patient_id)
from (
select  ec.patient_id, active_status.*, 
art_status.*,
p.dead,
p.gender,
p.birthdate,
-- right(max(concat(ec.encounter_datetime, o.value_datetime)),19) as tca, 
max(date(ec.encounter_datetime)) as visit_date, date_format(max(ec.encounter_datetime),'%Y-%m') as visit_month
from encounter ec 
join person p on p.person_id = ec.patient_id and p.voided=0 -- and p.dead = 0 -- filter dead
join patient_program pp on pp.patient_id = ec.patient_id and pp.voided = 0 and pp.program_id=2
left outer join (
-- art status
select patient_id as id, min(start_date) as arv_start_date
from (
select patient_id, group_concat(cn.name) as reg, start_date, discontinued, o.discontinued_reason
from orders o
join concept_name cn on cn.concept_id=o.concept_id and cn.voided=0 and cn.concept_name_type='SHORT'
where o.voided =0
group by patient_id, date(start_date)
) art
group by patient_id
) art_status on art_status.id = ec.patient_id
left outer join (
-- subquery to transfer out and death status
select 
o.person_id,
max(if(o.concept_id=1543, o.value_datetime,null)) as date_died,
max(if(o.concept_id=160649, o.value_datetime,null)) as to_date,
max(if(o.concept_id=161555, o.value_coded,null)) as dis_reason
from obs o
where o.concept_id in (1543, 161555, 160649) and o.voided = 0 -- concepts for date_died, date_transferred out and discontinuation reason
group by person_id

) active_status on active_status.person_id =ec.patient_id
where ec.encounter_type not in  (2,4,6,12)
group by ec.patient_id, month(ec.encounter_datetime)
order by ec.patient_id, date(ec.encounter_datetime) asc
)x
where visit_date between startDate and endDate and (if(date_died is not null, date_died, if(to_date is not null, to_date,null)) >endDate
or (if(date_died is null, to_date,date_died) is null))
and datediff(endDate,birthdate) div 365.25 <1 and arv_start_date is not null
) as 'HV03-14',
(select  count(distinct patient_id)
from (
select  ec.patient_id, active_status.*, 
p.dead,
p.gender,
p.birthdate,
art_status.*,
-- right(max(concat(ec.encounter_datetime, o.value_datetime)),19) as tca, 
max(date(ec.encounter_datetime)) as visit_date, date_format(max(ec.encounter_datetime),'%Y-%m') as visit_month
from encounter ec 
join person p on p.person_id = ec.patient_id and p.voided=0 -- and p.dead = 0 -- filter dead
join patient_program pp on pp.patient_id = ec.patient_id and pp.voided = 0 and pp.program_id=2
left outer join (
-- art status
select patient_id as id, min(start_date) as arv_start_date
from (
select patient_id, group_concat(cn.name) as reg, start_date, discontinued, o.discontinued_reason
from orders o
join concept_name cn on cn.concept_id=o.concept_id and cn.voided=0 and cn.concept_name_type='SHORT'
where o.voided =0
group by patient_id, date(start_date)
) art
group by patient_id
) art_status on art_status.id = ec.patient_id
left outer join (
-- subquery to transfer out and death status
select 
o.person_id,
max(if(o.concept_id=1543, o.value_datetime,null)) as date_died,
max(if(o.concept_id=160649, o.value_datetime,null)) as to_date,
max(if(o.concept_id=161555, o.value_coded,null)) as dis_reason
from obs o
where o.concept_id in (1543, 161555, 160649) and o.voided = 0 -- concepts for date_died, date_transferred out and discontinuation reason
group by person_id

) active_status on active_status.person_id =ec.patient_id
where ec.encounter_type not in  (2,4,6,12)
group by ec.patient_id, month(ec.encounter_datetime)
order by ec.patient_id, date(ec.encounter_datetime) asc
)x
where visit_date between startDate and endDate and (if(date_died is not null, date_died, if(to_date is not null, to_date,null)) >endDate
or (if(date_died is null, to_date,date_died) is null))
and datediff(endDate,birthdate) div 365.25 <15 and gender='M' and arv_start_date is not null
) as 'HV03-15',
(select  count(distinct patient_id)
from (
select  ec.patient_id, active_status.*, 
p.dead,
p.gender,
p.birthdate,
art_status.*,
-- right(max(concat(ec.encounter_datetime, o.value_datetime)),19) as tca, 
max(date(ec.encounter_datetime)) as visit_date, date_format(max(ec.encounter_datetime),'%Y-%m') as visit_month
from encounter ec 
join person p on p.person_id = ec.patient_id and p.voided=0 -- and p.dead = 0 -- filter dead
join patient_program pp on pp.patient_id = ec.patient_id and pp.voided = 0 and pp.program_id=2
left outer join (
-- art status
select patient_id as id, min(start_date) as arv_start_date
from (
select patient_id, group_concat(cn.name) as reg, start_date, discontinued, o.discontinued_reason
from orders o
join concept_name cn on cn.concept_id=o.concept_id and cn.voided=0 and cn.concept_name_type='SHORT'
where o.voided =0
group by patient_id, date(start_date)
) art
group by patient_id
) art_status on art_status.id = ec.patient_id

left outer join (
-- subquery to transfer out and death status
select 
o.person_id,
max(if(o.concept_id=1543, o.value_datetime,null)) as date_died,
max(if(o.concept_id=160649, o.value_datetime,null)) as to_date,
max(if(o.concept_id=161555, o.value_coded,null)) as dis_reason
from obs o
where o.concept_id in (1543, 161555, 160649) and o.voided = 0 -- concepts for date_died, date_transferred out and discontinuation reason
group by person_id

) active_status on active_status.person_id =ec.patient_id
where ec.encounter_type not in  (2,4,6,12)
group by ec.patient_id, month(ec.encounter_datetime)
order by ec.patient_id, date(ec.encounter_datetime) asc
)x
where visit_date between startDate and endDate and (if(date_died is not null, date_died, if(to_date is not null, to_date,null)) >endDate
or (if(date_died is null, to_date,date_died) is null))
and datediff(endDate,birthdate) div 365.25 <15 and gender='F' and arv_start_date is not null
) as 'HV03-16',
(select  count(distinct patient_id)
from (
select  ec.patient_id, active_status.*, 
p.dead,
p.gender,
p.birthdate,
art_status.*,
-- right(max(concat(ec.encounter_datetime, o.value_datetime)),19) as tca, 
max(date(ec.encounter_datetime)) as visit_date, date_format(max(ec.encounter_datetime),'%Y-%m') as visit_month
from encounter ec 
join person p on p.person_id = ec.patient_id and p.voided=0 -- and p.dead = 0 -- filter dead
join patient_program pp on pp.patient_id = ec.patient_id and pp.voided = 0 and pp.program_id=2
left outer join (
-- art status
select patient_id as id, min(start_date) as arv_start_date
from (
select patient_id, group_concat(cn.name) as reg, start_date, discontinued, o.discontinued_reason
from orders o
join concept_name cn on cn.concept_id=o.concept_id and cn.voided=0 and cn.concept_name_type='SHORT'
where o.voided =0
group by patient_id, date(start_date)
) art
group by patient_id
) art_status on art_status.id = ec.patient_id

left outer join (
-- subquery to transfer out and death status
select 
o.person_id,
max(if(o.concept_id=1543, o.value_datetime,null)) as date_died,
max(if(o.concept_id=160649, o.value_datetime,null)) as to_date,
max(if(o.concept_id=161555, o.value_coded,null)) as dis_reason
from obs o
where o.concept_id in (1543, 161555, 160649) and o.voided = 0 -- concepts for date_died, date_transferred out and discontinuation reason
group by person_id

) active_status on active_status.person_id =ec.patient_id
where ec.encounter_type not in  (2,4,6,12)
group by ec.patient_id, month(ec.encounter_datetime)
order by ec.patient_id, date(ec.encounter_datetime) asc
)x
where visit_date between startDate and endDate and (if(date_died is not null, date_died, if(to_date is not null, to_date,null)) >endDate
or (if(date_died is null, to_date,date_died) is null))
and datediff(endDate,birthdate) div 365.25 >=15 and gender='M'and arv_start_date is not null
) as 'HV03-17',
(select  count(distinct patient_id)
from (
select  ec.patient_id, active_status.*, 
p.dead,
p.gender,
p.birthdate,
art_status.*,
-- right(max(concat(ec.encounter_datetime, o.value_datetime)),19) as tca, 
max(date(ec.encounter_datetime)) as visit_date, date_format(max(ec.encounter_datetime),'%Y-%m') as visit_month
from encounter ec 
join person p on p.person_id = ec.patient_id and p.voided=0 -- and p.dead = 0 -- filter dead
join patient_program pp on pp.patient_id = ec.patient_id and pp.voided = 0 and pp.program_id=2
left outer join (
-- art status
select patient_id as id, min(start_date) as arv_start_date
from (
select patient_id, group_concat(cn.name) as reg, start_date, discontinued, o.discontinued_reason
from orders o
join concept_name cn on cn.concept_id=o.concept_id and cn.voided=0 and cn.concept_name_type='SHORT'
where o.voided =0
group by patient_id, date(start_date)
) art
group by patient_id
) art_status on art_status.id = ec.patient_id

left outer join (
-- subquery to transfer out and death status
select 
o.person_id,
max(if(o.concept_id=1543, o.value_datetime,null)) as date_died,
max(if(o.concept_id=160649, o.value_datetime,null)) as to_date,
max(if(o.concept_id=161555, o.value_coded,null)) as dis_reason
from obs o
where o.concept_id in (1543, 161555, 160649) and o.voided = 0 -- concepts for date_died, date_transferred out and discontinuation reason
group by person_id

) active_status on active_status.person_id =ec.patient_id
where ec.encounter_type not in  (2,4,6,12)
group by ec.patient_id, month(ec.encounter_datetime)
order by ec.patient_id, date(ec.encounter_datetime) asc
)x
where visit_date between startDate and endDate and (if(date_died is not null, date_died, if(to_date is not null, to_date,null)) >endDate
or (if(date_died is null, to_date,date_died) is null))
and datediff(endDate,birthdate) div 365.25 >=15 and gender='F' and arv_start_date is not null
) as 'HV03-18',
(select  count(distinct patient_id)
from (
select  ec.patient_id, active_status.*, 
p.dead,
p.gender,
p.birthdate,
art_status.*,
-- right(max(concat(ec.encounter_datetime, o.value_datetime)),19) as tca, 
max(date(ec.encounter_datetime)) as visit_date, date_format(max(ec.encounter_datetime),'%Y-%m') as visit_month
from encounter ec 
join person p on p.person_id = ec.patient_id and p.voided=0 -- and p.dead = 0 -- filter dead
join patient_program pp on pp.patient_id = ec.patient_id and pp.voided = 0 and pp.program_id=2
left outer join (
-- art status
select patient_id as id, min(start_date) as arv_start_date
from (
select patient_id, group_concat(cn.name) as reg, start_date, discontinued, o.discontinued_reason
from orders o
join concept_name cn on cn.concept_id=o.concept_id and cn.voided=0 and cn.concept_name_type='SHORT'
where o.voided =0
group by patient_id, date(start_date)
) art
group by patient_id
) art_status on art_status.id = ec.patient_id

left outer join (
-- subquery to transfer out and death status
select 
o.person_id,
max(if(o.concept_id=1543, o.value_datetime,null)) as date_died,
max(if(o.concept_id=160649, o.value_datetime,null)) as to_date,
max(if(o.concept_id=161555, o.value_coded,null)) as dis_reason
from obs o
where o.concept_id in (1543, 161555, 160649) and o.voided = 0 -- concepts for date_died, date_transferred out and discontinuation reason
group by person_id

) active_status on active_status.person_id =ec.patient_id
where ec.encounter_type not in  (2,4,6,12)
group by ec.patient_id, month(ec.encounter_datetime)
order by ec.patient_id, date(ec.encounter_datetime) asc
)x
where visit_date between startDate and endDate and (if(date_died is not null, date_died, if(to_date is not null, to_date,null)) >endDate
or (if(date_died is null, to_date,date_died) is null)) and arv_start_date is not null
) as 'HV03-19'
from (
select date_sub(date_add(LAST_DAY(e.encounter_datetime),interval 1 DAY),interval 3 MONTH) as startDate,
LAST_DAY(e.encounter_datetime) as endDate,
date_format(e.encounter_datetime, '%Y-%m') as visit_month
from encounter e
where voided =0
group by year(e.encounter_datetime), month(e.encounter_datetime) 
order by year(e.encounter_datetime), month(e.encounter_datetime)
) as mm

-- =======================================================================================================================================================
-- =========================================================== Active in Care ===========================================================================


select mm.visit_month,
(select  count(distinct patient_id)
from (
select  ec.patient_id, active_status.*, 
p.dead,
p.gender,
p.birthdate,
-- right(max(concat(ec.encounter_datetime, o.value_datetime)),19) as tca, 
max(date(ec.encounter_datetime)) as visit_date, date_format(max(ec.encounter_datetime),'%Y-%m') as visit_month
from encounter ec 
join person p on p.person_id = ec.patient_id and p.voided=0 -- and p.dead = 0 -- filter dead
join patient_program pp on pp.patient_id = ec.patient_id and pp.voided = 0 and pp.program_id=2
left outer join (
-- subquery to transfer out and death status
select 
o.person_id,
max(if(o.concept_id=1543, o.value_datetime,null)) as date_died,
max(if(o.concept_id=160649, o.value_datetime,null)) as to_date,
max(if(o.concept_id=161555, o.value_coded,null)) as dis_reason
from obs o
where o.concept_id in (1543, 161555, 160649) and o.voided = 0 -- concepts for date_died, date_transferred out and discontinuation reason
group by person_id

) active_status on active_status.person_id =ec.patient_id
where ec.encounter_type not in  (2,4,6,12)
group by ec.patient_id, month(ec.encounter_datetime)
order by ec.patient_id, date(ec.encounter_datetime) asc
)x
where visit_date between startDate and endDate and (if(date_died is not null, date_died, if(to_date is not null, to_date,null)) >endDate
or (if(date_died is null, to_date,date_died) is null))
and datediff(endDate,birthdate) div 365.25 <1
) as 'HV03-14',
(select  count(distinct patient_id)
from (
select  ec.patient_id, active_status.*, 
p.dead,
p.gender,
p.birthdate,
-- right(max(concat(ec.encounter_datetime, o.value_datetime)),19) as tca, 
max(date(ec.encounter_datetime)) as visit_date, date_format(max(ec.encounter_datetime),'%Y-%m') as visit_month
from encounter ec 
join person p on p.person_id = ec.patient_id and p.voided=0 -- and p.dead = 0 -- filter dead
join patient_program pp on pp.patient_id = ec.patient_id and pp.voided = 0 and pp.program_id=2
left outer join (
-- subquery to transfer out and death status
select 
o.person_id,
max(if(o.concept_id=1543, o.value_datetime,null)) as date_died,
max(if(o.concept_id=160649, o.value_datetime,null)) as to_date,
max(if(o.concept_id=161555, o.value_coded,null)) as dis_reason
from obs o
where o.concept_id in (1543, 161555, 160649) and o.voided = 0 -- concepts for date_died, date_transferred out and discontinuation reason
group by person_id

) active_status on active_status.person_id =ec.patient_id
where ec.encounter_type not in  (2,4,6,12)
group by ec.patient_id, month(ec.encounter_datetime)
order by ec.patient_id, date(ec.encounter_datetime) asc
)x
where visit_date between startDate and endDate and (if(date_died is not null, date_died, if(to_date is not null, to_date,null)) >endDate
or (if(date_died is null, to_date,date_died) is null))
and datediff(endDate,birthdate) div 365.25 <15 and gender='M'
) as 'HV03-15',
(select  count(distinct patient_id)
from (
select  ec.patient_id, active_status.*, 
p.dead,
p.gender,
p.birthdate,
-- right(max(concat(ec.encounter_datetime, o.value_datetime)),19) as tca, 
max(date(ec.encounter_datetime)) as visit_date, date_format(max(ec.encounter_datetime),'%Y-%m') as visit_month
from encounter ec 
join person p on p.person_id = ec.patient_id and p.voided=0 -- and p.dead = 0 -- filter dead
join patient_program pp on pp.patient_id = ec.patient_id and pp.voided = 0 and pp.program_id=2
left outer join (
-- subquery to transfer out and death status
select 
o.person_id,
max(if(o.concept_id=1543, o.value_datetime,null)) as date_died,
max(if(o.concept_id=160649, o.value_datetime,null)) as to_date,
max(if(o.concept_id=161555, o.value_coded,null)) as dis_reason
from obs o
where o.concept_id in (1543, 161555, 160649) and o.voided = 0 -- concepts for date_died, date_transferred out and discontinuation reason
group by person_id

) active_status on active_status.person_id =ec.patient_id
where ec.encounter_type not in  (2,4,6,12)
group by ec.patient_id, month(ec.encounter_datetime)
order by ec.patient_id, date(ec.encounter_datetime) asc
)x
where visit_date between startDate and endDate and (if(date_died is not null, date_died, if(to_date is not null, to_date,null)) >endDate
or (if(date_died is null, to_date,date_died) is null))
and datediff(endDate,birthdate) div 365.25 <15 and gender='F'
) as 'HV03-16',
(select  count(distinct patient_id)
from (
select  ec.patient_id, active_status.*, 
p.dead,
p.gender,
p.birthdate,
-- right(max(concat(ec.encounter_datetime, o.value_datetime)),19) as tca, 
max(date(ec.encounter_datetime)) as visit_date, date_format(max(ec.encounter_datetime),'%Y-%m') as visit_month
from encounter ec 
join person p on p.person_id = ec.patient_id and p.voided=0 -- and p.dead = 0 -- filter dead
join patient_program pp on pp.patient_id = ec.patient_id and pp.voided = 0 and pp.program_id=2
left outer join (
-- subquery to transfer out and death status
select 
o.person_id,
max(if(o.concept_id=1543, o.value_datetime,null)) as date_died,
max(if(o.concept_id=160649, o.value_datetime,null)) as to_date,
max(if(o.concept_id=161555, o.value_coded,null)) as dis_reason
from obs o
where o.concept_id in (1543, 161555, 160649) and o.voided = 0 -- concepts for date_died, date_transferred out and discontinuation reason
group by person_id

) active_status on active_status.person_id =ec.patient_id
where ec.encounter_type not in  (2,4,6,12)
group by ec.patient_id, month(ec.encounter_datetime)
order by ec.patient_id, date(ec.encounter_datetime) asc
)x
where visit_date between startDate and endDate and (if(date_died is not null, date_died, if(to_date is not null, to_date,null)) >endDate
or (if(date_died is null, to_date,date_died) is null))
and datediff(endDate,birthdate) div 365.25 >=15 and gender='M'
) as 'HV03-17',
(select  count(distinct patient_id)
from (
select  ec.patient_id, active_status.*, 
p.dead,
p.gender,
p.birthdate,
-- right(max(concat(ec.encounter_datetime, o.value_datetime)),19) as tca, 
max(date(ec.encounter_datetime)) as visit_date, date_format(max(ec.encounter_datetime),'%Y-%m') as visit_month
from encounter ec 
join person p on p.person_id = ec.patient_id and p.voided=0 -- and p.dead = 0 -- filter dead
join patient_program pp on pp.patient_id = ec.patient_id and pp.voided = 0 and pp.program_id=2
left outer join (
-- subquery to transfer out and death status
select 
o.person_id,
max(if(o.concept_id=1543, o.value_datetime,null)) as date_died,
max(if(o.concept_id=160649, o.value_datetime,null)) as to_date,
max(if(o.concept_id=161555, o.value_coded,null)) as dis_reason
from obs o
where o.concept_id in (1543, 161555, 160649) and o.voided = 0 -- concepts for date_died, date_transferred out and discontinuation reason
group by person_id

) active_status on active_status.person_id =ec.patient_id
where ec.encounter_type not in  (2,4,6,12)
group by ec.patient_id, month(ec.encounter_datetime)
order by ec.patient_id, date(ec.encounter_datetime) asc
)x
where visit_date between startDate and endDate and (if(date_died is not null, date_died, if(to_date is not null, to_date,null)) >endDate
or (if(date_died is null, to_date,date_died) is null))
and datediff(endDate,birthdate) div 365.25 >=15 and gender='F'
) as 'HV03-18',
(select  count(distinct patient_id)
from (
select  ec.patient_id, active_status.*, 
p.dead,
p.gender,
p.birthdate,
-- right(max(concat(ec.encounter_datetime, o.value_datetime)),19) as tca, 
max(date(ec.encounter_datetime)) as visit_date, date_format(max(ec.encounter_datetime),'%Y-%m') as visit_month
from encounter ec 
join person p on p.person_id = ec.patient_id and p.voided=0 -- and p.dead = 0 -- filter dead
join patient_program pp on pp.patient_id = ec.patient_id and pp.voided = 0 and pp.program_id=2
left outer join (
-- subquery to transfer out and death status
select 
o.person_id,
max(if(o.concept_id=1543, o.value_datetime,null)) as date_died,
max(if(o.concept_id=160649, o.value_datetime,null)) as to_date,
max(if(o.concept_id=161555, o.value_coded,null)) as dis_reason
from obs o
where o.concept_id in (1543, 161555, 160649) and o.voided = 0 -- concepts for date_died, date_transferred out and discontinuation reason
group by person_id

) active_status on active_status.person_id =ec.patient_id
where ec.encounter_type not in  (2,4,6,12)
group by ec.patient_id, month(ec.encounter_datetime)
order by ec.patient_id, date(ec.encounter_datetime) asc
)x
where visit_date between startDate and endDate and (if(date_died is not null, date_died, if(to_date is not null, to_date,null)) >endDate
or (if(date_died is null, to_date,date_died) is null))
) as 'HV03-19'
from (
select date_sub(date_add(LAST_DAY(e.encounter_datetime),interval 1 DAY),interval 3 MONTH) as startDate,
LAST_DAY(e.encounter_datetime) as endDate,
date_format(e.encounter_datetime, '%Y-%m') as visit_month
from encounter e
where voided =0
group by year(e.encounter_datetime), month(e.encounter_datetime) 
order by year(e.encounter_datetime), month(e.encounter_datetime)
) as mm

-- =======================================================================================================================================================
-- ============================================================== Revisits on ART ========================================================================


select mm.visit_month,
(select  count(distinct patient_id)
from (
select  ec.patient_id, active_status.*, 
art_status.*,
p.dead,
p.gender,
p.birthdate,
-- right(max(concat(ec.encounter_datetime, o.value_datetime)),19) as tca, 
max(date(ec.encounter_datetime)) as visit_date, date_format(max(ec.encounter_datetime),'%Y-%m') as visit_month
from encounter ec 
join person p on p.person_id = ec.patient_id and p.voided=0 -- and p.dead = 0 -- filter dead
join patient_program pp on pp.patient_id = ec.patient_id and pp.voided = 0 and pp.program_id=2
left outer join (
-- art status
select patient_id as id, min(start_date) as arv_start_date
from (
select patient_id, group_concat(cn.name) as reg, start_date, discontinued, o.discontinued_reason
from orders o
join concept_name cn on cn.concept_id=o.concept_id and cn.voided=0 and cn.concept_name_type='SHORT'
where o.voided =0
group by patient_id, date(start_date)
) art
group by patient_id
) art_status on art_status.id = ec.patient_id
left outer join (
-- subquery to transfer out and death status
select 
o.person_id,
max(if(o.concept_id=1543, o.value_datetime,null)) as date_died,
max(if(o.concept_id=160649, o.value_datetime,null)) as to_date,
max(if(o.concept_id=161555, o.value_coded,null)) as dis_reason
from obs o
where o.concept_id in (1543, 161555, 160649) and o.voided = 0 -- concepts for date_died, date_transferred out and discontinuation reason
group by person_id

) active_status on active_status.person_id =ec.patient_id
where ec.encounter_type not in  (2,4,6,12)
group by ec.patient_id, month(ec.encounter_datetime)
order by ec.patient_id, date(ec.encounter_datetime) asc
)x
where visit_date between startDate and endDate and (if(date_died is not null, date_died, if(to_date is not null, to_date,null)) >endDate
or (if(date_died is null, to_date,date_died) is null))
and datediff(endDate,birthdate) div 365.25 <1 and arv_start_date < startDate
) as 'HV03-14',
(select  count(distinct patient_id)
from (
select  ec.patient_id, active_status.*, 
p.dead,
p.gender,
p.birthdate,
art_status.*,
-- right(max(concat(ec.encounter_datetime, o.value_datetime)),19) as tca, 
max(date(ec.encounter_datetime)) as visit_date, date_format(max(ec.encounter_datetime),'%Y-%m') as visit_month
from encounter ec 
join person p on p.person_id = ec.patient_id and p.voided=0 -- and p.dead = 0 -- filter dead
join patient_program pp on pp.patient_id = ec.patient_id and pp.voided = 0 and pp.program_id=2
left outer join (
-- art status
select patient_id as id, min(start_date) as arv_start_date
from (
select patient_id, group_concat(cn.name) as reg, start_date, discontinued, o.discontinued_reason
from orders o
join concept_name cn on cn.concept_id=o.concept_id and cn.voided=0 and cn.concept_name_type='SHORT'
where o.voided =0
group by patient_id, date(start_date)
) art
group by patient_id
) art_status on art_status.id = ec.patient_id
left outer join (
-- subquery to transfer out and death status
select 
o.person_id,
max(if(o.concept_id=1543, o.value_datetime,null)) as date_died,
max(if(o.concept_id=160649, o.value_datetime,null)) as to_date,
max(if(o.concept_id=161555, o.value_coded,null)) as dis_reason
from obs o
where o.concept_id in (1543, 161555, 160649) and o.voided = 0 -- concepts for date_died, date_transferred out and discontinuation reason
group by person_id

) active_status on active_status.person_id =ec.patient_id
where ec.encounter_type not in  (2,4,6,12)
group by ec.patient_id, month(ec.encounter_datetime)
order by ec.patient_id, date(ec.encounter_datetime) asc
)x
where visit_date between startDate and endDate and (if(date_died is not null, date_died, if(to_date is not null, to_date,null)) >endDate
or (if(date_died is null, to_date,date_died) is null))
and datediff(endDate,birthdate) div 365.25 <15 and gender='M' and arv_start_date < startDate
) as 'HV03-15',
(select  count(distinct patient_id)
from (
select  ec.patient_id, active_status.*, 
p.dead,
p.gender,
p.birthdate,
art_status.*,
-- right(max(concat(ec.encounter_datetime, o.value_datetime)),19) as tca, 
max(date(ec.encounter_datetime)) as visit_date, date_format(max(ec.encounter_datetime),'%Y-%m') as visit_month
from encounter ec 
join person p on p.person_id = ec.patient_id and p.voided=0 -- and p.dead = 0 -- filter dead
join patient_program pp on pp.patient_id = ec.patient_id and pp.voided = 0 and pp.program_id=2
left outer join (
-- art status
select patient_id as id, min(start_date) as arv_start_date
from (
select patient_id, group_concat(cn.name) as reg, start_date, discontinued, o.discontinued_reason
from orders o
join concept_name cn on cn.concept_id=o.concept_id and cn.voided=0 and cn.concept_name_type='SHORT'
where o.voided =0
group by patient_id, date(start_date)
) art
group by patient_id
) art_status on art_status.id = ec.patient_id

left outer join (
-- subquery to transfer out and death status
select 
o.person_id,
max(if(o.concept_id=1543, o.value_datetime,null)) as date_died,
max(if(o.concept_id=160649, o.value_datetime,null)) as to_date,
max(if(o.concept_id=161555, o.value_coded,null)) as dis_reason
from obs o
where o.concept_id in (1543, 161555, 160649) and o.voided = 0 -- concepts for date_died, date_transferred out and discontinuation reason
group by person_id

) active_status on active_status.person_id =ec.patient_id
where ec.encounter_type not in  (2,4,6,12)
group by ec.patient_id, month(ec.encounter_datetime)
order by ec.patient_id, date(ec.encounter_datetime) asc
)x
where visit_date between startDate and endDate and (if(date_died is not null, date_died, if(to_date is not null, to_date,null)) >endDate
or (if(date_died is null, to_date,date_died) is null))
and datediff(endDate,birthdate) div 365.25 <15 and gender='F' and arv_start_date < startDate
) as 'HV03-16',
(select  count(distinct patient_id)
from (
select  ec.patient_id, active_status.*, 
p.dead,
p.gender,
p.birthdate,
art_status.*,
-- right(max(concat(ec.encounter_datetime, o.value_datetime)),19) as tca, 
max(date(ec.encounter_datetime)) as visit_date, date_format(max(ec.encounter_datetime),'%Y-%m') as visit_month
from encounter ec 
join person p on p.person_id = ec.patient_id and p.voided=0 -- and p.dead = 0 -- filter dead
join patient_program pp on pp.patient_id = ec.patient_id and pp.voided = 0 and pp.program_id=2
left outer join (
-- art status
select patient_id as id, min(start_date) as arv_start_date
from (
select patient_id, group_concat(cn.name) as reg, start_date, discontinued, o.discontinued_reason
from orders o
join concept_name cn on cn.concept_id=o.concept_id and cn.voided=0 and cn.concept_name_type='SHORT'
where o.voided =0
group by patient_id, date(start_date)
) art
group by patient_id
) art_status on art_status.id = ec.patient_id

left outer join (
-- subquery to transfer out and death status
select 
o.person_id,
max(if(o.concept_id=1543, o.value_datetime,null)) as date_died,
max(if(o.concept_id=160649, o.value_datetime,null)) as to_date,
max(if(o.concept_id=161555, o.value_coded,null)) as dis_reason
from obs o
where o.concept_id in (1543, 161555, 160649) and o.voided = 0 -- concepts for date_died, date_transferred out and discontinuation reason
group by person_id

) active_status on active_status.person_id =ec.patient_id
where ec.encounter_type not in  (2,4,6,12)
group by ec.patient_id, month(ec.encounter_datetime)
order by ec.patient_id, date(ec.encounter_datetime) asc
)x
where visit_date between startDate and endDate and (if(date_died is not null, date_died, if(to_date is not null, to_date,null)) >endDate
or (if(date_died is null, to_date,date_died) is null))
and datediff(endDate,birthdate) div 365.25 >=15 and gender='M'and arv_start_date < startDate
) as 'HV03-17',
(select  count(distinct patient_id)
from (
select  ec.patient_id, active_status.*, 
p.dead,
p.gender,
p.birthdate,
art_status.*,
-- right(max(concat(ec.encounter_datetime, o.value_datetime)),19) as tca, 
max(date(ec.encounter_datetime)) as visit_date, date_format(max(ec.encounter_datetime),'%Y-%m') as visit_month
from encounter ec 
join person p on p.person_id = ec.patient_id and p.voided=0 -- and p.dead = 0 -- filter dead
join patient_program pp on pp.patient_id = ec.patient_id and pp.voided = 0 and pp.program_id=2
left outer join (
-- art status
select patient_id as id, min(start_date) as arv_start_date
from (
select patient_id, group_concat(cn.name) as reg, start_date, discontinued, o.discontinued_reason
from orders o
join concept_name cn on cn.concept_id=o.concept_id and cn.voided=0 and cn.concept_name_type='SHORT'
where o.voided =0
group by patient_id, date(start_date)
) art
group by patient_id
) art_status on art_status.id = ec.patient_id

left outer join (
-- subquery to transfer out and death status
select 
o.person_id,
max(if(o.concept_id=1543, o.value_datetime,null)) as date_died,
max(if(o.concept_id=160649, o.value_datetime,null)) as to_date,
max(if(o.concept_id=161555, o.value_coded,null)) as dis_reason
from obs o
where o.concept_id in (1543, 161555, 160649) and o.voided = 0 -- concepts for date_died, date_transferred out and discontinuation reason
group by person_id

) active_status on active_status.person_id =ec.patient_id
where ec.encounter_type not in  (2,4,6,12)
group by ec.patient_id, month(ec.encounter_datetime)
order by ec.patient_id, date(ec.encounter_datetime) asc
)x
where visit_date between startDate and endDate and (if(date_died is not null, date_died, if(to_date is not null, to_date,null)) >endDate
or (if(date_died is null, to_date,date_died) is null))
and datediff(endDate,birthdate) div 365.25 >=15 and gender='F' and arv_start_date < startDate
) as 'HV03-18',
(select  count(distinct patient_id)
from (
select  ec.patient_id, active_status.*, 
p.dead,
p.gender,
p.birthdate,
art_status.*,
-- right(max(concat(ec.encounter_datetime, o.value_datetime)),19) as tca, 
max(date(ec.encounter_datetime)) as visit_date, date_format(max(ec.encounter_datetime),'%Y-%m') as visit_month
from encounter ec 
join person p on p.person_id = ec.patient_id and p.voided=0 -- and p.dead = 0 -- filter dead
join patient_program pp on pp.patient_id = ec.patient_id and pp.voided = 0 and pp.program_id=2
left outer join (
-- art status
select patient_id as id, min(start_date) as arv_start_date
from (
select patient_id, group_concat(cn.name) as reg, start_date, discontinued, o.discontinued_reason
from orders o
join concept_name cn on cn.concept_id=o.concept_id and cn.voided=0 and cn.concept_name_type='SHORT'
where o.voided =0
group by patient_id, date(start_date)
) art
group by patient_id
) art_status on art_status.id = ec.patient_id

left outer join (
-- subquery to transfer out and death status
select 
o.person_id,
max(if(o.concept_id=1543, o.value_datetime,null)) as date_died,
max(if(o.concept_id=160649, o.value_datetime,null)) as to_date,
max(if(o.concept_id=161555, o.value_coded,null)) as dis_reason
from obs o
where o.concept_id in (1543, 161555, 160649) and o.voided = 0 -- concepts for date_died, date_transferred out and discontinuation reason
group by person_id

) active_status on active_status.person_id =ec.patient_id
where ec.encounter_type not in  (2,4,6,12)
group by ec.patient_id, month(ec.encounter_datetime)
order by ec.patient_id, date(ec.encounter_datetime) asc
)x
where visit_date between startDate and endDate and (if(date_died is not null, date_died, if(to_date is not null, to_date,null)) >endDate
or (if(date_died is null, to_date,date_died) is null)) and arv_start_date < startDate
) as 'HV03-19'
from (
select date_sub(date_add(LAST_DAY(e.encounter_datetime),interval 1 DAY),interval 3 MONTH) as startDate,
LAST_DAY(e.encounter_datetime) as endDate,
date_format(e.encounter_datetime, '%Y-%m') as visit_month
from encounter e
where voided =0
group by year(e.encounter_datetime), month(e.encounter_datetime) 
order by year(e.encounter_datetime), month(e.encounter_datetime)
) as mm

-- ======================================================================================================================================================
-- ============================================================= Started on ART =========================================================================

select 'indicator 2' as ind, date_format(art_startDate, '%Y-%m') as cohort_month,
count(if(datediff(art_startDate,birthdate) div 365.25 <1,1,null)) as 'HV03-20',
count(if(gender='M' and datediff(art_startDate,birthdate) div 365.25 <15,1,null)) as 'HV03-21',
count(if(gender='F' and datediff(art_startDate,birthdate) div 365.25 <15,1,null)) as 'HV03-22',
count(if(gender='M' and datediff(art_startDate,birthdate) div 365.25 >=15,1,null)) as 'HV03-23',
count(if(gender='F' and datediff(art_startDate,birthdate) div 365.25 >=15,1,null)) as 'HV03-24',
count(patient_id) as 'HV03-25'
from (
select patient_id, min(start_date) as art_startDate, p.gender, p.birthdate, min(date_format(o.start_date, '%Y-%m')) as art_start_month
from orders o
join person p on person_id = o.patient_id and p.voided =0
where o.voided =0
group by patient_id) x
group by year(art_startDate), month(art_startDate) 
order by year(art_startDate), month(art_startDate);


-- =======================================================================================================================================================
-- ========================================================================================================================================================
--                                    Net Cohort and on Therapy Query
-- ---------------------------------------------------------------------------------------------------------------------------------------------------------

select trial_1.visit_month_, count(distinct cohort.patient_id) as net_cohort,
count(distinct if((coalesce(cohort.to_date,cohort.date_died) > trial_1.endDate or coalesce(cohort.to_date,cohort.date_died) is null), cohort.patient_id,null)) as on_therapy
from (
select patient_id, min(start_date) as art_startDate, p.gender, p.birthdate,
date_format(min(o.start_date), '%Y-%m') as art_start_month,
active_status.*
from orders o
join person p on person_id = o.patient_id and p.voided =0
left outer join (
-- subquery to transfer out and death status
select 
o.person_id,
max(if(o.concept_id=1543, o.value_datetime,null)) as date_died,
max(if(o.concept_id=160649, o.value_datetime,null)) as to_date,
max(if(o.concept_id=161555, o.value_coded,null)) as dis_reason,
min(if(o.concept_id=159599, o.value_datetime,null)) as ti_art_startDate,
min(if(o.concept_id=160534, o.value_datetime,null)) as ti_Date
from obs o
where o.concept_id in (1543, 161555, 160649, 159599, 160534) and o.voided = 0 -- concepts for date_died, date_transferred out and discontinuation reason
group by person_id
) active_status on active_status.person_id =o.patient_id
group by patient_id
)as cohort
left outer join (
select date_sub(date_add(LAST_DAY(e.encounter_datetime),interval 1 DAY),interval 1 MONTH) as startDate,
LAST_DAY(e.encounter_datetime) as endDate,
date_sub(date_sub(date_add(LAST_DAY(e.encounter_datetime),interval 1 DAY),interval 1 MONTH),interval 1 year) as startDate_,
date_sub(LAST_DAY(e.encounter_datetime),interval 1 year) as  endDate_,
date_format(e.encounter_datetime, '%Y-%m') as visit_month,
date_format(date_sub(e.encounter_datetime,interval 1 year), '%Y-%m') as visit_month_
from encounter e
where voided =0
group by year(e.encounter_datetime), month(e.encounter_datetime) 
order by year(e.encounter_datetime), month(e.encounter_datetime)
) as trial_1 on trial_1.visit_month_=cohort.art_start_month
group by trial_1.visit_month_;



-- ==============================================================================================================================================================
