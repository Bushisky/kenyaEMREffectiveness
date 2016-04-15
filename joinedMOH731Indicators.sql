
(
select
'HV02-24' as Indicator,
date_format(e.encounter_datetime, '%Y-%M') as 'Month',
extract(year_month from e.encounter_datetime) as period,
(select count(*) from (
select 
p.person_id,
p.birthdate as dob,
datediff(o.obs_datetime, p.birthdate) as ageInDays,
o.obs_datetime as encDate,
o.concept_id,
o.value_coded,
max(if(o.concept_id = 162084 and o.value_coded= 162080, 1, 0)) as pcrIntitialTest,
max(if(o.concept_id = 844 and o.value_coded in (1300,1301,1303,1304), 1, 0)) as pcrTest
from person p
inner join obs o on o.person_id = p.person_id and o.concept_id in (162084, 844)
group by p.person_id, extract(year_month from o.obs_datetime)
) x
where extract(YEAR_MONTH from x.encDate) = period and x.pcrIntitialTest=1 and x.pcrTest = 1 and x.ageInDays <= 62
) monthlyCount
from encounter e
where e.voided =0 and e.encounter_datetime between '1980-01-01' and curdate()
group by year(e.encounter_datetime), month(e.encounter_datetime)
order by period

)

union

(

select
'HV02-25' as Indicator,
date_format(e.encounter_datetime, '%Y-%M') as 'Month',
extract(year_month from e.encounter_datetime) as period,
(select count(*) from (
select 
p.person_id,
p.birthdate as dob,
datediff(o.obs_datetime, p.birthdate) as ageInDays,
o.obs_datetime as encDate,
o.concept_id,
o.value_coded,
max(if(o.concept_id = 162084 and o.value_coded= 162080, 1, 0)) as pcrIntitialTest,
max(if(o.concept_id = 844 and o.value_coded in (1300,1301,1303,1304), 1, 0)) as pcrTest
from person p
inner join obs o on o.person_id = p.person_id and o.concept_id in (162084, 844)
group by p.person_id, extract(year_month from o.obs_datetime)
) x
where extract(YEAR_MONTH from x.encDate) = period and x.pcrIntitialTest=1 and x.pcrTest = 1 and x.ageInDays between 90 and 252
) monthlyCount
from encounter e
where e.voided =0 and e.encounter_datetime between '1980-01-01' and curdate()
group by year(e.encounter_datetime), month(e.encounter_datetime)
order by period
)

union


(

select
'HV02-25' as Indicator,
date_format(e.encounter_datetime, '%Y-%M') as 'Month',
extract(year_month from e.encounter_datetime) as period,
(select count(*) from (
select 
p.person_id,
p.birthdate as dob,
datediff(o.obs_datetime, p.birthdate) as ageInDays,
o.obs_datetime as encDate,
o.concept_id,
o.value_coded,
max(if(o.concept_id = 162084 and o.value_coded= 162080, 1, 0)) as pcrIntitialTest,
max(if(o.concept_id = 844 and o.value_coded in (1300,1301,1303,1304), 1, 0)) as pcrTest
from person p
inner join obs o on o.person_id = p.person_id and o.concept_id in (162084, 844)
group by p.person_id, extract(year_month from o.obs_datetime)
) x
where extract(YEAR_MONTH from x.encDate) = period and x.pcrIntitialTest=1 and x.pcrTest = 1 and x.ageInDays between 90 and 252
) monthlyCount
from encounter e
where e.voided =0 and e.encounter_datetime between '1980-01-01' and curdate()
group by year(e.encounter_datetime), month(e.encounter_datetime)
order by period

)

union

