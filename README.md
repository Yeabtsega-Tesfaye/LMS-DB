# LMS-DB (CourseManagementDB)

A Microsoft SQL Server (T-SQL) implementation of a Learning Management System database (CourseManagementDB).  
This repository contains the schema, seed data, business logic, operational scripts and documentation used to build and maintain the LMS database for a university environment.

- Primary schema and seed data: Phase 1/scripts (DDLquery.sql, DMLscript.sql)
- Advanced/operational features: Phase 2/scripts (views, stored procedures, triggers, audit, backup/restore, encryption, linked servers, roles, transaction tests)
- Design docs and diagram: Phase 1/Phase 1 Report.pdf and Phase 1/RE-Diagram.png
- Author / owner: Yeabtsega-Tesfaye

Table of contents
- About
- Repository layout
- Requirements / prerequisites
- Quick start (create DB, load schema, seed data)
- Schema overview
- Seed data and demo queries
- Views (reporting)
- Stored procedures (usage examples)
- Triggers & auditing
- Encryption of sensitive data
- Backup & restore (recommended procedure)
- Linked servers & remote connection notes
- Roles & permissions
- Transaction tests & verification
- Troubleshooting
- Contributing & License

---

## About
CourseManagementDB is a relational schema for a university LMS that includes departments, instructors, students, courses, enrollments, assignments and submissions. Phase 2 adds reporting views, stored procedures to encapsulate business logic, triggers for audit logging, encryption for sensitive fields, backup/restore examples and remote/linked-server integration support.

---

## Repository layout (high-level)
- Phase 1/
  - Phase 1 Report.pdf — design, objectives, requirements
  - RE-Diagram.png — ER diagram
  - scripts/
    - DDLquery.sql — schema and indexes
    - DMLscript.sql — seed/sample data
- Phase 2/
  - Phase 2.docx — Phase 2 report/details
  - scripts/
    - views.sql
    - stored_procedures.sql
    - trigger.sql
    - audit_table.sql
    - encript_&_decript.sql
    - backup_&_restore.sql
    - linked_server.sql
    - remote_connection.sql
    - role_creation.sql
    - transaction_tests.sql
    - ...screenshots demonstrating outputs

Refer to the files above for the full scripts and screenshots.

---

