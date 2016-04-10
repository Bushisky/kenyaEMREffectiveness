-- =============================================================================================================================================================
-- 				|||	Completed query for Enrollments in Care 

-- =============================================================================================================================================================
select 'indicator 1' as ind, date_format(enroll_date, '%Y-%m') as cohort_month,
-- pmtct
count(if(gender='F' and timestampdiff(year,birthdate, enroll_date) <=14 and entry_point_text ='PMTCT',person_id,null)) as 'K1-1-FP',
count(if(gender='F' and timestampdiff(year,birthdate, enroll_date) >14 and entry_point_text ='PMTCT',person_id,null)) as 'K1-1-FA',
count(if(gender='F' and entry_point_text ='PMTCT',person_id,null)) as 'K1-1-F',
-- vct
count(if(gender='F' and timestampdiff(year,birthdate, enroll_date) <=14 and entry_point_text ='VCT',person_id,null)) as 'K1-2-FP',
count(if(gender='M' and timestampdiff(year,birthdate, enroll_date) <=14 and entry_point_text ='VCT',person_id,null)) as 'K1-2-MP',
count(if(gender='F' and timestampdiff(year,birthdate, enroll_date) >14 and entry_point_text ='VCT',person_id,null)) as 'K1-2-FA',
count(if(gender='M' and timestampdiff(year,birthdate, enroll_date) >14 and entry_point_text ='VCT',person_id,null)) as 'K1-2-MA',
count(if(gender='F' and entry_point_text ='VCT',person_id,null)) as 'K1-2-F',
count(if(gender='M' and entry_point_text ='VCT',person_id,null)) as 'K1-2-A',
count(if(entry_point_text ='VCT',person_id,null)) as 'K1-2-T',
-- TB
count(if(gender='F' and timestampdiff(year,birthdate, enroll_date) <=14 and entry_point_text ='TB',person_id,null)) as 'K1-3-FP',
count(if(gender='M' and timestampdiff(year,birthdate, enroll_date) <=14 and entry_point_text ='TB',person_id,null)) as 'K1-3-MP',
count(if(gender='F' and timestampdiff(year,birthdate, enroll_date) >14 and entry_point_text ='TB',person_id,null)) as 'K1-3-FA',
count(if(gender='M' and timestampdiff(year,birthdate, enroll_date) >14 and entry_point_text ='TB',person_id,null)) as 'K1-3-MA',
count(if(gender='F' and entry_point_text ='TB',person_id,null)) as 'K1-3-F',
count(if(gender='M' and entry_point_text ='TB',person_id,null)) as 'K1-3-A',
count(if(entry_point_text ='TB',person_id,null)) as 'K1-3-T',

