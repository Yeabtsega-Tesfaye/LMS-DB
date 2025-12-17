-- =============================================
-- Database: CourseManagementDB
-- Description: Online Course Registration System
-- =============================================

-- Create Database
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'CourseManagementDB')
BEGIN
    CREATE DATABASE CourseManagementDB;
END

USE CourseManagementDB;
GO

-- =============================================
-- Table: DEPARTMENT
-- Description: Stores academic department information
-- =============================================
CREATE TABLE DEPARTMENT (
    department_id INT IDENTITY(1,1) PRIMARY KEY,
    department_name VARCHAR(100) NOT NULL,
    department_code VARCHAR(10) NOT NULL UNIQUE,
    head_instructor_id INT NULL,
    office_location VARCHAR(200),
    contact_email VARCHAR(255),
    contact_phone VARCHAR(20),
    description TEXT,
    created_date DATETIME DEFAULT CURRENT_TIMESTAMP
);
GO

-- =============================================
-- Table: INSTRUCTOR
-- Description: Stores instructor/faculty information
-- =============================================
CREATE TABLE INSTRUCTOR (
    instructor_id INT IDENTITY(1,1) PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    office_location VARCHAR(200),
    office_hours VARCHAR(100),
    phone_extension VARCHAR(10),
    hire_date DATE NOT NULL,
    department_id INT NOT NULL,
    academic_rank VARCHAR(20) CHECK (academic_rank IN ('Professor', 'Associate Professor', 'Assistant Professor', 'Lecturer', 'Adjunct')),
    employment_status VARCHAR(20) CHECK (employment_status IN ('Full-time', 'Part-time', 'Adjunct')),
    created_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT FK_Instructor_Department FOREIGN KEY (department_id) REFERENCES DEPARTMENT(department_id)
);
GO

-- =============================================
-- Table: STUDENT
-- Description: Stores student information and academic records
-- =============================================
CREATE TABLE STUDENT (
    student_id INT IDENTITY(1,1) PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone_number VARCHAR(20),
    date_of_birth DATE NOT NULL,
    address TEXT,
    enrollment_date DATE DEFAULT GETDATE(),
    major_department_id INT NULL,
    academic_status VARCHAR(20) DEFAULT 'Active' CHECK (academic_status IN ('Active', 'Probation', 'Suspended', 'Graduated', 'Withdrawn')),
    total_credits_earned INT DEFAULT 0,
    cumulative_gpa DECIMAL(3,2),
    created_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT FK_Student_MajorDepartment FOREIGN KEY (major_department_id) REFERENCES DEPARTMENT(department_id)
);
GO

-- =============================================
-- Table: COURSE
-- Description: Stores course offerings and details
-- =============================================
CREATE TABLE COURSE (
    course_id INT IDENTITY(1,1) PRIMARY KEY,
    course_code VARCHAR(20) NOT NULL,
    course_name VARCHAR(100) NOT NULL,
    description TEXT,
    credits INT NOT NULL,
    department_id INT NOT NULL,
    instructor_id INT NULL,
    max_capacity INT NOT NULL,
    current_enrollment INT DEFAULT 0,
    semester VARCHAR(10) CHECK (semester IN ('Fall', 'Spring', 'Summer', 'Winter')),
    academic_year INT,
    course_level VARCHAR(20) CHECK (course_level IN ('Undergraduate', 'Graduate', 'Doctoral')),
    delivery_mode VARCHAR(20) CHECK (delivery_mode IN ('In-person', 'Online', 'Hybrid')),
    schedule_info VARCHAR(200),
    course_status VARCHAR(20) DEFAULT 'Active' CHECK (course_status IN ('Active', 'Archived', 'Cancelled')),
    created_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT FK_Course_Department FOREIGN KEY (department_id) REFERENCES DEPARTMENT(department_id),
    CONSTRAINT FK_Course_Instructor FOREIGN KEY (instructor_id) REFERENCES INSTRUCTOR(instructor_id),
    CONSTRAINT UQ_Course_Code_Semester_Year UNIQUE (course_code, semester, academic_year)
);
GO

-- =============================================
-- Table: ENROLLMENT
-- Description: Manages student course registrations and grades
-- =============================================
CREATE TABLE ENROLLMENT (
    enrollment_id INT IDENTITY(1,1) PRIMARY KEY,
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enrollment_date DATETIME DEFAULT GETDATE(),
    enrollment_status VARCHAR(20) DEFAULT 'Registered' CHECK (enrollment_status IN ('Registered', 'Waitlisted', 'Dropped', 'Completed', 'Withdrawn')),
    final_grade VARCHAR(2) CHECK (final_grade IN ('A', 'A-', 'B+', 'B', 'B-', 'C+', 'C', 'C-', 'D+', 'D', 'F', 'I', 'W')),
    grade_points DECIMAL(4,2),
    completion_date DATE NULL,
    attendance_percentage DECIMAL(5,2),
    created_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT FK_Enrollment_Student FOREIGN KEY (student_id) REFERENCES STUDENT(student_id) ON DELETE CASCADE,
    CONSTRAINT FK_Enrollment_Course FOREIGN KEY (course_id) REFERENCES COURSE(course_id) ON DELETE CASCADE,
    CONSTRAINT UQ_Student_Course UNIQUE (student_id, course_id)
);
GO

