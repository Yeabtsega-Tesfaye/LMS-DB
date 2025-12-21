USE CourseManagementDB;
GO

CREATE MASTER KEY
ENCRYPTION BY PASSWORD = 'StrongMasterKey@123';
GO

CREATE CERTIFICATE StudentDataCert
WITH SUBJECT = 'Certificate for encrypting student sensitive data';
GO

CREATE SYMMETRIC KEY StudentDataKey
WITH ALGORITHM = AES_256
ENCRYPTION BY CERTIFICATE StudentDataCert;
GO

ALTER TABLE STUDENT
ADD encrypted_phone VARBINARY(MAX);
GO

OPEN SYMMETRIC KEY StudentDataKey
DECRYPTION BY CERTIFICATE StudentDataCert;

UPDATE STUDENT
SET encrypted_phone = EncryptByKey(
    Key_GUID('StudentDataKey'),
    phone_number
);

CLOSE SYMMETRIC KEY StudentDataKey;
GO

SELECT student_id, encrypted_phone
FROM STUDENT;

OPEN SYMMETRIC KEY StudentDataKey
DECRYPTION BY CERTIFICATE StudentDataCert;

SELECT
    student_id,
    CONVERT(VARCHAR(20),
        DecryptByKey(encrypted_phone)
    ) AS decrypted_phone
FROM STUDENT;

CLOSE SYMMETRIC KEY StudentDataKey;
GO

