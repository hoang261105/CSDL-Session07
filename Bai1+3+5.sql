create database ss7;
use ss7;

-- Bài 1 
create table categories(
	category_id int primary key auto_increment,
    category_name varchar(255) not null
);

create table readers(
	reader_id int primary key auto_increment, 
    name varchar(255) not null,
    phone_number varchar(15) unique not null,
    email varchar(255) not null unique
);

create table books(
	book_id int primary key auto_increment,
    title varchar(255) not null,
    author varchar(255) not null,
    publication_year int,
    available_quantity int,
    category_id int,
    foreign key (category_id) references categories(category_id)
);

create table borrowing(
	borrow_id int primary key auto_increment,
    reader_id int,
    book_id int,
    foreign key (reader_id) references readers(reader_id),
    foreign key (book_id) references books(book_id),
    borrow_date date not null,
    due_date date not null
);

create table returning(
	return_id int primary key auto_increment,
    borrow_id int,
    foreign key (borrow_id) references borrowing(borrow_id),
    return_date date not null
);

create table fines(
	fine_id int primary key auto_increment,
    return_id int,
    foreign key (return_id) references returning(return_id),
    fine_amount decimal(10,2) 
);

INSERT INTO Categories (category_id, category_name) VALUES
(1, 'Science'),
(2, 'Literature'),
(3, 'History'),
(4, 'Technology'),
(5, 'Psychology');

-- Inserting books into the Books table with details such as title, author, and category
INSERT INTO Books (book_id, title, author, publication_year, available_quantity, category_id) VALUES
(1, 'The History of Vietnam', 'John Smith', 2001, 10, 1),
(2, 'Python Programming', 'Jane Doe', 2020, 5, 4),
(3, 'Famous Writers', 'Emily Johnson', 2018, 7, 2),
(4, 'Machine Learning Basics', 'Michael Brown', 2022, 3, 4),
(5, 'Psychology and Behavior', 'Sarah Davis', 2019, 6, 5);

-- Inserting library users (readers) into the Readers table
INSERT INTO Readers (reader_id, name, phone_number, email) VALUES
(1, 'Alice Williams', '123-456-7890', 'alice.williams@email.com'),
(2, 'Bob Johnson', '987-654-3210', 'bob.johnson@email.com'),
(3, 'Charlie Brown', '555-123-4567', 'charlie.brown@email.com');

-- Inserting borrowing records for books
INSERT INTO Borrowing (borrow_id, reader_id, book_id, borrow_date, due_date) VALUES
(1, 1, 1, '2025-02-19', '2025-02-15'),
(2, 2, 2, '2025-02-03', '2025-02-17'),
(3, 3, 3, '2025-02-02', '2025-02-16'),
(4, 1, 2, '2025-03-10', '2025-02-24'),
(5, 2, 3, '2025-05-11', '2025-02-25'),
(6, 2, 3, '2025-02-11', '2025-02-25');


-- Inserting book return records into the Returning table
INSERT INTO Returning (return_id, borrow_id, return_date) VALUES
(1, 1, '2025-03-14'),
(2, 2, '2025-02-28'),
(3, 3, '2025-02-15'),
(4, 4, '2025-02-20'),  
(5, 4, '2025-02-20');

-- Inserting penalty records into the Fines table for late returns
INSERT INTO Fines (fine_id, return_id, fine_amount) VALUES
(1, 1, 5.00),
(2, 2, 0.00),
(3, 3, 2.00);

-- Bài 3
-- 2.1
select * from books; 

-- 2.2
select * from readers;  

-- 2.3
select r.name, b.title, br.borrow_date 
from readers r 
join borrowing br on br.reader_id = r.reader_id
join books b on b.book_id = br.book_id;

-- 2.4
select b.title, b.author, c.category_name 
from books b join categories c on c.category_id = b.category_id; 

-- 2.5
select r.name, f.fine_amount, re.return_date
from readers r
join borrowing b on b.reader_id = r.reader_id
join returning re on re.borrow_id = b.borrow_id
join fines f on f.return_id = re.return_id;

-- 3.1
update books
set available_quantity = 15
where book_id = 1; 

-- 3.2
delete from readers
where reader_id = 2;

-- 3.3
INSERT INTO Readers (reader_id, name, phone_number, email)
VALUES (2, 'Bob Johnson', '987-654-3210', 'bob.johnson@email.com');

-- Bài 5
-- 2.1 
select b.title, b.author, c.category_name
from books b
join categories c on b.category_id = c.category_id
order by b.title;

-- 2.2
select r.name, count(b.title) as count_books
from readers r
join borrowing br on br.reader_id = r.reader_id
join books b on b.book_id = br.book_id
group by r.name;

-- 2.3
select r.name, avg(f.fine_amount) as avg_fines
from readers r
join borrowing br on br.reader_id = r.reader_id
join returning re on re.borrow_id = br.borrow_id
join fines f on f.return_id = re.return_id
group by r.name;

-- 2,4
select b.title, max(b.available_quantity) as max_quantity
from books b
group by b.title; 

-- 2.5
select r.name, f.fine_amount
from readers r 
join borrowing br on br.reader_id = r.reader_id
join returning re on re.borrow_id = br.borrow_id
join fines f on f.return_id = re.return_id
where f.fine_amount > 0;

-- 2.6
select b.title, count(br.book_id) as num_borrows
from books b
join borrowing br on br.book_id = b.book_id
group by b.title
having COUNT(br.book_id) = (
    select MAX(num_borrows)
    from (
        select COUNT(br2.book_id) AS num_borrows
        from borrowing br2
        group by br2.book_id
    ) AS max_borrows
);

-- 2.7
select b.title, r.name, br.borrow_date 
from books b
join borrowing br on br.book_id = b.book_id
join readers r on r.reader_id = br.reader_id
where br.borrow_date > now()
order by br.borrow_date; 

-- 2.8
select r.name, b.title 
from readers r 
join borrowing br on br.reader_id = r.reader_id
join books b on b.book_id = br.book_id
join returning re on re.borrow_id = br.borrow_id
where br.due_date = re.return_date
group by r.name, b.title;

-- 2.9
select distinct(b.title) as title, b.publication_year
from books b
join borrowing br on br.book_id = b.book_id
group by b.title, b.publication_year, b.book_id
having count(b.book_id) = (
	select max(num_borrows)
    from (
		select count(br1.book_id) as num_borrows
        from borrowing br1
        group by br1.book_id
    ) as max_borrows
);