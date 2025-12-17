CREATE ROLE Admin;
CREATE ROLE Manager;
CREATE ROLE Clerk;
CREATE ROLE Auditor;

GRANT CONTROL ON DATABASE::CourseManagementDB TO Admin;

GRANT SELECT, INSERT, UPDATE
ON COURSE TO Manager;

GRANT SELECT, INSERT, UPDATE
ON ENROLLMENT TO Manager;

GRANT SELECT, INSERT
ON ENROLLMENT TO Clerk;

GRANT SELECT
ON STUDENT TO Auditor;

GRANT SELECT
ON COURSE TO Auditor;

GRANT SELECT
ON ENROLLMENT TO Auditor;

GRANT SELECT
ON AUDIT_LOG TO Auditor;

CREATE USER clerk_user WITHOUT LOGIN;
ALTER ROLE Clerk ADD MEMBER clerk_user;

CREATE USER auditor_user WITHOUT LOGIN;
ALTER ROLE Auditor ADD MEMBER auditor_user;

SELECT * FROM sys.database_role_members;

SELECT
    dp.name AS RoleName,
    o.name AS ObjectName,
    p.permission_name AS Permission,
    p.state_desc AS PermissionState
FROM sys.database_permissions p
JOIN sys.database_principals dp
    ON p.grantee_principal_id = dp.principal_id
LEFT JOIN sys.objects o
    ON p.major_id = o.object_id
WHERE dp.type = 'R'
ORDER BY RoleName, ObjectName;



