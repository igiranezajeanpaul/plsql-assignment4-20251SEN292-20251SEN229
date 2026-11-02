CREATE OR REPLACE PROCEDURE raise_department_salaries (
    p_department IN departments.department_id%TYPE,
    p_percent IN NUMBER,
    p_rows OUT PLS_INTEGER
) AS
    TYPE t_employee_ids IS TABLE OF employees.employee_id%TYPE;
    v_ids t_employee_ids;
    v_department departments.department_id%TYPE;
    e_bulk_errors EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_bulk_errors, -24381);
    v_index PLS_INTEGER;
    v_message VARCHAR2(1800);
BEGIN
    SAVEPOINT employee_raise_start;
    IF p_percent IS NULL OR p_percent <= 0 OR p_percent > 100 THEN
        RAISE_APPLICATION_ERROR(-20007, 'Raise percentage must be greater than 0 and at most 100.');
    END IF;
    SELECT department_id INTO v_department
    FROM departments WHERE department_id = p_department;

    SELECT employee_id BULK COLLECT INTO v_ids
    FROM employees WHERE department_id = v_department ORDER BY employee_id;

    p_rows := 0;
    IF v_ids.COUNT = 0 THEN
        RETURN;
    END IF;

    BEGIN
        FORALL i IN 1 .. v_ids.COUNT SAVE EXCEPTIONS
            UPDATE employees
            SET salary = ROUND(salary * (1 + p_percent / 100), 2)
            WHERE employee_id = v_ids(i) AND department_id = v_department;
        p_rows := SQL%ROWCOUNT;
    EXCEPTION
        WHEN e_bulk_errors THEN
            v_message := 'Raise cancelled. Failed employees: ';
            FOR j IN 1 .. SQL%BULK_EXCEPTIONS.COUNT LOOP
                v_index := SQL%BULK_EXCEPTIONS(j).ERROR_INDEX;
                DBMS_OUTPUT.PUT_LINE('Employee ' || v_ids(v_index) || ': ' ||
                    SQLERRM(-SQL%BULK_EXCEPTIONS(j).ERROR_CODE));
                IF LENGTH(v_message) < 1300 THEN
                    v_message := v_message || v_ids(v_index) || ' ';
                END IF;
            END LOOP;
            RAISE_APPLICATION_ERROR(-20009, v_message);
    END;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        ROLLBACK TO employee_raise_start;
        RAISE_APPLICATION_ERROR(-20008, 'Raise department not found.');
    WHEN OTHERS THEN
        ROLLBACK TO employee_raise_start;
        RAISE;
END;
/
SHOW ERRORS PROCEDURE raise_department_salaries
