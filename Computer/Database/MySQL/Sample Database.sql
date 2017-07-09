DROP TABLE IF EXISTS students_courses;
DROP TABLE IF EXISTS courses;
DROP TABLE IF EXISTS teachers;
DROP TABLE IF EXISTS students;

CREATE TABLE students (
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(50) NOT NULL DEFAULT '',
	code VARCHAR(50) NOT NULL DEFAULT '',
	gender CHAR NOT NULL,
	birthday DATE,
	version INT NOT NULL DEFAULT 1,
	INDEX ix_students_name (name)
);

CREATE TABLE teachers (
	id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(50) NOT NULL DEFAULT '',
	code VARCHAR(50) NOT NULL DEFAULT '',
	gender CHAR NOT NULL,
	INDEX ix_teachers_name (name)
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
	(12, 'Ling', 'student12', 'F', '1982-12-12', 4);

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

INSERT students_courses(id, student_id, course_id) VALUES
	(1, 1, 1),
	(2, 1, 2),
	(3, 1, 3),
	(4, 2, 2),
	(5, 2, 4),
	(6, 5, 1),
	(7, 5, 4),
	(8, 5, 8),
	(9, 5, 9),
	(10, 5, 10),
	(11, 8, 3),
	(12, 9, 3),
	(13, 9, 8),
	(14, 12, 3),
	(15, 12, 8);