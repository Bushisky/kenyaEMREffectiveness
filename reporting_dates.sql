drop table month_dates;

create table month_dates (
id int(11) not null auto_increment,
one_month date not null,
two_month date not null,
three_month date not null,
six_month date not null,
twelve_month date not null,
endDate date not null,
yearMonth varchar(15) not null,
primary key(id)

);

insert into month_dates (one_month, two_month, three_month, six_month, twelve_month, endDate, yearMonth) 
select
	date_add(date_add(LAST_DAY(e.encounter_datetime),interval 1 DAY),interval -1 MONTH) as startDate,
	date_add(date_add(LAST_DAY(e.encounter_datetime),interval 1 DAY),interval -2 MONTH) as startDate,
	date_add(date_add(LAST_DAY(e.encounter_datetime),interval 1 DAY),interval -3 MONTH) as startDate,
	date_add(date_add(LAST_DAY(e.encounter_datetime),interval 1 DAY),interval -6 MONTH) as startDate,
	date_add(date_add(LAST_DAY(e.encounter_datetime),interval 1 DAY),interval -12 MONTH) as startDate,
	LAST_DAY(e.encounter_datetime) as endDate,
	date_format(e.encounter_datetime, '%Y-%M') as yearMonth
from encounter e
where e.voided =0 and e.encounter_datetime between '1980-01-01' and curdate()
group by year(e.encounter_datetime), month(e.encounter_datetime)
;