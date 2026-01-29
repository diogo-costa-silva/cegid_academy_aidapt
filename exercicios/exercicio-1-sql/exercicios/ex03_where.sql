-- ============================================
-- Exercicio 3 - WHERE
-- AiDAPT - Cegid Academy
-- ============================================
-- Conceitos: WHERE, operadores de comparacao, LIKE, IN, DATEADD
-- Base de dados: ExerciciosDB
-- ============================================

USE ExerciciosDB;
GO

-- ============================================
-- 3.1 Produtos com preco maior que 100
-- ============================================

SELECT *
FROM dbo.Products
WHERE Price > 100;

-- ============================================
-- 3.2 Clientes da cidade "Porto"
-- ============================================

SELECT *
FROM dbo.Customers
WHERE City = 'Porto';

-- ============================================
-- 3.3 Pedidos com status CANCELLED
-- ============================================

SELECT *
FROM dbo.Orders
WHERE Status = 'CANCELLED';

-- ============================================
-- 3.4 Pedidos dos ultimos 30 dias
-- ============================================

SELECT *
FROM dbo.Orders
WHERE OrderDate >= DATEADD(DAY, -30, GETDATE());

-- ============================================
-- 3.5 Produtos das categorias "Accessories" ou "Hardware"
-- ============================================

SELECT *
FROM dbo.Products
WHERE Category IN ('Accessories', 'Hardware');

-- Alternativa com OR:
-- WHERE Category = 'Accessories' OR Category = 'Hardware'

-- ============================================
-- 3.6 Produtos com nome contendo "Course"
-- ============================================

SELECT *
FROM dbo.Products
WHERE ProductName LIKE '%Course%';

-- ============================================
-- 3.7 Clientes com email terminando em ".com"
-- ============================================

SELECT *
FROM dbo.Customers
WHERE Email LIKE '%.com';

-- ============================================
-- Notas:
-- - DATEADD(DAY, -30, GETDATE()): Subtrai 30 dias da data actual
-- - IN: Verifica se valor esta numa lista
-- - LIKE '%texto%': Contem o texto em qualquer posicao
-- - LIKE '%.com': Termina com ".com"
-- ============================================
