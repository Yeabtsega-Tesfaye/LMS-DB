GO
CREATE TABLE AUDIT_LOG (
    audit_id INT IDENTITY(1,1) PRIMARY KEY,
    table_name VARCHAR(100),
    action_type VARCHAR(10),
    changed_by VARCHAR(100),
    change_time DATETIME DEFAULT GETDATE(),
    record_id INT,
    description VARCHAR(255)
);
GO