-- Inpatient
count(if(gender='F' and timestampdiff(year,birthdate, enroll_date) <=14 and entry_point_text ='Inpatient',person_id,null)) as 'K1-4-FP',
count(if(gender='M' and timestampdiff(year,birthdate, enroll_date) <=14 and entry_point_text ='Inpatient',person_id,null)) as 'K1-4-MP',
count(if(gender='F' and timestampdiff(year,birthdate, enroll_date) >14 and entry_point_text ='Inpatient',person_id,null)) as 'K1-4-FA',
count(if(gender='M' and timestampdiff(year,birthdate, enroll_date) >14 and entry_point_text ='Inpatient',person_id,null)) as 'K1-4-MA',
count(if(gender='F' and entry_point_text ='Inpatient',person_id,null)) as 'K1-4-F',
count(if(gender='M' and entry_point_text ='Inpatient',person_id,null)) as 'K1-4-A',
count(if(entry_point_text ='Inpatient',person_id,null)) as 'K1-4-T',
-- other
count(if(gender='F' and timestampdiff(year,birthdate, enroll_date) <=14 and entry_point_text ='other',person_id,null)) as 'K1-6-FP',
count(if(gender='M' and timestampdiff(year,birthdate, enroll_date) <=14 and entry_point_text ='other',person_id,null)) as 'K1-6-MP',
count(if(gender='F' and timestampdiff(year,birthdate, enroll_date) >14 and entry_point_text ='other',person_id,null)) as 'K1-6-FA',
count(if(gender='M' and timestampdiff(year,birthdate, enroll_date) >14 and entry_point_text ='other',person_id,null)) as 'K1-6-MA',
count(if(gender='F' and entry_point_text ='other',person_id,null)) as 'K1-6-F',
count(if(gender='M' and entry_point_text ='other',person_id,null)) as 'K1-6-A',
count(if(entry_point_text ='other',person_id,null)) as 'K1-6-T',
-- sub totals
count(if(gender='F' and timestampdiff(year,birthdate, enroll_date) <=14,person_id,null)) as 'K1-7-FP',
count(if(gender='M' and timestampdiff(year,birthdate, enroll_date) <=14,person_id,null)) as 'K1-7-MP',
count(if(gender='F' and timestampdiff(year,birthdate, enroll_date) >14,person_id,null)) as 'K1-7-FA',
count(if(gender='M' and timestampdiff(year,birthdate, enroll_date) >14,person_id,null)) as 'K1-7-MA',
count(distinct if(gender='F',person_id,null)) as 'K1-7-F',
count(distinct if(gender='M',person_id,null)) as 'K1-7-A',
count(distinct person_id) as 'K1-7-T'
from (
select o.person_id,p.gender, p.birthdate, min(date_format(o.obs_datetime, '%Y-%m')) as enrolled_month, 
min(date(o.obs_datetime)) as enroll_date,
min(if(o.concept_id=160534,o.value_datetime, null)) as ti_date,
min(if(o.concept_id=160540,case o.value_coded
when 5622 then 'other'
when 160538 then 'PMTCT'
when 160539 then 'VCT'
when 160542 then 'other'
when 160563 then 'TI'
when 160536 then 'Inpatient'
when 160537 then 'Inpatient'
when 162050 then 'other'
when 160631 then 'other'
when 160551 then 'other'
when 160541 then 'TB'
else 'other'
end
, null)) as entry_point_text
from obs o
join person p on p.person_id=o.person_id and p.voided=0
where o.concept_id in (160540,160534) and o.voided=0 -- and o.value_coded not in (160563) -- ignore TIs
group by o.person_id) x
group by year(enroll_date), month(enroll_date) 
order by year(enroll_date), month(enroll_date);

-- ============================================================================
-- Cummulative enrollments
-- ============================================================================
select 'indicator 2' as ind,
-- sub totals
count(distinct if(gender='F' and timestampdiff(year,birthdate, enroll_date) <=14,person_id,null)) as 'K2-FP',
count(distinct if(gender='M' and timestampdiff(year,birthdate, enroll_date) <=14,person_id,null)) as 'K2-MP',
count(distinct if(gender='F' and timestampdiff(year,birthdate, enroll_date) >14,person_id,null)) as 'K2-FA',
count(distinct if(gender='M' and timestampdiff(year,birthdate, enroll_date) >14,person_id,null)) as 'K2-MA',
count(distinct if(gender='F',person_id,null)) as 'K2-F',
count(distinct if(gender='M',person_id,null)) as 'K2-A',
count(distinct person_id) as 'K2-T'
from (
select o.person_id,p.gender, p.birthdate, min(date_format(o.obs_datetime, '%Y-%m')) as enrolled_month, 
min(date(o.obs_datetime)) as enroll_date,
min(if(o.concept_id=160534,o.value_datetime, null)) as ti_date,
min(if(o.concept_id=160540,case o.value_coded
when 5622 then 'other'
when 160538 then 'PMTCT'
when 160539 then 'VCT'
when 160542 then 'other'
when 160563 then 'TI'
when 160536 then 'Inpatient'
when 160537 then 'Inpatient'
when 162050 then 'other'
when 160631 then 'other'
when 160551 then 'other'
when 160541 then 'TB'
else 'other'
end
, null)) as entry_point_text
from obs o
join person p on p.person_id=o.person_id and p.voided=0
where o.concept_id in (160540,160534) and o.voided=0 -- and o.value_coded not in (160563) -- ignore TIs
group by o.person_id) x
-- ============== End of the Query ============================================

-- ==================================== End of enrollments query ==============
-- get Patient WHO stage function 
-- ============================================================================
CREATE DEFINER=`root`@`localhost` FUNCTION `getWhoStage`(patient_id integer, endDate Date) RETURNS int(11)
BEGIN
	DECLARE whostage Integer;
	SET whostage =0;
    select who into whostage from (
		select person_id, case mid(max(concat(obs_datetime, o.value_coded )),20)
        when 1204 then 1
when 1220 then 1
when 1205 then 2
when 1221 then 2
when 1206 then 3
when 1222 then 3
when 1207 then 4
when 1223 then 4
        
        end as who,
        max(concat(obs_datetime,o.value_coded )) as test
		from obs o
		where o.voided =0 and o.concept_id in (160553,5356)
		and date(obs_datetime)<= date(endDate) and o.person_id in (patient_id)
		group by o.person_id
 )x;
