-- ============================================
-- Exercicio 6 - UPDATE
-- AiDAPT - Cegid Academy
-- ============================================
-- Conceitos: UPDATE, SET, WHERE com condicoes complexas
-- Base de dados: ExerciciosDB
-- ============================================

USE ExerciciosDB;
GO

-- ============================================
-- ATENCAO: Estas queries MODIFICAM dados!
-- Recomenda-se fazer backup ou usar transaccoes
-- ============================================

-- ============================================
-- 6.1 Aumentar em 10% produtos da categoria "Accessories"
-- ============================================

-- Verificar antes:
SELECT ProductName, Category, Price
FROM dbo.Products
WHERE Category = 'Accessories';

-- UPDATE:
UPDATE dbo.Products
SET Price = Price * 1.10
WHERE Category = 'Accessories';

-- Verificar depois:
SELECT ProductName, Category, Price
FROM dbo.Products
WHERE Category = 'Accessories';

-- ============================================
-- 6.2 Marcar Active=0 para produtos com preco < 5
-- ============================================

-- Verificar antes:
SELECT ProductName, Price, Active
FROM dbo.Products
WHERE Price < 5;

-- UPDATE:
UPDATE dbo.Products
SET Active = 0
WHERE Price < 5;

-- Verificar depois:
SELECT ProductName, Price, Active
FROM dbo.Products
WHERE Price < 5;

-- ============================================
-- 6.3 Alterar status de pedidos NEW para CANCELLED
--     se tiverem mais de 7 dias
-- ============================================

-- Verificar antes:
SELECT OrderID, OrderDate, Status,
       DATEDIFF(DAY, OrderDate, GETDATE()) AS DiasDesdeoPedido
FROM dbo.Orders
WHERE Status = 'NEW';

-- UPDATE:
UPDATE dbo.Orders
SET Status = 'CANCELLED'
WHERE Status = 'NEW'
  AND OrderDate < DATEADD(DAY, -7, GETDATE());

-- Verificar depois:
SELECT OrderID, OrderDate, Status,
       DATEDIFF(DAY, OrderDate, GETDATE()) AS DiasDesdeoPedido
FROM dbo.Orders
WHERE Status IN ('NEW', 'CANCELLED');

-- ============================================
-- 6.4 Corrigir o email de um cliente
-- ============================================

-- Verificar antes:
SELECT CustomerID, FullName, Email
FROM dbo.Customers
WHERE CustomerID = 1;

-- UPDATE:
UPDATE dbo.Customers
SET Email = 'ana.silva.novo@email.com'
WHERE CustomerID = 1;

-- Verificar depois:
SELECT CustomerID, FullName, Email
FROM dbo.Customers
WHERE CustomerID = 1;

-- ============================================
-- Notas:
-- - SEMPRE usar WHERE no UPDATE (senao actualiza TUDO!)
-- - Verificar dados ANTES e DEPOIS do UPDATE
-- - Usar transaccoes para seguranca:
--   BEGIN TRANSACTION; UPDATE...; ROLLBACK/COMMIT;
-- - DATEADD/DATEDIFF para calculos com datas
-- ============================================
