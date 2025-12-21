USE master;
GO
ALTER DATABASE CourseManagementDB
SET RECOVERY FULL;
GO

SELECT
  name,
  recovery_model_desc
FROM master.sys.databases
WHERE name = 'CourseManagementDB';

SELECT name, state_desc
FROM sys.databases
WHERE name = 'CourseManagementDB';
GO

RESTORE DATABASE CourseManagementDB WITH RECOVERY;
GO

BACKUP DATABASE CourseManagementDB
TO DISK = 'C:\DB_backups\CourseManagementDB_Full.bak'
WITH INIT,
     NAME = 'Full Backup of CourseManagementDB';
GO

BACKUP DATABASE CourseManagementDB
TO DISK = 'C:\DB_backups\CourseManagementDB_Diff.bak'
WITH DIFFERENTIAL,
     INIT,
     NAME = 'Differential Backup of CourseManagementDB';
GO

BACKUP LOG CourseManagementDB
TO DISK = 'C:\DB_backups\CourseManagementDB_Log.trn'
WITH INIT,
     NAME = 'Transaction Log Backup of CourseManagementDB';
GO

RESTORE VERIFYONLY
FROM DISK = 'C:\DB_backups\CourseManagementDB_Full.bak';
GO

-- simulation
DELETE FROM ENROLLMENT
WHERE enrollment_id = 1;
GO

BACKUP LOG CourseManagementDB
TO DISK = 'C:\DB_backups\CourseManagementDB_TailLog.trn'
WITH NORECOVERY,
     NAME = 'Tail-Log Backup of CourseManagementDB';
GO

RESTORE DATABASE CourseManagementDB
FROM DISK = 'C:\DB_backups\CourseManagementDB_Full.bak'
WITH NORECOVERY;
GO

RESTORE DATABASE CourseManagementDB
FROM DISK = 'C:\DB_backups\CourseManagementDB_Diff.bak'
WITH NORECOVERY;
GO

RESTORE LOG CourseManagementDB
FROM DISK = 'C:\DB_backups\CourseManagementDB_Log.trn'
WITH NORECOVERY;
GO

RESTORE LOG CourseManagementDB
FROM DISK = 'C:\DB_backups\CourseManagementDB_TailLog.trn'
WITH RECOVERY;
GO

INSERT INTO DEPARTMENT (department_name, department_code)
VALUES ('Computer Science', 'CS');
GO

INSERT INTO STUDENT (first_name, last_name, email, date_of_birth)
VALUES ('Test', 'Student', 'test@student.com', '2000-01-01');
GO

SELECT * FROM ENROLLMENT;

INSERT INTO COURSE (course_code, course_name, credits, department_id, max_capacity, semester, academic_year)
VALUES ('CS101', 'Intro to CS', 3, 1, 50, 'Fall', 2025);
GO

USE CourseManagementDB;
GO

SELECT * FROM DEPARTMENT;
SELECT * FROM STUDENT;
SELECT * FROM COURSE;


INSERT INTO ENROLLMENT (student_id, course_id)
VALUES (1, 1);
GO
USE CourseManagementDB;
GO

EXEC sp_help ENROLLMENT;


USE CourseManagementDB;
GO

INSERT INTO ENROLLMENT (student_id, course_id)
VALUES (1, 8);
GO
