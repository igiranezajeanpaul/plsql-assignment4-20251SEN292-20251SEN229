CREATE OR REPLACE PROCEDURE list_employees (
    p_count OUT PLS_INTEGER
) AS
    TYPE t_employee_record IS RECORD (
        id employees.employee_id%TYPE,
        name employees.employee_name%TYPE,
        monthly_salary employees.salary%TYPE
    );
    v_employee t_employee_record;
    CURSOR c_employees IS
        SELECT employee_id, employee_name, salary
        FROM employees ORDER BY employee_id;
BEGIN
    p_count := 0;
    DBMS_OUTPUT.PUT_LINE('ALYOS EMPLOYEE DIRECTORY - monthly salaries in RWF');
    FOR r IN c_employees LOOP
        v_employee.id := r.employee_id;
        v_employee.name := r.employee_name;
        v_employee.monthly_salary := r.salary;
        DBMS_OUTPUT.PUT_LINE(v_employee.id || ' | ' || v_employee.name ||
            ' | salary (RWF)=' || v_employee.monthly_salary);
        p_count := p_count + 1;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Employees listed: ' || p_count);
END;
/
SHOW ERRORS PROCEDURE list_employees
