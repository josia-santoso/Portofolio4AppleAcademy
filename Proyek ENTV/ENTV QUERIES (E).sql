USE ENTV
GO

--1
SELECT Staff.StaffID,StaffName,SupplierName,
COUNT(PurchaseHeader.StaffID) AS 'Total Transaction'
FROM Staff, Supplier, PurchaseHeader
WHERE Staff.StaffID LIKE PurchaseHeader.StaffID and PurchaseHeader.SupplierID LIKE Supplier.SupplierID AND
MONTH (PurchaseDate) > 8 AND
LEFT (StaffName, 1) LIKE 'B'
GROUP BY Staff.StaffName, Staff.StaffID, SupplierName 


--2
SELECT RIGHT(Customer.CustomerID, 3) AS 'CustomerID', CustomerName, TelevisionPrice * SalesQty AS 'Total Spending'
FROM Customer, SalesDetail, Television, SalesHeader
WHERE Television.TelevisionID LIKE SalesDetail.TelevisionID AND
SalesDetail.SalesID LIKE SalesHeader.SalesID AND
SalesHeader.CustomerID LIKE Customer.CustomerID AND
CustomerName LIKE '%a%' AND TelevisionName LIKE '%LED%'


--3
SELECT LEFT(StaffName,CHARINDEX(' ',StaffName)) AS StaffName, TelevisionName, TelevisionPrice * SalesQty AS 'Total Price'
FROM Staff s, PurchaseHeader ph, PurchaseDetail pd, Television t, SalesDetail sd
WHERE s.StaffID LIKE ph.StaffID AND ph.PurchaseID LIKE pd.PurchaseID AND pd.TelevisionID LIKE t.TelevisionID AND t.TelevisionID LIKE sd.TelevisionID
AND TelevisionName LIKE '%UHD%' AND SalesQty > 2


--4
SELECT UPPER(TelevisionName) AS 'TelevisionName', CONCAT(MAX(SalesQty), ' Pc(s)') AS 'Max Television Sold in One Trans', CONCAT(SUM(SalesQty),' Pc(s)') AS 'Total Television Sold in All Trans'
FROM Television, SalesHeader, SalesDetail
WHERE SalesHeader.SalesID LIKE SalesDetail.SalesID AND SalesDetail.TelevisionID LIKE Television.TelevisionID AND TelevisionPrice > 3000000 AND MONTH (SalesDate) > 2
GROUP BY TelevisionName
ORDER BY SUM(SalesQty) ASC


--5
SELECT SupplierName AS 'VendorName', REPLACE(SupplierNumber, '+62', '0') AS 'VendorPhone', TelevisionName, [TelevisionPrice] = CONCAT('Rp. ',TelevisionPrice)
FROM Supplier, Television, PurchaseHeader, PurchaseDetail
WHERE Supplier.SupplierID = PurchaseHeader.SupplierID AND PurchaseHeader.PurchaseID = PurchaseDetail.PurchaseID AND PurchaseDetail.TelevisionID = Television.TelevisionID
GROUP BY Supplier.SupplierName, Supplier.SupplierNumber, Television.TelevisionName, Television.TelevisionPrice
HAVING TelevisionPrice > (SELECT AVG(TelevisionPrice) FROM Television AS T) AND SupplierName LIKE '% %'

--Untuk mengecek AVERAGE TV PRICE
--(SELECT AVG(TelevisionPrice) FROM Television AS T)


--6
SELECT s.StaffID, StaffName, LEFT(StaffEmail, CHARINDEX ('@', StaffEmail)-1) AS 'StaffEmail', StaffSalary
FROM Staff s, SalesHeader sh, Customer c
WHERE StaffSalary > (SELECT AVG(StaffSalary) FROM Staff AS T) AND 
s.StaffID = sh.StaffID AND sh.CustomerID = c.CustomerID AND CustomerName LIKE '%o%'

-- //Check Full Email dan Customer yang namanya O
--SELECT s.StaffID, StaffName, StaffEmail, StaffSalary, CustomerName
--FROM Staff s, SalesHeader sh, Customer c
--WHERE StaffSalary > (SELECT AVG(StaffSalary) FROM Staff AS T) AND 
--s.StaffID = sh.StaffID AND sh.CustomerID = c.CustomerID AND CustomerName LIKE '%o%'
--GROUP BY s.StaffID, StaffName, StaffEmail, StaffSalary, CustomerName

