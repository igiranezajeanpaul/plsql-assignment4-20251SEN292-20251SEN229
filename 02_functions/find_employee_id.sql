CREATE OR REPLACE FUNCTION find_employee_id (
    p_name IN employees.employee_name%TYPE
) RETURN NUMBER AS
    v_id employees.employee_id%TYPE;
BEGIN
    SELECT employee_id INTO v_id FROM employees
    WHERE UPPER(employee_name) = UPPER(TRIM(p_name));
    RETURN v_id;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20011, 'Employee name not found.');
    WHEN TOO_MANY_ROWS THEN
        RAISE_APPLICATION_ERROR(-20012, 'Several employees have that name. Use an employee ID.');
END;
/
SHOW ERRORS FUNCTION find_employee_id
