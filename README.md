# analystlab-week2-university-academic-analytics
PostgreSQL and Power BI analysis of university enrolment, attendance and academic performance across 17 datasets. AnalystLab Africa Experience Lab.
##Files included 
- ‘SQL Scripts’: Queries for business insights report all 25
- ‘Database schema’: All 17 datasets imported into PostgreSQL (Countries, Counties, Campuses, Faculties, Departments, Course categories, Programmes, Academic years, Semesters, Courses, Lecturers, Students, Student Enrolments, Class Schedules, Assessments, Examination Results.
- ‘Business Insights Report’ - five pages  findings and recommendations

## Data cleaning steps 
- Checked for all duplicated records
- Handled missing values 
- Standardised formats across formats (students and programmes tables ‘PROG’ , ‘PRO’) and (student and campuses tables ‘CAMP’ , ‘CAM’)
- Validated relationships between datasets 
- Foreign key consistency verification completed.

##Key decisions and assumptions 
-Missing values check-in and check-out values occur on every Absent(1962), Excused(1992) and Late(1943) record. They were left as nulll and not imputed, because invented timed would corrupt calculations .
-A time_data_missing flag column marks these rows. Absent and Excused gaps are expected.
-Data was loaded into PostgreSQL with pgAdmins import, parent tables before child tables, because foreign keys reject rows whose parents doesn’t exist yet. 
- Mismatch in programmeID format and campus ID format initially made joins return no rows.

##Key findings 
- Scales: 10000 students,240 courses, 6 faculties, 15 departments, 25 programmes and 5 campuses 
- Gender: Slightly perfectly balanced, 5005 female and 4995 male. 
- Enrolment trend: Student numbers by academic year fall each year, from 3417(AY2022) to 3306(AY20223) to 3277(AY2024), a drop of about 4.1% across the period.
- Campuses: enrolments are even from 9703(Nakuru) ro 10149 (Kisumu) and 10107(Eldoret)
-Attendance: Overall rate is 95.9%
-Pass rates are similar everywhere.
- Graduation: The overall is 34.2% with faculties between 33.6% and 34.8%

##Limitations
- Most results are descriptive. No significance tests were done, so small gaps (a point or two in pass rate) should not be treated as real findings. 
- Only 3 academic years exist, so enrolment trend is 3 points. 
- No GPA column in the dataset. 

##Tools Used 
PostgreSQL (Join , WHERE, ORDER BY, GROUP BY, CREATE, ALTER, UPDATE, COUNT)
