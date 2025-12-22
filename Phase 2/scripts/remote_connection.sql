USE CourseManagementDB;
GO

SELECT DB_NAME() AS CurrentDB;


USE master;
GO

CREATE LOGIN lms_remote_login
WITH PASSWORD = 'Strong@123';
GO

USE CourseManagementDB;
GO

CREATE USER lms_remote_user FOR LOGIN lms_remote_login;
GO

GRANT SELECT ON SCHEMA::dbo TO lms_remote_user;
GO
