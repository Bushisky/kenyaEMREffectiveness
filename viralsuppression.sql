select
	date_add(date_add(LAST_DAY(e.encounter_datetime),interval 1 DAY),interval -1 year) as startDate,
	LAST_DAY(e.encounter_datetime) as endDate,
	date_format(e.encounter_datetime, '%Y-%M') as yearMonth,
	(
select count(*) from (

select 
	sdate.patient, 
	sdate.date_art_start, 
	vlh.vlResult,
	vlh.vlDate,
	active_status.date_died,
	active_status.to_date 
from
(
select
od.patient_id as patient,
if(min(od.start_date) is not null 
	and if(o.concept_id=159599, min(o.value_datetime), null) is not null,
	least(min(od.start_date), if(o.concept_id=159599, min(o.value_datetime), null)),
	coalesce(min(od.start_date), if(o.concept_id=159599, min(o.value_datetime), null))) as date_art_start
from orders od
inner join concept_set cs on od.concept_id = cs.concept_id and cs.concept_set = 1085
left outer join obs o on o.person_id = od.patient_id and o.concept_id in (159599) and o.voided=0
where od.voided=0
group by patient
order by patient
) sdate
left outer join (
select
	o.person_id as patient,
	o.obs_datetime as vlDate,
	o.value_numeric as VL,
	concat(o.obs_datetime, o.value_numeric) as vlResult,
	mid(concat(o.obs_datetime, o.value_numeric), 20) as val
from obs o
where o.voided=0 and o.concept_id = 856
) vlh on vlh.patient = sdate.patient
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
) active_status on active_status.person_id =sdate.patient
where vlResult is not null
group by sdate.patient, vlh.vlDate
) vlTable
where vlTable.vlDate between startDate and endDate and datediff(endDate,vlTable.date_art_start) >= 185
group by vlTable.patient
having mid(max(vlTable.vlResult), 20) > 1000


) as monthlyCount
from encounter e
where e.voided =0 and e.encounter_datetime between '1980-01-01' and curdate()
group by year(e.encounter_datetime), month(e.encounter_datetime)
