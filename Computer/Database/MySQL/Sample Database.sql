DROP DATABASE IF EXISTS school;
CREATE DATABASE school DEFAULT CHARACTER SET utf8;

USE school;

CREATE TABLE students (
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(50) NOT NULL DEFAULT '',
	code VARCHAR(50) NOT NULL DEFAULT '',
	gender CHAR NOT NULL,
	birthday DATE,
	version INT NOT NULL DEFAULT 1,
	created_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	modified_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	INDEX ix_students_name (name)
);

CREATE TABLE teachers (
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(50) NOT NULL DEFAULT '',
	code VARCHAR(50) NOT NULL DEFAULT '',
	gender CHAR NOT NULL,
	created_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	modified_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	INDEX ix_teachers_name (name)
);

CREATE TABLE courses (
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(50) NOT NULL DEFAULT '',
	location VARCHAR(50) NOT NULL DEFAULT '',
	teacher_id INT,
	created_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	modified_time TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
	INDEX ix_courses_name (name),
	CONSTRAINT fk_courses_teachers_id FOREIGN KEY (teacher_id) REFERENCES teachers(id)
);

CREATE TABLE students_courses (
	student_id INT NOT NULL,
	course_id INT NOT NULL,
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
	(12, 'Ling', 'student12', 'F', '1982-12-12', 4),
	(13, 'April', 'student13', 'F', '1980-01-13', 2);

INSERT teachers (id, name, code, gender) VALUES
	(1, 'Andrew', 'teacher1', 'M'),
	(2, 'Boris', 'teacher2', 'M'),
	(3, 'Carol', 'teacher3', 'F'),
	(4, 'Doris', 'teacher4', 'F'),
	(5, 'Edison', 'teacher5', 'M'),
	(6, 'Fiona', 'teacher6', 'F'),
	(7, 'Grace', 'teacher7', 'F'),
	(8, 'Helen', 'teacher8', 'F'),
	(9, 'Issac', 'teacher9', 'M'),
	(10, 'Jack', 'teacher10', 'M');

INSERT courses (id, name, location, teacher_id) VALUES
	(1, 'Chinese', 'Lecture Theatre A', 1),
	(2, 'English', 'Room 1', 2),
	(3, 'Maths', 'Lecture Theatre B', 2),
	(4, 'Physics', 'Room 2', 3),
	(5, 'Chemistry', 'Lecture Theatre C', 6),
	(6, 'Biology', 'Room 3', 7),
	(7, 'Geography', 'Lecture Theatre D', 7),
	(8, 'Economics', 'Room 4', 7),
	(9, 'Accounting', 'Lecture Theatre E', 8),
	(10, 'History', 'Room 5', NULL);

INSERT students_courses(student_id, course_id) VALUES
	(1, 1),
	(1, 2),
	(1, 3),
	(2, 2),
	(2, 4),
	(5, 1),
	(5, 4),
	(5, 8),
	(5, 9),
	(5, 10),
	(8, 3),
	(9, 3),
	(9, 8),
	(12, 3),
	(12, 8);
