--ایجاد دیتابیس تست
DROP DATABASE IF EXISTS tst1402
CREATE DATABASE tst1402


USE TST1402


--ساخت جدول مورد نظر
DROP TABLE IF EXISTS SaleTable

CREATE TABLE SaleTable
(	SalesID INT primary KEY,
	OrderID INT ,
	Customer NVARCHAR(10),
	Product NVARCHAR(10),
	Date INT ,
	Quantity INT , 
	UnitPrice INT
)


--درج اطلاعات جداول
INSERT into SaleTable
Values 
(1,1,'C1','P1',1,2,100),
(2,1,'C1','P2',1,4,150),
(3,2,'C2','P2',1,5,150),
(4,3,'C3','P4',1,3,550),
(5,4,'C4','P3',1,1,300),
(6,4,'C4','P6',1,6,150),
(7,4,'C4','P4',1,6,550),
(8,5,'C5','P2',1,3,150),
(9,5,'C5','P1',1,6,100),
(10,6,'C1','P6',1,3,150),
(11,6,'C1','P3',1,2,300),
(12,7,'C3','P5',1,4,400),
(13,7,'C3','P1',1,6,100),
(14,7,'C3','P3',1,1,300),
(15,8,'C5','P2',1,3,150),
(16,8,'C5','P5',1,4,400),
(17,8,'C5','P1',1,2,100),
(18,9,'C2','P3',2,1,300),
(19,9,'C2','P4',2,3,550),
(20,9,'C2','P5',2,6,400),
(21,9,'C2','P1',2,4,100),
(22,10,'C4','P6',2,3,150),
(23,11,'C6','P3',2,2,300),
(24,11,'C6','P4',2,3,550),
(25,12,'C7','P1',2,5,100),
(26,12,'C7','P2',2,3,150),
(27,12,'C7','P3',2,1,300),
(28,13,'C2','P1',2,4,100),
(29,13,'C2','P3',2,2,300),
(30,14,'C6','P2',2,6,150),
(31,15,'C4','P6',2,1,150),
(32,16,'C1','P4',3,6,550),
(33,17,'C2','P5',3,3,400),
(34,18,'C8','P1',3,6,100),
(35,18,'C8','P3',3,3,300),
(36,18,'C8','P5',3,5,400),
(37,19,'C9','P2',3,2,150),
(38,20,'C2','P3',3,3,300),
(39,20,'C2','P1',3,4,100),
(40,20,'C2','P2',3,1,150)

DROP TABLE IF EXISTS SaleProfit
Create table SaleProfit
(
	Product NVARCHAR(10),
	ProfitRatio Float
)

Insert into SaleProfit
VAlues ('P1',0.05),
('P2',0.25),
('P3',0.1),
('P4',0.2),
('P5',0.1),
('P6',0.1)

DROP TABLE IF EXISTS OrganChart
Create table OrganChart
(
	ID INT PRIMARY KEY,
	Name NVARCHAR(20),
	Manager NVARCHAR(20),
	ManagerID INT
)


Insert into OrganChart
Values (1,'Ken',NULL,NULL),
(2,'Hugo',NULL,NULL),
(3,'James','Carol',5),
(4,'Mark','Morgan',13),
(5,'Carol','Alex',12),
(6,'David','Rose',21),
(7,'Michael','Markos',11),
(8,'Brad','Alex',12),
(9,'Rob','Matt',15),
(10,'Dylan','Alex',12),
(11,'Markos','Carol',5),
(12,'Alex','Ken',1),
(13,'Morgan','Matt',15),
(14,'Jennifer','Morgan',13),
(15,'Matt','Hugo',2),
(16,'Tom','Brad',8),
(17,'Oliver','Dylan',10),
(18,'Daniel','Rob',9),
(19,'Amanda','Markos',11),
(20,'Ana','Dylan',10),
(21,'Rose','Rob',9),
(22,'Robert','Rob',9),
(23,'Fill','Morgan',13),
(24,'Antoan','David',6),
(25,'Eddie','Mark',4)


----کل فروش شرکت تمرین اول
Select SUM(QUANTITY*UNITPRICE) AS TotalSale FRom SaleTable


---تعداد مشتریان که خرید کرده اند تمرین دوم
SELECT Count(DISTinct Customer) AS CustNum
from SaleTable


---تعداد فروش هر محصول
Select sum(quantity) as SumCount ,Product
FROM SaleTable
GROUP BY Product
GO



----تمرین چهارم مشتریان با بیش از خرید 1500 با مجموع تعداد آیتم و فاکتور ثبتی 
Select 
	Customer,
	SUM(quantity*unitprice) as TotalPurchase,
	Count(OrderID) AS FactorsNum,
	Count(Quantity) As ItemNum

from SaleTable
group by customer
Having SUM(Quantity * UnitPrice) > 1500
GO


---مبلغ و سود حاصل از فروش شرکت تمرین پنجم بخش الف
Select 
	SUM(QUANTITY * ProfitRatio*UnitPrice) AS TotalProfit,
	(SUM(QUANTITY * ProfitRatio*UnitPrice)/ SUM(QUANTITY *UnitPrice)) * 100 as TotalProfitPecentage
from SaleTable
join SaleProfit
  ON SaleProfit.Product = SaleTable.Product
GO

---هرمشتری هر روز تمرین ششم بخش الف
WITH CTE AS
(
SELECT DISTINCT DATE,Customer FROM SaleTable)
SELECT COUNT(*) AS CustCount FROM CTE



----تمرین ب چارت سازمانی
SELECT a.name,(select count(*)
        from (values (a.ID), (a.BossID), (a.ID3), (a.ID4),(a.ID5),(a.ID6)) as v(col)
        where v.col is not null)as level,A.ID,A.BossID,A.BossName

FROM (
select o1.name,o1.id ID,O2.id BossID,o3.id id3,o4.id id4,o5.id id5,o6.id id6,O2.NAME AS BossName from OrganChart as o1
 left JOIN ORGANCHART AS O2
ON O1.managerid = O2.id
 left JOIN ORGANCHART AS O3
ON O2.managerid = O3.id
left JOIN ORGANCHART AS O4
ON O3.managerid = O4.id
left JOIN ORGANCHART AS O5
ON O4.managerid = O5.id
left JOIN ORGANCHART AS O6
ON O5.managerid = O6.id
) as a
ORDER BY level
GO
