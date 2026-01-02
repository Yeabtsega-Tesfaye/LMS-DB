-- COMPLETE REMOTELINKUSER SCRIPT
USE [master];
GO

-- 1. CHECK if the login exists and its properties
PRINT '1. Checking login existence...';
SELECT 
    name, 
    type_desc,
    is_disabled,
    default_database_name
FROM sys.server_principals 
WHERE name = N'RemoteLinkUser';

-- 2. DROP and RECREATE the login to ensure correct password (Fix for "Login failed")
PRINT '2. Recreating login with known password...';
IF EXISTS (SELECT * FROM sys.server_principals WHERE name = N'RemoteLinkUser')
BEGIN
    DROP LOGIN [RemoteLinkUser];
    PRINT '   Old login dropped.';
END

-- Create with the EXACT password used in your linked server ('SecurePass123!')
CREATE LOGIN [RemoteLinkUser] 
WITH PASSWORD = N'SecurePass123!',
     DEFAULT_DATABASE = [master],
     CHECK_EXPIRATION = OFF,
     CHECK_POLICY = OFF;
PRINT '   Login recreated.';

-- 3. GRANT essential server-level permissions
PRINT '3. Granting server permissions...';
GRANT CONNECT SQL TO [RemoteLinkUser];
GRANT VIEW ANY DATABASE TO [RemoteLinkUser]; -- Allows seeing database list
PRINT '   Permissions granted.';

-- 4. MAP the login to the CourseManagementDB database
PRINT '4. Mapping to CourseManagementDB...';
USE [CourseManagementDB];
GO

IF EXISTS (SELECT * FROM sys.database_principals WHERE name = N'RemoteLinkUser')
BEGIN
    DROP USER [RemoteLinkUser];
    PRINT '   Old user dropped.';
END

CREATE USER [RemoteLinkUser] FOR LOGIN [RemoteLinkUser];
PRINT '   User created.';

-- 5. GRANT specific table permissions
PRINT '5. Granting SELECT permission on Students table...';
GRANT SELECT ON [dbo].[STUDENT] TO [RemoteLinkUser];
-- Optional: Grant VIEW DEFINITION to avoid metadata errors
GRANT VIEW DEFINITION TO [RemoteLinkUser];
PRINT '   Permissions granted.';

-- 6. TEST the login locally on HP (Optional verification)
PRINT '6. Testing login locally...';
EXECUTE AS LOGIN = 'RemoteLinkUser';
SELECT 
    'SUCCESS: Connected as' AS Status,
    ORIGINAL_LOGIN() AS Original_Login,
    CURRENT_USER AS Database_User,
    @@SERVERNAME AS Server_Name;
REVERT;
GO

PRINT '--- SCRIPT COMPLETE ---';
PRINT 'Please return to your new PC and retest the linked server connection.';
GO

EXEC sp_linkedservers;