RETURN whostage;
END
-- =============================== End of function definition =================
-- STARTING ART
-- ============================================================================
select 'indicator 3' as ind, date_format(art_startDate, '%Y-%m') as cohort_month,
-- who stage 1
count(if(gender='F' and timestampdiff(year,birthdate, art_startDate) <=14 and whostage =1,person_id,null)) as 'K3-1-FP',
count(if(gender='M' and timestampdiff(year,birthdate, art_startDate) <=14 and whostage =1,person_id,null)) as 'K3-1-MP',
count(if(gender='F' and timestampdiff(year,birthdate, art_startDate) >14 and whostage =1,person_id,null)) as 'K3-1-FA',
count(if(gender='M' and timestampdiff(year,birthdate, art_startDate) >14 and whostage =1,person_id,null)) as 'K3-1-MA',
count(if(gender='F' and whostage =1,person_id,null)) as 'K3-1-F',
count(if(gender='M' and whostage =1,person_id,null)) as 'K3-1-A',
count(if(whostage =1,person_id,null)) as 'K3-1-T',

-- who stage 2
count(if(gender='F' and timestampdiff(year,birthdate, art_startDate) <=14 and whostage =2,person_id,null)) as 'K3-2-FP',
count(if(gender='M' and timestampdiff(year,birthdate, art_startDate) <=14 and whostage =2,person_id,null)) as 'K3-2-MP',
count(if(gender='F' and timestampdiff(year,birthdate, art_startDate) >14 and whostage =2,person_id,null)) as 'K3-2-FA',
count(if(gender='M' and timestampdiff(year,birthdate, art_startDate) >14 and whostage =2,person_id,null)) as 'K3-2-MA',
count(if(gender='F' and whostage =2,person_id,null)) as 'K3-2-F',
count(if(gender='M' and whostage =2,person_id,null)) as 'K3-2-A',
count(if(whostage =2,person_id,null)) as 'K3-2-T',

-- who stage 3
count(if(gender='F' and timestampdiff(year,birthdate, art_startDate) <=14 and whostage =3,person_id,null)) as 'K3-3-FP',
count(if(gender='M' and timestampdiff(year,birthdate, art_startDate) <=14 and whostage =3,person_id,null)) as 'K3-3-MP',
count(if(gender='F' and timestampdiff(year,birthdate, art_startDate) >14 and whostage =3,person_id,null)) as 'K3-3-FA',
count(if(gender='M' and timestampdiff(year,birthdate, art_startDate) >14 and whostage =3,person_id,null)) as 'K3-3-MA',
count(if(gender='F' and whostage =3,person_id,null)) as 'K3-3-F',
count(if(gender='M' and whostage =3,person_id,null)) as 'K3-3-A',
count(if(whostage =3,person_id,null)) as 'K3-3-T',

-- who stage 4
count(if(gender='F' and timestampdiff(year,birthdate, art_startDate) <=14 and whostage =4,person_id,null)) as 'K3-4-FP',
count(if(gender='M' and timestampdiff(year,birthdate, art_startDate) <=14 and whostage =4,person_id,null)) as 'K3-4-MP',
count(if(gender='F' and timestampdiff(year,birthdate, art_startDate) >14 and whostage =4,person_id,null)) as 'K3-4-FA',
count(if(gender='M' and timestampdiff(year,birthdate, art_startDate) >14 and whostage =4,person_id,null)) as 'K3-4-MA',
count(if(gender='F' and whostage =4,person_id,null)) as 'K3-4-F',
count(if(gender='M' and whostage =4,person_id,null)) as 'K3-4-A',
count(if(whostage =4,person_id,null)) as 'K3-4-T',

-- who stage unstaged
count(if(gender='F' and timestampdiff(year,birthdate, art_startDate) <=14 and whostage =0,person_id,null)) as 'K3-0-FP',
count(if(gender='M' and timestampdiff(year,birthdate, art_startDate) <=14 and whostage =0,person_id,null)) as 'K3-0-MP',
count(if(gender='F' and timestampdiff(year,birthdate, art_startDate) >14 and whostage =0,person_id,null)) as 'K3-0-FA',
count(if(gender='M' and timestampdiff(year,birthdate, art_startDate) >14 and whostage =0,person_id,null)) as 'K3-0-MA',
count(if(gender='F' and whostage =0,person_id,null)) as 'K3-0-F',
count(if(gender='M' and whostage =0,person_id,null)) as 'K3-0-A',
count(if(whostage =0,person_id,null)) as 'K3-0-T',

