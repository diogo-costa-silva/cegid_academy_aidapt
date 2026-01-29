-- ============================================
-- Exercicio 5 - JOINs
-- AiDAPT - Cegid Academy
-- ============================================
-- Conceitos: INNER JOIN, LEFT JOIN, anti-join, multiplas tabelas
-- Base de dados: ExerciciosDB
-- ============================================

USE ExerciciosDB;
GO

-- ============================================
-- 5.1 INNER JOIN: pedidos + nome do cliente
-- ============================================

SELECT
    o.OrderID,
    o.OrderDate,
    o.Status,
    c.FullName AS Cliente
FROM dbo.Orders o
INNER JOIN dbo.Customers c ON o.CustomerID = c.CustomerID
ORDER BY o.OrderID;

-- ============================================
-- 5.2 INNER JOIN: itens + nome do produto
-- ============================================

SELECT
    oi.OrderItemID,
    oi.OrderID,
    p.ProductName,
    oi.Quantity,
    oi.UnitPrice
FROM dbo.OrderItems oi
INNER JOIN dbo.Products p ON oi.ProductID = p.ProductID
ORDER BY oi.OrderID, oi.OrderItemID;

-- ============================================
-- 5.3 Total do pedido com nome do cliente
-- ============================================

SELECT
    c.FullName AS Cliente,
    o.OrderID,
    SUM(oi.Quantity * oi.UnitPrice) AS TotalPedido
FROM dbo.Customers c
INNER JOIN dbo.Orders o ON c.CustomerID = o.CustomerID
INNER JOIN dbo.OrderItems oi ON o.OrderID = oi.OrderID
GROUP BY c.FullName, o.OrderID
ORDER BY c.FullName, o.OrderID;

-- ============================================
-- 5.4 Pagamentos com nome do cliente e status do pedido
-- ============================================

SELECT
    c.FullName AS Cliente,
    o.OrderID,
    o.Status AS StatusPedido,
    p.PaymentID,
    p.Amount,
    p.Method,
    p.Status AS StatusPagamento
FROM dbo.Payments p
INNER JOIN dbo.Orders o ON p.OrderID = o.OrderID
INNER JOIN dbo.Customers c ON o.CustomerID = c.CustomerID
ORDER BY c.FullName, o.OrderID;

-- ============================================
-- 5.5 LEFT JOIN: clientes e seus pedidos
-- ============================================

SELECT
    c.CustomerID,
    c.FullName,
    o.OrderID,
    o.OrderDate,
    o.Status
FROM dbo.Customers c
LEFT JOIN dbo.Orders o ON c.CustomerID = o.CustomerID
ORDER BY c.CustomerID, o.OrderID;

-- ============================================
-- 5.6 Clientes que NAO possuem pedidos (anti-join)
-- ============================================

SELECT
    c.CustomerID,
    c.FullName,
    c.Email
FROM dbo.Customers c
LEFT JOIN dbo.Orders o ON c.CustomerID = o.CustomerID
WHERE o.OrderID IS NULL;

-- Alternativa com NOT EXISTS:
-- SELECT c.* FROM dbo.Customers c
-- WHERE NOT EXISTS (SELECT 1 FROM dbo.Orders o WHERE o.CustomerID = c.CustomerID);

-- ============================================
-- 5.7 Pedidos SEM pagamento confirmado
-- ============================================

SELECT
    o.OrderID,
    o.OrderDate,
    o.Status AS StatusPedido,
    c.FullName AS Cliente
FROM dbo.Orders o
INNER JOIN dbo.Customers c ON o.CustomerID = c.CustomerID
LEFT JOIN dbo.Payments p ON o.OrderID = p.OrderID AND p.Status = 'CONFIRMED'
WHERE p.PaymentID IS NULL
ORDER BY o.OrderID;

-- ============================================
-- 5.8 Pedidos com mais de 2 itens
-- ============================================

SELECT
    oi.OrderID,
    COUNT(*) AS QtdItens,
    SUM(oi.Quantity * oi.UnitPrice) AS TotalPedido
FROM dbo.OrderItems oi
GROUP BY oi.OrderID
HAVING COUNT(*) > 2
ORDER BY QtdItens DESC;

-- ============================================
-- Notas:
-- - INNER JOIN: Apenas registos com correspondencia em ambas tabelas
-- - LEFT JOIN: Todos os registos da tabela esquerda
-- - Anti-join: LEFT JOIN + WHERE ... IS NULL
-- - Multiplos JOINs: Encadear varias tabelas
-- ============================================
