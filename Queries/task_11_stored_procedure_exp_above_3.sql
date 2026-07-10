DELIMITER $$

CREATE PROCEDURE GetExperiencedEmployees()
BEGIN
    SELECT *
    FROM emp_record_table
    WHERE EXP > 3;
END $$

DELIMITER ;

CALL GetExperiencedEmployees();
