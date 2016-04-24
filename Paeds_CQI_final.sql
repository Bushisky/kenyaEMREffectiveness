call create_flat_table_vl();

-- ind 1.1
(
select '1.1' as Indicator, d.cohort_month as Period, n.sixMonthsTotal as Numerator, d.ActiveInCareTotal as Denominator
from
(
select
	 six_month,
	endDate,
	yearMonth as cohort_month,
(
-- query to get active patients in specified duration
select count(distinct ec.patient_id)
from encounter ec 
join person p on p.person_id = ec.patient_id and p.voided=0 -- and p.dead = 0 -- filter dead
join patient_program pp on pp.patient_id = ec.patient_id and pp.voided = 0 and pp.program_id=2
left outer join (
select person_id, mid(max(concat(tca, visit_date)),11) as visit_date,
left(max(concat(tca, visit_date)),10) as tca
from (
select person_id, date(mid(max(concat(obs_datetime,value_datetime)),20)) as tca,
date(left(max(concat(obs_datetime,value_datetime)),19)) as visit_date
from obs 
where voided =0 and concept_id = 5096
group by person_id, date(obs_datetime))x
group by person_id 
)lft on lft.person_id = ec.patient_id and lft.visit_date<=GREATEST(LAST_DAY((select max(ec.encounter_datetime))),0)
left outer join (
-- subquery to transfer out and death status
select 
o.person_id,
ifnull(max(if(o.concept_id=1543, o.value_datetime,null)), '') as date_died,
ifnull(max(if(o.concept_id=160649, o.value_datetime,null)), '') as to_date,
ifnull(max(if(o.concept_id=161555, o.value_coded,null)), '') as dis_reason
from obs o
where o.concept_id in (1543, 161555, 160649) and o.voided = 0 -- concepts for date_died, date_transferred out and discontinuation reason
group by person_id
) active_status on active_status.person_id =ec.patient_id
where ec.encounter_datetime between six_month and endDate
and if(date_died <= endDate,1,0) =0 and if(to_date <= endDate,1,0)=0
 and if(timestampdiff(day,lft.tca, endDate) <= 90, 0,1) = 0
 and timestampdiff(year,p.birthdate, endDate) < 15
) as ActiveInCareTotal,
(
-- query to get active on ART patients in specified duration
select count(distinct ec.patient_id)
from encounter ec 
join person p on p.person_id = ec.patient_id and p.voided=0 -- and p.dead = 0 -- filter dead
join patient_program pp on pp.patient_id = ec.patient_id and pp.voided = 0 and pp.program_id=2
left outer join (
select person_id, mid(max(concat(tca, visit_date)),11) as visit_date,
left(max(concat(tca, visit_date)),10) as tca
from (
select person_id, date(mid(max(concat(obs_datetime,value_datetime)),20)) as tca,
date(left(max(concat(obs_datetime,value_datetime)),19)) as visit_date
from obs 
where voided =0 and concept_id = 5096
group by person_id, date(obs_datetime))x
group by person_id 
)lft on lft.person_id = ec.patient_id and lft.visit_date<=GREATEST(LAST_DAY((select max(ec.encounter_datetime))),0)
left outer join (
-- art status
select patient_id, min(start_date) as start_date
from (
select patient_id, group_concat(cn.name) as reg, start_date, discontinued, o.discontinued_reason
from orders o
join concept_name cn on cn.concept_id=o.concept_id and cn.voided=0 and cn.concept_name_type='SHORT'
where o.voided =0
group by patient_id, date(start_date)
) art
group by patient_id
) art_status on art_status.patient_id = ec.patient_id
left outer join (
-- subquery to transfer out and death status
select 
o.person_id,
ifnull(max(if(o.concept_id=1543, o.value_datetime,null)), '') as date_died,
ifnull(max(if(o.concept_id=160649, o.value_datetime,null)), '') as to_date,
ifnull(max(if(o.concept_id=161555, o.value_coded,null)), '') as dis_reason
from obs o
where o.concept_id in (1543, 161555, 160649) and o.voided = 0 -- concepts for date_died, date_transferred out and discontinuation reason
group by person_id
) active_status on active_status.person_id =ec.patient_id
where ec.encounter_datetime between six_month and endDate
and if(date_died <= endDate,1,0) =0 and if(to_date <= endDate,1,0)=0
and if(start_date <= endDate,1,0) =1
 and if(timestampdiff(day,lft.tca, endDate) <= 90, 0,1) = 0
 and timestampdiff(year,p.birthdate, endDate) < 15
) as ActiveOnARTTotal
from month_dates 
group by year(endDate), month(endDate) 

) d
inner join (
select
	 six_month,
	endDate,
	yearMonth as cohort_month,
	(
		select count(distinct ec.patient_id)
		from (select 
			@patient_id :=case -- for every group of a given patient's encounters, compare current encounter date to the previous encounter date
				when (@patient_id = patient_id) and (datediff(date(e.encounter_datetime), @enc_date)) between 85 and 95 then
					1
				else 0
				end as three_m_apart,
			@patient_id :=patient_id as patient_id, -- cache patient_id
			@enc_date :=date(e.encounter_datetime) as enc_date, -- cache encounter date
			e.encounter_datetime, e.voided -- needed for joins & where clause
		from encounter e where encounter_type in (3,7,12,13,14,18,19) order by patient_id, encounter_datetime) ec
		inner join person p on p.person_id=ec.patient_id and p.voided=0
		join patient_program pp on pp.patient_id = ec.patient_id and ec.voided = 0 and pp.voided = 0 and pp.program_id=2
		left outer join 
		(
			select person_id, mid(max(concat(tca, visit_date)),11) as visit_date,
			left(max(concat(tca, visit_date)),10) as tca
			from (
			select person_id, date(mid(max(concat(obs_datetime,value_datetime)),20)) as tca,
			date(left(max(concat(obs_datetime,value_datetime)),19)) as visit_date
			from obs 
			where voided =0 and concept_id = 5096
			group by person_id, date(obs_datetime))x
			group by person_id 
		)lft on lft.person_id = ec.patient_id and lft.visit_date<=GREATEST(LAST_DAY((select max(ec.encounter_datetime))),0)
		left outer join (
			-- subquery to transfer out and death status
			select 
			o.person_id,
			ifnull(max(if(o.concept_id=1543, o.value_datetime,null)), '') as date_died,
			ifnull(max(if(o.concept_id=160649, o.value_datetime,null)), '') as to_date,
			ifnull(max(if(o.concept_id=161555, o.value_coded,null)), '') as dis_reason
			from obs o
			where o.concept_id in (1543, 161555, 160649) and o.voided = 0 -- concepts for date_died, date_transferred out and discontinuation reason
			group by person_id
		) active_status on active_status.person_id =ec.patient_id
		where ec.encounter_datetime between six_month and endDate
		and ec.three_m_apart=1 -- two or more encounters satisfy three months apart
		and if(date_died <= endDate,1,0) =0 and if(to_date <= endDate,1,0)=0
		 and if(timestampdiff(day,lft.tca, endDate) <= 90, 0,1) = 0
 		and timestampdiff(year,p.birthdate, endDate) < 15
	) as sixMonthsTotal
from month_dates 
group by year(endDate), month(endDate)

) n on n.cohort_month = d.cohort_month
order by 1

)
union
-- 1.2 patients with at least one cd4 result in the last 6 months
(
select '1.2' as Indicator, d.cohort_month as Period, n.monthTotal as Numerator, d.ActiveInCareTotal as Denominator
from
(
select
	 six_month,
	endDate,
	yearMonth as cohort_month,
(
-- query to get active patients in specified duration
select count(distinct ec.patient_id)
from encounter ec 
join person p on p.person_id = ec.patient_id and p.voided=0 -- and p.dead = 0 -- filter dead
join patient_program pp on pp.patient_id = ec.patient_id and pp.voided = 0 and pp.program_id=2
left outer join (
select person_id, mid(max(concat(tca, visit_date)),11) as visit_date,
left(max(concat(tca, visit_date)),10) as tca
from (
select person_id, date(mid(max(concat(obs_datetime,value_datetime)),20)) as tca,
date(left(max(concat(obs_datetime,value_datetime)),19)) as visit_date
from obs 
where voided =0 and concept_id = 5096
group by person_id, date(obs_datetime))x
group by person_id 
)lft on lft.person_id = ec.patient_id and lft.visit_date<=GREATEST(LAST_DAY((select max(ec.encounter_datetime))),0)
left outer join (
-- subquery to transfer out and death status
select 
o.person_id,
ifnull(max(if(o.concept_id=1543, o.value_datetime,null)), '') as date_died,
ifnull(max(if(o.concept_id=160649, o.value_datetime,null)), '') as to_date,
ifnull(max(if(o.concept_id=161555, o.value_coded,null)), '') as dis_reason
from obs o
where o.concept_id in (1543, 161555, 160649) and o.voided = 0 -- concepts for date_died, date_transferred out and discontinuation reason
group by person_id
) active_status on active_status.person_id =ec.patient_id
where ec.encounter_datetime between six_month and endDate
and if(date_died <= endDate,1,0) =0 and if(to_date <= endDate,1,0)=0
 and if(timestampdiff(day,lft.tca, endDate) <= 90, 0,1) = 0
 and timestampdiff(year,p.birthdate, endDate) < 15
) as ActiveInCareTotal,
(
-- query to get active on ART patients in specified duration
select count(distinct ec.patient_id)
from encounter ec 
join person p on p.person_id = ec.patient_id and p.voided=0 -- and p.dead = 0 -- filter dead
join patient_program pp on pp.patient_id = ec.patient_id and pp.voided = 0 and pp.program_id=2
left outer join (
select person_id, mid(max(concat(tca, visit_date)),11) as visit_date,
left(max(concat(tca, visit_date)),10) as tca
from (
select person_id, date(mid(max(concat(obs_datetime,value_datetime)),20)) as tca,
date(left(max(concat(obs_datetime,value_datetime)),19)) as visit_date
from obs 
where voided =0 and concept_id = 5096
group by person_id, date(obs_datetime))x
group by person_id 
)lft on lft.person_id = ec.patient_id and lft.visit_date<=GREATEST(LAST_DAY((select max(ec.encounter_datetime))),0)
left outer join (
-- art status
select patient_id, min(start_date) as start_date
from (
select patient_id, group_concat(cn.name) as reg, start_date, discontinued, o.discontinued_reason
from orders o
join concept_name cn on cn.concept_id=o.concept_id and cn.voided=0 and cn.concept_name_type='SHORT'
where o.voided =0
group by patient_id, date(start_date)
) art
group by patient_id
) art_status on art_status.patient_id = ec.patient_id
left outer join (
-- subquery to transfer out and death status
select 
o.person_id,
ifnull(max(if(o.concept_id=1543, o.value_datetime,null)), '') as date_died,
ifnull(max(if(o.concept_id=160649, o.value_datetime,null)), '') as to_date,
ifnull(max(if(o.concept_id=161555, o.value_coded,null)), '') as dis_reason
from obs o
where o.concept_id in (1543, 161555, 160649) and o.voided = 0 -- concepts for date_died, date_transferred out and discontinuation reason
group by person_id
) active_status on active_status.person_id =ec.patient_id
where ec.encounter_datetime between six_month and endDate
and if(date_died <= endDate,1,0) =0 and if(to_date <= endDate,1,0)=0
and if(start_date <= endDate,1,0) =1
 and if(timestampdiff(day,lft.tca, endDate) <= 90, 0,1) = 0
 and timestampdiff(year,p.birthdate, endDate) < 15
) as ActiveOnARTTotal
from month_dates 
group by year(endDate), month(endDate) 

) d
inner join (
select
	 six_month,
	endDate,
	yearMonth,
	(
select count(distinct patient_id) from (
select patient_id, 
left(max(concat(visit_date, tca_date)), 10) as visit_date,
mid(max(concat(visit_date, tca_date)), 11) as tca_date,
mid(max(concat(visit_date, date_to)),11) as date_to,
mid(max(concat(visit_date, date_died)),11) as date_died,
dob,
cd4_percent,
cd4_count
from flat_visit_table_vl f
where  cd4_percent is not null or cd4_count is not null
group by patient_id, visit_date ) cd4
where visit_date between six_month and endDate 
and (datediff(endDate, date(visit_date)) <= 96 or datediff(endDate, date(tca_date)) <= 96) 
and (date_died is null or date_died='' or date_died > endDate)
and (date_to is null or date_to='' or date_to > endDate)
and timestampdiff(year,dob, endDate) < 15
) as monthTotal
from month_dates 
group by year(endDate), month(endDate) 

) n on n.yearMonth = d.cohort_month
order by 1
)
union
-- 1.4 at least a viral load result in the last 12 months
(
select '1.4' as Indicator, d.cohort_month as Period, n.monthTotal as Numerator, d.ActiveOnARTTotal as Denominator
from
(
select
	twelve_month,
	endDate,
	yearMonth as cohort_month,
(
-- query to get active patients in specified duration
select count(distinct ec.patient_id)
from encounter ec 
join person p on p.person_id = ec.patient_id and p.voided=0 -- and p.dead = 0 -- filter dead
join patient_program pp on pp.patient_id = ec.patient_id and pp.voided = 0 and pp.program_id=2
left outer join (
select person_id, mid(max(concat(tca, visit_date)),11) as visit_date,
left(max(concat(tca, visit_date)),10) as tca
from (
select person_id, date(mid(max(concat(obs_datetime,value_datetime)),20)) as tca,
date(left(max(concat(obs_datetime,value_datetime)),19)) as visit_date
from obs 
where voided =0 and concept_id = 5096
group by person_id, date(obs_datetime))x
group by person_id 
)lft on lft.person_id = ec.patient_id and lft.visit_date<=GREATEST(LAST_DAY((select max(ec.encounter_datetime))),0)
left outer join (
-- subquery to transfer out and death status
select 
o.person_id,
ifnull(max(if(o.concept_id=1543, o.value_datetime,null)), '') as date_died,
ifnull(max(if(o.concept_id=160649, o.value_datetime,null)), '') as to_date,
ifnull(max(if(o.concept_id=161555, o.value_coded,null)), '') as dis_reason
from obs o
where o.concept_id in (1543, 161555, 160649) and o.voided = 0 -- concepts for date_died, date_transferred out and discontinuation reason
group by person_id
) active_status on active_status.person_id =ec.patient_id
where ec.encounter_datetime between twelve_month and endDate
and if(date_died <= endDate,1,0) =0 and if(to_date <= endDate,1,0)=0
and if(timestampdiff(day,lft.tca, endDate) <= 90, 0,1) = 0
and timestampdiff(year,p.birthdate, endDate) < 15
) as ActiveInCareTotal,
(
-- query to get active on ART patients in specified duration
select count(distinct ec.patient_id)
from encounter ec 
join person p on p.person_id = ec.patient_id and p.voided=0 -- and p.dead = 0 -- filter dead
join patient_program pp on pp.patient_id = ec.patient_id and pp.voided = 0 and pp.program_id=2
left outer join (
select person_id, mid(max(concat(tca, visit_date)),11) as visit_date,
left(max(concat(tca, visit_date)),10) as tca
from (
select person_id, date(mid(max(concat(obs_datetime,value_datetime)),20)) as tca,
date(left(max(concat(obs_datetime,value_datetime)),19)) as visit_date
from obs 
where voided =0 and concept_id = 5096
group by person_id, date(obs_datetime))x
group by person_id 
)lft on lft.person_id = ec.patient_id and lft.visit_date<=GREATEST(LAST_DAY((select max(ec.encounter_datetime))),0)
left outer join (
-- art status
select patient_id, min(start_date) as start_date
from (
select patient_id, group_concat(cn.name) as reg, start_date, discontinued, o.discontinued_reason
from orders o
join concept_name cn on cn.concept_id=o.concept_id and cn.voided=0 and cn.concept_name_type='SHORT'
where o.voided =0
group by patient_id, date(start_date)
) art
group by patient_id
) art_status on art_status.patient_id = ec.patient_id
left outer join (
-- subquery to transfer out and death status
select 
o.person_id,
ifnull(max(if(o.concept_id=1543, o.value_datetime,null)), '') as date_died,
ifnull(max(if(o.concept_id=160649, o.value_datetime,null)), '') as to_date,
ifnull(max(if(o.concept_id=161555, o.value_coded,null)), '') as dis_reason
from obs o
where o.concept_id in (1543, 161555, 160649) and o.voided = 0 -- concepts for date_died, date_transferred out and discontinuation reason
group by person_id
) active_status on active_status.person_id =ec.patient_id
where ec.encounter_datetime between twelve_month and endDate
and if(date_died <= endDate,1,0) =0 and if(to_date <= endDate,1,0)=0
and if(start_date <= endDate,1,0) =1
and if(timestampdiff(day,lft.tca, endDate) <= 90, 0,1) = 0
and timestampdiff(year,p.birthdate, endDate) < 15
) as ActiveOnARTTotal
from month_dates 
group by year(endDate), month(endDate)

) d
inner join (
	select
	twelve_month,
	endDate,
	yearMonth,
	(
select count(distinct patient_id) from (
select patient_id, 
left(max(concat(visit_date, tca_date)), 10) as visit_date,
mid(max(concat(visit_date, tca_date)), 11) as tca_date,
mid(max(concat(visit_date, date_to)),11) as date_to,
mid(max(concat(visit_date, date_died)),11) as date_died,
dob,
vl
from flat_visit_table_vl f
where  vl is not null
group by patient_id, visit_date ) vl
where visit_date between twelve_month and endDate 
and (datediff(endDate, date(visit_date)) <= 96 or datediff(endDate, date(tca_date)) <= 96) 
and (date_died is null or date_died='' or date_died > endDate)
and (date_to is null or date_to='' or date_to > endDate)
and timestampdiff(year,dob, endDate) < 15
) as monthTotal
from month_dates 
group by year(endDate), month(endDate)
) n on n.yearMonth = d.cohort_month
order by 1
)
union
-- viral suppression
(
select '1.5' as Indicator, d.yearMonth as Period, n.monthTotal as Numerator, d.ActiveOnARTTotal as Denominator
from
(
select
	 six_month,
	endDate,
	yearMonth,
(
-- query to get active patients in specified duration
select count(distinct ec.patient_id)
from encounter ec 
join person p on p.person_id = ec.patient_id and p.voided=0 -- and p.dead = 0 -- filter dead
join patient_program pp on pp.patient_id = ec.patient_id and pp.voided = 0 and pp.program_id=2
left outer join (
select person_id, mid(max(concat(tca, visit_date)),11) as visit_date,
left(max(concat(tca, visit_date)),10) as tca
from (
select person_id, date(mid(max(concat(obs_datetime,value_datetime)),20)) as tca,
date(left(max(concat(obs_datetime,value_datetime)),19)) as visit_date
from obs 
where voided =0 and concept_id = 5096
group by person_id, date(obs_datetime))x
group by person_id 
)lft on lft.person_id = ec.patient_id and lft.visit_date<=GREATEST(LAST_DAY((select max(ec.encounter_datetime))),0)
left outer join (
-- subquery to transfer out and death status
select 
o.person_id,
ifnull(max(if(o.concept_id=1543, o.value_datetime,null)), '') as date_died,
ifnull(max(if(o.concept_id=160649, o.value_datetime,null)), '') as to_date,
ifnull(max(if(o.concept_id=161555, o.value_coded,null)), '') as dis_reason
from obs o
where o.concept_id in (1543, 161555, 160649) and o.voided = 0 -- concepts for date_died, date_transferred out and discontinuation reason
group by person_id
) active_status on active_status.person_id =ec.patient_id
where ec.encounter_datetime between six_month and endDate
and if(date_died <= endDate,1,0) =0 and if(to_date <= endDate,1,0)=0
and if(timestampdiff(day,lft.tca, endDate) <= 90, 0,1) = 0
and timestampdiff(year,p.birthdate, endDate) < 15
) as ActiveInCareTotal,
(
-- query to get active on ART patients in specified duration
select count(distinct ec.patient_id)
from encounter ec 
join person p on p.person_id = ec.patient_id and p.voided=0 -- and p.dead = 0 -- filter dead
join patient_program pp on pp.patient_id = ec.patient_id and pp.voided = 0 and pp.program_id=2
left outer join (
select person_id, mid(max(concat(tca, visit_date)),11) as visit_date,
left(max(concat(tca, visit_date)),10) as tca
from (
select person_id, date(mid(max(concat(obs_datetime,value_datetime)),20)) as tca,
date(left(max(concat(obs_datetime,value_datetime)),19)) as visit_date
from obs 
where voided =0 and concept_id = 5096
group by person_id, date(obs_datetime))x
group by person_id 
)lft on lft.person_id = ec.patient_id and lft.visit_date<=GREATEST(LAST_DAY((select max(ec.encounter_datetime))),0)
left outer join (
-- art status
select patient_id, min(start_date) as start_date
from (
select patient_id, group_concat(cn.name) as reg, start_date, discontinued, o.discontinued_reason
from orders o
join concept_name cn on cn.concept_id=o.concept_id and cn.voided=0 and cn.concept_name_type='SHORT'
where o.voided =0
group by patient_id, date(start_date)
) art
group by patient_id
) art_status on art_status.patient_id = ec.patient_id
left outer join (
-- subquery to transfer out and death status
select 
o.person_id,
ifnull(max(if(o.concept_id=1543, o.value_datetime,null)), '') as date_died,
ifnull(max(if(o.concept_id=160649, o.value_datetime,null)), '') as to_date,
ifnull(max(if(o.concept_id=161555, o.value_coded,null)), '') as dis_reason
from obs o
where o.concept_id in (1543, 161555, 160649) and o.voided = 0 -- concepts for date_died, date_transferred out and discontinuation reason
group by person_id
) active_status on active_status.person_id =ec.patient_id
where ec.encounter_datetime between six_month and endDate
and if(date_died <= endDate,1,0) =0 and if(to_date <= endDate,1,0)=0
and if(start_date <= endDate,1,0) =1
and if(timestampdiff(day,lft.tca, endDate) <= 90, 0,1) = 0
and timestampdiff(year,p.birthdate, endDate) < 15
) as ActiveOnARTTotal
from month_dates 
group by year(endDate), month(endDate)
 

) d
inner join (
select
	 six_month,
	endDate,
	yearMonth,
	(
select count(distinct patient_id) from (
select patient_id, 
min(art_start_date) as art_start_date,
min(ti_art_start_date) ti_art_start_date,
left(max(concat(visit_date, tca_date)), 10) as visit_date,
mid(max(concat(visit_date, tca_date)), 11) as tca_date,
mid(max(concat(visit_date, date_to)),11) as date_to,
mid(max(concat(visit_date, date_died)),11) as date_died,
mid(max(concat(visit_date, vl)),11) as vl,
dob
from flat_visit_table_vl f
where  vl is not null
group by patient_id, visit_date ) vl
where visit_date between six_month and endDate 
and (datediff(endDate, date(visit_date)) <= 96 or datediff(endDate, date(tca_date)) <= 96) 
and (date_died is null or date_died='' or date_died > endDate)
and (date_to is null or date_to='' or date_to > endDate)
and timestampdiff(year,dob, endDate) < 15
and vl > 1000
and timestampdiff(month,if(ti_art_start_date is not null, least(ti_art_start_date, art_start_date), art_start_date), endDate) >= 6
) as monthTotal
from month_dates 
group by year(endDate), month(endDate)

) n on n.yearMonth = d.yearMonth
order by 1
)

