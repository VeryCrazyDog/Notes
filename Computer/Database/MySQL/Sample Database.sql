DROP TABLE IF EXISTS students_courses;
DROP TABLE IF EXISTS courses;
DROP TABLE IF EXISTS teachers;
DROP TABLE IF EXISTS students;

CREATE TABLE students (
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(50) NOT NULL DEFAULT '',
	version INT NOT NULL DEFAULT 1,
	INDEX ix_students_name (name)
);

CREATE TABLE teachers (
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(50) NOT NULL DEFAULT ''
);

CREATE TABLE courses (
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(50) NOT NULL DEFAULT '',
	location VARCHAR(50) NOT NULL DEFAULT '',
	teacher_id INT,
	INDEX ix_courses_name (name),
	CONSTRAINT fk_courses_teachers_id FOREIGN KEY (teacher_id) REFERENCES teachers(id)
);

CREATE TABLE students_courses (
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	student_id INT NOT NULL,
	course_id INT NOT NULL,
	CONSTRAINT uk_students_courses UNIQUE KEY (student_id, course_id),
	CONSTRAINT fk_students_courses_students_id FOREIGN KEY (student_id) REFERENCES students(id),
	CONSTRAINT fk_students_courses_courses_id FOREIGN KEY (course_id) REFERENCES courses(id)
);
