 DELIMITER $$
 DROP PROCEDURE IF EXISTS create_flat_table_vl$$
 CREATE PROCEDURE create_flat_table_vl()
 BEGIN
DECLARE rowCount  INT;
SET rowCount = 1000000;
drop table if exists flat_visit_table_vl;

create table flat_visit_table_vl(
id int(11) not null auto_increment,
visit_id int(11) default null,
patient_id int(11) not null,
gender varchar(10) default null,
dob date default null,
visit_date date not null,
prev_visit_date date default null,
tca_date date default null,
prev_tca_date date default null,
art_start_date date default null,
ti_art_start_date date default null,
transfer_in_date date default null,
vl double default null,
cd4_percent double default null,
cd4_count double default null,
hiv_disc date default null ,
disc_reason int(11) default null,
date_died date default null,
date_to date default null,
primary key(id),
index(patient_id),
constraint foreign key(patient_id) references patient(patient_id)

)
;


insert into flat_visit_table_vl (visit_date, patient_id, gender, dob,art_start_date)
select date(e.encounter_datetime), e.patient_id, p.gender, p.birthdate, date(art.art_start_date) 
from encounter e
inner join person p on p.person_id=e.patient_id and p.voided=0
left outer join (
select 
od.patient_id as patient_id,
min(od.start_date) as art_start_date 
from orders od
inner join concept_set cs on od.concept_id = cs.concept_id and cs.concept_set = 1085
where od.voided=0
group by 1
) art on art.patient_id = e.patient_id
where e.voided = 0 and e.encounter_type not in (2,4,5,9,20)
group by e.patient_id, date(e.encounter_datetime)
order by e.patient_id asc, date(e.encounter_datetime) asc
;

update flat_visit_table_vl f
inner join visit v on v.patient_id = f.patient_id and f.visit_date= date(v.date_started)
set f.visit_id=v.visit_id
;

update flat_visit_table_vl f
inner join obs o on f.patient_id=o.person_id inner join encounter e on o.encounter_id=e.encounter_id
set f.ti_art_start_date = date(o.value_datetime),
f.transfer_in_date = date(e.encounter_datetime)
where o.concept_id=159599 and o.voided=0 
and date(e.encounter_datetime) = date(f.visit_date)
;


update flat_visit_table_vl f
inner join obs o on f.patient_id=o.person_id inner join encounter e on o.encounter_id=e.encounter_id
set f.vl = o.value_numeric 
where o.concept_id=856 and o.voided=0 
and date(e.encounter_datetime) = date(f.visit_date)
;

update flat_visit_table_vl f
inner join obs o on f.patient_id=o.person_id inner join encounter e on o.encounter_id=e.encounter_id
set f.tca_date = o.value_datetime 
where o.concept_id=5096 and o.voided=0 
and date(e.encounter_datetime) = date(f.visit_date)
;

update flat_visit_table_vl f
inner join obs o on f.patient_id=o.person_id inner join encounter e on o.encounter_id=e.encounter_id
set f.cd4_percent = o.value_numeric
where o.concept_id =730 and o.voided=0 
and date(e.encounter_datetime) = date(f.visit_date)
;

update flat_visit_table_vl f
inner join obs o on f.patient_id=o.person_id inner join encounter e on o.encounter_id=e.encounter_id
set f.cd4_count = o.value_numeric
where o.concept_id =5497 and o.voided=0 
and date(e.encounter_datetime) = date(f.visit_date)
;

update flat_visit_table_vl f
inner join encounter e on f.patient_id=e.patient_id and f.visit_date = date(e.encounter_datetime)
set f.hiv_disc = date(e.encounter_datetime)
where e.encounter_type=1
;

update flat_visit_table_vl f
inner join obs o on f.patient_id=o.person_id inner join encounter e on o.encounter_id=e.encounter_id
set f.date_died = o.value_datetime
where o.concept_id =1543 and o.voided=0 
and date(e.encounter_datetime) = date(f.visit_date)
;

update flat_visit_table_vl f
inner join obs o on f.patient_id=o.person_id inner join encounter e on o.encounter_id=e.encounter_id
set f.date_to = o.value_datetime
where o.concept_id =160649 and o.voided=0 
and date(e.encounter_datetime) = date(f.visit_date)
;

update flat_visit_table_vl f
inner join obs o on f.patient_id=o.person_id inner join encounter e on o.encounter_id=e.encounter_id
set f.disc_reason = o.value_coded
where o.concept_id =161555 and o.voided=0 
and date(e.encounter_datetime) = date(f.visit_date)
;
 
 WHILE rowCount  > 0 DO

	update flat_visit_table_vl f
	inner join flat_visit_table_vl fv on f.patient_id=fv.patient_id and (f.id-fv.id) = 1
	set f.tca_date = case when f.tca_date is null and fv.tca_date is not null then fv.tca_date else f.tca_date end,
	-- f.cd4_percent = case when f.cd4_percent is null and fv.cd4_percent is not null then fv.cd4_percent else f.cd4_percent end,
	-- f.cd4_count = case when f.cd4_count is null and fv.cd4_count is not null then fv.cd4_count else f.cd4_count end,
	f.date_died = case when f.date_died is null and fv.date_died is not null then fv.date_died else f.date_died end,
	f.date_to = case when f.date_to is null and fv.date_to is not null then fv.date_to else f.date_to end,
	f.prev_visit_date = case when f.prev_visit_date is null then fv.visit_date else f.prev_visit_date end,
	f.prev_tca_date = case when f.prev_tca_date is null then fv.tca_date else f.prev_tca_date end
	;

 SET  rowCount = ROW_COUNT();
 END WHILE;

 END$$

DELIMITER ;
