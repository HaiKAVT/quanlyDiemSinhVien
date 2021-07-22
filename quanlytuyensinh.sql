create database quanlytuyensinh;
use quanlytuyensinh;
create table ChiTietDT(
DTDUTHI double primary key,
DienGiaiDT nvarchar (45),
DiemUT double 
);

create table DiemThi(
SoBD int primary key,
Toan double ,
Van double ,
AnhVan double
);

creATE TABLE DanhSach(
SoBD int,
Ho nvarchar (45),
Ten nvarchar (45),
Phai BOOLEAN,
NTNS date,
DTDUTHI double,
PRIMARY KEY (SoBD,DTDUTHI),
FOREIGN KEY (SoBD)  REFERENCES DiemThi(SoBD),
FOREIGN KEY (DTDUTHI)  REFERENCES ChiTietDT(DTDUTHI)
);


-- 1. Tạo viewKET QUA chứa kết quả thi của từng học sinh bao gồm các thông tin:
-- SoBD, HoTen, Phai, Tuoi, Toan, Van, AnhVan, TongDiem, XepLoai, DTDuThI

Create view KetQua as 
select SoBD, HoTen, Phai, Tuoi, Toan, Van, AnhVan, DTDuThI, (casre)