-- sub totals
count(if(gender='F' and timestampdiff(year,birthdate, art_startDate) <=14,person_id,null)) as 'K3-5-FP',
count(if(gender='M' and timestampdiff(year,birthdate, art_startDate) <=14,person_id,null)) as 'K3-5-MP',
count(if(gender='F' and timestampdiff(year,birthdate, art_startDate) >14,person_id,null)) as 'K3-5-FA',
count(if(gender='M' and timestampdiff(year,birthdate, art_startDate) >14,person_id,null)) as 'K3-5-MA',
count(distinct if(gender='F',person_id,null)) as 'K3-5-F',
count(distinct if(gender='M',person_id,null)) as 'K3-5-A',
count(distinct person_id) as 'K3-5-T'
from(select patient_id,coalesce(active_status.ti_art_startDate, min(start_date))  as art_startDate, p.gender, p.birthdate,
date_format(min(o.start_date), '%Y-%m') as art_start_month,
getWhoStage(patient_id, min(start_date)) as whoStage,
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
where coalesce(active_status.ti_art_startDate,active_status.ti_Date) is null
group by patient_id) x
group by year(art_startDate), month(art_startDate) 
order by year(art_startDate), month(art_startDate);
-- =================== end of the query =======================================

-- ============================================================================
-- Cummulative started 
-- ============================================================================
select 'indicator 4' as ind,
-- sub totals
count(distinct if(gender='F' and timestampdiff(year,birthdate, art_startDate) <=14,person_id,null)) as 'K4-FP',
count(distinct if(gender='M' and timestampdiff(year,birthdate, art_startDate) <=14,person_id,null)) as 'K4-MP',
count(distinct if(gender='F' and timestampdiff(year,birthdate, art_startDate) >14,person_id,null)) as 'K4-FA',
count(distinct if(gender='M' and timestampdiff(year,birthdate, art_startDate) >14,person_id,null)) as 'K4-MA',
count(distinct if(gender='F',person_id,null)) as 'K4-F',
count(distinct if(gender='M',person_id,null)) as 'K4-A',
count(distinct person_id) as 'K4-T'
from(select patient_id,coalesce(active_status.ti_art_startDate, min(start_date))  as art_startDate, p.gender, p.birthdate,
date_format(min(o.start_date), '%Y-%m') as art_start_month,
getWhoStage(patient_id, min(start_date)) as whoStage,
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
where coalesce(active_status.ti_art_startDate,active_status.ti_Date) is null
group by patient_id) x
-- ======================== end of the query ==================================

-- ====== Temporary table for cohort filters ==================================
drop table if exists ke.dates;
create table ke.dates (endDate datetime, startDate datetime);
insert into dates (endDate, startDate)
SELECT LAST_DAY(e.encounter_datetime) as endDate,
date_sub(date_add(LAST_DAY(e.encounter_datetime),interval 1 DAY),interval 6 MONTH) as startDate
from ke.encounter e
group by year(e.encounter_datetime), month(e.encounter_datetime) 
order by year(e.encounter_datetime), month(e.encounter_datetime);

-- ====================== end of temporary table
-- ============================================================================
-- ON Prophylaxis (CTX and Fluconazole)
-- ============================================================================

