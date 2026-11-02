# Alyos Employee Management System

Oracle PL/SQL Assignment 4 - INSY 8311

## Group members: GROUP I

| Name | Student ID |
| --- | --- |
| Igiraneza Jean Paul | 20251SEN292 |
| Iyeze Bruno | 20251SEN229 |

## About the application

This simple coursework application manages employees and departments for Alyos.
It uses fictional employees with Rwandan names and salaries in Rwandan francs (RWF).

Users can add, update, delete and list employees, calculate annual salary, find
an employee by name, and give a department a salary increase. Each employee must
belong to an existing department. Employee IDs are unique, and monthly salaries
must be between RWF 50,000 and 5,000,000 under our example salary policy.

## How to run

Connect to an empty Oracle coursework schema in SQL Developer. Open each file
on the same connection and press **F5**, following this order:

1. `00_schema/01_create_tables.sql`
2. `00_schema/02_insert_sample_data.sql`
3. All five files in `01_procedures/`
4. Both files in `02_functions/`
5. `03_tests/verify_setup.sql`
6. `03_tests/test_success_cases.sql`
7. `03_tests/test_error_cases.sql`

Run table creation only once. The sample contains three departments and five
employees. Successful procedures leave COMMIT or ROLLBACK to the caller.

## Test results

- All five procedures and two functions are shown as VALID.
- Success tests S01-S13 passed: [success output](screenshots/test_success_output.png).
- Error tests E01-E16 passed: [error output](screenshots/test_error_output.png).
- The tests roll back their changes: [original data after testing](screenshots/data_after_test_output.png).

Other setup and compilation evidence is in `screenshots/`.
See [implementation notes](docs/IMPLEMENTATION_NOTES.md) for the PL/SQL concepts
and performance explanation.

## AI assistance

We used OpenAI Codex to help write parts of the code and documentation and
understand PL/SQL concepts. We ran the tests in Oracle SQL Developer and included
the results in the screenshots. We are responsible for understanding
and explaining the submitted work.
