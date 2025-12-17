-- Phase 2.1 – Views (Reporting & Dashboards)
-- 4️. View: Student Dashboard
-- Shows enrolled courses and current status.

GO
CREATE VIEW vw_student_dashboard AS
SELECT
    s.student_id,
    s.first_name,
    s.last_name,
    c.course_name,
    c.course_code,
    e.enrollment_status,
    e.enrollment_date
FROM STUDENT s
JOIN ENROLLMENT e ON s.student_id = e.student_id
JOIN COURSE c ON e.course_id = c.course_id;
GO


-- 5️. View: Course Enrollment Analytics
-- Used for admin reporting.

GO
CREATE VIEW vw_course_enrollment_summary AS
SELECT
    c.course_id,
    c.course_name,
    c.course_code,
    c.max_capacity,
    c.current_enrollment,
    (c.max_capacity - c.current_enrollment) AS available_seats
FROM COURSE c;
GO

-- 6️. View: Instructor Course Load
-- Shows which instructor teaches which courses.

GO
CREATE VIEW vw_instructor_course_load AS
SELECT
    i.instructor_id,
    i.first_name,
    i.last_name,
    c.course_name,
    c.semester,
    c.academic_year
FROM INSTRUCTOR i
JOIN COURSE c ON i.instructor_id = c.instructor_id;
GO


-- 7️. View: Department-Level Course Summary
-- High-level analytics per department.

GO
CREATE VIEW vw_department_course_summary AS
SELECT
    d.department_name,
    COUNT(c.course_id) AS total_courses,
    SUM(c.current_enrollment) AS total_enrollments
FROM DEPARTMENT d
LEFT JOIN COURSE c ON d.department_id = c.department_id
GROUP BY d.department_name;
GO