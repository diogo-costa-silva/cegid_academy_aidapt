-- ============================================
-- Exercicio 4 - GROUP BY / HAVING
-- AiDAPT - Cegid Academy
-- ============================================
-- Conceitos: GROUP BY, HAVING, AVG, COUNT, SUM
-- Base de dados: ExerciciosDB
-- ============================================

USE ExerciciosDB;
GO

-- ============================================
-- 4.1 Preco medio por categoria
-- ============================================

SELECT
    Category,
    AVG(Price) AS PrecoMedio
FROM dbo.Products
GROUP BY Category;

-- ============================================
-- 4.2 Quantidade de produtos por categoria
-- ============================================

SELECT
    Category,
    COUNT(*) AS QtdProdutos
FROM dbo.Products
GROUP BY Category;

-- ============================================
-- 4.3 Quantidade de pedidos por status
-- ============================================

SELECT
    Status,
    COUNT(*) AS QtdPedidos
FROM dbo.Orders
GROUP BY Status;

-- ============================================
-- 4.4 Total confirmado recebido (SUM payments)
-- ============================================

SELECT
    SUM(Amount) AS TotalConfirmado
FROM dbo.Payments
WHERE Status = 'CONFIRMED';

-- ============================================
-- 4.5 Total pago por cliente
-- ============================================

SELECT
    c.FullName,
    SUM(p.Amount) AS TotalPago
FROM dbo.Customers c
INNER JOIN dbo.Orders o ON c.CustomerID = o.CustomerID
INNER JOIN dbo.Payments p ON o.OrderID = p.OrderID
WHERE p.Status = 'CONFIRMED'
GROUP BY c.FullName
ORDER BY TotalPago DESC;

-- ============================================
-- 4.6 Clientes com total gasto > 300 (HAVING)
-- ============================================

SELECT
    c.FullName,
    SUM(p.Amount) AS TotalPago
FROM dbo.Customers c
INNER JOIN dbo.Orders o ON c.CustomerID = o.CustomerID
INNER JOIN dbo.Payments p ON o.OrderID = p.OrderID
WHERE p.Status = 'CONFIRMED'
GROUP BY c.FullName
HAVING SUM(p.Amount) > 300
ORDER BY TotalPago DESC;

-- ============================================
-- 4.7 Total de cada pedido (somar itens)
-- ============================================

SELECT
    OrderID,
    SUM(Quantity * UnitPrice) AS TotalPedido
FROM dbo.OrderItems
GROUP BY OrderID
ORDER BY OrderID;

-- ============================================
-- Notas:
-- - GROUP BY: Agrupa linhas com valores iguais
-- - HAVING: Filtra grupos (usa-se apos GROUP BY)
-- - WHERE filtra ANTES de agrupar
-- - HAVING filtra DEPOIS de agrupar
-- ============================================