(

select
'HV02-26' as Indicator,
date_format(e.encounter_datetime, '%Y-%M') as 'Month',
extract(year_month from e.encounter_datetime) as period,
(select count(*) from (
select 
p.person_id,
p.birthdate as dob,
datediff(o.obs_datetime, p.birthdate) as ageInMonths,
o.obs_datetime encDate,
o.concept_id,
o.value_coded,
max(if(o.value_coded in (664,1304,703), 1, 0)) as serologyTest
from person p
inner join obs o on o.person_id = p.person_id and o.concept_id = 1040
group by p.person_id, extract(year_month from o.obs_datetime)
) x
where extract(YEAR_MONTH from x.encDate) = period and x.serologyTest=1 and x.ageInMonths between 270 and 366
) monthlyCount
from encounter e
where e.voided =0 and e.encounter_datetime between '1980-01-01' and curdate()
group by year(e.encounter_datetime), month(e.encounter_datetime)
order by period

) 


union

(

select
'HV02-27' as Indicator,
date_format(e.encounter_datetime, '%Y-%M') as 'Month',
extract(year_month from e.encounter_datetime) as period,
(select count(*) from (
select 
p.person_id,
p.birthdate as dob,
datediff(o.obs_datetime, p.birthdate) as ageInDays,
o.obs_datetime as encDate,
o.concept_id,
o.value_coded,
max(if(o.concept_id = 162084 and o.value_coded= 162080, 1, 0)) as pcrIntitialTest,
max(if(o.concept_id = 844 and o.value_coded in (1300,1301,1303,1304), 1, 0)) as pcrTest
from person p
inner join obs o on o.person_id = p.person_id and o.concept_id in (162084, 844)
group by p.person_id, extract(year_month from o.obs_datetime)
) x
where extract(YEAR_MONTH from x.encDate) = period and x.pcrIntitialTest=1 and x.pcrTest = 1 and x.ageInDays between 270 and 366
) monthlyCount
from encounter e
where e.voided =0 and e.encounter_datetime between '1980-01-01' and curdate()
group by year(e.encounter_datetime), month(e.encounter_datetime)
order by period

) 

union

(

select
'HV02-29' as Indicator,
date_format(e.encounter_datetime, '%Y-%M') as 'Month',
extract(year_month from e.encounter_datetime) as period,
(select count(*) from (
select 
p.person_id,
p.birthdate as dob,
datediff(o.obs_datetime, p.birthdate) as ageInDays,
o.obs_datetime as encDate,
o.concept_id,
o.value_coded,
max(if(o.concept_id = 162084 and o.value_coded= 162082, 1, 0)) as pcrPositiveTest,
max(if(o.concept_id = 844 and o.value_coded in (1300,1301,1303,1304), 1, 0)) as pcrTest
from person p
inner join obs o on o.person_id = p.person_id and o.concept_id in (162084, 844)
group by p.person_id, extract(year_month from o.obs_datetime)
) x
where extract(YEAR_MONTH from x.encDate) = period and x.pcrPositiveTest=1 and x.pcrTest = 1 and ageInDays <= 62
) monthlyCount
from encounter e
where e.voided =0 and e.encounter_datetime between '1980-01-01' and curdate()
group by year(e.encounter_datetime), month(e.encounter_datetime)
order by period

)

union

(

select
'HV02-30' as Indicator,
date_format(e.encounter_datetime, '%Y-%M') as 'Month',
extract(year_month from e.encounter_datetime) as period,
(select count(*) from (
select 
p.person_id,
p.birthdate as dob,
datediff(o.obs_datetime, p.birthdate) as ageInDays,
o.obs_datetime as encDate,
o.concept_id,
o.value_coded,
max(if(o.concept_id = 162084 and o.value_coded= 162082, 1, 0)) as pcrPositiveTest,
max(if(o.concept_id = 844 and o.value_coded in (1300,1301,1303,1304), 1, 0)) as pcrTest
from person p
inner join obs o on o.person_id = p.person_id and o.concept_id in (162084, 844)
group by p.person_id, extract(year_month from o.obs_datetime)
) x
where extract(YEAR_MONTH from x.encDate) = period and x.pcrPositiveTest=1 and x.pcrTest = 1 and x.ageInDays between 90 and 252
) monthlyCount
from encounter e
where e.voided =0 and e.encounter_datetime between '1980-01-01' and curdate()
group by year(e.encounter_datetime), month(e.encounter_datetime)
order by period

) 

