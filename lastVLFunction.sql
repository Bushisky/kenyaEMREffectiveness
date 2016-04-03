DELIMITER $$ 
DROP FUNCTION IF EXISTS lastViralLoad$$
CREATE FUNCTION lastViralLoad(patient INT, endDate DATE) RETURNS DOUBLE
	DETERMINISTIC
BEGIN
	DECLARE lastVL DOUBLE;
	SET lastVL = 0;
	select mid(max(concat(obs_datetime,value_numeric)), 20) into lastVL 
	from obs 
	where concept_id = 856 and voided=0 and person_id= patient and obs_datetime <=endDate;
	return lastVL;
END$$
DELIMITER ;