-- //Check Average
--SELECT AVG(StaffSalary) AS 'Average StaffSalary' FROM Staff


--7
SELECT REPLACE(Television.TelevisionID,'TE','Television ') AS 'TelevisionID', TelevisionName, UPPER(TelevisionBrName) AS TelevisionBrName, CONCAT(SUM(SalesQty), ' Pc(s)') AS 'TotalSold'
FROM Television, TelevisionBr , SalesDetail
WHERE Television.TelevisionID = SalesDetail.TelevisionID AND Television.TelevisionBrID = TelevisionBr.TelevisionBrID
AND TelevisionName like '%LED%' 
GROUP BY Television.TelevisionID, TelevisionName, TelevisionBrName, SalesQty
HAVING SUM(SalesQty) > (SELECT AVG(SalesQty) FROM SalesDetail AS T) 
ORDER BY SUM(SalesQty) ASC

--Check Average SalesQty
--(SELECT AVG(SalesQty) FROM SalesDetail) 

--8
SELECT SupplierName AS 'VendorName', SupplierEmail AS 'VendorEmail', REPLACE(SupplierNumber, '+62', '+62') AS 'VendorPhone', [Total Quantity] = CONCAT(SUM(PurchaseQty),' Pc(s)')
FROM Supplier s, PurchaseHeader ph, PurchaseDetail pd, Television t
WHERE s.SupplierID = ph.SupplierID AND ph.PurchaseID = pd.PurchaseID AND pd.TelevisionID = t.TelevisionID
AND Month(PurchaseDate) BETWEEN '3' AND '6' AND SupplierName LIKE '% %'
GROUP BY s.SupplierName, s.SupplierEmail, s.SupplierNumber
HAVING MAX(PurchasePrice) BETWEEN '3' AND '6'


--9
CREATE VIEW [CustomerTransaction] AS 
SELECT CustomerName, CustomerEmail,
[Maximum Quantity Television] = CONCAT(MAX(SalesQty), ' Pc(s)'),
[Minimum Quantity Television] = CONCAT(MIN(SalesQty), ' Pc(s)')
FROM Customer c, SalesDetail sd, SalesHeader sh 
WHERE c.CustomerID = sh.CustomerID AND sh.SalesID = sd.SalesID AND CustomerName LIKE '%b%'
GROUP BY CustomerName, CustomerEmail
HAVING MAX(SalesQty) != MIN(SalesQty)

-- // Sebelum 2 kondisi CustomerName dan Max min tidak sama
--SELECT CustomerName, CustomerEmail,
--[Maximum Quantity Television] = CONCAT(MAX(SalesQty), ' Pc(s)'),
--[Minimum Quantity Television] = CONCAT(MIN(SalesQty), ' Pc(s)')
--FROM Customer c, SalesDetail sd, SalesHeader sh 
--WHERE c.CustomerID = sh.CustomerID AND sh.SalesID = sd.SalesID
--GROUP BY CustomerName, CustomerEmail

-- // Sebelum Kondisi CustomerName LIKE '%b%' 
--SELECT CustomerName, CustomerEmail,
--[Maximum Quantity Television] = CONCAT(MAX(SalesQty), ' Pc(s)'),
--[Minimum Quantity Television] = CONCAT(MIN(SalesQty), ' Pc(s)')
--FROM Customer c, SalesDetail sd, SalesHeader sh 
--WHERE c.CustomerID = sh.CustomerID AND sh.SalesID = sd.SalesID
--GROUP BY CustomerName, CustomerEmail
--HAVING MAX(SalesQty) != MIN(SalesQty)



--10
CREATE VIEW StaffTransaction
AS 
SELECT StaffName, StaffEmail, StaffNumber, 
[Count Transaction] = COUNT(ph.StaffID),
[Total Television]  = SUM(PurchaseQty)
FROM Staff s JOIN PurchaseHeader ph ON s.StaffID = ph.StaffID JOIN PurchaseDetail pd ON ph.PurchaseID = pd.PurchaseID
WHERE DAY(PurchaseDate) > 10 AND StaffEmail LIKE '%@gmail.com'
GROUP BY StaffName, StaffEmail, StaffNumber

--SELECT * FROM StaffTransaction