CREATE OR REPLACE PROCEDURE update_salary (
    p_id IN employees.employee_id%TYPE,
    p_salary IN NUMBER,
    p_rows OUT PLS_INTEGER
) AS
    e_invalid_salary EXCEPTION;
BEGIN
    IF p_salary IS NULL OR p_salary < 50000 OR p_salary > 5000000 THEN
        RAISE e_invalid_salary;
    END IF;
    UPDATE employees SET salary = p_salary WHERE employee_id = p_id;
    p_rows := SQL%ROWCOUNT;
    IF SQL%FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Salary updated for employee ' || p_id);
    ELSE
        RAISE_APPLICATION_ERROR(-20005, 'Cannot update: employee not found.');
    END IF;
EXCEPTION
    WHEN e_invalid_salary THEN
        RAISE_APPLICATION_ERROR(-20004, 'Salary must be between RWF 50000 and RWF 5000000.');
END;
/
SHOW ERRORS PROCEDURE update_salary
