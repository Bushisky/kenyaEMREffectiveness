drop table flat_visit_table;

create table flat_visit_table(
id int(11) not null auto_increment,
visit_id int(11) default null,
visit_date date not null,
patient_id int(11) not null,
tca_date date default null,
vl double default null,
cd4_percent double default null,
cd4_count double default null,
hiv_disc date default null ,
disc_reason int(11) default null,
date_died date default null,
date_to date default null,
m_tca_date date default null,
m_vl double default null,
m_cd4_percent double default null,
m_cd4_count double default null,
m_date_died date default null,
primary key(id),
index(patient_id),
constraint foreign key(patient_id) references patient(patient_id)

)
;

insert into flat_visit_table (visit_date, patient_id)
select date(e.encounter_datetime), e.patient_id 
from encounter e
where e.voided = 0
group by e.patient_id, date(e.encounter_datetime)
order by e.patient_id asc, date(e.encounter_datetime) asc
;

update flat_visit_table f
inner join visit v on v.patient_id = f.patient_id and f.visit_date= date(v.date_started)
set f.visit_id=v.visit_id

;

update flat_visit_table f
inner join obs o on f.patient_id=o.person_id inner join encounter e on o.encounter_id=e.encounter_id
set f.vl = o.value_numeric -- , f.vl_obs_datetime = o.obs_datetime
where o.concept_id=856 and o.voided=0 
and date(e.encounter_datetime) = date(f.visit_date)
;

update flat_visit_table f
inner join obs o on f.patient_id=o.person_id inner join encounter e on o.encounter_id=e.encounter_id
set f.tca_date = o.value_datetime 
where o.concept_id=5096 and o.voided=0 
and date(e.encounter_datetime) = date(f.visit_date)
;

update flat_visit_table f
inner join obs o on f.patient_id=o.person_id inner join encounter e on o.encounter_id=e.encounter_id
set f.cd4_percent = o.value_numeric
where o.concept_id =730 and o.voided=0 
and date(e.encounter_datetime) = date(f.visit_date)
;

update flat_visit_table f
inner join obs o on f.patient_id=o.person_id inner join encounter e on o.encounter_id=e.encounter_id
set f.cd4_count = o.value_numeric
where o.concept_id =5497 and o.voided=0 
and date(e.encounter_datetime) = date(f.visit_date)
;

update flat_visit_table f
inner join encounter e on f.patient_id=e.patient_id and f.visit_date = date(e.encounter_datetime)
set f.hiv_disc = date(e.encounter_datetime)
where e.encounter_type=1
;

update flat_visit_table f
inner join obs o on f.patient_id=o.person_id inner join encounter e on o.encounter_id=e.encounter_id
set f.date_died = o.value_datetime
where o.concept_id =1543 and o.voided=0 
and date(e.encounter_datetime) = date(f.visit_date)
;

update flat_visit_table f
inner join obs o on f.patient_id=o.person_id inner join encounter e on o.encounter_id=e.encounter_id
set f.date_to = o.value_datetime
where o.concept_id =160649 and o.voided=0 
and date(e.encounter_datetime) = date(f.visit_date)
;

update flat_visit_table f
inner join obs o on f.patient_id=o.person_id inner join encounter e on o.encounter_id=e.encounter_id
set f.disc_reason = o.value_coded
where o.concept_id =161555 and o.voided=0 
and date(e.encounter_datetime) = date(f.visit_date)
;

update flat_visit_table f
inner join flat_visit_table fv on f.patient_id=fv.patient_id and (f.id-fv.id) = 1
set f.tca_date = case when f.tca_date is null and fv.tca_date is not null then fv.tca_date else f.tca_date end
;
