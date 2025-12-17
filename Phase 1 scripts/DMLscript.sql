USE CourseManagementDB;

-- Insert Departments (Woldia University Structure)
INSERT INTO DEPARTMENT (department_name, department_code, office_location, contact_email, contact_phone, description) 
VALUES
('Computer Science', 'CS', 'Main Campus, ICT Building Room 101', 'cs@woldiau.edu.et', '+251-33-551-0001', 'Department of Computer Science and Engineering - Woldia University'),
('Software Engineering', 'SWE', 'Main Campus, ICT Building Room 102', 'swe@woldiau.edu.et', '+251-33-551-0002', 'Department of Software Engineering - Woldia University'),
('Electrical Engineering', 'EE', 'Engineering Campus, Block A Room 201', 'ee@woldiau.edu.et', '+251-33-551-0003', 'Department of Electrical and Computer Engineering - Woldia University'),
('Civil Engineering', 'CE', 'Engineering Campus, Block B Room 301', 'ce@woldiau.edu.et', '+251-33-551-0004', 'Department of Civil Engineering - Woldia University'),
('Management', 'MGMT', 'Business Campus, Room 401', 'management@woldiau.edu.et', '+251-33-551-0005', 'Department of Management - Woldia University');

-- Insert Instructors (Ethiopian Academic Staff)
INSERT INTO INSTRUCTOR (first_name, last_name, email, office_location, office_hours, phone_extension, hire_date, department_id, academic_rank, employment_status) 
VALUES
('Abebe', 'Kebede', 'abebe.kebede@woldiau.edu.et', 'ICT-105', 'Mon-Wed 08:30-10:30', 'x1001', '2018-01-15', 1, 'Professor', 'Full-time'),
('Meron', 'Tesfaye', 'meron.tesfaye@woldiau.edu.et', 'ICT-106', 'Tue-Thu 14:00-16:00', 'x1002', '2019-03-10', 1, 'Associate Professor', 'Full-time'),
('Dawit', 'Girma', 'dawit.girma@woldiau.edu.et', 'ICT-107', 'Mon-Fri 09:00-11:00', 'x1003', '2020-07-22', 2, 'Assistant Professor', 'Full-time'),
('Hana', 'Mohammed', 'hana.mohammed@woldiau.edu.et', 'ENG-A-205', 'Wed 13:00-15:00', 'x2001', '2021-09-05', 3, 'Lecturer', 'Full-time'),
('Samuel', 'Getachew', 'samuel.getachew@woldiau.edu.et', 'ENG-B-305', 'Tue 10:00-12:00', 'x3001', '2017-11-30', 4, 'Professor', 'Full-time'),
('Eyerus', 'Alemu', 'eyerus.alemu@woldiau.edu.et', 'BUS-405', 'Thu 08:30-10:30', 'x4001', '2022-01-20', 5, 'Assistant Professor', 'Full-time');

-- Update Department Heads
UPDATE DEPARTMENT SET head_instructor_id = 1 WHERE department_id = 1;
UPDATE DEPARTMENT SET head_instructor_id = 3 WHERE department_id = 2;
UPDATE DEPARTMENT SET head_instructor_id = 4 WHERE department_id = 3;
UPDATE DEPARTMENT SET head_instructor_id = 5 WHERE department_id = 4;
UPDATE DEPARTMENT SET head_instructor_id = 6 WHERE department_id = 5;

