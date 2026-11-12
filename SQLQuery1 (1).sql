CREATE DATABASE Inventory_Management
ON PRIMARY(
    NAME = 'Inventory_Management',
    FILENAME = 'D:\sql phase1\Inventory_Management.mdf',
    SIZE = 10MB,
    FILEGROWTH = 5MB,
    MAXSIZE = 100MB
),
FILEGROUP Inventory_Management_sec(
    NAME = 'Inventory_Management_sec',
    FILENAME = 'D:\sql phase1\Inventory_Management.ndf',
    SIZE = 5MB,
    FILEGROWTH = 10MB,
    MAXSIZE = 100MB
)
LOG ON(
    NAME = 'Inventory_Management_log_1',
    FILENAME = 'D:\sql phase1\Inventory_Management_log_1.ldf',
    SIZE = 10MB,
    FILEGROWTH = 50%,
    MAXSIZE = UNLIMITED
),
(
    NAME = 'Inventory_Management_log_2',
    FILENAME = 'D:\sql phase1\Inventory_Management_log_2.ldf',
    SIZE = 10MB,
    FILEGROWTH = 50%,
    MAXSIZE = UNLIMITED
);
GO

USE Inventory_Management;
GO

--1
CREATE TABLE Warehouses (
    Branch_ID INT CONSTRAINT PK_Warehouses PRIMARY KEY,
    Branch_Name NVARCHAR(50) CONSTRAINT UQ_Warehouse_Name UNIQUE NOT NULL, 
    Branch_address NVARCHAR(100),
    Country NVARCHAR(50) CONSTRAINT DF_Warehouse_Country DEFAULT 'Egypt' NOT NULL 
);
GO

--2
CREATE TABLE Suppliers (
    Supplier_ID INT CONSTRAINT PK_Supplier PRIMARY KEY,
    Supplier_name NVARCHAR(50) NOT NULL,
    Country NVARCHAR(50) CONSTRAINT DF_Supplier_Country DEFAULT 'Egypt' NOT NULL 
);
GO

--3
CREATE TABLE Departments (
    Department_ID INT CONSTRAINT PK_Department PRIMARY KEY,
    [floor] INT CONSTRAINT CHK_Department_Floor CHECK (floor >= 0) NOT NULL,
    Branch_ID INT NOT NULL,
    CONSTRAINT FK_Department_Warehouses FOREIGN KEY (Branch_ID) 
        REFERENCES Warehouses(Branch_ID)
);
GO

--4
CREATE TABLE Employees (
    Employee_ID INT CONSTRAINT PK_Employee PRIMARY KEY,
    First_name NVARCHAR(50) NOT NULL,
    Last_name NVARCHAR(50) NOT NULL,
    Phone_number VARCHAR(15) NOT NULL CONSTRAINT UQ_Employees_Phone UNIQUE,
    CONSTRAINT Emp_PHN CHECK (LEN(Phone_number) >= 11), 
    Address NVARCHAR(100),
    Department_ID INT NOT NULL,
    CONSTRAINT FK_Employee_Department FOREIGN KEY (Department_ID) 
        REFERENCES Departments(Department_ID)
);
GO

--5
CREATE TABLE Customers(
    Customer_ID INT CONSTRAINT PK_CustId PRIMARY KEY,
    [User_name] NVARCHAR(50) CONSTRAINT CustUN UNIQUE NOT NULL,
    First_name NVARCHAR(50) NOT NULL,
    Last_name NVARCHAR(50) NOT NULL,
    Phone_number VARCHAR(15) NOT NULL CONSTRAINT UQ_Customers_Phone UNIQUE,
    CONSTRAINT CustPHN CHECK (LEN(Phone_number) >= 11),
    Address NVARCHAR(100) NOT NULL
);
GO

--6
CREATE TABLE Inventory(
    Product_ID INT CONSTRAINT PK_PdctI PRIMARY KEY,
    Branch_ID INT NOT NULL,
    Supplier_ID INT NOT NULL,
    Stock INT NOT NULL CONSTRAINT STOCK_CHCK CHECK (Stock>=0),
    Product_name NVARCHAR(50) NOT NULL,
    Price DECIMAL(10,2) NOT NULL CONSTRAINT PRICE_CHCK CHECK (Price >0),
    CONSTRAINT branch_id_con FOREIGN KEY (Branch_ID) REFERENCES Warehouses(Branch_ID),
    CONSTRAINT supplier_id_con FOREIGN KEY (Supplier_ID) REFERENCES Suppliers(Supplier_ID)
);
GO

--7
CREATE TABLE Orders(
    Order_ID INT NOT NULL,
    Product_ID INT NOT NULL,
    Customer_ID INT NOT NULL,
    Quantity INT NOT NULL CONSTRAINT Q_CHCK CHECK (Quantity>0),
    Total_price DECIMAL(10,2) NOT NULL,
    CONSTRAINT product_id_con FOREIGN KEY (Product_ID) REFERENCES Inventory(Product_ID),
    CONSTRAINT customer_id_con FOREIGN KEY (Customer_ID) REFERENCES Customers(Customer_ID),
    CONSTRAINT orders_pk PRIMARY KEY (Order_ID, Product_ID)
);
GO

SELECT * FROM sys.database_files;