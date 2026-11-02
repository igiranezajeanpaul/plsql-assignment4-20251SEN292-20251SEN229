CREATE OR REPLACE FUNCTION annual_salary (
    p_id IN employees.employee_id%TYPE
) RETURN NUMBER AS
    v_employee employees%ROWTYPE;
BEGIN
    SELECT * INTO v_employee FROM employees WHERE employee_id = p_id;
    RETURN v_employee.salary * 12;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20010, 'Cannot calculate annual salary: employee not found.');
END;
/
SHOW ERRORS FUNCTION annual_salary
