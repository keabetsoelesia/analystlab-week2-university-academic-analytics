-- Q1: Total number of students
SELECT COUNT (*) FROM students;
-- Q2: Student enrollment by faculty
SELECT f.faculty_name,
       COUNT(e.enrollment_id) AS total_enrollments
FROM faculties f
JOIN students s ON s.faculty_id = f.faculty_id
JOIN student_enrollments e ON e.student_id = s.student_id
GROUP BY f.faculty_name
ORDER BY total_enrollments DESC;
--Q3:Student enrollment by department
SELECT d.department_name,
       COUNT(e.enrollment_id) AS total_enrollments
FROM departments d
JOIN students s ON s.department_id = d.department_id
JOIN student_enrollments e ON e.student_id = s.student_id
GROUP BY d.department_name
ORDER BY total_enrollments DESC;
-- Q4: Student enrollment by programme
SELECT p.programme_name,
       COUNT(e.enrollment_id) AS total_enrollments
FROM programmes p
JOIN students s ON s.programme_id = p.programme_id
JOIN student_enrollments e ON e.student_id = s.student_id
GROUP BY p.programme_name
ORDER BY total_enrollments DESC;
-- Q5: Student enrollment by campus
SELECT c.campus_name,
       COUNT(e.enrollment_id) AS total_enrollments
FROM campuses c
JOIN students s ON s.campus_id = c.campus_id
JOIN student_enrollments e ON e.student_id = s.student_id
GROUP BY c.campus_name;
-- Q6: Gender distribution of students 
SELECT gender,
       COUNT(*) AS total_students,
       ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) AS percentage
FROM students
GROUP BY gender
ORDER BY total_students DESC;
-- Q7: Enrolments trends by academic year
SELECT academic_year_id,
       COUNT(*) AS total_students
FROM students
GROUP BY academic_year_id
ORDER BY academic_year_id;
-- Q8: Most popular programmes
SELECT p.programme_name,
       COUNT(s.student_id) AS total_students
FROM students s
JOIN programmes p ON s.programme_id = p.programme_id
GROUP BY p.programme_name
ORDER BY total_students DESC
LIMIT 10;
-- Q9: Most popular courses
SELECT c.course_code,
       c.course_title,
       COUNT(e.enrollment_id) AS total_enrollments
FROM student_enrollments e
JOIN courses c ON e.course_id = c.course_id
GROUP BY c.course_code, c.course_title
ORDER BY total_enrollments DESC
LIMIT 10;
-- Q10: Attendance rate by course
SELECT ROUND(100.0 * COUNT(*) FILTER (WHERE a.status IN ('Present', 'Late'))
       / NULLIF(COUNT(*) FILTER (WHERE a.status <> 'Excused'), 0), 1) AS attendance_rate_pct
FROM attendance a
JOIN courses c ON a.course_id = c.course_id
GROUP BY c.course_code, c.course_title
ORDER BY attendance_rate_pct DESC;
-- Q11: Attendence rate by lecturer
SELECT ROUND(100.0 * COUNT(*) FILTER (WHERE status IN ('Present', 'Late'))
       / NULLIF(COUNT(*) FILTER (WHERE status <> 'Excused'), 0), 1) AS attendance_rate_pct
FROM attendance a
JOIN class_schedules cs on a.course_id = cs.course_id
JOIN lecturers l on cs.lecturer_id = l.lecturer_id
GROUP BY l.lecturer_id
ORDER BY attendance_rate_pct DESC;
-- Q12: Attendance rate by department 
SELECT ROUND(100.0 * COUNT(*) FILTER (WHERE a.status IN ('Present', 'Late'))
       / NULLIF(COUNT(*) FILTER (WHERE a.status <> 'Excused'), 0), 1) AS attendance_rate_pct
FROM attendance a
JOIN courses c ON a.course_id = c.course_id
JOIN departments d ON c.department_id = d.department_id 
GROUP BY d.department_id
ORDER BY attendance_rate_pct DESC;
-- Q13: Students with attendance below 75%
SELECT s.student_id,
       s.first_name,
       s.last_name,
       COUNT(*) AS records_counted,
       ROUND(100.0 * COUNT(*) FILTER (WHERE a.status IN ('Present', 'Late'))
             / COUNT(*), 1) AS attendance_rate_pct
FROM attendance a
JOIN students s ON a.student_id = s.student_id
WHERE a.status <> 'Excused'
GROUP BY s.student_id, s.first_name, s.last_name
HAVING 100.0 * COUNT(*) FILTER (WHERE a.status IN ('Present', 'Late'))
       / COUNT(*) < 75
ORDER BY attendance_rate_pct ASC;
-- Q14: Average assessment score by course
SELECT c.course_code,
       c.course_title,
       ROUND(AVG(100.0 * a.marks_obtained / NULLIF(a.maximum_marks, 0)), 1) AS avg_assessment_pct
FROM assessments a
JOIN courses c ON a.course_id = c.course_id
GROUP BY c.course_code, c.course_title
ORDER BY avg_assessment_pct DESC;
-- Q15: Pass rate by faculty 
SELECT f.faculty_name,
       COUNT(*) AS exam_results,
       COUNT(*) FILTER (WHERE er.pass_status = 'Pass') AS passed,
       ROUND(100.0 * COUNT(*) FILTER (WHERE er.pass_status = 'Pass') / COUNT(*), 1) AS pass_rate_pct
