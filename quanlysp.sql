create database quanlysp;
use quanlysp;
create table khachhang(
makh int primary key,
tenkh nvarchar(50),
diachi nvarchar(50),
sdt int(10)
);
create table sanpham(
masp int primary key,
tensp nvarchar(50),
gia double
);
create table hoadon(
mahd int primary key,
ngaylap date,
tongtien double,
makh int not null,
foreign key (makh) references khachhang(makh)
);
create table chitiethoadon(
id int primary key,
mahd int,
masp int,
soluong int,
giaban double,
foreign key (mahd) references hoadon(mahd),
foreign key (masp) references sanpham(masp)
);
insert into khachhang values (1, 'Hai', 'Hà Nội', 0988889999),
							 (2, 'Toan', 'Hà Nội', 0988889969),
                              (3, 'Tuan', 'Hà Nội', 0988889969),
                               (4, 'Tam', 'Hà Nội', 0988889969),
                                (5, 'Trang', 'Hà Nội', 0988889969);
 insert into sanpham values (1,'Máy giặt',500),
							(2,'Ti vi',200),
							(3,'Tủ lạnh',400),
                            (4,'Điều Hòa', 100),
                            (5, 'Điện Thoại', 150);
insert into hoadon values (1,'2006-06-19', 300, 2),
						 (2,'2006-06-20',500,3),
						   (3,'2006-06-19',600,1);
insert into chitiethoadon values (1,1,3,4,400),
									(2,2,2,5,200),
									(3,3,1,3,500);
                                    
--  In ra các số hóa đơn, trị giá hóa đơn bán ra trong ngày 19/6/2006 và ngày 20/6/2006.

select * from hoadon
where hoadon.ngaylap between '2006-06-19' and '2006-06-20';

/*In ra các số hóa đơn, trị giá hóa đơn trong tháng 6/2007, sắp xếp theo ngày (tăng dần) và trị giá của hóa đơn (giảm dần). */

select * from hoadon
where hoadon.ngaylap like '2007-06%'
order by  tongtien desc;
/* 40 Tìm khách hàng (MAKH, HOTEN) có số lần mua hàng nhiều nhất.*/
SELECT makh, tenkh
FROM khachhang
WHERE makh = (SELECT mahd
              FROM hoadon
              GROUP BY mahd
              ORDER BY COUNT(DISTINCT mahd) DESC
              limit 1);
              
              -- 45. Trong 10 khách hàng có doanh số cao nhất, tìm khách hàng có số lần mua hàng nhiều nhất.
              
select distinct * from (select khachhang.makh,tenkh from khachhang join hoadon on khachhang.makh = hoadon.makh 
				join chitiethoadon on hoadon.mahd = chitiethoadon.mahd
				join sanpham on sanpham.masp = chitiethoadon.masp
				order by tongtien desc limit 10) 
                as top10
where top10.makh = (select khachhang.makh from khachhang join hoadon on khachhang.makh = hoadon.makh 
						join chitiethoadon on hoadon.mahd = chitiethoadon.mahd
						join sanpham on sanpham.masp = chitiethoadon.masp
						group by khachhang.makh
						order by count(hoadon.mahd) desc limit 1);
                        
-- 39. Tìm hóa đơn có mua 3 sản phẩm có giá <300 (3 sản phẩm khác nhau).

SELECT * FROM quanlysp.hoadon
where mahd in
(select hoadon.mahd from khachhang join hoadon on khachhang.makh = hoadon.makh 
			join chitiethoadon on hoadon.mahd = chitiethoadon.mahd
			join sanpham on sanpham.masp = chitiethoadon.masp
where gia < 200
group by hoadon.mahd
having count(hoadon.mahd) >= 3);

-- 28. In ra danh sách các sản phẩm (MASP, TENSP) có giá bán bằng 1 trong 3 mức giá caonhất.

select * from sanpham
where gia between (select gia from (SELECT gia FROM quanlysp.sanpham order by gia desc limit 3) as min order by min.gia limit 1) 
and (select gia from (SELECT gia FROM quanlysp.sanpham order by gia desc limit 3) as max limit 1 );


DROP TRIGGER IF EXISTS tongtien;
DELIMITER $$
CREATE TRIGGER tongtien
before update
ON chitiethoadon
FOR EACH ROW
BEGIN
update hoadon set tongtien = tongtien + new.soluong * (select gia from sanpham where masp = new.masp) where hoadon.mahd = new.mahd;
END$$
 DELIMITER ;
 DELIMITER $$
 
CREATE TRIGGER ngaytao
before insert
ON hoadon
FOR EACH ROW
BEGIN
set new.ngaylap = now();
END$$
 DELIMITER ;