-- Insert Students (3rd Year Woldia University Students - Ethiopian Names)
INSERT INTO STUDENT (first_name, last_name, email, phone_number, date_of_birth, address, enrollment_date, major_department_id, academic_status, total_credits_earned, cumulative_gpa) 
VALUES
('Bereket', 'Assefa', 'bereket.assefa@woldiau.edu.et', '+251-91-123-4567', '2001-05-15', 'Kobo Road, Woldia, Amhara', '2021-09-01', 1, 'Active', 85, 3.45),
('Mekdes', 'Gebre', 'mekdes.gebre@woldiau.edu.et', '+251-92-234-5678', '2002-08-22', 'Harbu Street, Woldia, Amhara', '2021-09-01', 1, 'Active', 82, 3.65),
('Tewodros', 'Haile', 'tewodros.haile@woldiau.edu.et', '+251-93-345-6789', '2001-12-10', 'Mersa Road, Woldia, Amhara', '2021-09-01', 2, 'Active', 88, 3.82),
('Selam', 'Teshome', 'selam.teshome@woldiau.edu.et', '+251-94-456-7890', '2001-03-30', 'Lalibela Street, Woldia, Amhara', '2021-09-01', 1, 'Active', 79, 3.20),
('Yohannes', 'Worku', 'yohannes.worku@woldiau.edu.et', '+251-95-567-8901', '2002-01-18', 'Gonder Road, Woldia, Amhara', '2021-09-01', 3, 'Active', 86, 3.55),
('Hirut', 'Mulu', 'hirut.mulu@woldiau.edu.et', '+251-96-678-9012', '2001-11-05', 'Bahir Dar Street, Woldia, Amhara', '2021-09-01', 4, 'Active', 91, 3.78),
('Kaleb', 'Dereje', 'kaleb.dereje@woldiau.edu.et', '+251-97-789-0123', '2001-07-12', 'Dessie Road, Woldia, Amhara', '2021-09-01', 1, 'Active', 84, 3.45),
('Rahel', 'Alemayehu', 'rahel.alemayehu@woldiau.edu.et', '+251-98-890-1234', '2000-09-25', 'Debre Birhan Street, Woldia, Amhara', '2021-09-01', 2, 'Active', 87, 3.68),
('Nahom', 'Solomon', 'nahom.solomon@woldiau.edu.et', '+251-99-901-2345', '2001-04-08', 'Addis Ababa Road, Woldia, Amhara', '2021-09-01', 3, 'Active', 81, 3.35),
('Birtukan', 'Mengistu', 'birtukan.mengistu@woldiau.edu.et', '+251-91-012-3456', '2002-02-14', 'Mekelle Street, Woldia, Amhara', '2021-09-01', 4, 'Active', 78, 3.42),
('Daniel', 'Kassa', 'daniel.kassa@woldiau.edu.et', '+251-92-123-4567', '2001-06-20', 'Debre Markos Road, Woldia, Amhara', '2021-09-01', 5, 'Active', 83, 3.60),
('Martha', 'Gebru', 'martha.gebru@woldiau.edu.et', '+251-93-234-5678', '2001-10-12', 'Jimma Street, Woldia, Amhara', '2021-09-01', 5, 'Active', 85, 3.75);


-- Insert Courses (3rd Year Computer Science/Software Engineering Courses)
INSERT INTO COURSE (course_code, course_name, description, credits, department_id, instructor_id, max_capacity, current_enrollment, semester, academic_year, course_level, delivery_mode, schedule_info) 
VALUES
('SENG301', 'Advanced Database Systems', 'Advanced database concepts, normalization, transactions, and distributed databases', 4, 2, 3, 35, 28, 'Spring', 2024, 'Undergraduate', 'In-person', 'Mon-Wed 08:30-10:00, ICT Building Room 201'),
('SENG302', 'Software Engineering', 'Software development methodologies, requirements engineering, and design patterns', 3, 2, 3, 30, 25, 'Spring', 2024, 'Undergraduate', 'Hybrid', 'Tue-Thu 10:30-12:00, ICT Building Room 202'),
('CS305', 'Computer Networks', 'Network protocols, TCP/IP, routing algorithms, and network security', 4, 1, 1, 40, 32, 'Spring', 2024, 'Undergraduate', 'In-person', 'Mon-Wed-Fri 14:00-15:00, ICT Building Room 101'),
('CS306', 'Operating Systems', 'Process management, memory management, file systems, and virtualization', 4, 1, 2, 35, 30, 'Spring', 2024, 'Undergraduate', 'In-person', 'Tue-Thu 08:30-10:00, ICT Building Room 102'),
('EE301', 'Digital Signal Processing', 'Signal analysis, filtering, and digital signal processing techniques', 3, 3, 4, 25, 18, 'Spring', 2024, 'Undergraduate', 'In-person', 'Mon-Wed 16:00-17:30, Engineering Building Room 201'),
('MGMT301', 'Project Management', 'Project planning, scheduling, risk management, and team leadership', 3, 5, 6, 45, 35, 'Spring', 2024, 'Undergraduate', 'Online', 'Asynchronous with bi-weekly meetings');

