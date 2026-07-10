# ScienceQtech Employee Performance Mapping

Every task in this project, written out in order, each one runnable on its own.

```sql
CREATE DATABASE IF NOT EXISTS employee;
USE employee;

DROP TABLE IF EXISTS emp_record_table;
CREATE TABLE emp_record_table (
    EMP_ID VARCHAR(10),
    FIRST_NAME VARCHAR(50),
    LAST_NAME VARCHAR(50),
    GENDER VARCHAR(5),
    ROLE VARCHAR(50),
    DEPT VARCHAR(50),
    EXP INT,
    COUNTRY VARCHAR(50),
    CONTINENT VARCHAR(50),
    SALARY INT,
    EMP_RATING INT,
    MANAGER_ID VARCHAR(10),
    PROJ_ID VARCHAR(10)
);

DROP TABLE IF EXISTS proj_table;
CREATE TABLE proj_table (
    PROJECT_ID VARCHAR(10),
    PROJ_NAME VARCHAR(100),
    DOMAIN VARCHAR(50),
    START_DATE VARCHAR(20),
    CLOSURE_DATE VARCHAR(20),
    DEV_QTR VARCHAR(10),
    STATUS VARCHAR(20)
);

DROP TABLE IF EXISTS data_science_team;
CREATE TABLE data_science_team (
    EMP_ID VARCHAR(10),
    FIRST_NAME VARCHAR(50),
    LAST_NAME VARCHAR(50),
    GENDER VARCHAR(5),
    ROLE VARCHAR(50),
    DEPT VARCHAR(50),
    EXP INT,
    COUNTRY VARCHAR(50),
    CONTINENT VARCHAR(50)
);
```

Import emp_record_table.csv, proj_table.csv and data_science_team.csv from the Datasets folder into the three tables above using the Table Data Import Wizard before running the tasks below.

## Task 1: Basic employee details

```sql
select EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT from emp_record_table;
```

## Task 2: Filter employees by rating

```sql
select EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPT, EMP_RATING from emp_record_table
WHERE EMP_RATING <=2 OR EMP_RATING >= 4;
```

## Task 3: Concatenate FIRST_NAME and LAST_NAME

```sql
SELECT CONCAT(FIRST_NAME,' ',LAST_NAME) as NAME from emp_record_table
WHERE DEPT = 'FINANCE' ;
```

## Task 4: Employees who have reporters

```sql
SELECT COUNT(EMP_ID) AS NO_OF_REPORTERS, MANAGER_ID FROM emp_record_table
WHERE MANAGER_ID IS NOT NULL
GROUP BY MANAGER_ID
ORDER BY MANAGER_ID DESC;
```

## Task 5: Finance and Healthcare employees, UNION

```sql
SELECT * FROM emp_record_table WHERE DEPT = 'HEALTHCARE'
UNION
SELECT * FROM emp_record_table WHERE DEPT = 'FINANCE';
```

## Task 6: Max rating per department

```sql
SELECT EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPT, EMP_RATING,
       MAX(EMP_RATING) OVER (PARTITION BY DEPT) AS MAX_DEPT_RATING
FROM emp_record_table
ORDER BY DEPT;
```

## Task 7: Min and max salary per role

```sql
SELECT ROLE, MIN(SALARY) AS MIN_SALARY, MAX(SALARY) AS MAX_SALARY
FROM emp_record_table
GROUP BY ROLE;
```

## Task 8: Rank employees by experience

```sql
SELECT EMP_ID, FIRST_NAME, LAST_NAME, EXP,
       RANK() OVER (ORDER BY EXP DESC) AS EXPERIENCE_RANK
FROM emp_record_table;
```

## Task 9: View for employees with salary above 6000

```sql
CREATE VIEW high_earners_by_country AS
SELECT EMP_ID, FIRST_NAME, LAST_NAME, COUNTRY, SALARY
FROM emp_record_table
WHERE SALARY > 6000;

SELECT * FROM high_earners_by_country;
```

## Task 10: Nested query, experience above 10 years

```sql
SELECT *
FROM emp_record_table
WHERE EMP_ID IN (
    SELECT EMP_ID
    FROM emp_record_table
    WHERE EXP > 10
);
```

## Task 11: Stored procedure, experience above 3 years

```sql
DELIMITER $$

CREATE PROCEDURE GetExperiencedEmployees()
BEGIN
    SELECT *
    FROM emp_record_table
    WHERE EXP > 3;
END $$

DELIMITER ;

CALL GetExperiencedEmployees();
```

## Task 12: Stored function, data science profile validation

```sql
DELIMITER $$

CREATE FUNCTION CHECK_JOB_PROFILE(EXPERIENCE INT)
RETURNS VARCHAR(30)
DETERMINISTIC
BEGIN
    DECLARE PROFILE VARCHAR(30);
    IF EXPERIENCE <= 2 THEN
        SET PROFILE = 'JUNIOR DATA SCIENTIST';
    ELSEIF EXPERIENCE <= 5 THEN
        SET PROFILE = 'ASSOCIATE DATA SCIENTIST';
    ELSEIF EXPERIENCE <= 10 THEN
        SET PROFILE = 'SENIOR DATA SCIENTIST';
    ELSEIF EXPERIENCE <= 12 THEN
        SET PROFILE = 'LEAD DATA SCIENTIST';
    ELSE
        SET PROFILE = 'MANAGER';
    END IF;
    RETURN PROFILE;
END $$

DELIMITER ;

SELECT EMP_ID, FIRST_NAME, LAST_NAME, ROLE, EXP,
       CHECK_JOB_PROFILE(EXP) AS EXPECTED_PROFILE
FROM data_science_team;
```

## Task 13: Index creation for optimisation

```sql
EXPLAIN SELECT * FROM emp_record_table WHERE FIRST_NAME = 'Eric';

CREATE INDEX idx_first_name ON emp_record_table(FIRST_NAME);

EXPLAIN SELECT * FROM emp_record_table WHERE FIRST_NAME = 'Eric';
```

## Task 14: Bonus calculation, five per cent times rating

```sql
SELECT EMP_ID, FIRST_NAME, LAST_NAME, SALARY, EMP_RATING,
       ROUND(0.05 * SALARY * EMP_RATING, 2) AS BONUS
FROM emp_record_table;
```

## Task 15: Average salary by continent and country

```sql
SELECT CONTINENT, COUNTRY, AVG(SALARY) AS AVERAGE_SALARY
FROM emp_record_table
GROUP BY CONTINENT, COUNTRY
ORDER BY CONTINENT, COUNTRY;
```
