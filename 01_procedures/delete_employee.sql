CREATE OR REPLACE PROCEDURE delete_employee (
    p_id IN employees.employee_id%TYPE,
    p_rows OUT PLS_INTEGER
) AS
BEGIN
    DELETE FROM employees WHERE employee_id = p_id;
    IF SQL%NOTFOUND THEN
        RAISE_APPLICATION_ERROR(-20006, 'Cannot delete: employee not found.');
    END IF;
    p_rows := SQL%ROWCOUNT;
END;
/
SHOW ERRORS PROCEDURE delete_employee