-- Insert Enrollments (3rd Year Student Course Registrations)
INSERT INTO ENROLLMENT (student_id, course_id, enrollment_status, final_grade, grade_points, attendance_percentage) 
VALUES
-- SENG301 - Advanced Database Systems
(1, 1, 'Registered', NULL, NULL, 92.5),
(2, 1, 'Registered', NULL, NULL, 88.2),
(3, 1, 'Registered', NULL, NULL, 95.0),
(4, 1, 'Registered', NULL, NULL, 90.1),
(8, 1, 'Registered', NULL, NULL, 87.8),

-- SENG302 - Software Engineering
(1, 2, 'Registered', NULL, NULL, 91.3),
(3, 2, 'Registered', NULL, NULL, 89.7),
(8, 2, 'Registered', NULL, NULL, 93.2),

-- CS305 - Computer Networks
(1, 3, 'Registered', NULL, NULL, 94.1),
(2, 3, 'Registered', NULL, NULL, 86.5),
(4, 3, 'Registered', NULL, NULL, 92.8),
(7, 3, 'Registered', NULL, NULL, 88.9),

-- CS306 - Operating Systems
(2, 4, 'Registered', NULL, NULL, 90.4),
(4, 4, 'Registered', NULL, NULL, 87.3),
(7, 4, 'Registered', NULL, NULL, 95.2),

-- EE301 - Digital Signal Processing
(5, 5, 'Registered', NULL, NULL, 91.7),
(9, 5, 'Registered', NULL, NULL, 89.0),

-- MGMT301 - Project Management
(1, 6, 'Registered', NULL, NULL, 96.0),
(3, 6, 'Registered', NULL, NULL, 92.3),
(5, 6, 'Registered', NULL, NULL, 88.7),
(9, 6, 'Registered', NULL, NULL, 94.5),
(11, 6, 'Registered', NULL, NULL, 90.8),
(12, 6, 'Registered', NULL, NULL, 93.1);

-- Insert Assignments (3rd Year Course Assignments)
INSERT INTO ASSIGNMENT (course_id, title, description, assignment_type, due_date, max_points, submission_format, weight_in_course) 
VALUES
-- SENG301 Assignments
(1, 'Database Normalization', 'Normalize the given database schema to 3NF and justify your design', 'Project', '2024-03-15 23:59:00', 100, 'File Upload', 20.00),
(1, 'SQL Query Optimization', 'Optimize the given SQL queries and explain performance improvements', 'Homework', '2024-03-01 23:59:00', 100, 'Both', 15.00),
(1, 'Transaction Management', 'Implement ACID properties in database transactions', 'Project', '2024-04-10 23:59:00', 100, 'File Upload', 25.00),

-- SENG302 Assignments
(2, 'Requirements Specification', 'Create SRS document for a library management system', 'Project', '2024-03-20 23:59:00', 100, 'File Upload', 30.00),
(2, 'UML Diagrams', 'Design use case, class, and sequence diagrams for given system', 'Homework', '2024-03-05 23:59:00', 100, 'Both', 20.00),

-- CS305 Assignments
(3, 'Network Protocol Analysis', 'Analyze TCP/IP protocols using Wireshark', 'Lab', '2024-03-12 23:59:00', 100, 'File Upload', 25.00),
(3, 'Routing Algorithms', 'Implement Dijkstra algorithm for network routing', 'Project', '2024-04-05 23:59:00', 100, 'File Upload', 30.00),

