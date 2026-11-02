# Implementation Notes

## Tables

`departments` stores department names. `employees` stores employee details,
monthly salary and hire date. A foreign key links employees to departments.
Primary keys, NOT NULL, UNIQUE and CHECK constraints protect the data.

## Records and collections

`list_employees` uses a user-defined record containing ID, name and salary.
`annual_salary` uses `employees%ROWTYPE` to hold a complete employee row and
returns monthly salary multiplied by 12.

`raise_department_salaries` uses a nested-table collection to store employee IDs.
`BULK COLLECT` fills this collection. An empty department returns zero updates.

## Cursors

- `add_employee` uses `SQL%ROWCOUNT` after INSERT.
- `update_salary` uses `SQL%FOUND` and `SQL%ROWCOUNT` after UPDATE.
- `delete_employee` uses `SQL%NOTFOUND` after DELETE.
- `list_employees` declares an explicit cursor. Its FOR loop automatically
  opens, fetches and closes the cursor.

## Exceptions

The routines handle duplicate IDs, missing employees/departments and ambiguous
names. They demonstrate `DUP_VAL_ON_INDEX`, `NO_DATA_FOUND` and `TOO_MANY_ROWS`.
The two Mugisha Eric records intentionally demonstrate the ambiguous-name case.

`update_salary` raises a user-defined exception for an invalid salary.
`RAISE_APPLICATION_ERROR` provides meaningful messages. Unexpected errors
propagate instead of being silently ignored.

## Bulk processing and transactions

`FORALL ... SAVE EXCEPTIONS` attempts the department salary updates.
`SQL%BULK_EXCEPTIONS` identifies failed employees. A savepoint allows the
procedure to undo the entire raise if any salary violates the allowed range.

For example, employee 103 earns RWF 4,900,000. A 10% raise would produce
RWF 5,390,000, exceeding the RWF 5,000,000 limit. The procedure cancels the
raise, and tests E13-E15 confirm the original salaries remain. E16 confirms
that earlier caller work is preserved.

## Performance and testing

Bulk operations reduce repeated calls between PL/SQL and SQL compared with
row-by-row updates. A single UPDATE would normally be simpler for a uniform
raise; this version demonstrates the required bulk concepts. No timing speedup
is claimed for this small dataset. Large collections would need bounded batches.

The success tests compare actual and expected values. The error tests check
expected error codes and rollback behavior. Screenshots show S01-S13 and
E01-E16 passing, seven VALID routines, and the original data after testing.