select endDate, date_format(endDate,'%M-%Y')  as report_month,
-- ctx
count(distinct if(gender='F' and fluconazole=0 and timestampdiff(year,birthdate, endDate) <=14,person_id,null)) as 'K8-1-FP',
count(distinct if(gender='M' and fluconazole=0 and timestampdiff(year,birthdate, endDate) <=14,person_id,null)) as 'K8-1-MP',
count(distinct if(gender='F' and fluconazole=0 and timestampdiff(year,birthdate, endDate) >14,person_id,null)) as 'K8-1-FA',
count(distinct if(gender='M' and fluconazole=0 and timestampdiff(year,birthdate, endDate) >14,person_id,null)) as 'K8-1-MA',
count(distinct if(gender='F' and fluconazole=0 ,person_id,null)) as 'K8-1-F',
count(distinct if(gender='M' and fluconazole=0 ,person_id,null)) as 'K8-1-A',
count(distinct if(fluconazole=0,person_id,null)) as 'K8-1-T',
-- fluconazole
count(distinct if(gender='F' and fluconazole=1 and timestampdiff(year,birthdate, endDate) <=14,person_id,null)) as 'K8-2-FP',
count(distinct if(gender='M' and fluconazole=1 and timestampdiff(year,birthdate, endDate) <=14,person_id,null)) as 'K8-2-MP',
count(distinct if(gender='F' and fluconazole=1 and timestampdiff(year,birthdate, endDate) >14,person_id,null)) as 'K8-2-FA',
count(distinct if(gender='M' and fluconazole=1 and timestampdiff(year,birthdate, endDate) >14,person_id,null)) as 'K8-2-MA',
count(distinct if(gender='F' and fluconazole=1 ,person_id,null)) as 'K8-2-F',
count(distinct if(gender='M' and fluconazole=1 ,person_id,null)) as 'K8-2-A',
count(distinct if(fluconazole=1,person_id,null)) as 'K8-2-T',
-- sub total
count(distinct if(gender='F'  and timestampdiff(year,birthdate, endDate) <=14,person_id,null)) as 'K8-3-FP',
count(distinct if(gender='M'  and timestampdiff(year,birthdate, endDate) <=14,person_id,null)) as 'K8-3-MP',
count(distinct if(gender='F'  and timestampdiff(year,birthdate, endDate) >14,person_id,null)) as 'K8-3-FA',
count(distinct if(gender='M'  and timestampdiff(year,birthdate, endDate) >14,person_id,null)) as 'K8-3-MA',
count(distinct if(gender='F', person_id,null)) as 'K8-3-F',
count(distinct if(gender='M', person_id,null)) as 'K8-3-A',
count(distinct person_id) as 'K8-3-T'
	from dates t1
	join (select o.person_id,p.gender, p.birthdate, date_format(o.obs_datetime, '%Y-%m') as ctx_month, 
    max(date(o.obs_datetime)) as ctx_date,
    max(if(o.value_coded=76488,1,0)) as fluconazole,
active_status.*
from obs o
join person p on p.person_id=o.person_id and p.voided=0
join patient_program pp on pp.patient_id = o.person_id and pp.voided = 0 and pp.program_id=2
left outer join (
-- subquery to transfer out and death status
select 
o.person_id as pid,
max(if(o.concept_id=1543, o.value_datetime,null)) as date_died,
max(if(o.concept_id=160649, o.value_datetime,null)) as to_date,
max(if(o.concept_id=161555, o.value_coded,null)) as dis_reason
from obs o
where o.concept_id in (1543, 161555, 160649) and o.voided = 0 -- concepts for date_died, date_transferred out and discontinuation reason
group by person_id
) active_status on active_status.pid =o.person_id
where o.concept_id in (162229, 1282) and o.voided=0 and o.value_coded in (1065,105281,74250,76488)
group by o.person_id, month(o.obs_datetime)
) t2 on t2.ctx_date between date_sub(endDate, interval 3 month) and endDate
	and (coalesce(date_died,to_date)  is null or coalesce(date_died, to_date)  = '' or coalesce(date_died,to_date) >endDate)
group by endDate;

-- ========================== Endo of Query ===================================

-- ============================================================================
-- Curnent on ART
-- ============================================================================

select endDate, date_format(endDate,'%M-%Y')  as report_month,
-- Pregnant on arvs
count(distinct if(gender='F' and pregnancy_status=1 and art_startDate is not null and timestampdiff(year,birthdate, endDate) <=14,person_id,null)) as 'K5-1-FP',
count(distinct if(gender='F' and pregnancy_status=1 and art_startDate is not null and timestampdiff(year,birthdate, endDate) >14,person_id,null)) as 'K5-1-FA',
count(distinct if(gender='F' and pregnancy_status=1 and art_startDate is not null, person_id,null)) as 'K5-1-F',

