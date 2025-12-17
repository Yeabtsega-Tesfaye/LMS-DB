-- 1️. Stored Procedure: Add New Student
-- Business logic: Register a new student into the system.

GO
CREATE PROCEDURE sp_add_student
    @first_name VARCHAR(50),
    @last_name VARCHAR(50),
    @email VARCHAR(255),
    @phone_number VARCHAR(20),
    @date_of_birth DATE,
    @address TEXT,
    @major_department_id INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Check for duplicate email
    IF EXISTS (SELECT 1 FROM STUDENT WHERE email = @email)
    BEGIN
        RAISERROR('Student with this email already exists.', 16, 1);
        RETURN;
    END

    INSERT INTO STUDENT (
        first_name,
        last_name,
        email,
        phone_number,
        date_of_birth,
        address,
        major_department_id
    )
    VALUES (
        @first_name,
        @last_name,
        @email,
        @phone_number,
        @date_of_birth,
        @address,
        @major_department_id
    );
END;
GO


-- 2️. Stored Procedure: Enroll Student in Course
-- Business logic: Register a student for a course while checking capacity.

GO
CREATE PROCEDURE sp_enroll_student
    @student_id INT,
    @course_id INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;

    -- Prevent duplicate enrollment
    IF EXISTS (
        SELECT 1 FROM ENROLLMENT
        WHERE student_id = @student_id AND course_id = @course_id
    )
    BEGIN
        ROLLBACK;
        RAISERROR('Student already enrolled in this course.', 16, 1);
        RETURN;
    END

    -- Check course capacity
    IF (
        SELECT current_enrollment FROM COURSE WHERE course_id = @course_id
    ) >= (
        SELECT max_capacity FROM COURSE WHERE course_id = @course_id
    )
    BEGIN
        ROLLBACK;
        RAISERROR('Course is already full.', 16, 1);
        RETURN;
    END

    -- Enroll student
    INSERT INTO ENROLLMENT (student_id, course_id)
    VALUES (@student_id, @course_id);

    -- Update course enrollment count
    UPDATE COURSE
    SET current_enrollment = current_enrollment + 1
    WHERE course_id = @course_id;

    COMMIT TRANSACTION;
END;
GO


-- 3️. Stored Procedure: Cancel Enrollment (Booking)
-- Business logic: Drop a student from a course safely.

GO
CREATE PROCEDURE sp_cancel_enrollment
    @student_id INT,
    @course_id INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRANSACTION;

    IF NOT EXISTS (
        SELECT 1 FROM ENROLLMENT
        WHERE student_id = @student_id AND course_id = @course_id
    )
    BEGIN
        ROLLBACK;
        RAISERROR('Enrollment does not exist.', 16, 1);
        RETURN;
    END

    UPDATE ENROLLMENT
    SET enrollment_status = 'Dropped'
    WHERE student_id = @student_id AND course_id = @course_id;

    UPDATE COURSE
    SET current_enrollment = current_enrollment - 1
    WHERE course_id = @course_id;

    COMMIT TRANSACTION;
END;
GO
