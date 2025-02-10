SET SQL_SAFE_UPDATES = 0;

create table tests(
	test_id int primary key auto_increment,
    name varchar(20) 
);

create table students(
	RN int primary key auto_increment,
    name varchar(20),
    age tinyint 
);

create table studentTest(
	RN int,
    test_id int,
    foreign key (RN) references students(RN),
    foreign key (test_id) references tests(test_id),
    date datetime,
    mark float
);

alter table students
add constraint age check(age > 15 and age < 55);

alter table studenttest
modify column mark float default 0;

-- Chèn dữ liệu vào bảng Student
INSERT INTO Students (RN, Name, Age) VALUES
(1, 'Nguyen Hong Ha', 20),
(2, 'Truong Ngoc Anh', 30),
(3, 'Tuan Minh', 25),
(4, 'Dan Truong', 22);

-- Chèn dữ liệu vào bảng Test
INSERT INTO Tests (Test_ID, Name) VALUES
(1, 'EPC'),
(2, 'DWMX'),
(3, 'SQL1'),
(4, 'SQL2');

-- Chèn dữ liệu vào bảng StudentTest
INSERT INTO StudentTest (RN, Test_ID, Date, Mark) VALUES
(1, 1, '2006-07-17', 8),
(1, 2, '2006-07-18', 5),
(1, 3, '2006-07-19', 7),
(2, 1, '2006-07-17', 7),
(2, 2, '2006-07-18', 4),
(2, 3, '2006-07-19', 2),
(3, 1, '2006-07-17', 10),
(3, 3, '2006-07-18', 1);

-- 1.
select s.name as student_name, t.name as test_name, st.mark, st.date
from students s
join studenttest st on st.RN = s.RN
join tests t on t.test_id = st.test_id; 

-- 2
select distinct s.RN, s.name as student_name, s.age
from students s 
left join studenttest st on st.RN = s.RN
where st.rn is null;

-- 3.
select s.name as student_name, t.name as test_name, st.mark, st.date
from students s
join studenttest st on st.RN = s.RN
join tests t on t.test_id = st.test_id
where st.mark < 5;

-- 4.
select s.name as student_name, avg(st.mark) as average
from students s
join studenttest st on st.RN = s.RN
group by s.name
order by average desc;

-- 5
select s.name as student_name, avg(st.mark) as average
from students s
join studenttest st on st.RN = s.RN
group by s.name, s.rn
having avg(st.mark) = (
	select max(average)
    from (
		select avg(st1.mark) as average
        from studenttest st1
        group by st1.rn
    ) as max_avg
);

-- 6
select t.name as test_name, max(st.mark) as max_mark
from tests t
join studenttest st on st.test_id = t.test_id
group by t.name
order by test_name;

-- 7
select s.name as student_name, t.name as test_name
from students s 
left join studenttest st on st.RN = s.RN
left join tests t on t.test_id = st.test_id;

-- 8
update students
set age = age + 1;

alter table students
add column status varchar(10);

-- 9
update students
set status = 'Old'
where age > 30; 

-- 10
select s.name as student_name, t.name as test_name, st.mark, st.date
from students s
join studenttest st on st.RN = s.RN
join tests t on t.test_id = st.test_id
order by st.date;

-- 11
select s.name as student_name, s.age, avg(st.mark) as average
from students s
join studenttest st on st.RN = s.RN
group by s.name, s.age
having s.name like 'T%' and avg(st.mark) > 4.5; 

-- 12
select s.RN, s.name as student_name, s.age, avg(st.mark) as average, rank() over (order by avg(st.mark) desc) as ranking
from students s
join studenttest st on st.RN = s.RN
group by s.RN, s.name, s.age
order by ranking;

-- 13
ALTER TABLE students
modify COLUMN name nvarchar(100);	

-- 14+15
update students
set name = 
	case 
		when age > 20 then concat('Old', ' - ', name)
        when age <= 20 then concat('Young', ' - ', name)
        else name
	end;

-- 16
DELETE FROM tests
WHERE test_id NOT IN (SELECT DISTINCT test_id FROM studenttest);

-- 17
DELETE FROM studenttest
WHERE mark < 5;
 
 