-- All others on arvs
count(distinct if(gender='F' and pregnancy_status=0 and art_startDate is not null and timestampdiff(year,birthdate, endDate) <=14,person_id,null)) as 'K5-2-FP',
count(distinct if(gender='M' and pregnancy_status=0 and art_startDate is not null and timestampdiff(year,birthdate, endDate) <=14,person_id,null)) as 'K5-2-MP',
count(distinct if(gender='F' and pregnancy_status=0 and art_startDate is not null and timestampdiff(year,birthdate, endDate) >14,person_id,null)) as 'K5-2-FA',
count(distinct if(gender='M' and pregnancy_status=0 and art_startDate is not null and timestampdiff(year,birthdate, endDate) >14,person_id,null)) as 'K5-2-MA',
count(distinct if(gender='F' and pregnancy_status=0 and art_startDate is not null, person_id,null)) as 'K5-2-F',
count(distinct if(gender='M' and pregnancy_status=0 and art_startDate is not null, person_id,null)) as 'K5-2-A',
count(distinct if(pregnancy_status=0 and art_startDate is not null, person_id,null)) as 'K5-2-T',
 -- sub totals
count(distinct if(gender='F' and art_startDate is not null and timestampdiff(year,birthdate, endDate) <=14,person_id,null)) as 'K5-3-FP',
count(distinct if(gender='M' and art_startDate is not null and timestampdiff(year,birthdate, endDate) <=14,person_id,null)) as 'K5-3-MP',
count(distinct if(gender='F' and art_startDate is not null and timestampdiff(year,birthdate, endDate) >14,person_id,null)) as 'K5-3-FA',
count(distinct if(gender='M' and art_startDate is not null and timestampdiff(year,birthdate, endDate) >14,person_id,null)) as 'K5-3-MA',
count(distinct if(gender='F' and art_startDate is not null, person_id,null)) as 'K5-3-F',
count(distinct if(gender='M' and art_startDate is not null, person_id,null)) as 'K5-3-A',
count(distinct if(art_startDate is not null, person_id,null)) as 'K5-3-T'
	from dates t1
	join (select o.person_id,p.gender, p.birthdate, date_format(o.obs_datetime, '%Y-%m') as ctx_month, 
    max(date(o.obs_datetime)) as visit_date,
coalesce(active_status.ti_art_startDate, min(art_status.start_date))as art_startDate,
max(if(o.concept_id in(5272), case o.value_coded 
when 1066 then 0
when 1065 then 1
else 0 end,null)) as pregnancy_status,
active_status.*
from obs o
join person p on p.person_id=o.person_id and p.voided=0
join patient_program pp on pp.patient_id = o.person_id and pp.voided = 0 and pp.program_id=2
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
) art_status on art_status.patient_id = o.person_id
left outer join (
-- subquery to transfer out and death status
select 
o.person_id as pid,
max(if(o.concept_id=1543, o.value_datetime,null)) as date_died,
max(if(o.concept_id=160649, o.value_datetime,null)) as to_date,
max(if(o.concept_id=161555, o.value_coded,null)) as dis_reason,
min(if(o.concept_id=159599, o.value_datetime,null)) as ti_art_startDate,
min(if(o.concept_id=160534, o.value_datetime,null)) as ti_Date
from obs o
where o.concept_id in (1543, 161555, 160649, 159599, 160534) and o.voided = 0 -- concepts for date_died, date_transferred out and discontinuation reason
group by person_id
) active_status on active_status.pid =o.person_id
where  o.voided=0
group by o.person_id, month(o.obs_datetime)) t2 on t2.visit_date between date_sub(endDate, interval 3 month) and endDate
	and (coalesce(date_died,to_date)  is null or coalesce(date_died, to_date)  = '' or coalesce(date_died,to_date) >endDate)
group by endDate;

-- ===================== end of query =========================================

