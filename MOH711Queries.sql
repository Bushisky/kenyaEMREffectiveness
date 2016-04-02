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