FROM examination_results er
JOIN students s ON er.student_id = s.student_id
JOIN faculties f ON s.faculty_id = f.faculty_id
GROUP BY f.faculty_name
ORDER BY pass_rate_pct DESC;
-- Q16: Pass rate by department 
SELECT d.department_name,
       COUNT(*) AS exam_results,
       COUNT(*) FILTER (WHERE er.pass_status = 'Pass') AS passed,
       ROUND(100.0 * COUNT(*) FILTER (WHERE er.pass_status = 'Pass') / COUNT(*), 1) AS pass_rate_pct
FROM examination_results er
JOIN students s ON er.student_id = s.student_id
JOIN departments d ON s.department_id = d.department_id
GROUP BY d.department_name
ORDER BY pass_rate_pct DESC;
-- Q17: Pass rate by programme 
SELECT p.programme_name,
       COUNT(*) AS exam_results,
       COUNT(*) FILTER (WHERE er.pass_status = 'Pass') AS passed,
       ROUND(100.0 * COUNT(*) FILTER (WHERE er.pass_status = 'Pass') / COUNT(*), 1) AS pass_rate_pct
FROM examination_results er
JOIN students s ON er.student_id = s.student_id
JOIN programmes p ON s.programme_id = p.programme_id
GROUP BY p.programme_name
ORDER BY pass_rate_pct DESC;
-- Q18: Top-performing students 
SELECT s.student_id,
       s.first_name,
       s.last_name,
       COUNT(*) AS exams_written,
       ROUND(AVG(er.exam_score), 1) AS avg_exam_score
FROM examination_results er
JOIN students s ON er.student_id = s.student_id
GROUP BY s.student_id, s.first_name, s.last_name
ORDER BY avg_exam_score DESC
LIMIT 10;
-- Q19: Bottom-performing students
SELECT s.student_id,
       s.first_name,
       s.last_name,
       COUNT(*) AS exams_written,
       ROUND(AVG(er.exam_score), 1) AS avg_exam_score
FROM examination_results er
JOIN students s ON er.student_id = s.student_id
GROUP BY s.student_id, s.first_name, s.last_name
ORDER BY avg_exam_score ASC
LIMIT 10;
-- Q20: Lecturer teaching workload
SELECT l.lecturer_id,
       l.first_name,
       l.last_name,
       COUNT(DISTINCT cs.course_id) AS courses_taught,
       COUNT(*)                     AS scheduled_classes
FROM lecturers l
JOIN class_schedules cs ON cs.lecturer_id = l.lecturer_id
GROUP BY l.lecturer_id, l.first_name, l.last_name
ORDER BY courses_taught DESC, scheduled_classes DESC;
-- Q21: Courses with the highest failure rates
SELECT c.course_code,
       c.course_title,
       COUNT(*) AS exam_results,
       COUNT(*) FILTER (WHERE er.pass_status <> 'Pass') AS failed,
       ROUND(100.0 * COUNT(*) FILTER (WHERE er.pass_status <> 'Pass') / COUNT(*), 1) AS failure_rate_pct
FROM examination_results er
JOIN courses c ON er.course_id = c.course_id
GROUP BY c.course_code, c.course_title
HAVING COUNT(*) >= 10
ORDER BY failure_rate_pct DESC
LIMIT 10;
-- Q22: Average GPA by programme
SELECT p.programme_name,
       ROUND(AVG(er.exam_score), 2) AS avg_gpa
FROM examination_results er
JOIN students s ON er.student_id = s.student_id
JOIN programmes p ON s.programme_id = p.programme_id
GROUP BY p.programme_name
ORDER BY avg_gpa DESC;
-- Q23: Gradutaion rate by faculty 
SELECT f.faculty_name,
       COUNT(*) AS total_students,
       COUNT(*) FILTER (WHERE s.enrollement_status = 'Graduated') AS graduates,
       ROUND(100.0 * COUNT(*) FILTER (WHERE s.enrollement_status = 'Graduated') / COUNT(*), 1) AS graduation_rate_pct
FROM students s
JOIN faculties f ON s.faculty_id = f.faculty_id
GROUP BY f.faculty_name
ORDER BY graduation_rate_pct DESC;
-- Q24: Scholarship distribution across programmes
SELECT p.programme_name,
       s.scholarship_status,
       COUNT(*) AS total_students
FROM students s
JOIN programmes p ON s.programme_id = p.programme_id
GROUP BY p.programme_name, s.scholarship_status
ORDER BY p.programme_name, total_students DESC;
-- Q25:Executive summary of academic performance
SELECT (SELECT COUNT(*) FROM students)    AS total_students,
       (SELECT COUNT(*) FROM courses)     AS total_courses,
       (SELECT COUNT(*) FROM faculties)   AS total_faculties,
       (SELECT COUNT(*) FROM departments) AS total_departments,
       (SELECT ROUND(100.0 * COUNT(*) FILTER (WHERE status IN ('Present', 'Late'))
               / NULLIF(COUNT(*) FILTER (WHERE status <> 'Excused'), 0), 1)
        FROM attendance) AS attendance_rate_pct,
       (SELECT ROUND(100.0 * COUNT(*) FILTER (WHERE students.enrollement_status = 'Graduated')
               / COUNT(*), 1)
        FROM students) AS graduation_rate_pct;