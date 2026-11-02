SET SERVEROUTPUT ON SIZE UNLIMITED
DECLARE
    v_rows PLS_INTEGER;
    v_value NUMBER;
    PROCEDURE expect_error(p_sql VARCHAR2, p_code NUMBER, p_label VARCHAR2) IS
        v_raised BOOLEAN := FALSE;
    BEGIN
        BEGIN
            EXECUTE IMMEDIATE p_sql;
        EXCEPTION
            WHEN OTHERS THEN
                IF SQLCODE <> p_code THEN
                    RAISE;
                END IF;
                v_raised := TRUE;
                DBMS_OUTPUT.PUT_LINE('PASS ' || p_label || ' -> ' || SQLERRM);
        END;
        IF NOT v_raised THEN
            RAISE_APPLICATION_ERROR(-20992, p_label || ': expected error ' || p_code);
        END IF;
    END;
    PROCEDURE check_value(p_actual NUMBER, p_expected NUMBER, p_label VARCHAR2) IS
    BEGIN
        IF p_actual IS NULL OR p_actual <> p_expected THEN
            RAISE_APPLICATION_ERROR(-20993, 'Assertion failed: ' || p_label);
        END IF;
        DBMS_OUTPUT.PUT_LINE('PASS ' || p_label);
    END;
BEGIN
    SAVEPOINT error_tests_start;
    expect_error('DECLARE n PLS_INTEGER; BEGIN add_employee(101,''Duplicate'',1,100000,n); END;',
        -20002, 'E01 duplicate employee ID');
    expect_error('DECLARE n PLS_INTEGER; BEGIN add_employee(900,''Test'',999,100000,n); END;',
        -20003, 'E02 unknown department foreign key');
    expect_error('DECLARE n PLS_INTEGER; BEGIN add_employee(900,''Test'',1,100,n); END;',
        -20001, 'E03 invalid employee input');
    expect_error('DECLARE n PLS_INTEGER; BEGIN update_salary(101,100,n); END;',
        -20004, 'E04 user-defined invalid salary exception');
    expect_error('DECLARE n PLS_INTEGER; BEGIN update_salary(999,100000,n); END;',
        -20005, 'E05 update missing employee');
    expect_error('DECLARE n PLS_INTEGER; BEGIN delete_employee(999,n); END;',
        -20006, 'E06 SQL%NOTFOUND');
    expect_error('DECLARE n PLS_INTEGER; BEGIN raise_department_salaries(1,0,n); END;',
        -20007, 'E07 invalid raise percent');
    expect_error('DECLARE n PLS_INTEGER; BEGIN raise_department_salaries(999,10,n); END;',
        -20008, 'E08 missing raise department');
    expect_error('DECLARE n NUMBER; BEGIN n := annual_salary(999); END;',
        -20010, 'E09 NO_DATA_FOUND in annual salary');
    expect_error('DECLARE n NUMBER; BEGIN n := find_employee_id(''Missing''); END;',
        -20011, 'E10 missing name');
    expect_error('DECLARE n NUMBER; BEGIN n := find_employee_id(''Mugisha Eric''); END;',
        -20012, 'E11 TOO_MANY_ROWS');

    add_employee(900, 'Niyonsenga Claude', 2, 250000, v_rows);
    expect_error('DECLARE n PLS_INTEGER; BEGIN raise_department_salaries(1,10,n); END;',
        -20009, 'E12 FORALL SAVE EXCEPTIONS');
    SELECT salary INTO v_value FROM employees WHERE employee_id = 101;
    check_value(v_value, 100000, 'E13 first successful bulk change rolled back');
    SELECT salary INTO v_value FROM employees WHERE employee_id = 102;
    check_value(v_value, 200000, 'E14 second successful bulk change rolled back');
    SELECT salary INTO v_value FROM employees WHERE employee_id = 103;
    check_value(v_value, 4900000, 'E15 failed employee salary unchanged');
    SELECT COUNT(*) INTO v_rows FROM employees WHERE employee_id = 900;
    check_value(v_rows, 1, 'E16 earlier caller work preserved');
    ROLLBACK TO error_tests_start;
    DBMS_OUTPUT.PUT_LINE('ERROR TESTS PASS');
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK TO error_tests_start;
        RAISE;
END;
/
