CREATE OR REPLACE PROCEDURE add_employee (
    p_id IN employees.employee_id%TYPE,
    p_name IN employees.employee_name%TYPE,
    p_department IN employees.department_id%TYPE,
    p_salary IN NUMBER,
    p_rows OUT PLS_INTEGER
) AS
    e_missing_department EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_missing_department, -2291);
BEGIN
    IF p_id IS NULL OR p_id <= 0 OR p_id <> TRUNC(p_id)
       OR TRIM(p_name) IS NULL OR p_department IS NULL
       OR p_salary IS NULL OR p_salary < 50000 OR p_salary > 5000000 THEN
        RAISE_APPLICATION_ERROR(-20001,
            'Provide a positive integer ID, name, department and salary RWF 50000-5000000.');
    END IF;
    INSERT INTO employees(employee_id, employee_name, department_id, salary)
    VALUES (p_id, TRIM(p_name), p_department, p_salary);
    p_rows := SQL%ROWCOUNT;
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        RAISE_APPLICATION_ERROR(-20002, 'Employee ID already exists.');
    WHEN e_missing_department THEN
        RAISE_APPLICATION_ERROR(-20003, 'Department does not exist.');
END;
/
SHOW ERRORS PROCEDURE add_employee