union

(

select
'HV02-31' as Indicator,
date_format(e.encounter_datetime, '%Y-%M') as 'Month',
extract(year_month from e.encounter_datetime) as period,
(select count(*) from (
select 
p.person_id,
p.birthdate as dob,
datediff(o.obs_datetime, p.birthdate) as ageInDays,
o.obs_datetime as encDate,
o.concept_id,
o.value_coded,
max(if(o.concept_id = 162084 and o.value_coded= 162082, 1, 0)) as pcrPositiveTest,
max(if(o.concept_id = 844 and o.value_coded in (1300,1301,1303,1304), 1, 0)) as pcrTest
from person p
inner join obs o on o.person_id = p.person_id and o.concept_id in (162084, 844)
group by p.person_id, extract(year_month from o.obs_datetime)
) x
where extract(YEAR_MONTH from x.encDate) = period and x.pcrPositiveTest=1 and x.pcrTest = 1 and x.ageInDays between 270 and 366
) monthlyCount
from encounter e
where e.voided =0 and e.encounter_datetime between '1980-01-01' and curdate()
group by year(e.encounter_datetime), month(e.encounter_datetime)
order by period

) 

union

(

select
'HV02-33' as Indicator,
date_format(e.encounter_datetime, '%Y-%M') as 'Month',
extract(year_month from e.encounter_datetime) as period,
(select count(*) from (
select 
p.person_id,
p.birthdate as dob,
datediff(o.obs_datetime, p.birthdate) as ageInDays,
o.obs_datetime as encDate,
o.concept_id,
o.value_coded,
max(if(o.concept_id = 1151 and o.value_coded= 5526, 1, 0)) as exclusiveFeeding
from person p
inner join obs o on o.person_id = p.person_id and o.concept_id in (1151)
group by p.person_id, extract(year_month from o.obs_datetime)
) x
where extract(YEAR_MONTH from x.encDate) = period and x.exclusiveFeeding=1 and ageInDays between 179 and 215
) monthlyCount
from encounter e
where e.voided =0 and e.encounter_datetime between '1980-01-01' and curdate()
group by year(e.encounter_datetime), month(e.encounter_datetime)
order by period

) 

union 
(

select
'HV02-34' as Indicator,
date_format(e.encounter_datetime, '%Y-%M') as 'Month',
extract(year_month from e.encounter_datetime) as period,
(select count(*) from (
select 
p.person_id,
p.birthdate as dob,
datediff(o.obs_datetime, p.birthdate) as ageInDays,
o.obs_datetime as encDate,
o.concept_id,
o.value_coded,
max(if(o.concept_id = 1151 and o.value_coded= 1595, 1, 0)) as exclusiveReplacementFeeding
from person p
inner join obs o on o.person_id = p.person_id and o.concept_id in (1151)
group by p.person_id, extract(year_month from o.obs_datetime)
) x
where extract(YEAR_MONTH from x.encDate) = period and x.exclusiveReplacementFeeding=1 and ageInDays between 179 and 215
) monthlyCount
from encounter e
where e.voided =0 and e.encounter_datetime between '1980-01-01' and curdate()
group by year(e.encounter_datetime), month(e.encounter_datetime)
order by period

)

union

