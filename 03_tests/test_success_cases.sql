SET SERVEROUTPUT ON SIZE UNLIMITED
DECLARE
    v_rows PLS_INTEGER;
    v_value NUMBER;
    PROCEDURE check_value(p_actual NUMBER, p_expected NUMBER, p_label VARCHAR2) IS
    BEGIN
        IF p_actual IS NULL OR p_actual <> p_expected THEN
            RAISE_APPLICATION_ERROR(-20991, p_label || ': expected ' || p_expected ||
                ', got ' || NVL(TO_CHAR(p_actual), 'NULL'));
        END IF;
        DBMS_OUTPUT.PUT_LINE('PASS ' || p_label);
    END;
BEGIN
    SAVEPOINT success_tests_start;
    SELECT annual_salary(101) INTO v_value FROM dual;
    check_value(v_value, 1200000, 'S01 function called from SQL');
    v_value := find_employee_id('uwase aline');
    check_value(v_value, 101, 'S02 name lookup called from PL/SQL');
    list_employees(v_rows);
    check_value(v_rows, 5, 'S03 explicit cursor and custom record');

    add_employee(900, 'Ndayisaba Patrick', 2, 250000, v_rows);
    check_value(v_rows, 1, 'S04 INSERT and SQL%ROWCOUNT');
    update_salary(900, 350000, v_rows);
    check_value(v_rows, 1, 'S05 UPDATE and SQL%FOUND');
    v_value := annual_salary(900);
    check_value(v_value, 4200000, 'S06 updated salary and %ROWTYPE');

    raise_department_salaries(2, 10, v_rows);
    -- Employee 900 is in IT too, so this test updates three employees.
    check_value(v_rows, 3, 'S07 BULK COLLECT and FORALL row count');
    SELECT salary INTO v_value FROM employees WHERE employee_id = 201;
    check_value(v_value, 330000, 'S08 Mukamana Diane received 10 percent raise');
    SELECT salary INTO v_value FROM employees WHERE employee_id = 202;
    check_value(v_value, 440000, 'S09 Mugisha Eric received 10 percent raise');
    raise_department_salaries(3, 10, v_rows);
    check_value(v_rows, 0, 'S10 empty department handled');

    delete_employee(900, v_rows);
    check_value(v_rows, 1, 'S11 DELETE row count');
    SELECT COUNT(*) INTO v_rows FROM employees WHERE employee_id = 900;
    check_value(v_rows, 0, 'S12 deleted employee absent');
    ROLLBACK TO success_tests_start;
    SELECT salary INTO v_value FROM employees WHERE employee_id = 201;
    check_value(v_value, 300000, 'S13 test changes rolled back');
    DBMS_OUTPUT.PUT_LINE('SUCCESS TESTS PASS');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK TO success_tests_start;
        RAISE;
END;
/
