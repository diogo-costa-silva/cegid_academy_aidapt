-- ============================================
-- Exercicio 1 - Schema da Base de Dados
-- AiDAPT - Cegid Academy
-- ============================================

-- Criar base de dados (se nao existir)
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'ExerciciosDB')
BEGIN
    CREATE DATABASE ExerciciosDB;
END
GO

USE ExerciciosDB;
GO

-- ============================================
-- Limpar tabelas existentes (ordem inversa das FK)
-- ============================================

IF OBJECT_ID('dbo.Payments', 'U') IS NOT NULL DROP TABLE dbo.Payments;
IF OBJECT_ID('dbo.OrderItems', 'U') IS NOT NULL DROP TABLE dbo.OrderItems;
IF OBJECT_ID('dbo.Orders', 'U') IS NOT NULL DROP TABLE dbo.Orders;
IF OBJECT_ID('dbo.Products', 'U') IS NOT NULL DROP TABLE dbo.Products;
IF OBJECT_ID('dbo.Customers', 'U') IS NOT NULL DROP TABLE dbo.Customers;
GO

-- ============================================
-- Tabela: Customers (Clientes)
-- ============================================

CREATE TABLE dbo.Customers (
    CustomerID INT PRIMARY KEY IDENTITY(1,1),
    FullName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) NOT NULL,
    City NVARCHAR(50) NOT NULL,
    CreatedAt DATETIME DEFAULT GETDATE()
);
GO

-- ============================================
-- Tabela: Products (Produtos)
-- ============================================

CREATE TABLE dbo.Products (
    ProductID INT PRIMARY KEY IDENTITY(1,1),
    ProductName NVARCHAR(100) NOT NULL,
    Category NVARCHAR(50) NOT NULL,
    Price DECIMAL(10,2) NOT NULL,
    Active BIT DEFAULT 1
);
GO

-- ============================================
-- Tabela: Orders (Pedidos)
-- ============================================

CREATE TABLE dbo.Orders (
    OrderID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT NOT NULL,
    OrderDate DATETIME NOT NULL,
    Status NVARCHAR(20) NOT NULL,
    CONSTRAINT FK_Orders_Customers
        FOREIGN KEY (CustomerID) REFERENCES dbo.Customers(CustomerID)
);
GO

-- ============================================
-- Tabela: OrderItems (Itens do Pedido)
-- ============================================

CREATE TABLE dbo.OrderItems (
    OrderItemID INT PRIMARY KEY IDENTITY(1,1),
    OrderID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,
    CONSTRAINT FK_OrderItems_Orders
        FOREIGN KEY (OrderID) REFERENCES dbo.Orders(OrderID),
    CONSTRAINT FK_OrderItems_Products
        FOREIGN KEY (ProductID) REFERENCES dbo.Products(ProductID)
);
GO

-- ============================================
-- Tabela: Payments (Pagamentos)
-- ============================================

CREATE TABLE dbo.Payments (
    PaymentID INT PRIMARY KEY IDENTITY(1,1),
    OrderID INT NOT NULL,
    PaymentDate DATETIME NOT NULL,
    Amount DECIMAL(10,2) NOT NULL,
    Method NVARCHAR(20) NOT NULL,
    Status NVARCHAR(20) NOT NULL,
    CONSTRAINT FK_Payments_Orders
        FOREIGN KEY (OrderID) REFERENCES dbo.Orders(OrderID)
);
GO

-- ============================================
-- Verificar criacao das tabelas
-- ============================================

SELECT
    t.name AS TableName,
    COUNT(c.name) AS ColumnCount
FROM sys.tables t
JOIN sys.columns c ON t.object_id = c.object_id
WHERE t.schema_id = SCHEMA_ID('dbo')
  AND t.name IN ('Customers', 'Products', 'Orders', 'OrderItems', 'Payments')
GROUP BY t.name
ORDER BY t.name;
GO