union

-- 1.8
(
select '1.8' as Indicator, d.yearMonth as Period, nm.monthlyCount as Numerator, d.monthlyCount as Denominator
from
(
select
	 six_month,
	endDate,
	yearMonth,
	(
select count(*) from (
select 
x.patient,
x.dob,
max(concat(x.eDate,x.weight,x.height)) as lastEnc,
left(max(concat(x.eDate,x.weight,x.height)),10) as lastEncDate,
substring(max(concat(x.eDate,x.weight,x.height)),11,1) as lastWeight,
substring(max(concat(x.eDate,x.weight,x.height)),12,1) as lastHeight
from 
(
select
	e.patient_id as patient,
	p.birthdate as dob,
	date(e.encounter_datetime) as eDate,
	max(if(o.concept_id=5089 and o.value_numeric is not null,1, 0)) as weight,
	max(if(o.concept_id=5090 and o.value_numeric is not null,1, 0)) as height
	-- max(if(o.concept_id=1343 and o.value_numeric is not null,1, 0)) as muac
from encounter e
inner join person p on e.patient_id=p.person_id and p.voided=0
left outer join obs o on e.encounter_id = o.encounter_id and o.concept_id in (5089, 5090) and o.voided=0
where e.encounter_type in (7) -- and e.patient_id=12
group by e.patient_id, e.encounter_id  
order by e.patient_id, e.encounter_datetime) x
-- where x.eDate between six_month and endDate -- x.weight =0 and x.height =0 -- and x.eDate <= '2011-05-17';
group by x.patient
) n
where n.lastEncDate  between six_month and endDate and (datediff(endDate, dob) / 365.25)>=15
) as monthlyCount
from month_dates 
group by year(endDate), month(endDate)
) d
inner join (
select
	 six_month,
	endDate,
	yearMonth,
	(
select count(*) from (
select 
x.patient,
x.dob,
max(concat(x.eDate,x.weight,x.height)) as lastEnc,
left(max(concat(x.eDate,x.weight,x.height)),10) as lastEncDate,
substring(max(concat(x.eDate,x.weight,x.height)),11,1) as lastWeight,
substring(max(concat(x.eDate,x.weight,x.height)),12,1) as lastHeight
from 
(
select
	e.patient_id as patient,
	p.birthdate as dob,
	date(e.encounter_datetime) as eDate,
	max(if(o.concept_id=5089 and o.value_numeric is not null,1, 0)) as weight,
	max(if(o.concept_id=5090 and o.value_numeric is not null,1, 0)) as height
from encounter e
inner join person p on e.patient_id=p.person_id and p.voided=0
left outer join obs o on e.encounter_id = o.encounter_id and o.concept_id in (5089, 5090) and o.voided=0
where e.encounter_type in (7) 
group by e.patient_id, e.encounter_id  
order by e.patient_id, e.encounter_datetime) x
group by x.patient
) n
where n.lastEncDate  between six_month and endDate and lastWeight=1 and lastHeight=1 and (datediff(endDate, dob) / 365.25)>=15
) as monthlyCount
from month_dates 
group by year(endDate), month(endDate)

) nm on nm.yearMonth = d.yearMonth
order by 1
)

