create database quanlytrongtai;

use quanlytrongtai;
create table LoTrinh(
MaLoTrinh nvarchar(20) primary key,
TenLoTrinh nvarchar(20),
DonGia double,
ThoiGianQD double
);
create table TrongTai(
MaTrongTai nvarchar(20) primary key,
TrongTaiQD double
);

create table ChiTietVanTai(
MaVT int primary key,
Soxe nvarchar(20),
MaTrongTai  nvarchar(20),
MaLoTrinh nvarchar(20),
SoLuongVT int,
NgayDi date,
NgayDen date,
foreign key (MaLoTrinh) references LoTrinh(MaLoTrinh),
foreign key (MaTrongTai) references TrongTai(MaTrongTai)
);


-- tạo  view  gồm  các  trường SoXe,   MaLoTrinh,   SoLuongVT,   NgayDi,   NgayDen, ThoiGianVT, CuocPhi, Thuong.

/*Tạo view gồm các trường SoXe, MaLoTrinh, SoLuongVT, NgayDi, NgayDen,
ThoiGianVT, CuocPhi, Thuong*/

CREATE VIEW ChiTietVanTai_view AS	
SELECT Soxe, LoTrinh.MaLoTrinh,NgayDen,NgayDi,SoLuongVT, (case when ngayden - ngaydi = 0 then 1 else  datediff(ngayden, ngaydi) end) as 'ThoiGianVT' ,
(SoLuongVT * DonGia * 105/100 ) as cuocphi, ((SoLuongVT * DonGia * 105/100 ) * 5/100) as Thuong
FROM ChiTietVanTai join LoTrinh on ChiTietVanTai.MaLoTrinh = LoTrinh.MaLoTrinh;
select distinct * from ChiTietVanTai_view;

-- 3. Tạo view để lập bảng cước phí gồmcác trườngSoXe, TenLoTrinh, SoLuongVT, NgayDi, NgayDen, CuocPhi. 

CREATE VIEW CUOCPHI AS
SELECT Soxe,LoTrinh.TenLoTrinh, SoLuongVT, NgayDi, NgayDen, (SoLuongVT * DonGia * 105/100 ) as cuocphi
FROM ChiTietVanTai JOIN lotrinh ON chitietvantai.MaLoTrinh = lotrinh.MaLoTrinh;
SELECT distinct * FROM CUOCPHI;

-- 4. Tạo viewdanh  sách  các  xe  có  có  SoLuongVT vượt trọng tải qui định, gồm các trườngSoXe, TenLoTrinh, SoLuongVT, TronTaiQD, NgayDi, NgayDen.
drop view danhsachxe;
create view danhsachxe as
select Soxe,LoTrinh.TenLoTrinh, TrongTaiQD, NgayDi,NgayDen, SoLuongVT
from chitietvantai join lotrinh on chitietvantai.MaLoTrinh = lotrinh.MaLoTrinh 
join trongtai on chitietvantai.MaTrongTai = trongtai.MaTrongTai
where (SoLuongVT - TrongTaiQD > 0);
select distinct * from danhsachxe;

-- 5. Tạo hàmcó đầu vào là lộ trình, đầu ra là số xe, mã trọng tải, số lượng vận tải, ngày đi, ngày đến (SoXe, MaTrongTai, SoLuongVT, NgayDi, NgayDen.)
 drop procedure lotrinh;
DELIMITER //

CREATE PROCEDURE LOTRINH( tenlotrinh varchar(50))
BEGIN
SELECT SoXe, MaTrongTai, SoLuongVT, NgayDi, NgayDen 
FROM chitietvantai JOIN lotrinh on chitietvantai.MaLoTrinh = lotrinh.MaLoTrinh
GROUP BY chitietvantai.malotrinh
HAVING (chitietvantai.malotrinh= (Select(malotrinh) from lotrinh where lotrinh.tenlotrinh=tenlotrinh));
END;

//

DELIMITER ;
call lotrinh("HN-HD");


/*Thiết lập hàm có đầu vào là số xe, đầu ra là thông tin về lộ trình*/

drop procedure soxe;

delimiter //
CREATE PROCEDURE Soxe (Soxe nvarchar(20))
  BEGIN
    SELECT SoXe,lotrinh.malotrinh,TenLoTrinh,DonGia,ThoiGianQD
    from LoTrinh join ChiTietVanTai on ChiTietVanTai.MaLoTrinh = LoTrinh.MaLoTrinh
    where  ChiTietVanTai.malotrinh = lotrinh.malotrinh;
  END//
delimiter ;
call Soxe('1');

-- Thêm trường Thành tiền vào bảng chi tiết vận tải và tạo trigger điền dữ liệu cho trường

DROP TRIGGER IF EXISTS tongtien;
DELIMITER $$
CREATE TRIGGER tongtien
before update
ON chitietvantai
FOR EACH ROW
BEGIN
update chitietvantai set  cuocphi =  new.SoLuongVT * (select dongia from lotrinh where malotrinh = new.malotrinh) where chitietvantai.maVT = new.maVT;
END$$
 DELIMITER ;
 DELIMITER $$
 