-- =============================================
-- Table: ASSIGNMENT
-- Description: Stores course assignments and assessment details
-- =============================================
CREATE TABLE ASSIGNMENT (
    assignment_id INT IDENTITY(1,1) PRIMARY KEY,
    course_id INT NOT NULL,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    assignment_type VARCHAR(20) CHECK (assignment_type IN ('Homework', 'Quiz', 'Project', 'Exam', 'Presentation', 'Lab')),
    due_date DATETIME NOT NULL,
    max_points DECIMAL(5,2) NOT NULL,
    submission_format VARCHAR(20) CHECK (submission_format IN ('File Upload', 'Text Entry', 'Both')),
    allowed_file_types VARCHAR(100),
    late_submission_policy VARCHAR(200),
    instructions TEXT,
    weight_in_course DECIMAL(5,2),
    created_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT FK_Assignment_Course FOREIGN KEY (course_id) REFERENCES COURSE(course_id) ON DELETE CASCADE
);
GO

-- =============================================
-- Table: SUBMISSION
-- Description: Stores student assignment submissions
-- =============================================
CREATE TABLE SUBMISSION (
    submission_id INT IDENTITY(1,1) PRIMARY KEY,
    assignment_id INT NOT NULL,
    student_id INT NOT NULL,
    submission_date DATETIME DEFAULT GETDATE(),
    submission_content TEXT,
    file_path VARCHAR(500),
    file_name VARCHAR(255),
    file_size BIGINT,
    submission_status VARCHAR(20) DEFAULT 'Submitted' CHECK (submission_status IN ('Submitted', 'Late', 'Resubmitted')),
    version_number INT DEFAULT 1,
    created_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT FK_Submission_Assignment FOREIGN KEY (assignment_id) REFERENCES ASSIGNMENT(assignment_id) ON DELETE CASCADE,
    CONSTRAINT FK_Submission_Student FOREIGN KEY (student_id) REFERENCES STUDENT(student_id) ON DELETE CASCADE,
    CONSTRAINT UQ_Assignment_Student UNIQUE (assignment_id, student_id, version_number)
);
GO

-- =============================================
-- Create Indexes for Performance
-- =============================================

-- DEPARTMENT indexes
CREATE INDEX IX_Department_HeadInstructor ON DEPARTMENT(head_instructor_id);

-- INSTRUCTOR indexes
CREATE INDEX IX_Instructor_Department ON INSTRUCTOR(department_id);
CREATE INDEX IX_Instructor_Email ON INSTRUCTOR(email);
CREATE INDEX IX_Instructor_LastName ON INSTRUCTOR(last_name, first_name);

-- STUDENT indexes
CREATE INDEX IX_Student_MajorDepartment ON STUDENT(major_department_id);
CREATE INDEX IX_Student_Email ON STUDENT(email);
CREATE INDEX IX_Student_LastName ON STUDENT(last_name, first_name);
CREATE INDEX IX_Student_AcademicStatus ON STUDENT(academic_status);

-- COURSE indexes
CREATE INDEX IX_Course_Department ON COURSE(department_id);
CREATE INDEX IX_Course_Instructor ON COURSE(instructor_id);
CREATE INDEX IX_Course_Code ON COURSE(course_code);
CREATE INDEX IX_Course_SemesterYear ON COURSE(semester, academic_year, course_status);
CREATE INDEX IX_Course_Level_Department ON COURSE(course_level, department_id);

-- ENROLLMENT indexes
CREATE INDEX IX_Enrollment_Student ON ENROLLMENT(student_id);
CREATE INDEX IX_Enrollment_Course ON ENROLLMENT(course_id);
CREATE INDEX IX_Enrollment_Status ON ENROLLMENT(enrollment_status);
CREATE INDEX IX_Enrollment_StudentCourse ON ENROLLMENT(student_id, course_id);

-- ASSIGNMENT indexes
CREATE INDEX IX_Assignment_Course ON ASSIGNMENT(course_id);
CREATE INDEX IX_Assignment_DueDate ON ASSIGNMENT(due_date);
CREATE INDEX IX_Assignment_CourseDueDate ON ASSIGNMENT(course_id, due_date);

-- SUBMISSION indexes
CREATE INDEX IX_Submission_Assignment ON SUBMISSION(assignment_id);
CREATE INDEX IX_Submission_Student ON SUBMISSION(student_id);
CREATE INDEX IX_Submission_AssignmentStudent ON SUBMISSION(assignment_id, student_id);
CREATE INDEX IX_Submission_Date ON SUBMISSION(submission_date);
GO

-- =============================================
-- Verification Queries
-- =============================================
SELECT 'Database CourseManagementDB created successfully!' AS Status;

-- Verify table creation
SELECT
    TABLE_NAME AS 'Table Name',
    TABLE_TYPE AS 'Type'
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'CourseManagementDB'
ORDER BY TABLE_NAME;

-- Verify constraints
SELECT
    TABLE_NAME AS 'Table',
    CONSTRAINT_NAME AS 'Constraint',
    CONSTRAINT_TYPE AS 'Type'
FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS
WHERE TABLE_SCHEMA = 'CourseManagementDB'
ORDER BY TABLE_NAME, CONSTRAINT_TYPE;

-- Verify Indexes
SELECT 
    object_name(IXOS.OBJECT_ID) AS 'Table Name',
    IX.name AS 'Index Name',
    IX.type_desc AS 'Index Type'
FROM sys.indexes AS IX
INNER JOIN sys.objects AS IXOS 
    ON IXOS.OBJECT_ID = IX.OBJECT_ID
WHERE IXOS.type = 'U' AND IX.type_desc <> 'HEAP'
ORDER BY 'Table Name', 'Index Name';

-- Final Status
SELECT 'All tables, constraints, and indexes created successfully!' AS Final_Status;
GO