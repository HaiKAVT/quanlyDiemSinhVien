create database QuanlySinhVien;
use QuanlySinhVien;
create table Subjects(
SubjectsID int primary key,
SubjectsName nvarchar(50)
);
create table Classes(
ClassID int primary key,
ClassName nvarchar(50)
);

create table Students(
StudentID int primary key,
StudentName nvarchar(50),
Age int,
Email nvarchar(50)
);

create table ClassStudent(
StudentID int,
ClassID int,
foreign key (StudentID) references Students(StudentID),
foreign key (ClassID) references Classes(ClassID)
);

create table Mark(
MarkID int primary key,
Mark int,
StudentID int,
SubjectsID int,
foreign key (StudentID) references Students(StudentID),
foreign key (SubjectsID) references Subjects(SubjectsID)
);

--  Hien thi danh sach tat ca cac hoc vien 

select * from students;

-- Hien thi danh sach tat ca cac mon hoc

select * from subjects;


-- Tinh diem trung binh 

select avg(Mark) as DiemTB from Mark ;

-- Hien thi mon hoc nao co hoc sinh thi duoc diem cao nhat
select StudentName,Mark
from Students
join Mark on Students.StudentID=Mark.StudentID
order by Mark desc
limit 1;

-- Danh so thu tu cua diem theo chieu giam
select row_number() OVER  (order by Mark) as 'so thu tu', Mark 
from Mark;

-- Trong bang Student them mot column Status co kieu du lieu la Bit va co gia tri Default la 1
ALTER TABLE  Students
  ADD  Status Bit Default 1;
  
  
  -- Thay doi kieu du lieu cua cot SubjectName trong bang Subjects thanh nvarchar(max)
alter table subjects change column SubjectsName SubjectsName NVARCHAR(4000) ;
  
  
--  Cap nhat them dong chu « Day la mon hoc «  vao truoc cac ban ghi tren cot SubjectName trong bang Subjects
UPDATE subjects SET SubjectsName = ' Day la mon hoc SQL' WHERE (SubjectsID = '1');
UPDATE subjects SET SubjectsName = ' Day la mon hoc Java' WHERE (SubjectsID = '2');
UPDATE subjects SET SubjectsName = ' Day la mon hoc C' WHERE (SubjectsID = '3');
UPDATE subjects SET SubjectsName = ' Day la mon hoc Visual Basic' WHERE (SubjectsID = '4');


  
  /*Loai bo tat ca quan he giua cac bang*/
alter TABLE ClassStudent
drop foreign key  ClassStudent_IBFK_1,
drop foreign key ClassStudent_IBFK_2;

alter TABLE Mark
drop foreign key Mark_IBFK_1,
drop foreign key Mark_IBFK_2;

  
  -- Xoa hoc vien co StudentID la 1
  DELETE FROM Students WHERE StudentID = 1;
  
  
-- Viet Check Constraint de kiem tra do tuoi nhap vao trong bang Student yeu cau Age >15 va Age < 50*/
alter TABLE Students
add Check (Age >15 and Age<50);

-- Cap nhap gia tri Status trong bang Student thanh 0

update Students set status = 0 ;

SET SQL_SAFE_UPDATES = 0;