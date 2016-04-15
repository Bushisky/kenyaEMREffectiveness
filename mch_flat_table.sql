
-- drop table and recreate it 
drop table mch_data;

create table mch_data(
id int(11) auto_increment not null,
patient_id int(11) not null,
date_enrolled datetime default null,
date_completed datetime default null,
date_tested datetime default null,
delivery_date datetime default null,
date_diagnosed datetime default null,
partner_status varchar(50) default null,
hiv_test_result varchar(50) default null,
adjusted_column int(11) default 0,
primary key(id),
constraint foreign key(patient_id) references patient(patient_id)
);

-- insert into mch data from mch program
insert into mch_data (patient_id, date_enrolled, date_completed)
select pp.patient_id,
 date(pp.date_enrolled),
 date(pp.date_completed)
from patient_program pp
where pp.program_id=4 and pp.voided=0
order by pp.patient_id, pp.date_enrolled

;
-- adjust null end dates to reflect a year after date enrolled in mch. this will help fix date tested, diagnosed and deliveries accordingly
update mch_data m
set m.date_completed = date_add(m.date_enrolled, interval 12 month),
m.adjusted_column=1
where m.date_completed is null;

select * from mch_data;
-- update date tested for hiv
update mch_data m
join obs o on o.person_id=m.patient_id
set m.date_tested = o.value_datetime
where o.concept_id=160082 and o.value_datetime between m.date_enrolled and m.date_completed
;
-- update deliveries
update mch_data m
join obs o on o.person_id=m.patient_id
set m.delivery_date = o.value_datetime
where o.concept_id=5599 and o.value_datetime between m.date_enrolled and m.date_completed
;

-- update diagnosis
update mch_data m
join obs o on o.person_id=m.patient_id
set m.date_diagnosed = o.value_datetime
where o.concept_id=160554 and o.value_datetime between m.date_enrolled and m.date_completed
;

-- update Hiv test result
update mch_data m
join obs o on o.person_id=m.patient_id
set m.hiv_test_result = (case o.value_coded when 664 then 'Neg' when 703 then 'Pos' when 1067 then 'Uknown' when 1138 then 'INDETERMINATE' end)
where o.concept_id =159427 and o.obs_datetime between m.date_enrolled and m.date_completed
;

-- update partner status
update mch_data m
join obs o on o.person_id=m.patient_id
set m.partner_status = (case o.value_coded when 664 then 'Neg' when 703 then 'Pos' when 1067 then 'Uknown' end)
where o.concept_id =1436 and o.obs_datetime between m.date_enrolled and m.date_completed
;

select * from mch_data;



-- ========================================================== adding something for visit information ------------------------------------------------------------------------------------------------

drop table flat_visit_table;

create table flat_visit_table(
id int(11) not null auto_increment,
visit_id int(11) default null,
visit_date datetime not null,
patient_id int(11) not null,
tca_date datetime default null,
vl double default null,
primary key(id),
constraint foreign key(patient_id) references patient(patient_id)

)
;

insert into flat_visit_table (visit_date, patient_id)
select date(e.encounter_datetime), e.patient_id 
from encounter e
where e.voided = 0
group by e.patient_id, date(e.encounter_datetime)
order by e.patient_id, 2
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
