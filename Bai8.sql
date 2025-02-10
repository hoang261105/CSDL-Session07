CREATE TABLE Customer (
    cID INT PRIMARY KEY,
    Name VARCHAR(25),
    cAge INT
);

CREATE TABLE Orders (
    oID INT PRIMARY KEY,
    cID INT,
    oDate DATETIME,
    oTotalPrice INT,
    FOREIGN KEY (cID) REFERENCES Customer(cID) ON DELETE CASCADE
);

CREATE TABLE Products (
    pID INT PRIMARY KEY,
    pName VARCHAR(25),
    pPrice DOUBLE
);

CREATE TABLE Order_Detail (
    oID INT,
    pID INT,
    odQTY INT,
    PRIMARY KEY (oID, pID),
    FOREIGN KEY (oID) REFERENCES Orders(oID),
    FOREIGN KEY (pID) REFERENCES Products(pID)
);

-- Chèn dữ liệu vào bảng Customer
INSERT INTO Customer (cID, Name, cAge) VALUES
(1, 'Minh Quan', 10),
(2, 'Ngoc Oanh', 20),
(3, 'Hong Ha', 50);

-- Chèn dữ liệu vào bảng Orders
INSERT INTO Orders (oID, cID, oDate, oTotalPrice) VALUES
(1, 1, '2006-03-21', NULL),
(2, 2, '2006-03-23', NULL),
(3, 1, '2006-03-16', NULL);

-- Chèn dữ liệu vào bảng Products
INSERT INTO Products (pID, pName, pPrice) VALUES
(1, 'May Giat', 3),
(2, 'Tu Lanh', 5),
(3, 'Dieu Hoa', 7),
(4, 'Quat', 1),
(5, 'Bep Dien', 2);

-- Chèn dữ liệu vào bảng OrderDetail
INSERT INTO Order_Detail (oID, pID, odQTY) VALUES
(1, 1, 3),
(1, 3, 7),
(1, 4, 2),
(2, 1, 1),
(3, 1, 8),
(2, 5, 4),
(2, 3, 3);

-- 2
select o.oID, c.cID, o.oDate, o.oTotalPrice
from customer c
join orders o on o.cID = c.cID
order by o.oDate desc;  

-- 3
SELECT p.pName, p.pPrice AS max_price
FROM products p
WHERE p.pPrice = (SELECT MAX(pPrice) FROM products);

-- 4
select c.Name, p.pName
from products p
join order_detail od on od.pID = p.pID
join orders o on o.oID = od.oID
join customer c on c.cID = o.cID;

-- 5 
select c.Name from customer c 
left join orders o on o.cID = c.cID
where o.cID is null;

-- 6
select o.oID, o.oDate, od.odQTY, p.pName, p.pPrice
from products p
join order_detail od on od.pID = p.pID
join orders o on o.oID = od.oID;

-- 7
select o.oID, o.oDate, sum(od.odQTY * p.pPrice) as total_price
from orders o
join order_detail od on od.oID = o.oID
join products p on p.pID = od.pID
group by o.oID, o.oDate;