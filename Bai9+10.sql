CREATE TABLE tblPhong (
    PhongID INT PRIMARY KEY auto_increment,
    Ten_Phong VARCHAR(20),
    Trang_Thai TINYINT
);

CREATE TABLE tblGhe (
    GheID INT PRIMARY KEY auto_increment,
    PhongID INT,
    So_Ghe VARCHAR(10),
    FOREIGN KEY (PhongID) REFERENCES tblPhong(PhongID)
);

CREATE TABLE tblPhim (
    phimID INT PRIMARY KEY auto_increment,
    Ten_Phim VARCHAR(30),
    Loai_Phim VARCHAR(25),
    Thoi_Gian INT
);

CREATE TABLE tblVe (
    GheID INT,
    PhimID INT,
    Ngay_Chieu DATETIME,
    Trang_Thai VARCHAR(20),
    PRIMARY KEY (GheID, PhimID, Ngay_Chieu),
    FOREIGN KEY (GheID) REFERENCES tblGhe(GheID),
    FOREIGN KEY (PhimID) REFERENCES tblPhim(phimID)
);

-- Thêm dữ liệu vào bảng tblPhim
INSERT INTO tblPhim (Ten_Phim, Loai_Phim, Thoi_Gian) VALUES
('Em bé Hà Nội', 'Tâm lý', 90),
('Nhiệm vụ bất khả thi', 'Hành động', 100),
('Dị nhân', 'Viễn tưởng', 90),
('Cuốn theo chiều gió', 'Tình cảm', 120);

-- Thêm dữ liệu vào bảng tblPhong
INSERT INTO tblPhong (Ten_Phong, Trang_Thai) VALUES
('Phòng chiếu 1', 1),
('Phòng chiếu 2', 1),
('Phòng chiếu 3', 0);

-- Thêm dữ liệu vào bảng tblGhe
INSERT INTO tblGhe (PhongID, So_Ghe) VALUES
(1, 'A3'),
(1, 'B5'),
(2, 'A7'),
(2, 'D1'),
(3, 'T2');

-- Thêm dữ liệu vào bảng tblVe
INSERT INTO tblVe (PhimID, GheID, Ngay_Chieu, Trang_Thai) VALUES
(1, 1, '2008-10-20', 'Đã bán'),
(1, 3, '2008-11-20', 'Đã bán'),
(1, 4, '2008-12-23', 'Đã bán'),
(2, 1, '2009-02-14', 'Đã bán'),
(3, 1, '2009-02-14', 'Đã bán'),
(2, 5, '2009-03-08', 'Chưa bán'),
(2, 3, '2009-03-08', 'Chưa bán');

-- 2
SELECT Ten_Phim FROM tblPhim
WHERE Thoi_Gian = (SELECT MAX(Thoi_Gian) FROM tblPhim);
 
-- 3
SELECT Ten_Phim FROM tblPhim
WHERE Thoi_Gian = (SELECT MIN(Thoi_Gian) FROM tblPhim);

-- 4
SELECT So_Ghe FROM tblGhe
WHERE So_Ghe LIKE 'A%';
  
-- 5
ALTER TABLE tblPhong 
MODIFY COLUMN Trang_Thai VARCHAR(25);

-- 6
DELIMITER //
CREATE PROCEDURE UpdateAndShowPhong()
BEGIN
    UPDATE tblPhong 
    SET Trang_Thai = CASE 
        WHEN Trang_Thai = '0' THEN 'Đang sửa'
        WHEN Trang_Thai = '1' THEN 'Đang sử dụng'
        ELSE 'Unknow'
    END;
    
    SELECT * FROM tblPhong;
END //
DELIMITER ;

CALL UpdateAndShowPhong();

-- 7
SELECT Ten_Phim FROM tblPhim
WHERE LENGTH(Ten_Phim) > 15 AND LENGTH(Ten_Phim) < 25;
 
-- 8
CREATE VIEW tblRank AS
SELECT ROW_NUMBER() OVER (ORDER BY Ten_Phim) AS STT, Ten_Phim, Thoi_Gian
FROM tblPhim;
 
-- 9
ALTER TABLE tblPhim 
ADD COLUMN Mo_ta NVARCHAR(100);

-- 10
UPDATE tblPhim 
SET Mo_ta = CONCAT('Đây là bộ phim thể loại ', Loai_Phim);

-- 11
UPDATE tblPhim 
SET Mo_ta = REPLACE(Mo_ta, 'bộ phim', 'film');
 
-- 12
ALTER TABLE tblGhe DROP FOREIGN KEY tblGhe_ibfk_1;
ALTER TABLE tblVe DROP FOREIGN KEY tblVe_ibfk_1;
ALTER TABLE tblVe DROP FOREIGN KEY tblVe_ibfk_2;

-- 13
DELETE FROM tblGhe;

-- 14
SELECT Ngay_Chieu AS 'Ngày chiếu ban đầu',
       DATE_ADD(Ngay_Chieu, INTERVAL 5000 MINUTE) AS 'Ngày chiếu cộng 5000 phút'
FROM tblVe;
  
 