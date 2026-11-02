SELECT * FROM departments ORDER BY department_id;


SELECT * FROM employees ORDER BY employee_id;





SELECT object_name, object_type, status FROM user_objects
WHERE object_name IN ('ADD_EMPLOYEE', 'UPDATE_SALARY', 'DELETE_EMPLOYEE',
    'LIST_EMPLOYEES', 'RAISE_DEPARTMENT_SALARIES', 'ANNUAL_SALARY',
    'FIND_EMPLOYEE_ID') ORDER BY object_type, object_name;
    
    
    
SELECT name, type, line, position, text FROM user_errors
WHERE name IN ('ADD_EMPLOYEE', 'UPDATE_SALARY', 'DELETE_EMPLOYEE',
    'LIST_EMPLOYEES', 'RAISE_DEPARTMENT_SALARIES', 'ANNUAL_SALARY',
    'FIND_EMPLOYEE_ID') AND attribute = 'ERROR' ORDER BY name, sequence;
