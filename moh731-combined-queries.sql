select *
from (select date(t1.endDate) as endDate, date_format(endDate,'%M-%Y')  as report_month,
count(distinct if(gender='M' and timestampdiff(year,birthdate, ctx_date) <15,person_id,null)) as 'HV03-03',
count(distinct if(gender='F' and timestampdiff(year,birthdate, ctx_date) <15,person_id,null)) as 'HV03-04',
count(distinct if(gender='M' and timestampdiff(year,birthdate, ctx_date) >=15,person_id,null)) as 'HV03-05',
count(distinct if(gender='F' and timestampdiff(year,birthdate, ctx_date) >=15,person_id,null)) as 'HV03-06',
count(distinct person_id) as 'HV03-07'

from dates t1
left outer join(select o.person_id,p.gender, p.birthdate, date_format(o.obs_datetime, '%Y-%m') as ctx_month, date(o.obs_datetime) as ctx_date,
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
group by o.person_id, month(o.obs_datetime)) t2 on t2.ctx_date 
between date_add(date_sub(endDate, interval 3 month), interval 1 day) and t1.endDate
and (coalesce(t2.to_date, t2.date_died) is null or coalesce(t2.to_date, t2.date_died)>t1.endDate )
group by t1.endDate
) a
left outer join (select LAST_DAY(enroll_date) as endDate, 'indicator 1' as ind, date_format(enroll_date, '%M-%Y') as report_month,
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
order by year(enroll_date), month(enroll_date)
) b using (endDate)
left outer join (select date(t1.endDate) as endDate, date_format(endDate,'%M-%Y')  as report_month,
count(distinct if(gender='M' and timestampdiff(year,birthdate, endDate) <1,patient_id,null)) as 'HV03-14',
count(distinct if(gender='M' and timestampdiff(year,birthdate, endDate) <15,patient_id,null)) as 'HV03-15',
count(distinct if(gender='F' and timestampdiff(year,birthdate, endDate) <15,patient_id,null)) as 'HV03-16',
count(distinct if(gender='M' and timestampdiff(year,birthdate, endDate) >=15,patient_id,null)) as 'HV03-17',
count(distinct if(gender='F' and timestampdiff(year,birthdate, endDate) >=15,patient_id,null)) as 'HV03-18',
count(distinct patient_id) as 'HV03-19'
from dates t1
left outer join (select  ec.patient_id, active_status.*, 
p.dead,
p.gender,
p.birthdate,
art_status.*,
-- right(max(concat(ec.encounter_datetime, o.value_datetime)),19) as tca, 
max(date(ec.encounter_datetime)) as visit_date, date_format(max(ec.encounter_datetime),'%M-%Y') as visit_month
from encounter ec 
join person p on p.person_id = ec.patient_id and p.voided=0 -- and p.dead = 0 -- filter dead
join patient_program pp on pp.patient_id = ec.patient_id and pp.voided = 0 and pp.program_id=2
left outer join (
-- art status
-- art status
select coalesce(t1.patient_id,t2.person_id) as id,
min(coalesce(t1.arv_date,t2.arv_date)) as arv_date,
coalesce(t1.reg,t2.reg) as reg
from (
select patient_id, group_concat(cn.name) as reg, max(start_date) as arv_date, discontinued, o.discontinued_reason,
group_concat(cn.concept_id)
from orders o
join concept_name cn on cn.concept_id=o.concept_id and cn.voided=0 and cn.concept_name_type='SHORT'
where o.voided =0
group by patient_id, date(start_date)
)t1
left outer join(
select person_id, obs_datetime as arv_date, o.concept_id,group_concat(value_coded),group_concat(cn.name) as reg
from obs o
left outer join concept_name cn on cn.concept_id=o.value_coded and cn.voided=0 and cn.concept_name_type='SHORT'
where (o.concept_id in (1282) and 
value_coded in (1149,80586,1652,161364,75523,78643,78643,70056,84795.161361,794,792,86663,103166,630,160124,84309,817))
or o.concept_id in (930,1088)
and o.voided =0
group by person_id,date(obs_datetime)) t2 on t2.person_id = t1.patient_id
group by t1.patient_id
order by t1.arv_date
) art_status on art_status.id = ec.patient_id

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

) active_status on active_status.person_id =ec.patient_id
where ec.encounter_type not in  (2,4,6,12)
group by ec.patient_id, month(ec.encounter_datetime)
order by ec.patient_id, date(ec.encounter_datetime) asc
) t2 on t2.visit_date between date_add(date_sub(endDate, interval 3 month), interval 1 day) and endDate
and (coalesce(date_died,to_date) >endDate or coalesce(date_died,to_date) is null)
group by endDate
)c using (endDate)
left outer join (select date(t1.endDate) as endDate, date_format(endDate,'%M-%Y')  as report_month,
count(distinct if(gender='M' and timestampdiff(year,birthdate, endDate) <1,patient_id,null)) as 'HV03-20',
count(distinct if(gender='M' and timestampdiff(year,birthdate, endDate) <15,patient_id,null)) as 'HV03-21',
count(distinct if(gender='F' and timestampdiff(year,birthdate, endDate) <15,patient_id,null)) as 'HV03-22',
count(distinct if(gender='M' and timestampdiff(year,birthdate, endDate) >=15,patient_id,null)) as 'HV03-23',
count(distinct if(gender='F' and timestampdiff(year,birthdate, endDate) >=15,patient_id,null)) as 'HV03-24',
count(distinct patient_id) as 'HV03-25'
from dates t1
left outer join (select  ec.patient_id, active_status.*, 
p.dead,
p.gender,
p.birthdate,
art_status.*,
-- right(max(concat(ec.encounter_datetime, o.value_datetime)),19) as tca, 
max(date(ec.encounter_datetime)) as visit_date, date_format(max(ec.encounter_datetime),'%M-%Y') as visit_month
from encounter ec 
join person p on p.person_id = ec.patient_id and p.voided=0 -- and p.dead = 0 -- filter dead
join patient_program pp on pp.patient_id = ec.patient_id and pp.voided = 0 and pp.program_id=2
left outer join (
-- art status
-- art status
select coalesce(t1.patient_id,t2.person_id) as id,
min(coalesce(t1.arv_date,t2.arv_date)) as arv_date,
coalesce(t1.reg,t2.reg) as reg
from (
select patient_id, group_concat(cn.name) as reg, max(start_date) as arv_date, discontinued, o.discontinued_reason,
group_concat(cn.concept_id)
from orders o
join concept_name cn on cn.concept_id=o.concept_id and cn.voided=0 and cn.concept_name_type='SHORT'
where o.voided =0
group by patient_id
)t1
left outer join(
select person_id, min(obs_datetime) as arv_date, o.concept_id,group_concat(value_coded),group_concat(cn.name) as reg
from obs o
left outer join concept_name cn on cn.concept_id=o.value_coded and cn.voided=0 and cn.concept_name_type='SHORT'
where (o.concept_id in (1282) and 
value_coded in (1149,80586,1652,161364,75523,78643,78643,70056,84795.161361,794,792,86663,103166,630,160124,84309,817))
or o.concept_id in (930,1088)
and o.voided =0
group by person_id) t2 on t2.person_id = t1.patient_id
group by t1.patient_id
order by t1.arv_date
) art_status on art_status.id = ec.patient_id

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

) active_status on active_status.person_id =ec.patient_id
where ec.encounter_type not in  (2,4,6,12)
group by ec.patient_id, month(ec.encounter_datetime)
order by ec.patient_id, date(ec.encounter_datetime) asc
) t2 on t2.arv_date between date_add(date_sub(endDate, interval 1 month), interval 1 day) and endDate
group by endDate

)d using (endDate)
left outer join (select date(t1.endDate) as endDate, date_format(endDate,'%M-%Y')  as report_month,
count(distinct if(gender='M' and timestampdiff(year,birthdate, endDate) <1,patient_id,null)) as 'HV03-28',
count(distinct if(gender='M' and timestampdiff(year,birthdate, endDate) <15,patient_id,null)) as 'HV03-29',
count(distinct if(gender='F' and timestampdiff(year,birthdate, endDate) <15,patient_id,null)) as 'HV03-30',
count(distinct if(gender='M' and timestampdiff(year,birthdate, endDate) >=15,patient_id,null)) as 'HV03-31',
count(distinct if(gender='F' and timestampdiff(year,birthdate, endDate) >=15,patient_id,null)) as 'HV03-32',
count(distinct patient_id) as 'HV03-33'
from dates t1
left outer join (select  ec.patient_id, active_status.*, 
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
-- art status
select coalesce(t1.patient_id,t2.person_id) as id,
min(coalesce(t1.arv_date,t2.arv_date)) as arv_date,
coalesce(t1.reg,t2.reg) as reg
from (
select patient_id, group_concat(cn.name) as reg, max(start_date) as arv_date, discontinued, o.discontinued_reason,
group_concat(cn.concept_id)
from orders o
join concept_name cn on cn.concept_id=o.concept_id and cn.voided=0 and cn.concept_name_type='SHORT'
where o.voided =0
group by patient_id, date(start_date)
)t1
left outer join(
select person_id, obs_datetime as arv_date, o.concept_id,group_concat(value_coded),group_concat(cn.name) as reg
from obs o
left outer join concept_name cn on cn.concept_id=o.value_coded and cn.voided=0 and cn.concept_name_type='SHORT'
where (o.concept_id in (1282) and 
value_coded in (1149,80586,1652,161364,75523,78643,78643,70056,84795.161361,794,792,86663,103166,630,160124,84309,817))
or o.concept_id in (930,1088)
and o.voided =0
group by person_id,date(obs_datetime)) t2 on t2.person_id = t1.patient_id
group by t1.patient_id
order by t1.arv_date
) art_status on art_status.id = ec.patient_id

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

) active_status on active_status.person_id =ec.patient_id
where ec.encounter_type not in  (2,4,6,12)
group by ec.patient_id, month(ec.encounter_datetime)
order by ec.patient_id, date(ec.encounter_datetime) asc
) t2 on t2.visit_date between date_add(date_sub(endDate, interval 3 month), interval 1 day) and endDate
and (coalesce(date_died,to_date) >endDate or coalesce(date_died,to_date) is null)
and (coalesce(arv_date, ti_art_startDate) is not null and arv_date < date_add(date_sub(endDate, interval 3 month), interval 1 day))
group by endDate
)e using(endDate)
left outer join (select date(t1.endDate) as endDate, date_format(endDate,'%M-%Y')  as report_month,
count(distinct if(gender='M' and timestampdiff(year,birthdate, endDate) <1,patient_id,null)) as 'HV03-34',
count(distinct if(gender='M' and timestampdiff(year,birthdate, endDate) <15,patient_id,null)) as 'HV03-35',
count(distinct if(gender='F' and timestampdiff(year,birthdate, endDate) <15,patient_id,null)) as 'HV03-36',
count(distinct if(gender='M' and timestampdiff(year,birthdate, endDate) >=15,patient_id,null)) as 'HV03-37',
count(distinct if(gender='F' and timestampdiff(year,birthdate, endDate) >=15,patient_id,null)) as 'HV03-38',
count(distinct patient_id) as 'HV03-39'
from dates t1
left outer join (select  ec.patient_id, active_status.*, 
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
-- art status
select coalesce(t1.patient_id,t2.person_id) as id,
min(coalesce(t1.arv_date,t2.arv_date)) as arv_date,
coalesce(t1.reg,t2.reg) as reg
from (
select patient_id, group_concat(cn.name) as reg, max(start_date) as arv_date, discontinued, o.discontinued_reason,
group_concat(cn.concept_id)
from orders o
join concept_name cn on cn.concept_id=o.concept_id and cn.voided=0 and cn.concept_name_type='SHORT'
where o.voided =0
group by patient_id, date(start_date)
)t1
left outer join(
select person_id, obs_datetime as arv_date, o.concept_id,group_concat(value_coded),group_concat(cn.name) as reg
from obs o
left outer join concept_name cn on cn.concept_id=o.value_coded and cn.voided=0 and cn.concept_name_type='SHORT'
where (o.concept_id in (1282) and 
value_coded in (1149,80586,1652,161364,75523,78643,78643,70056,84795.161361,794,792,86663,103166,630,160124,84309,817))
or o.concept_id in (930,1088)
and o.voided =0
group by person_id,date(obs_datetime)) t2 on t2.person_id = t1.patient_id
group by t1.patient_id
order by t1.arv_date
) art_status on art_status.id = ec.patient_id

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

) active_status on active_status.person_id =ec.patient_id
where ec.encounter_type not in  (2,4,6,12)
group by ec.patient_id, month(ec.encounter_datetime)
order by ec.patient_id, date(ec.encounter_datetime) asc
) t2 on t2.visit_date between date_add(date_sub(endDate, interval 3 month), interval 1 day) and endDate
and (coalesce(date_died,to_date) >endDate or coalesce(date_died,to_date) is null)
and (coalesce(arv_date, ti_art_startDate) is not null and arv_date <=endDate)
group by endDate
) f using (endDate)