DELIMITER $$ 
DROP FUNCTION IF EXISTS isActive$$
CREATE FUNCTION isActive(patient INT, endDate DATE) RETURNS INT
	DETERMINISTIC
BEGIN
	DECLARE patientActive INT;
	SET patientActive = 0;
	select 
		(case 
			when 
				datediff(endDate, date(left(max(concat(o.obs_datetime, o.value_datetime)),19))) > 96
				or 
				datediff(endDate, date(mid(max(concat(o.obs_datetime, o.value_datetime)),20))) > 96
			then 0
			else 1
		end) into patientActive
	from obs o
	where o.concept_id=5096 and o.voided=0 and o.person_id=patient and obs_datetime <= endDate
	group by o.person_id;
	return patientActive;
END$$
DELIMITER ;