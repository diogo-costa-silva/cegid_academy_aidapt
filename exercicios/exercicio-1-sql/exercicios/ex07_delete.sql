-- ============================================
-- Exercicio 7 - DELETE
-- AiDAPT - Cegid Academy
-- ============================================
-- Conceitos: DELETE, subconsultas, NOT IN, NOT EXISTS
-- Base de dados: ExerciciosDB
-- ============================================

USE ExerciciosDB;
GO

-- ============================================
-- NOTA: Todos os DELETEs estao envolvidos em
-- BEGIN TRANSACTION / ROLLBACK para nao alterar
-- os dados da base de dados.
-- Para eliminar de facto, substituir ROLLBACK por COMMIT.
-- ============================================

-- ============================================
-- 7.1 Remover pagamentos FAILED
-- ============================================

-- Verificar antes:
SELECT *
FROM dbo.Payments
WHERE Status = 'FAILED';

-- DELETE:
BEGIN TRANSACTION;
DELETE FROM dbo.Payments
WHERE Status = 'FAILED';
ROLLBACK;

-- Verificar depois:
SELECT COUNT(*) AS PagamentosFailed
FROM dbo.Payments
WHERE Status = 'FAILED';

-- ============================================
-- 7.2 Remover pedidos CANCELLED
--     (se nao houver pagamentos confirmados)
-- ============================================

-- Verificar antes:
SELECT o.OrderID, o.Status, p.PaymentID, p.Status AS PaymentStatus
FROM dbo.Orders o
LEFT JOIN dbo.Payments p ON o.OrderID = p.OrderID
WHERE o.Status = 'CANCELLED';

-- DELETE (dentro de transaccao):
-- A FK FK_OrderItems_Orders (ON DELETE NO_ACTION) obriga a
-- eliminar filhos (OrderItems) antes de pais (Orders).
--
-- Alternativa sem transaccao (opcao 1):
-- Eliminar OrderItems e Orders definitivamente, sem ROLLBACK.
-- A ordem seria a mesma (filhos antes de pais), mas com COMMIT.
BEGIN TRANSACTION;

-- 1. Eliminar OrderItems dos pedidos CANCELLED (filhos antes de pais)
DELETE FROM dbo.OrderItems
WHERE OrderID IN (
    SELECT OrderID FROM dbo.Orders
    WHERE Status = 'CANCELLED'
      AND OrderID NOT IN (
          SELECT OrderID FROM dbo.Payments WHERE Status = 'CONFIRMED'
      )
);

-- 2. Eliminar os pedidos CANCELLED
DELETE FROM dbo.Orders
WHERE Status = 'CANCELLED'
  AND OrderID NOT IN (
      SELECT OrderID
      FROM dbo.Payments
      WHERE Status = 'CONFIRMED'
  );

ROLLBACK;

-- ============================================
-- 7.3 Remover produtos inativos que nunca foram vendidos
-- ============================================

-- Verificar antes:
SELECT p.ProductID, p.ProductName, p.Active
FROM dbo.Products p
WHERE p.Active = 0
  AND p.ProductID NOT IN (
      SELECT DISTINCT ProductID
      FROM dbo.OrderItems
  );

-- DELETE:
BEGIN TRANSACTION;
DELETE FROM dbo.Products
WHERE Active = 0
  AND ProductID NOT IN (
      SELECT DISTINCT ProductID
      FROM dbo.OrderItems
  );
ROLLBACK;

-- Alternativa com NOT EXISTS:
-- DELETE FROM dbo.Products p
-- WHERE p.Active = 0
--   AND NOT EXISTS (
--       SELECT 1 FROM dbo.OrderItems oi WHERE oi.ProductID = p.ProductID
--   );

-- ============================================
-- 7.4 Remover clientes sem pedido
-- ============================================

-- Verificar antes:
SELECT c.CustomerID, c.FullName
FROM dbo.Customers c
WHERE c.CustomerID NOT IN (
    SELECT DISTINCT CustomerID
    FROM dbo.Orders
);

-- DELETE:
BEGIN TRANSACTION;
DELETE FROM dbo.Customers
WHERE CustomerID NOT IN (
    SELECT DISTINCT CustomerID
    FROM dbo.Orders
);
ROLLBACK;

-- Alternativa com NOT EXISTS:
-- DELETE FROM dbo.Customers c
-- WHERE NOT EXISTS (
--     SELECT 1 FROM dbo.Orders o WHERE o.CustomerID = c.CustomerID
-- );

-- ============================================
-- Notas:
-- - SEMPRE usar WHERE no DELETE (senao elimina TUDO!)
-- - Verificar dados ANTES de eliminar
-- - Considerar FOREIGN KEYS: eliminar filhos antes de pais
-- - NOT IN vs NOT EXISTS: NOT EXISTS e geralmente mais eficiente
-- - Transaccoes: BEGIN TRAN; DELETE...; ROLLBACK/COMMIT;
--
-- Neste notebook, todos os DELETEs usam ROLLBACK.
-- No notebook (.ipynb), como o JupySQL nao suporta transaccoes,
-- os DELETEs usam SQLAlchemy directamente (engine.connect() + rollback).
-- ============================================