-- MGMT301 Assignments
(6, 'Project Charter', 'Develop project charter for software development project', 'Homework', '2024-03-08 23:59:00', 100, 'Text Entry', 20.00),
(6, 'Risk Management Plan', 'Identify and analyze project risks with mitigation strategies', 'Project', '2024-04-01 23:59:00', 100, 'File Upload', 25.00);

-- Insert Submissions (Student Work Submissions)
INSERT INTO SUBMISSION (assignment_id, student_id, submission_content, file_path, file_name, file_size, submission_status) 
VALUES
-- Database Normalization Submissions
(1, 1, 'Normalized schema to 3NF with proper justification', '/uploads/bereket_normalization.pdf', 'normalization_report.pdf', 2048, 'Submitted'),
(1, 3, 'Completed normalization with ER diagrams and schema', '/uploads/tewodros_normalization.docx', 'database_design.docx', 3072, 'Submitted'),

-- SQL Query Optimization Submissions
(2, 1, 'Optimized 5 complex queries with execution plan analysis', '/uploads/bereket_queries.sql', 'query_optimization.sql', 1024, 'Submitted'),
(2, 2, 'Query optimization with indexing strategies', '/uploads/mekdes_optimization.pdf', 'sql_optimization.pdf', 2560, 'Submitted'),

-- Requirements Specification Submissions
(4, 1, 'Complete SRS for Library Management System', '/uploads/bereket_srs.pdf', 'library_srs.pdf', 4096, 'Submitted'),
(4, 3, 'Software Requirements Specification document', '/uploads/tewodros_srs.docx', 'srs_document.docx', 3584, 'Submitted'),

-- UML Diagrams Submissions
(5, 1, 'Use case, class, and sequence diagrams in UML', '/uploads/bereket_uml.drawio', 'uml_diagrams.drawio', 1536, 'Submitted'),

-- Network Protocol Analysis
(6, 1, 'Wireshark analysis of TCP handshake and data transfer', '/uploads/bereket_wireshark.pcapng', 'protocol_analysis.pcapng', 5120, 'Submitted'),

-- Project Charter Submissions
(8, 1, 'Project charter for student portal development', NULL, NULL, NULL, 'Submitted'),
(8, 3, 'Charter for mobile app development project', '/uploads/tewodros_charter.pdf', 'project_charter.pdf', 2048, 'Submitted');

-- Verification Query
SELECT 'Woldia University sample data populated successfully!' AS Status;

-- Count records in each table
SELECT 
    'DEPARTMENT' AS Table_Name, COUNT(*) AS Record_Count FROM DEPARTMENT
UNION ALL 
SELECT 'INSTRUCTOR', COUNT(*) FROM INSTRUCTOR
UNION ALL 
SELECT 'STUDENT', COUNT(*) FROM STUDENT
UNION ALL 
SELECT 'COURSE', COUNT(*) FROM COURSE
UNION ALL 
SELECT 'ENROLLMENT', COUNT(*) FROM ENROLLMENT
UNION ALL 
SELECT 'ASSIGNMENT', COUNT(*) FROM ASSIGNMENT
UNION ALL 
SELECT 'SUBMISSION', COUNT(*) FROM SUBMISSION;

-- Display sample student data (corrected for SQL Server)
SELECT TOP 8 student_id, first_name, last_name, email, major_department_id, cumulative_gpa 
FROM STUDENT 
ORDER BY student_id;

-- Display course enrollments (corrected for SQL Server)
SELECT TOP 10 s.first_name, s.last_name, c.course_code, c.course_name, e.enrollment_status
FROM STUDENT s
JOIN ENROLLMENT e ON s.student_id = e.student_id
JOIN COURSE c ON e.course_id = c.course_id
ORDER BY c.course_code, s.first_name;