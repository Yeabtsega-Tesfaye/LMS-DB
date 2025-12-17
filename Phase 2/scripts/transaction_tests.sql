BEGIN TRANSACTION;

INSERT INTO ENROLLMENT (student_id, course_id)
VALUES (3, 4);

UPDATE COURSE
SET current_enrollment = current_enrollment + 1
WHERE course_id = 1;

COMMIT;

BEGIN TRANSACTION;

INSERT INTO ENROLLMENT (student_id, course_id)
VALUES (4, 2);

-- Intentional error (invalid column)
UPDATE COURSE
SET wrong_column = wrong_column + 1
WHERE course_id = 1;

ROLLBACK;

BEGIN TRANSACTION;

BEGIN TRY
    -- Step 1: Enroll student (must be a NEW pair)
    INSERT INTO ENROLLMENT (student_id, course_id)
    VALUES (5, 2);

    -- Savepoint
    SAVE TRANSACTION EnrollSavepoint;

    -- Step 2: Force a runtime error
    RAISERROR ('Simulated failure after savepoint', 16, 1);

END TRY
BEGIN CATCH
    -- Roll back only to savepoint
    ROLLBACK TRANSACTION EnrollSavepoint;
END CATCH

-- Commit remaining successful work
COMMIT;


SELECT * FROM ENROLLMENT WHERE student_id = 5 AND course_id = 2;



SELECT * FROM ENROLLMENT;