(

select
'HV02-35' as Indicator,
date_format(e.encounter_datetime, '%Y-%M') as 'Month',
extract(year_month from e.encounter_datetime) as period,
(select count(*) from (
select 
p.person_id,
p.birthdate as dob,
datediff(o.obs_datetime, p.birthdate) as ageInDays,
o.obs_datetime as encDate,
o.concept_id,
o.value_coded,
max(if(o.concept_id = 1151 and o.value_coded= 6046, 1, 0)) as mixedFeeding
from person p
inner join obs o on o.person_id = p.person_id and o.concept_id in (1151)
group by p.person_id, extract(year_month from o.obs_datetime)
) x
where extract(YEAR_MONTH from x.encDate) = period and x.mixedFeeding=1 and ageInDays between 179 and 215
) monthlyCount
from encounter e
where e.voided =0 and e.encounter_datetime between '1980-01-01' and curdate()
group by year(e.encounter_datetime), month(e.encounter_datetime)
order by period

)

union 

(

select
'HV02-36' as Indicator,
date_format(e.encounter_datetime, '%Y-%M') as 'Month',
extract(year_month from e.encounter_datetime) as period,
(select count(*) from (
select 
p.person_id,
p.birthdate as dob,
datediff(o.obs_datetime, p.birthdate) as ageInDays,
o.obs_datetime as encDate,
o.concept_id,
o.value_coded,
max(if(o.concept_id = 1151 and o.value_coded= 5526, 1, 0)) as exclusiveBreastFeeding,
max(if(o.concept_id = 1151 and o.value_coded= 1595, 1, 0)) as exclusiveReplacementFeeding,
max(if(o.concept_id = 1151 and o.value_coded= 6046, 1, 0)) as mixedFeeding
from person p
inner join obs o on o.person_id = p.person_id and o.concept_id in (1151)
group by p.person_id, extract(year_month from o.obs_datetime)
) x
where extract(YEAR_MONTH from x.encDate) = period and x.exclusiveBreastFeeding=1 and x.exclusiveReplacementFeeding=1 and x.mixedFeeding=1 and ageInDays between 179 and 215
) monthlyCount
from encounter e
where e.voided =0 and e.encounter_datetime between '1980-01-01' and curdate()
group by year(e.encounter_datetime), month(e.encounter_datetime)
order by period

)

union 

(

select
'HV02-37' as Indicator,
date_format(e.encounter_datetime, '%Y-%M') as 'Month',
extract(year_month from e.encounter_datetime) as period,
(select count(*) from (
select 
p.person_id,
p.birthdate as dob,
datediff(o.obs_datetime, p.birthdate) div 365.25 as ageInyears,
o.obs_datetime as encDate,
o.concept_id,
o.value_coded,
max(if(o.concept_id = 159941 and o.value_coded= 1065, 1, 0)) as pregnantBreastFeeding
from person p
inner join obs o on o.person_id = p.person_id and o.concept_id in (159941)
group by p.person_id, extract(year_month from o.obs_datetime)

) x
where extract(YEAR_MONTH from x.encDate) = period and x.pregnantBreastFeeding=1 and x.ageInyears =1 
) monthlyCount
from encounter e
where e.voided =0 and e.encounter_datetime between '1980-01-01' and curdate()
group by year(e.encounter_datetime), month(e.encounter_datetime)
order by period

)

union

(

select
'HV02-38' as Indicator,
date_format(e.encounter_datetime, '%Y-%M') as 'Month',
extract(year_month from e.encounter_datetime) as period,
(select count(*) from (
select 
p.person_id,
p.birthdate as dob,
datediff(o.obs_datetime, p.birthdate) div 365.25 as ageInyears,
o.obs_datetime as encDate,
o.concept_id,
o.value_coded,
max(if(o.concept_id = 159941 and o.value_coded= 1066, 1, 0)) as pregnantBreastFeeding
from person p
inner join obs o on o.person_id = p.person_id and o.concept_id in (159941)
group by p.person_id, extract(year_month from o.obs_datetime)

) x
where extract(YEAR_MONTH from x.encDate) = period and x.pregnantBreastFeeding=1 and x.ageInyears =1 
) monthlyCount
from encounter e
where e.voided =0 and e.encounter_datetime between '1980-01-01' and curdate()
group by year(e.encounter_datetime), month(e.encounter_datetime)
order by period

)

