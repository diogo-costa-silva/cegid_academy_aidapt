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
-- ATENCAO: Estas queries ELIMINAM dados!
-- Recomenda-se fazer backup ou usar transaccoes
-- ============================================

-- ============================================
-- 7.1 Remover pagamentos FAILED
-- ============================================

-- Verificar antes:
SELECT *
FROM dbo.Payments
WHERE Status = 'FAILED';

-- DELETE:
DELETE FROM dbo.Payments
WHERE Status = 'FAILED';

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

-- DELETE (apenas pedidos CANCELLED sem pagamentos CONFIRMED):
DELETE FROM dbo.Orders
WHERE Status = 'CANCELLED'
  AND OrderID NOT IN (
      SELECT OrderID
      FROM dbo.Payments
      WHERE Status = 'CONFIRMED'
  );

-- Nota: Pode falhar se houver OrderItems referenciando estes pedidos
-- Nesse caso, eliminar primeiro os OrderItems:
-- DELETE FROM dbo.OrderItems WHERE OrderID IN (SELECT OrderID FROM dbo.Orders WHERE Status = 'CANCELLED' AND ...)

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
DELETE FROM dbo.Products
WHERE Active = 0
  AND ProductID NOT IN (
      SELECT DISTINCT ProductID
      FROM dbo.OrderItems
  );

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
DELETE FROM dbo.Customers
WHERE CustomerID NOT IN (
    SELECT DISTINCT CustomerID
    FROM dbo.Orders
);

-- Alternativa com NOT EXISTS:
-- DELETE FROM dbo.Customers c
-- WHERE NOT EXISTS (
--     SELECT 1 FROM dbo.Orders o WHERE o.CustomerID = c.CustomerID
-- );

-- ============================================
-- Notas:
-- - SEMPRE usar WHERE no DELETE (senao elimina TUDO!)
-- - Verificar dados ANTES de eliminar
-- - Considerar FOREIGN KEYS (eliminar filhos antes de pais)
-- - NOT IN vs NOT EXISTS: NOT EXISTS e geralmente mais eficiente
-- - Usar transaccoes: BEGIN TRAN; DELETE...; ROLLBACK/COMMIT;
-- ============================================
