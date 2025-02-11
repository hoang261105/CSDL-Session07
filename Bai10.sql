CREATE TABLE students1 (
    studentId INT PRIMARY KEY,
    studentName VARCHAR(50),
    age INT,
    email VARCHAR(100)
);

CREATE TABLE subjects (
    subjectId INT PRIMARY KEY,
    subjectName VARCHAR(50)
);

CREATE TABLE class (
    classId INT PRIMARY KEY,
    className VARCHAR(50)
);

CREATE TABLE classStudent (
    studentId INT,
    classId INT,
    PRIMARY KEY (studentId, classId),
    FOREIGN KEY (studentId) REFERENCES students1(studentId),
    FOREIGN KEY (classId) REFERENCES class(classId)
);

CREATE TABLE marks (
    subject_id INT,
    student_id INT,
    mark INT,
    PRIMARY KEY (subject_id, student_id),
    FOREIGN KEY (subject_id) REFERENCES subjects(subjectId),
    FOREIGN KEY (student_id) REFERENCES students1(studentId)
);

-- Thêm dữ liệu vào bảng students
INSERT INTO students (studentId, studentName, age, email) VALUES
(1, 'Nguyen Quang An', 18, 'an@yahoo.com'),
(2, 'Nguyen Cong Vinh', 20, 'vinh@gmail.com'),
(3, 'Nguyen Van Quyen', 19, 'quyen'),
(4, 'Pham Thanh Binh', 25, 'binh@com'),
(5, 'Nguyen Van Tai Em', 30, 'taiem@sport.vn');

-- Thêm dữ liệu vào bảng class
INSERT INTO class (classId, className) VALUES
(1, 'C0706L'),
(2, 'C0708G');

-- Thêm dữ liệu vào bảng classStudent
INSERT INTO classStudent (studentId, classId) VALUES
(1, 1),
(2, 1),
(3, 2),
(4, 2),
(5, 2),
(5, 1);

-- Thêm dữ liệu vào bảng subjects
INSERT INTO subjects1 (subjectId, subjectName) VALUES
(1, 'SQL'),
(2, 'Java'),
(3, 'C'),
(4, 'Visual Basic');

-- Thêm dữ liệu vào bảng marks
INSERT INTO marks (mark, subject_id, student_id) VALUES
(8, 1, 1),
(4, 2, 1),
(9, 1, 1),
(7, 1, 3),
(3, 1, 4),
(5, 2, 5),
(8, 3, 3),
(1, 3, 5),
(3, 2, 4);

-- 1
SELECT * FROM students1;

-- 2
SELECT * FROM subjects;

-- 3
SELECT 
    s.studentId, 
    s.studentName, 
    AVG(m.mark) AS avg_mark
FROM students s
LEFT JOIN marks m ON s.studentId = m.student_id
GROUP BY s.studentId, s.studentName;

-- 4 
SELECT DISTINCT sub.subjectName
FROM marks m
JOIN subjects sub ON m.subject_id = sub.subjectId
WHERE m.mark > 9;
 
-- 5
SELECT 
    s.studentId, 
    s.studentName, 
    AVG(m.mark) AS avg_mark
FROM students s
LEFT JOIN marks m ON s.studentId = m.student_id
GROUP BY s.studentId, s.studentName
ORDER BY avg_mark DESC;

-- 6
UPDATE subjects
SET subjectName = CONCAT('Day la mon hoc ', subjectName);

-- 7
DELIMITER //
CREATE TRIGGER check_age_before_insert
BEFORE INSERT ON students
FOR EACH ROW
BEGIN
    IF NEW.age <= 15 OR NEW.age >= 50 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Tuổi phải lớn hơn 15 và nhỏ hơn 50';
    END IF;
END;
//
DELIMITER ;
   