union 

(

select
'HV02-39' as Indicator,
date_format(e.encounter_datetime, '%Y-%M') as 'Month',
extract(year_month from e.encounter_datetime) as period,
(select count(*) from (
select 
p.person_id,
p.birthdate as dob,
datediff(o.obs_datetime, p.birthdate) div 365.25 as ageInyears,
o.obs_datetime as encDate,
o.concept_id,
o.value_coded,
max(if(o.concept_id = 159941 and o.value_coded= 1067, 1, 0)) as pregnantBreastFeeding
from person p
inner join obs o on o.person_id = p.person_id and o.concept_id in (159941)
group by p.person_id, extract(year_month from o.obs_datetime)

) x
where extract(YEAR_MONTH from x.encDate) = period and x.pregnantBreastFeeding=1 and x.ageInyears =1 
) monthlyCount
from encounter e
where e.voided =0 and e.encounter_datetime between '1980-01-01' and curdate()
group by year(e.encounter_datetime), month(e.encounter_datetime)
order by period

)

union

(

select 
'HV03-01' as Indicator,
date_format(e.encounter_datetime, '%Y-%M') as 'Month',
extract(year_month from e.encounter_datetime) as period,
(select count(*) from (
select 
p.person_id,
extract(YEAR_MONTH from o.obs_datetime) as yearMonth,
o.obs_datetime as encDate,
p.birthdate,
datediff(o.obs_datetime, p.birthdate) as ageInDays,
o.concept_id,
o.value_coded
from person p
inner join obs o on o.person_id = p.person_id and o.voided = 0 and o.concept_id = 5303 and o.value_coded=822
) x
where x.ageInDays <=60 and extract(YEAR_MONTH from x.encDate) = period
) monthlyCount
from encounter e
where e.voided =0 and e.encounter_datetime between '1980-01-01' and curdate()
group by year(e.encounter_datetime), month(e.encounter_datetime)
order by period
)
union
(
select
'HV03-02' as Indicator,
date_format(e.encounter_datetime, '%Y-%M') as 'Month',
extract(year_month from e.encounter_datetime) as period,
(select count(*) from (
select 
p.person_id,
p.dead as dead,
extract(YEAR_MONTH from o.obs_datetime) as yearMonth,
o.obs_datetime as encDate,
max(if(o.concept_id = 5303 and o.value_coded=822, 1, 0)) as exposed,
max(if(o.concept_id=162229 and o.value_coded=1065, 1, 0)) as ctxDispensed,
max(if(o.concept_id=1282 and o.value_coded=105281,1,0)) as sulfaOrder,-- MEDICATION_ORDERS = "1282: SULFAMETHOXAZOLE_TRIMETHOPRIM = 105281
p.birthdate,
datediff(o.obs_datetime, p.birthdate) as ageInDays,
o.concept_id
from person p
inner join obs o on o.person_id = p.person_id and o.voided = 0 and o.concept_id in(162229, 5303, 1282)
group by 1
) x
where x.ageInDays <=60 and x.exposed=1 and extract(YEAR_MONTH from x.encDate) = period and (x.ctxDispensed=1 or x.sulfaOrder =1)
) monthlyCount
from encounter e
where e.voided =0 and e.encounter_datetime between '1980-01-01' and curdate()
group by year(e.encounter_datetime), month(e.encounter_datetime)
order by period
)
union
-- TB Screening indicators
(
select Indicator, fperiod as 'Month', period, monthlyCount from (
select 'HV03-50' as Indicator,
date_format(e.encounter_datetime, '%Y-%M') as fPeriod,
last_day(e.encounter_datetime) as lastDay,
extract(year_month from e.encounter_datetime) as period,
(select count(*) from (
select 
o.person_Id as person,
p.gender as gender,
p.birthdate as dob,
enrolled.enrolmentDate,
left(max(concat(o.obs_datetime, if(o.value_coded in (142177, 1661, 1660), 1, 0))),10) as Lastscreen,
mid(max(concat(o.obs_datetime, if(o.value_coded in (142177, 1661, 1660), 1, 0))),20) as screened,
mid(max(concat(o.obs_datetime, if(o.value_coded = 1662, 1, 0))),20) as onTreatment
from obs o 
inner join person p on p.person_id = o.person_id and p.voided=0
inner join (
select 
e.patient_id as patient,
date(min(e.encounter_datetime)) as enrolmentDate
from encounter e
where e.voided =0
group by patient
) enrolled on o.person_id = enrolled.patient
where o.voided=0 and o.concept_id =1659  
group by person, extract(year_month from o.obs_datetime)
) x
where extract(YEAR_MONTH from x.Lastscreen) = period and x.enrolmentDate <= lastDay and x.gender='M' and (datediff(lastDay, dob) div 365.25 < 15) and x.onTreatment =0 and x.screened =1 
) monthlyCount
from encounter e
where e.voided =0 and e.encounter_datetime between '1980-01-01' and curdate()
group by year(e.encounter_datetime), month(e.encounter_datetime)
order by period
) i
)
union
(
select Indicator, fperiod as 'Month', period, monthlyCount from (
select 'HV03-52' as Indicator,
date_format(e.encounter_datetime, '%Y-%M') as fPeriod,
last_day(e.encounter_datetime) as lastDay,
extract(year_month from e.encounter_datetime) as period,
(select count(*) from (
select 
o.person_Id as person,
p.gender as gender,
p.birthdate as dob,
enrolled.enrolmentDate,
left(max(concat(o.obs_datetime, if(o.value_coded in (142177, 1661, 1660), 1, 0))),10) as Lastscreen,
mid(max(concat(o.obs_datetime, if(o.value_coded in (142177, 1661, 1660), 1, 0))),20) as screened,
mid(max(concat(o.obs_datetime, if(o.value_coded = 1662, 1, 0))),20) as onTreatment
from obs o 
inner join person p on p.person_id = o.person_id and p.voided=0
inner join (
select 
e.patient_id as patient,
date(min(e.encounter_datetime)) as enrolmentDate
from encounter e
where e.voided =0
group by patient
) enrolled on o.person_id = enrolled.patient
where o.voided=0 and o.concept_id =1659  
group by person, extract(year_month from o.obs_datetime)
) x
where extract(YEAR_MONTH from x.Lastscreen) = period and x.enrolmentDate <= lastDay and x.gender='M' and (datediff(lastDay, dob) div 365.25 >= 15) and x.onTreatment =0 and x.screened =1 
) monthlyCount
from encounter e
where e.voided =0 and e.encounter_datetime between '1980-01-01' and curdate()
group by year(e.encounter_datetime), month(e.encounter_datetime)
order by period
) i
)
union
(
select Indicator, fperiod as 'Month', period, monthlyCount from (
select 'HV03-51' as Indicator,
date_format(e.encounter_datetime, '%Y-%M') as fPeriod,
last_day(e.encounter_datetime) as lastDay,
extract(year_month from e.encounter_datetime) as period,
(select count(*) from (
select 
o.person_Id as person,
p.gender as gender,
p.birthdate as dob,
enrolled.enrolmentDate,
left(max(concat(o.obs_datetime, if(o.value_coded in (142177, 1661, 1660), 1, 0))),10) as Lastscreen,
mid(max(concat(o.obs_datetime, if(o.value_coded in (142177, 1661, 1660), 1, 0))),20) as screened,
mid(max(concat(o.obs_datetime, if(o.value_coded = 1662, 1, 0))),20) as onTreatment
from obs o 
inner join person p on p.person_id = o.person_id and p.voided=0
inner join (
select 
e.patient_id as patient,
date(min(e.encounter_datetime)) as enrolmentDate
from encounter e
where e.voided =0
group by patient
) enrolled on o.person_id = enrolled.patient
where o.voided=0 and o.concept_id =1659  
group by person, extract(year_month from o.obs_datetime)
) x
where extract(YEAR_MONTH from x.Lastscreen) = period and x.enrolmentDate <= lastDay and x.gender='F' and (datediff(lastDay, dob) div 365.25 < 15) and x.onTreatment =0 and x.screened =1 
) monthlyCount
from encounter e
where e.voided =0 and e.encounter_datetime between '1980-01-01' and curdate()
group by year(e.encounter_datetime), month(e.encounter_datetime)
order by period
) i 
)
union
(
select Indicator, fperiod as 'Month', period, monthlyCount from (
select 'HV03-53' as Indicator,
date_format(e.encounter_datetime, '%Y-%M') as fPeriod,
last_day(e.encounter_datetime) as lastDay,
extract(year_month from e.encounter_datetime) as period,
(select count(*) from (
select 
o.person_Id as person,
p.gender as gender,
p.birthdate as dob,
enrolled.enrolmentDate,
left(max(concat(o.obs_datetime, if(o.value_coded in (142177, 1661, 1660), 1, 0))),10) as Lastscreen,
mid(max(concat(o.obs_datetime, if(o.value_coded in (142177, 1661, 1660), 1, 0))),20) as screened,
mid(max(concat(o.obs_datetime, if(o.value_coded = 1662, 1, 0))),20) as onTreatment
from obs o 
inner join person p on p.person_id = o.person_id and p.voided=0
inner join (
select 
e.patient_id as patient,
date(min(e.encounter_datetime)) as enrolmentDate
from encounter e
where e.voided =0
group by patient
) enrolled on o.person_id = enrolled.patient
where o.voided=0 and o.concept_id =1659  
group by person, extract(year_month from o.obs_datetime)
) x
where extract(YEAR_MONTH from x.Lastscreen) = period and x.enrolmentDate <= lastDay and x.gender='F' and (datediff(lastDay, dob) div 365.25 >= 15) and x.onTreatment =0 and x.screened =1 
) monthlyCount
from encounter e
where e.voided =0 and e.encounter_datetime between '1980-01-01' and curdate()
group by year(e.encounter_datetime), month(e.encounter_datetime)
order by period 
) i
)
union 
(
select
'HV03-70' as Indicator,
date_format(e.encounter_datetime, '%Y-%M') as 'Month',
extract(year_month from e.encounter_datetime) as period,
(select count(distinct patientId) from (
select 
p.person_id as patientId,
p.birthdate as dob,
p.gender,
datediff(e.encounter_datetime, p.birthdate) div 365.25 as age,
e.encounter_datetime as encDate,
extract(YEAR_MONTH from e.encounter_datetime) as yearMonth,
e.form_id as form
from person p
inner join encounter e on p.person_id = e.patient_id and e.form_id in (11,15) and e.voided =0
where p.voided=0 and gender='F'--  and extract(YEAR_MONTH from e.encounter_datetime) = '201403'
having age >= 18
) x
where extract(YEAR_MONTH from x.encDate) = period
) monthlyCount
from encounter e
where e.voided =0 and e.encounter_datetime between '1980-01-01' and curdate()
group by year(e.encounter_datetime), month(e.encounter_datetime)
order by period

)
union 
(
select
'HV03-71' as Indicator,
date_format(e.encounter_datetime, '%Y-%M') as 'Month',
extract(year_month from e.encounter_datetime) as period,
(select count(*) from (
select 
e.patient_id as patientId,
e.visit_id as visit,
e.encounter_datetime as encDate,
if(o.concept_id = 1246, o.value_coded, '') as scheduledVisitConcept,
tca.encDate as tcaEncDate,
tca.tca as tca,
tca.patient,
extract(YEAR_MONTH from e.encounter_datetime) as yearMonth,
e.form_id as form
from encounter e 
left outer join obs o on o.encounter_id = e.encounter_id and o.voided=0 and o.concept_id =1246
left outer join (
select 
o.person_id as patient,
date(o.obs_datetime) as encDate,
o.value_datetime as tca
from obs o
where o.concept_id = 5096 and o.voided=0
) tca on e.patient_id = tca.patient and e.encounter_datetime = tca.tca
where e.form_id in (11,15) and e.voided =0 
having (scheduledVisitConcept=1 or tca is not null)
) x
where extract(YEAR_MONTH from x.encDate) = period
) monthlyCount
from encounter e
where e.voided =0 and e.encounter_datetime between '1980-01-01' and curdate()
group by year(e.encounter_datetime), month(e.encounter_datetime)
order by period

)
union 
(
select
'HV03-72' as Indicator,
date_format(e.encounter_datetime, '%Y-%M') as 'Month',
extract(year_month from e.encounter_datetime) as period,
(select count(*) from (
select 
e.patient_id as patientId,
e.visit_id as visit,
e.encounter_datetime as encDate,
if(o.concept_id = 1246, o.value_coded, '') as scheduledVisitConcept,
tca.encDate as tcaEncDate,
tca.tca as tca,
tca.patient,
extract(YEAR_MONTH from e.encounter_datetime) as yearMonth,
e.form_id as form
from encounter e 
left outer join obs o on o.encounter_id = e.encounter_id and o.voided=0 and o.concept_id =1246
left outer join (
select 
o.person_id as patient,
date(o.obs_datetime) as encDate,
o.value_datetime as tca
from obs o
where o.concept_id = 5096 and o.voided=0
) tca on e.patient_id = tca.patient and e.encounter_datetime = tca.tca
where e.form_id in (11,15) and e.voided =0 
having ((scheduledVisitConcept = '' or scheduledVisitConcept is null) and tca is null)
) x
where extract(YEAR_MONTH from x.encDate) = period
) monthlyCount
from encounter e
where e.voided =0 and e.encounter_datetime between '1980-01-01' and curdate()
group by year(e.encounter_datetime), month(e.encounter_datetime)
order by period

)

