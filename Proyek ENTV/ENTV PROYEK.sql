CREATE DATABASE ENTV
GO
USE ENTV

CREATE TABLE Staff(
	StaffID CHAR(5) CONSTRAINT StaffID_PK PRIMARY KEY CHECK(StaffID LIKE 'ST[0-9][0-9][0-9]'),
	StaffName VARCHAR(50) NOT NULL,
	StaffEmail VARCHAR(35) NOT NULL,
	StaffGender VARCHAR(10) CONSTRAINT StaffGender_ch CHECK(StaffGender IN('Male','Female')) NOT NULL,
	StaffNumber VARCHAR (20) CONSTRAINT StaffNumber_ch CHECK(StaffNumber LIKE '+62%') NOT NULL,
	StaffAddress VARCHAR(50) NOT NULL,
	StaffSalary INT NOT NULL,
	StaffDOB DATE CONSTRAINT StaffDOB_ch CHECK(StaffDOB LIKE '%-%-%' AND DATEPART(YEAR, StaffDOB) <= 2000) NOT NULL
)


CREATE TABLE Customer(
	CustomerID CHAR(5) CONSTRAINT CustomerID_PK PRIMARY KEY CHECK(CustomerID LIKE 'CU[0-9][0-9][0-9]'),
	CustomerName VARCHAR(50) NOT NULL,
	CustomerEmail VARCHAR(35) CONSTRAINT CustomerEmail_ch CHECK(CustomerEmail LIKE '%@yahoo.com' OR CustomerEmail LIKE '%@gmail.com') NOT NULL,
	CustomerGender VARCHAR(10) CONSTRAINT CustomerGender_ch CHECK(CustomerGender IN('Male', 'Female')) NOT NULL,
	CustomerNumber VARCHAR (20) CONSTRAINT CustomerNumber_ch CHECK(CustomerNumber LIKE '+62%') NOT NULL,
	CustomerAddress VARCHAR(50) NOT NULL,
	CustomerDOB DATE NOT NULL
)


CREATE TABLE Supplier(
	SupplierID CHAR(5) CONSTRAINT SupplierID_PK PRIMARY KEY CHECK(SupplierID LIKE 'VE[0-9][0-9][0-9]'),
	SupplierName VARCHAR(50) CONSTRAINT SupplierName_ch CHECK(LEN(SupplierName) > 3) NOT NULL,
	SupplierEmail VARCHAR(35) NOT NULL,
	SupplierNumber VARCHAR (20) NOT NULL,
	SupplierAddress VARCHAR(50) NOT NULL
)


CREATE TABLE TelevisionBr(
	TelevisionBrID CHAR(5) CONSTRAINT TelevisionBrID_PK PRIMARY KEY CHECK(TelevisionBrID LIKE 'TB[0-9][0-9][0-9]'),
	TelevisionBrName VARCHAR(50) NOT NULL,
	TelevisionQty INT NOT NULL
)


CREATE TABLE Television(
	TelevisionID CHAR(5) CONSTRAINT TelevisionID_PK PRIMARY KEY CHECK(TelevisionID LIKE 'TE[0-9][0-9][0-9]'),
	TelevisionName VARCHAR(50) NOT NULL,
	TelevisionBrID CHAR(5) CONSTRAINT TelevisionBrIDt_FK FOREIGN KEY REFERENCES TelevisionBr(TelevisionBrID) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
	TelevisionPrice INT CONSTRAINT TelevisionPrice_ch CHECK(TelevisionPrice BETWEEN 1000000 AND 20000000) NOT NULL
)


CREATE TABLE PurchaseHeader(
	PurchaseID CHAR(5) CONSTRAINT PurchaseID_PK PRIMARY KEY CHECK(PurchaseID LIKE 'PE[0-9][0-9][0-9]'),
	StaffID CHAR(5) CONSTRAINT StaffIDpd_FK FOREIGN KEY REFERENCES Staff(StaffID) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
	SupplierID CHAR(5) CONSTRAINT SupplierIDpd_FK FOREIGN KEY REFERENCES Supplier(SupplierID) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
	PurchasePrice INT NOT NULL,		--Satuannya harga 1 TV saja
	PurchaseDate DATE NOT NULL
)

--Untuk mentrack Quantity TV dan TV jenis apa (Merek Sama karena hanya dari vendor brand yang sama) yang dibeli dari satu vendor.
CREATE TABLE PurchaseDetail(
	PurchaseDetailID CHAR(5) CONSTRAINT PurchaseDetailID_PK CHECK (PurchaseDetailID LIKE 'PD[0-9][0-9][0-9]'), --Untuk Unique ID karena bisa saja ENTV membeli 2 TV Merk sama tetapi berbeda jenis dalam satu purchase.
	PurchaseID CHAR(5) CONSTRAINT PurchaseID_FK FOREIGN KEY REFERENCES PurchaseHeader(PurchaseID) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
	TelevisionID CHAR(5) CONSTRAINT TelevisionIDpd_FK FOREIGN KEY REFERENCES Television(TelevisionID) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
	PurchaseQty INT NOT NULL
)


CREATE TABLE SalesHeader(
	SalesID CHAR(5) CONSTRAINT SalesID_PK PRIMARY KEY CONSTRAINT SalesID_ch CHECK(SalesID LIKE 'SA[0-9][0-9][0-9]'),
	StaffID CHAR(5) CONSTRAINT StaffIDSales_FK FOREIGN KEY REFERENCES Staff(StaffID) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
	CustomerID CHAR(5) CONSTRAINT CustomerIDSales_FK FOREIGN KEY REFERENCES Customer(CustomerID) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
	SalesDate DATE NOT NULL	
)

--Untuk mentrack Quantity dan TV apa (Karena Customer bisa saja beli lebih dari 1 Tv dengan jenis dan merk yang berbeda jika stock tidak ada) yang dibeli dalam satu kali transaksi
CREATE TABLE SalesDetail(
	SalesDetailID CHAR(5) CONSTRAINT SalesDetailID_PK PRIMARY KEY CHECK (SalesDetailID LIKE 'SD[0-9][0-9][0-9]'),
	SalesID CHAR(5) CONSTRAINT SalesID_FK FOREIGN KEY REFERENCES SalesHeader(SalesID) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
	TelevisionID CHAR(5) CONSTRAINT TelevisionIDSales_FK FOREIGN KEY REFERENCES Television(TelevisionID) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
	SalesQty INT NOT NULL
)