-- ============================================================================
-- Elibility query
-- ============================================================================
select endDate, date_format(endDate,'%M-%Y')  as report_month,
-- sub total
count(distinct if(gender='F'  and timestampdiff(year,birthdate, endDate) <=14,person_id,null)) as 'K6-FP',
count(distinct if(gender='M'  and timestampdiff(year,birthdate, endDate) <=14,person_id,null)) as 'K6-MP',
count(distinct if(gender='F'  and timestampdiff(year,birthdate, endDate) >14,person_id,null)) as 'K6-FA',
count(distinct if(gender='M'  and timestampdiff(year,birthdate, endDate) >14,person_id,null)) as 'K6-MA',
count(distinct if(gender='F', person_id,null)) as 'K6-F',
count(distinct if(gender='M', person_id,null)) as 'K6-A',
count(distinct person_id) as 'K6-T'
	from dates t1
	join (select x.person_id, 
if(date(x.art_startDate)>= date(x.pregnancy_date) or x.art_startDate is null, x.pregnancy_date,
		if((who_stage in (1206,1207) and  date(x.art_startDate)>=date(x.who_date)) or x.art_startDate is null,who_date,
        if((cd4_count<=500 and  date(x.art_startDate)>=date(x.cd4_date)) or x.art_startDate is null,cd4_date,
        if((risk_factor=1 and  date(x.art_startDate)>=date(x.risk_factor_date)) or x.art_startDate is null,risk_factor_date,
        if((tb_status=1 and  date(x.art_startDate)>=date(x.tb_date)) or x.art_startDate is null,tb_date,
        if((pcr=1 and  date(x.art_startDate)>=date(x.pcr_date)) or x.art_startDate is null,pcr_date,
null)))))) as date_eligible,
x.art_startDate,
x.gender,
x.birthdate,
x.date_died,
x.to_date
from (select o.person_id,p.gender, p.birthdate, date_format(o.obs_datetime, '%Y-%m') as ctx_month, 
    max(date(o.obs_datetime)) as visit_date,
coalesce(active_status.ti_art_startDate, min(art_status.start_date))as art_startDate,
max(if(o.concept_id in(5272), case o.value_coded 
when 1066 then 0
when 1065 then 1
else 0 end,null)) as pregnancy_status,
max(if(o.concept_id in(5272), case o.value_coded 
when 1066 then null
when 1065 then o.obs_datetime
else 0 end,null)) as pregnancy_date,

mid(max(concat(o.obs_datetime,if (o.concept_id = 160581 and o.value_coded = 6096, 1,null))),20) as risk_factor,
mid(max(concat(o.obs_datetime,if (o.concept_id = 160581 and o.value_coded = 6096, o.obs_datetime,null))),20) as risk_factor_date,
mid(max(concat(o.obs_datetime,if (o.concept_id in(1030,844) and o.value_coded in (1301,703), 1,null))),20) as pcr,
mid(max(concat(o.obs_datetime,if (o.concept_id = 160581 and o.value_coded = 6096, o.obs_datetime,null))),20) as pcr_date,
mid(max(concat(o.obs_datetime, if(o.concept_id = 1659 and o.value_coded in (1662, 16610), 1,null))),20) as tb_status,
left(max(concat(o.obs_datetime, if(o.concept_id = 1659 and o.value_coded in (1662, 16610), 1,null))),19) as tb_date,
mid(max(concat(o.obs_datetime, if(o.concept_id = 5497, o.value_numeric,null))),20) as cd4_count,
left(max(concat(o.obs_datetime, if(o.concept_id = 5497, o.value_numeric,null))),19) as cd4_date,
mid(max(concat(o.obs_datetime, if(o.concept_id in (160553,5356), 
o.value_coded, null))),20) as who_stage,
left(max(concat(o.obs_datetime, if(o.concept_id in (160553,5356), o.value_coded, null))),19) as who_date,
active_status.*
from obs o
join person p on p.person_id=o.person_id and p.voided=0
join patient_program pp on pp.patient_id = o.person_id and pp.voided = 0 and pp.program_id in (2)
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
) art_status on art_status.patient_id = o.person_id
left outer join (
-- subquery to transfer out and death status
select 
o.person_id as pid,
max(if(o.concept_id=1543, o.value_datetime,null)) as date_died,
coalesce(max(if(o.concept_id=160649, o.value_datetime,null)),max(if(o.concept_id=161555, o.value_datetime,null)))  as to_date,
max(if(o.concept_id=161555, o.value_coded,null)) as dis_reason,
min(if(o.concept_id=159599, o.value_datetime,null)) as ti_art_startDate,
min(if(o.concept_id=160534, o.value_datetime,null)) as ti_Date
from obs o
where o.concept_id in (1543, 161555, 160649, 159599, 160534) and o.voided = 0 -- concepts for date_died, date_transferred out and discontinuation reason
group by person_id
) active_status on active_status.pid =o.person_id
where  o.voided=0
group by o.person_id, month(o.obs_datetime)) x) t2 on t2.date_eligible between date_sub(endDate, interval 3 month) and endDate
	and (coalesce(date_died,to_date)  is null or coalesce(date_died, to_date)  = '' or coalesce(date_died,to_date) >endDate)
    and t2.date_eligible is not null
group by endDate;

-- ============================= End of the query =============================