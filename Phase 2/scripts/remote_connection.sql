USE master;
GO
-- Drop if exists
DROP LOGIN IF EXISTS lms_remote_login;
GO
-- Create SQL login
CREATE LOGIN lms_remote_login WITH PASSWORD = 'Strong@123';
GO

USE CourseManagementDB;
GO
-- Create database user
CREATE USER lms_remote_user FOR LOGIN lms_remote_login;
GO
-- Grant SELECT on all tables in dbo schema
GRANT SELECT ON SCHEMA::dbo TO lms_remote_user;
GO

-- ON SQLDIST

-- Drop old linked server if it exists
EXEC sp_dropserver 'CourseMgmt_Link', 'droplogins';
GO

-- Create linked server
EXEC sp_addlinkedserver
    @server = 'CourseMgmt_Link',   -- Linked server name
    @srvproduct = '',
    @provider = 'SQLNCLI',         -- SQL Native Client
    @datasrc = 'localhost';         -- Main instance (default)
GO

EXEC sp_addlinkedsrvlogin
    @rmtsrvname = 'CourseMgmt_Link',
    @useself = 'FALSE',            -- Must use SQL login
    @rmtuser = 'yeab',
    @rmtpassword = 'Strong@123';
GO

SELECT *
FROM CourseMgmt_Link.CourseManagementDB.dbo.STUDENT;

SELECT @@SERVERNAME + 
       CASE WHEN SERVERPROPERTY('InstanceName') IS NULL THEN '' 
            ELSE '\' + CAST(SERVERPROPERTY('InstanceName') AS NVARCHAR(128)) 
       END AS InstanceInfo;
