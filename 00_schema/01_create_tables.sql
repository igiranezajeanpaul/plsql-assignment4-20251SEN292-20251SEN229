CREATE TABLE departments (
    department_id NUMBER(4) CONSTRAINT pk_departments PRIMARY KEY,
    department_name VARCHAR2(50) NOT NULL,
    CONSTRAINT uq_department_name UNIQUE (department_name)
);

CREATE TABLE employees (
    employee_id NUMBER(6) CONSTRAINT pk_employees PRIMARY KEY,
    employee_name VARCHAR2(80) NOT NULL,
    department_id NUMBER(4) NOT NULL,
    salary NUMBER(10,2) NOT NULL,
    hire_date DATE DEFAULT SYSDATE NOT NULL,
    CONSTRAINT fk_employee_department FOREIGN KEY (department_id)
        REFERENCES departments(department_id),
    CONSTRAINT ck_employee_id CHECK (employee_id > 0),
    CONSTRAINT ck_employee_salary CHECK (salary BETWEEN 50000 AND 5000000)
);
CREATE INDEX ix_employee_department ON employees(department_id);
