-- ============================================
-- Exercicio 2 - SELECT Basico
-- AiDAPT - Cegid Academy
-- ============================================
-- Conceitos: SELECT, FROM, ORDER BY, DISTINCT, TOP
-- Base de dados: ExerciciosDB
-- ============================================

USE ExerciciosDB;
GO

-- ============================================
-- 2.1 Liste todos os clientes
-- ============================================

SELECT *
FROM dbo.Customers;

-- ============================================
-- 2.2 Liste FullName, Email, City
-- ============================================

SELECT
    FullName,
    Email,
    City
FROM dbo.Customers;

-- ============================================
-- 2.3 Liste os produtos ordenados por Price DESC
-- ============================================

SELECT *
FROM dbo.Products
ORDER BY Price DESC;

-- ============================================
-- 2.4 Liste as categorias distintas
-- ============================================

SELECT DISTINCT Category
FROM dbo.Products;

-- ============================================
-- 2.5 Liste os 5 produtos mais caros (TOP 5)
-- ============================================

SELECT TOP 5 *
FROM dbo.Products
ORDER BY Price DESC;

-- ============================================
-- Notas:
-- - SELECT *: Seleciona todas as colunas
-- - ORDER BY DESC: Ordenacao decrescente
-- - DISTINCT: Remove duplicados
-- - TOP N: Limita o numero de resultados
-- ============================================