## Requirements / prerequisites
- Microsoft SQL Server (2016+ recommended to support AES_256, database features and modern tooling)
- SQL Server Management Studio (SSMS) or sqlcmd
- Windows filesystem access where backups will be stored (scripts use paths like `C:\DB_backups\`; change to a suitable path)
- Administrative permissions on the SQL Server instance for CREATE DATABASE, BACKUP/RESTORE, CREATE MASTER KEY, LOGIN creation, etc.

Security note: many sample scripts include example passwords and file paths. Always change passwords and adapt file paths to your environment before running.

---

## Quick start

1. Open SSMS (or connect via sqlcmd) to the SQL Server instance.
2. Create the database and run DDL (schema):
   - File: Phase 1/scripts/DDLquery.sql
   - In SSMS: open the script, execute. Or:
     - sqlcmd -S <server> -i "Phase 1/scripts/DDLquery.sql"

3. Seed the database with sample data:
   - File: Phase 1/scripts/DMLscript.sql
   - Execute in SSMS while connected to CourseManagementDB (the script uses USE CourseManagementDB).

4. Create audit/log table and Phase 2 objects:
   - Execute Phase 2/scripts/audit_table.sql
   - Execute Phase 2/scripts/views.sql
   - Execute Phase 2/scripts/stored_procedures.sql
   - Execute Phase 2/scripts/trigger.sql (note: triggers reference AUDIT_LOG, so create it first)

5. Optional: run encryption, backup scripts and remote/linked-server scripts once you have admin privileges and have adapted passwords/paths (see sections below).

---

## Schema overview (key tables)
Major tables implemented in DDLquery.sql:
- DEPARTMENT — departments (department_id, name, code, head_instructor_id, contact info)
- INSTRUCTOR — faculty with department FK
- STUDENT — student profiles (phone_number, enrollment_date, major_department_id, GPA)
- COURSE — course offerings (course_code, instructor_id, capacity, semester, academic_year)
- ENROLLMENT — student registrations (FKs to STUDENT and COURSE, unique constraint per student-course)
- ASSIGNMENT — assignments per course
- SUBMISSION — student assignment submissions
- AUDIT_LOG — audit trail (created in Phase 2 script)

Refer to Phase 1/scripts/DDLquery.sql for full column definitions, FK constraints and indexes.

ER Diagram: Phase 1/RE-Diagram.png — view this for a visual relationship map.

---

## Seed data and demo queries
Seed data with DMLscript.sql contains sample departments, instructors, students, courses, enrollments, assignments and submissions for demonstration.

Sample verification queries (run in SSMS against CourseManagementDB):

- Count rows:
```sql
SELECT 'DEPARTMENT' AS Table_Name, COUNT(*) AS Record_Count FROM DEPARTMENT
UNION ALL 
SELECT 'INSTRUCTOR', COUNT(*) FROM INSTRUCTOR
UNION ALL 
SELECT 'STUDENT', COUNT(*) FROM STUDENT
UNION ALL 
SELECT 'COURSE', COUNT(*) FROM COURSE
UNION ALL 
SELECT 'ENROLLMENT', COUNT(*) FROM ENROLLMENT
UNION ALL 
SELECT 'ASSIGNMENT', COUNT(*) FROM ASSIGNMENT
UNION ALL 
SELECT 'SUBMISSION', COUNT(*) FROM SUBMISSION;
```

- Sample join (students with course enrollments):
```sql
SELECT TOP 20 s.student_id, s.first_name, s.last_name, c.course_code, c.course_name, e.enrollment_status
FROM STUDENT s
JOIN ENROLLMENT e ON s.student_id = e.student_id
JOIN COURSE c ON e.course_id = c.course_id
ORDER BY c.course_code, s.first_name;
```

---

## Views (reporting layer)
Files: Phase 2/scripts/views.sql

Key views:
- vw_student_dashboard — student courses and enrollment status
- vw_course_enrollment_summary — capacity/availability per course
- vw_instructor_course_load — instructor assignments by semester/year
- vw_department_course_summary — department-level course counts and enrollment totals

Use them like:
```sql
SELECT * FROM vw_student_dashboard WHERE student_id = 1;
SELECT * FROM vw_course_enrollment_summary ORDER BY available_seats DESC;
```

---

## Stored procedures (business logic)
File: Phase 2/scripts/stored_procedures.sql

Notable procedures:
- sp_add_student (@first_name, @last_name, @email, ...)
- sp_enroll_student (@student_id, @course_id) — checks duplicates and capacity; transaction-safe
- sp_cancel_enrollment (@student_id, @course_id) — sets status to 'Dropped' and decrements course count

Example calls:
```sql
-- Add a student
EXEC sp_add_student
  @first_name = 'Test',
  @last_name  = 'User',
  @email      = 'test.user@example.com',
  @phone_number = '+251-9...',
  @date_of_birth = '2000-01-01',
  @address = 'Sample address',
  @major_department_id = 1;

-- Enroll student (uses transactional checks)
EXEC sp_enroll_student @student_id = 1, @course_id = 2;

-- Cancel enrollment
EXEC sp_cancel_enrollment @student_id = 1, @course_id = 2;
```

Important: sp_enroll_student uses transactions and RAISERROR for business rule violations.

---

## Triggers & Auditing
Files: Phase 2/scripts/trigger.sql and Phase 2/scripts/audit_table.sql

- AUDIT_LOG records INSERT/UPDATE/DELETE on ENROLLMENT via triggers (trg_enrollment_insert, trg_enrollment_update, trg_enrollment_delete).
- Create AUDIT_LOG before enabling triggers.

Example:
```sql
SELECT TOP 50 * FROM AUDIT_LOG ORDER BY change_time DESC;
```

Audit fields: audit_id, table_name, action_type, changed_by, change_time, record_id, description

---

## Encryption (sensitive data)
File: Phase 2/scripts/encript_&_decript.sql

This script demonstrates:
- Creating a database master key
- Creating a certificate
- Creating a symmetric key (AES_256)
- Encrypting phone_number into a varbinary encrypted_phone column
- Decrypting for display (requires opening the symmetric key each session)

Security notes:
- Replace hard-coded passwords with secure secrets and protect the master key/certificate backups.
- Example uses: MASTER KEY password = 'StrongMasterKey@123' — change immediately in production.

Example usage:
```sql
-- Open key, decrypt and display
OPEN SYMMETRIC KEY StudentDataKey
DECRYPTION BY CERTIFICATE StudentDataCert;

SELECT student_id, CONVERT(VARCHAR(20), DecryptByKey(encrypted_phone)) AS decrypted_phone
FROM STUDENT;

CLOSE SYMMETRIC KEY StudentDataKey;
```

---

## Backup & restore (operations)
File: Phase 2/scripts/backup_&_restore.sql

Key points:
- Script sets CourseManagementDB to FULL recovery model before log backups.
- Demonstrates full backup, differential backup, log backup, tail-log backup, and staged restore with NORECOVERY / RECOVERY.
- Backup file paths in the script use `C:\DB_backups\CourseManagementDB_*.bak` and `.trn`. Update paths to your backup location.

Typical sequence to perform a full backup:
```sql
BACKUP DATABASE CourseManagementDB
TO DISK = N'C:\DB_backups\CourseManagementDB_Full.bak'
WITH INIT, NAME = 'Full Backup of CourseManagementDB';
```

To restore:
```sql
RESTORE DATABASE CourseManagementDB
FROM DISK = N'C:\DB_backups\CourseManagementDB_Full.bak'
WITH RECOVERY;
```

Important: Always verify backups with RESTORE VERIFYONLY and test restores on a non-production instance.

---

## Linked servers & remote access
Files: Phase 2/scripts/linked_server.sql and remote_connection.sql

These scripts show:
- Creating SQL logins for remote access (examples: RemoteLinkUser; lms_remote_login)
- Mapping login to database users and granting SELECT permissions
- Creating linked server (sp_addlinkedserver) and login mapping (sp_addlinkedsrvlogin)

Security & configuration notes:
- Do not use example passwords in production. Replace them and follow your organization's password policy.
- The provider in linked_server.sql uses 'SQLNCLI' and a `@datasrc` of 'localhost' — change to the appropriate instance/host.
- Make sure firewall and server-level remote access settings are configured.

Example check of linked server:
```sql
SELECT * FROM CourseMgmt_Link.CourseManagementDB.dbo.STUDENT;
```

---

## Roles & permissions
File: Phase 2/scripts/role_creation.sql

Roles created:
- Admin (CONTROL on database)
- Manager (SELECT/INSERT/UPDATE on COURSE, ENROLLMENT)
- Clerk (limited ENROLLMENT insert/update)
- Auditor (SELECT on STUDENT, COURSE, ENROLLMENT, AUDIT_LOG)

Script also demonstrates creating database users and adding them to roles. Review and adjust privileges before applying to production.

---

## Transaction tests & examples
File: Phase 2/scripts/transaction_tests.sql

This file demonstrates:
- Simple transactions with COMMIT
- Transactions with intentional error and ROLLBACK
- Use of SAVE TRANSACTION and partial rollback via savepoint
- Example queries to verify insertions/rollbacks

Use these to validate ACID behavior on your instance.

---

## Troubleshooting (common issues & fixes)
- Permission errors creating master key or backup files:
  - Run scripts as a sysadmin or user with appropriate server-level privileges.
  - Ensure SQL Server service account has write permissions to backup directory.

- Linked server "Login failed":
  - Recreate the login with correct password, map to a database user, grant necessary permissions (see linked_server.sql and audit_table.sql for examples).
  - Check network/firewall settings and provider configuration.

- Encryption errors:
  - Ensure MASTER KEY and certificate are created in the same database before creating symmetric keys.
  - Backup the certificate and private key as part of DR plan.

- Restore fails with NORECOVERY/RECOVERY mismatch:
  - Follow backup/restore step order exactly: restore full -> diff (if used) -> logs -> RECOVERY. Tail-log backup requires NORECOVERY before subsequent restore steps.

- Duplicate enrollment errors when calling sp_enroll_student:
  - The procedure checks for existing enrollment and raises an error; handle exceptions in client applications.

---

## Security & safe-editing notes
- Do not commit real passwords or production certificates to the repository.
- Replace example passwords (e.g., 'SecurePass123!', 'Strong@123', 'StrongMasterKey@123') and file paths with environment-appropriate values before running scripts.
- Back up master keys and certificates securely; losing them will prevent decryption of data.

---

## Testing & verification
- Use the transaction_tests.sql and stored procedure calls to validate logic.
- Validate triggers by inserting/updating/deleting ENROLLMENT records and then querying AUDIT_LOG.
- Verify views return expected aggregates (e.g., vw_course_enrollment_summary).

---

## Contributing
- Open an issue or submit a PR with improvements.
- When adding or modifying scripts:
  - Include a short header comment describing purpose and tested environment.
  - Avoid committing secrets (passwords, keys).
  - Update this README if you add new scripts or change behavior.

---

## License
No license file is provided in the repository. Add a LICENSE file (for example MIT) if you want to make reuse explicit.

---

## Next steps / suggestions
- Add automated tests (unit tests for SPs and integration restore tests) and include a CI workflow that runs verification queries against a disposable test instance.
- Add a deployment script or PowerShell helper to run all initial setup tasks with environment variables for secrets.
- Add sample application or API that consumes the stored procedures and views to demonstrate end-to-end functionality.

---

If you want, I can:
- Create a one-click setup script (PowerShell / batch) that runs the DDL, seeds data, and creates roles with configurable parameters.
- Produce a smaller "quickstart" SQL file that only creates the minimal schema+sample data for rapid testing.

Thank you — let me know which extras you'd like and I will add them.