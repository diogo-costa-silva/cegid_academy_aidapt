-- ============================================
-- Exercicio 1 - Dados de Exemplo (Seed)
-- AiDAPT - Cegid Academy
-- ============================================

USE ExerciciosDB;
GO

-- ============================================
-- Clientes (8 registos)
-- ============================================

INSERT INTO dbo.Customers (FullName, Email, City)
VALUES
    ('Ana Silva',      'ana.silva@email.com',      'Porto'),
    ('Bruno Costa',    'bruno.costa@email.com',    'Lisboa'),
    ('Carla Souza',    'carla.souza@email.com',    'Madrid'),
    ('Daniel Rocha',   'daniel.rocha@email.com',   'Porto'),
    ('Eva Martins',    'eva.martins@email.com',    'Paris'),
    ('Felipe Lima',    'felipe.lima@email.com',    'Porto'),
    ('Gabriela Nunes', 'gabriela.nunes@email.com', 'Berlin'),
    ('Hugo Mendes',    'hugo.mendes@email.com',    'Lisboa');
GO

-- ============================================
-- Produtos (10 registos)
-- ============================================

INSERT INTO dbo.Products (ProductName, Category, Price, Active)
VALUES
    ('Power BI Pro Course',     'Courses',     199.90, 1),
    ('Excel Advanced Course',   'Courses',     149.90, 1),
    ('SQL Server Fundamentals', 'Courses',     129.90, 1),
    ('Keyboard',                'Hardware',     49.90, 1),
    ('Mouse',                   'Hardware',     29.90, 1),
    ('Notebook Stand',          'Accessories',  19.90, 1),
    ('USB Hub',                 'Accessories',  15.00, 1),
    ('Old Cable',               'Accessories',   3.50, 0),
    ('Monitor 24"',             'Hardware',    120.00, 1),
    ('Fabric Workshop',         'Courses',     299.90, 1);
GO

-- ============================================
-- Pedidos (12 registos)
-- ============================================

INSERT INTO dbo.Orders (CustomerID, OrderDate, Status)
VALUES
    (1, DATEADD(DAY, -10, GETDATE()), 'PAID'),
    (2, DATEADD(DAY, -5,  GETDATE()), 'NEW'),
    (3, DATEADD(DAY, -20, GETDATE()), 'CANCELLED'),
    (4, DATEADD(DAY, -2,  GETDATE()), 'SHIPPED'),
    (5, DATEADD(DAY, -40, GETDATE()), 'PAID'),
    (6, DATEADD(DAY, -1,  GETDATE()), 'NEW'),
    (7, DATEADD(DAY, -15, GETDATE()), 'PAID'),
    (8, DATEADD(DAY, -3,  GETDATE()), 'PAID'),
    (1, DATEADD(DAY, -60, GETDATE()), 'SHIPPED'),
    (2, DATEADD(DAY, -12, GETDATE()), 'PAID'),
    (3, DATEADD(DAY, -8,  GETDATE()), 'NEW'),
    (4, DATEADD(DAY, -25, GETDATE()), 'CANCELLED');
GO

-- ============================================
-- Itens do Pedido (20 registos)
-- ============================================

INSERT INTO dbo.OrderItems (OrderID, ProductID, Quantity, UnitPrice)
VALUES
    -- Pedido 1
    (1, 1, 1, 199.90),
    (1, 6, 2,  19.90),

    -- Pedido 2
    (2, 2, 1, 149.90),
    (2, 5, 1,  29.90),

    -- Pedido 3
    (3, 4, 1,  49.90),

    -- Pedido 4
    (4, 9, 1, 120.00),
    (4, 7, 2,  15.00),

    -- Pedido 5
    (5, 10, 1, 299.90),
    (5, 6,  1,  19.90),

    -- Pedido 6
    (6, 3, 1, 129.90),

    -- Pedido 7
    (7, 1, 1, 199.90),
    (7, 2, 1, 149.90),

    -- Pedido 8
    (8, 4, 1, 49.90),
    (8, 5, 1, 29.90),
    (8, 7, 2, 15.00),

    -- Pedido 9
    (9, 9, 2, 120.00),

    -- Pedido 10
    (10, 3, 1, 129.90),
    (10, 6, 1,  19.90),

    -- Pedido 11
    (11, 2, 2, 149.90),

    -- Pedido 12
    (12, 4, 1, 49.90);
GO

-- ============================================
-- Pagamentos (7 registos)
-- ============================================

INSERT INTO dbo.Payments (OrderID, PaymentDate, Amount, Method, Status)
VALUES
    (1,  DATEADD(DAY, -9,  GETDATE()), 239.70, 'CARD',     'CONFIRMED'),
    (4,  DATEADD(DAY, -2,  GETDATE()), 150.00, 'TRANSFER', 'CONFIRMED'),
    (5,  DATEADD(DAY, -38, GETDATE()), 319.80, 'PIX',      'CONFIRMED'),
    (7,  DATEADD(DAY, -14, GETDATE()), 349.80, 'CARD',     'CONFIRMED'),
    (8,  DATEADD(DAY, -3,  GETDATE()), 124.90, 'CASH',     'CONFIRMED'),
    (9,  DATEADD(DAY, -59, GETDATE()), 240.00, 'PIX',      'CONFIRMED'),
    (10, DATEADD(DAY, -11, GETDATE()), 149.80, 'CARD',     'FAILED');
GO

-- ============================================
-- Verificar dados inseridos
-- ============================================

SELECT 'Customers' AS Tabela, COUNT(*) AS Registos FROM dbo.Customers
UNION ALL
SELECT 'Products', COUNT(*) FROM dbo.Products
UNION ALL
SELECT 'Orders', COUNT(*) FROM dbo.Orders
UNION ALL
SELECT 'OrderItems', COUNT(*) FROM dbo.OrderItems
UNION ALL
SELECT 'Payments', COUNT(*) FROM dbo.Payments;
GO