union
-- 1.12 indicator
-- select '1.1' as Indicator, d.cohort_month as Period, n.sixMonthsTotal as Numerator, d.ActiveInCareTotal as Denominator
(
select '1.12' as Indicator, n.cohort_month as Period, n.sixMonthsTotal as Numerator, d.sixMonthsTotal as Denominator
from
(
select
	 six_month,
	endDate,
	yearMonth as cohort_month,
	(
		-- 
		select count(distinct ec.patient_id)
		from encounter ec
		join person p on p.person_id = ec.patient_id
		and p.voided = 0 and ec.voided = 0 
		and p.gender = 'F' -- female

		join patient pa on pa.patient_id = ec.patient_id
		and pa.voided = 0

		join obs o on o.person_id = ec.patient_id
		and o.concept_id in (374,5272) -- family planning, pregnancy
		and if(o.concept_id=5272, if(o.value_coded =(1066),1,0),0) = 0 -- non-pregnant
		and o.voided = 0
		join patient_program pp on pp.patient_id = ec.patient_id and pp.voided = 0 and pp.program_id=2
		left outer join 
		(
			select person_id, mid(max(concat(tca, visit_date)),11) as visit_date,
			left(max(concat(tca, visit_date)),10) as tca
			from (
			select person_id, date(mid(max(concat(obs_datetime,value_datetime)),20)) as tca,
			date(left(max(concat(obs_datetime,value_datetime)),19)) as visit_date
			from obs 
			where voided =0 and concept_id = 5096
			group by person_id, date(obs_datetime))x
			group by person_id 
		)lft on lft.person_id = ec.patient_id and lft.visit_date<=GREATEST(LAST_DAY((select max(ec.encounter_datetime))),0)
		left outer join (
			-- subquery to transfer out and death status
			select 
			o.person_id,
			ifnull(max(if(o.concept_id=1543, o.value_datetime,null)), '') as date_died,
			ifnull(max(if(o.concept_id=160649, o.value_datetime,null)), '') as to_date,
			ifnull(max(if(o.concept_id=161555, o.value_coded,null)), '') as dis_reason
			from obs o
			where o.concept_id in (1543, 161555, 160649) and o.voided = 0 -- concepts for date_died, date_transferred out and discontinuation reason
			group by person_id
		) active_status on active_status.person_id =ec.patient_id
		where ec.encounter_datetime between six_month and endDate
		and if(date_died <= endDate,1,0) =0 and if(to_date <= endDate,1,0)=0
		and if(timestampdiff(day,lft.tca, endDate) <= 90, 0,1) = 0
        and timestampdiff(year,p.birthdate, endDate) < 15
	) as sixMonthsTotal
from month_dates 
group by year(endDate), month(endDate) 
) d
join
	
(select
	 six_month,
	endDate,
	yearMonth as cohort_month,
	(
		-- 
		select count(distinct ec.patient_id)
		from encounter ec
		join person p on p.person_id = ec.patient_id
		and p.voided = 0 and ec.voided = 0 
		and p.gender = 'F' -- female

		join patient pa on pa.patient_id = ec.patient_id
		and pa.voided = 0

		join obs o on o.person_id = ec.patient_id
		and o.concept_id in (374,5272) -- family planning, pregnancy
		and if(o.concept_id=374, if(o.value_coded not in(5277, 159524, 1107, 1175, 5622),1,0),0) = 1 -- only modern contraceptive
		and if(o.concept_id=5272, if(o.value_coded =(1066),1,0),0) = 0 -- not pregnant
		and o.voided = 0
		join patient_program pp on pp.patient_id = ec.patient_id and pp.voided = 0 and pp.program_id=2
		left outer join 
		(
			select person_id, mid(max(concat(tca, visit_date)),11) as visit_date,
			left(max(concat(tca, visit_date)),10) as tca
			from (
			select person_id, date(mid(max(concat(obs_datetime,value_datetime)),20)) as tca,
			date(left(max(concat(obs_datetime,value_datetime)),19)) as visit_date
			from obs 
			where voided =0 and concept_id = 5096
			group by person_id, date(obs_datetime))x
			group by person_id 
		)lft on lft.person_id = ec.patient_id and lft.visit_date<=GREATEST(LAST_DAY((select max(ec.encounter_datetime))),0)
		left outer join (
			-- subquery to transfer out and death status
			select 
			o.person_id,
			ifnull(max(if(o.concept_id=1543, o.value_datetime,null)), '') as date_died,
			ifnull(max(if(o.concept_id=160649, o.value_datetime,null)), '') as to_date,
			ifnull(max(if(o.concept_id=161555, o.value_coded,null)), '') as dis_reason
			from obs o
			where o.concept_id in (1543, 161555, 160649) and o.voided = 0 -- concepts for date_died, date_transferred out and discontinuation reason
			group by person_id
		) active_status on active_status.person_id =ec.patient_id
		where ec.encounter_datetime between six_month and endDate
		and if(date_died <= endDate,1,0) =0 and if(to_date <= endDate,1,0)=0
		and timestampdiff(year,p.birthdate, endDate) < 15
	) as sixMonthsTotal
from month_dates 
group by year(endDate), month(endDate) 
) n on n.cohort_month = d.cohort_month
order by 1
)
