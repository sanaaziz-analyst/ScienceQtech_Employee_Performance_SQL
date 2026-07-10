SELECT *
FROM emp_record_table
WHERE EMP_ID IN (
    SELECT EMP_ID
    FROM emp_record_table
    WHERE EXP > 10
);