union

(
select
'HV09-04' as Indicator,
date_format(e.encounter_datetime, '%Y-%M') as 'Month',
extract(year_month from e.encounter_datetime) as period,
(select count(*) from (
select distinct
p.person_id as patient,
o.obs_datetime as encDate,
(
case o.value_coded
when 5277 or 159524 or 1107 or 1175 or 5622 then 0
else 1
end
) as onModernFP 
from person p
inner join obs o using(person_id)
where p.voided=0 and o.concept_id = 374 and o.voided =0 and o.value_coded is not null 
) x
where x.onModernFP=1 and extract(YEAR_MONTH from x.encDate) = period
) monthlyCount
from encounter e
where e.voided =0 and e.encounter_datetime between '1980-01-01' and curdate()
group by year(e.encounter_datetime), month(e.encounter_datetime)
order by period

)

union 

(
select
'HV09-05' as Indicator,
date_format(e.encounter_datetime, '%Y-%M') as 'Month',
extract(year_month from e.encounter_datetime) as period,
(select count(distinct x.patient) from (
select distinct
o.person_id as patient,
o.obs_datetime as encDate,
(case o.value_coded when 1065 then 1 else 0 end) as condomProvided
from obs o
where o.concept_id = 159777 and o.voided = 0
) x
where x.condomProvided=1 and extract(YEAR_MONTH from x.encDate) = period
) monthlyCount
from encounter e
where e.voided =0 and e.encounter_datetime between '1980-01-01' and curdate()
group by year(e.encounter_datetime), month(e.encounter_datetime)
order by period

)
