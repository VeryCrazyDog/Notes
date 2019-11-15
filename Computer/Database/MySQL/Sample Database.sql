DROP DATABASE IF EXISTS school;
CREATE DATABASE school DEFAULT CHARACTER SET utf8;

USE school;

CREATE TABLE students (
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(50) NOT NULL,
	code VARCHAR(10) NOT NULL,
	gender CHAR,
	birthday DATE,
	version INT NOT NULL DEFAULT 1,
	created_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	modified_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	INDEX ix_name (name),
	UNIQUE uk_code (code)
);

CREATE TABLE teachers (
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(50) NOT NULL,
	code VARCHAR(10) NOT NULL,
	gender CHAR,
	version INT NOT NULL DEFAULT 1,
	created_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	modified_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	INDEX ix_name (name),
	UNIQUE uk_code (code)
);

CREATE TABLE courses (
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(50) NOT NULL,
	code VARCHAR(10) NOT NULL,
	location VARCHAR(50) NOT NULL,
	teacher_id INT,
	version INT NOT NULL DEFAULT 1,
	created_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	modified_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	INDEX ix_name (name),
	UNIQUE uk_code (code),
	CONSTRAINT fk_courses_teachers_id FOREIGN KEY (teacher_id) REFERENCES teachers(id)
);

CREATE TABLE students_courses (
	student_id INT NOT NULL,
	course_id INT NOT NULL,
	registered_date DATE NOT NULL,
	created_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	modified_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	PRIMARY KEY (student_id, course_id),
	CONSTRAINT uk_students_courses UNIQUE KEY (course_id, student_id),
	CONSTRAINT fk_students_courses_students_id FOREIGN KEY (student_id) REFERENCES students(id),
	CONSTRAINT fk_students_courses_courses_id FOREIGN KEY (course_id) REFERENCES courses(id)
);

INSERT students (id, name, code, gender, birthday, version) VALUES
	(1, 'Amy', 'student1', 'F', '1980-01-01', 1),
	(2, 'Benny', 'student2', 'M', '1981-02-02', 1),
	(3, 'Carmen', 'student3', 'F', '1981-03-03', 1),
	(4, 'David', 'student4', 'M', '1980-04-04', 1),
	(5, 'Edith', 'student5', 'F', '1983-05-05', 2),
	(6, 'Fanny', 'student6', 'F', '1980-06-06', 2),
	(7, 'Gabriel', 'student7', 'M', '1981-07-07', 2),
	(8, 'Henry', 'student8', 'M', '1980-08-08', 2),
	(9, 'Ivan', 'student9', 'M', '1982-09-09', 3),
	(10, 'Janice', 'student10', 'F', '1983-10-10', 3),
	(11, 'Keith', 'student11', 'M', '1983-11-11', 4),
	(12, 'Ling', 'student12', NULL, '1982-12-12', 4),
	(13, 'April', 'student13', 'F', '1980-01-13', 2);

INSERT teachers (id, name, code, gender) VALUES
	(1, 'Andrew', 'teacher1', 'M'),
	(2, 'Boris', 'teacher2', 'M'),
	(3, 'Carol', 'teacher3', 'F'),
	(4, 'Doris', 'teacher4', NULL),
	(5, 'Edison', 'teacher5', 'M'),
	(6, 'Fiona', 'teacher6', 'F'),
	(7, 'Grace', 'teacher7', 'F'),
	(8, 'Helen', 'teacher8', 'F'),
	(9, 'Issac', 'teacher9', 'M'),
	(10, 'Jack', 'teacher10', 'M');

INSERT courses (id, name, code, location, teacher_id) VALUES
	(1, 'Chinese', 'course01', 'Lecture Theatre A', 1),
	(2, 'English', 'course02', 'Room 1', 2),
	(3, 'Maths', 'course03', 'Lecture Theatre B', 2),
	(4, 'Physics', 'course04', 'Room 2', 3),
	(5, 'Chemistry', 'course05', 'Lecture Theatre C', 6),
	(6, 'Biology', 'course06', 'Room 3', 7),
	(7, 'Geography', 'course07', 'Lecture Theatre D', 7),
	(8, 'Economics', 'course08', 'Room 4', 7),
	(9, 'Accounting', 'course09', 'Lecture Theatre E', 8),
	(10, 'Chinese History', 'course10', 'Room 5', NULL);

INSERT students_courses(student_id, course_id, registered_date) VALUES
	(1, 1, '2005-09-01'),
	(1, 2, '2005-09-01'),
	(1, 3, '2005-09-01'),
	(2, 2, '2005-09-01'),
	(2, 4, '2005-09-15'),
	(5, 1, '2005-09-01'),
	(5, 4, '2005-09-01'),
	(5, 8, '2005-10-02'),
	(5, 9, '2005-09-01'),
	(5, 10, '2005-09-01'),
	(8, 3, '2005-09-13'),
	(9, 3, '2005-09-01'),
	(9, 8, '2005-09-01'),
	(12, 3, '2005-09-01'),
	(12, 8, '2005-09-01');
