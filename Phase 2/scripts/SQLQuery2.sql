GO
CREATE TRIGGER trg_enrollment_insert
ON ENROLLMENT
AFTER INSERT
AS
BEGIN
    INSERT INTO AUDIT_LOG (
        table_name,
        action_type,
        changed_by,
        record_id,
        description
    )
    SELECT
        'ENROLLMENT',
        'INSERT',
        SYSTEM_USER,
        enrollment_id,
        'Student enrolled in a course'
    FROM inserted;
END;
GO

GO
CREATE TRIGGER trg_enrollment_update
ON ENROLLMENT
AFTER UPDATE
AS
BEGIN
    INSERT INTO AUDIT_LOG (
        table_name,
        action_type,
        changed_by,
        record_id,
        description
    )
    SELECT
        'ENROLLMENT',
        'UPDATE',
        SYSTEM_USER,
        enrollment_id,
        'Enrollment record updated'
    FROM inserted;
END;
GO

GO
CREATE TRIGGER trg_enrollment_delete
ON ENROLLMENT
AFTER DELETE
AS
BEGIN
    INSERT INTO AUDIT_LOG (
        table_name,
        action_type,
        changed_by,
        record_id,
        description
    )
    SELECT
        'ENROLLMENT',
        'DELETE',
        SYSTEM_USER,
        enrollment_id,
        'Enrollment record deleted'
    FROM deleted;
END;
GO

EXEC sp_enroll_student 2, 5;
EXEC sp_cancel_enrollment 1, 1;

SELECT * FROM AUDIT_LOG ORDER BY change_time DESC;

