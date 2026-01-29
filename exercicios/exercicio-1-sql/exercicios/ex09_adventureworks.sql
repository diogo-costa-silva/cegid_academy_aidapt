-- ============================================
-- Exercicio 9 - SQL: AdventureWorks
-- AiDAPT - Cegid Academy
-- ============================================
-- Conceitos: Subconsultas, ROW_NUMBER, CTE, agregacoes avancadas
-- Base de dados: AdventureWorks2022
-- ============================================

USE AdventureWorks2022;
GO

-- ============================================
-- 9.1 Qual e o produto mais vendido em termos de valor total?
-- ============================================

SELECT TOP 1
    p.ProductID,
    p.Name AS ProductName,
    SUM(sod.LineTotal) AS TotalVendas
FROM Production.Product p
INNER JOIN Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID
GROUP BY p.ProductID, p.Name
ORDER BY TotalVendas DESC;

-- ============================================
-- 9.2 Quantos produtos tiveram mais de 100 unidades vendidas?
-- ============================================

SELECT COUNT(*) AS QtdProdutos
FROM (
    SELECT ProductID
    FROM Sales.SalesOrderDetail
    GROUP BY ProductID
    HAVING SUM(OrderQty) > 100
) AS ProdutosVendidos;

-- Alternativa mostrando os produtos:
SELECT
    p.ProductID,
    p.Name,
    SUM(sod.OrderQty) AS TotalUnidades
FROM Production.Product p
INNER JOIN Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID
GROUP BY p.ProductID, p.Name
HAVING SUM(sod.OrderQty) > 100
ORDER BY TotalUnidades DESC;

-- ============================================
-- 9.3 Que produtos venderam mais de 100 unidades
--     no 1.o trimestre de 2013?
-- ============================================

SELECT
    p.ProductID,
    p.Name,
    SUM(sod.OrderQty) AS TotalUnidades
FROM Production.Product p
INNER JOIN Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID
INNER JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
WHERE soh.OrderDate >= '2013-01-01'
  AND soh.OrderDate < '2013-04-01'
GROUP BY p.ProductID, p.Name
HAVING SUM(sod.OrderQty) > 100
ORDER BY TotalUnidades DESC;

-- ============================================
-- 9.4 Quais sao as subcategorias de produtos com
--     pelo menos 5 produtos e qual a media do preco?
-- ============================================

SELECT
    psc.ProductSubcategoryID,
    psc.Name AS Subcategoria,
    COUNT(*) AS QtdProdutos,
    AVG(p.ListPrice) AS PrecoMedio
FROM Production.Product p
INNER JOIN Production.ProductSubcategory psc
    ON p.ProductSubcategoryID = psc.ProductSubcategoryID
GROUP BY psc.ProductSubcategoryID, psc.Name
HAVING COUNT(*) >= 5
ORDER BY QtdProdutos DESC;

-- ============================================
-- 9.5 Quantas pessoas existem por titulo e
--     qual o titulo menos e mais frequente?
-- ============================================

-- Contagem por titulo:
SELECT
    Title,
    COUNT(*) AS QtdPessoas
FROM Person.Person
WHERE Title IS NOT NULL
GROUP BY Title
ORDER BY QtdPessoas DESC;

-- Titulo mais e menos frequente:
WITH TituloContagem AS (
    SELECT
        Title,
        COUNT(*) AS QtdPessoas,
        ROW_NUMBER() OVER (ORDER BY COUNT(*) DESC) AS RankDesc,
        ROW_NUMBER() OVER (ORDER BY COUNT(*) ASC) AS RankAsc
    FROM Person.Person
    WHERE Title IS NOT NULL
    GROUP BY Title
)
SELECT
    Title,
    QtdPessoas,
    CASE
        WHEN RankDesc = 1 THEN 'Mais frequente'
        WHEN RankAsc = 1 THEN 'Menos frequente'
    END AS Classificacao
FROM TituloContagem
WHERE RankDesc = 1 OR RankAsc = 1;

-- ============================================
-- 9.6 Quantos funcionarios existem por nivel organizacional
--     e qual a media de horas de ferias?
-- ============================================

SELECT
    OrganizationLevel,
    COUNT(*) AS QtdFuncionarios,
    AVG(CAST(VacationHours AS DECIMAL(10,2))) AS MediaHorasFerias
FROM HumanResources.Employee
GROUP BY OrganizationLevel
ORDER BY OrganizationLevel;

-- ============================================
-- 9.7 Para cada cliente: numero de encomendas
--     e valor total faturado em 2013
-- ============================================

SELECT
    soh.CustomerID,
    COUNT(*) AS NumEncomendas,
    SUM(soh.TotalDue) AS TotalFaturado
FROM Sales.SalesOrderHeader soh
WHERE YEAR(soh.OrderDate) = 2013
GROUP BY soh.CustomerID
ORDER BY TotalFaturado DESC;

-- ============================================
-- 9.8 Quais sao as 10 cidades com maior valor de vendas
--     (considerando morada de envio)?
-- ============================================

SELECT TOP 10
    a.City,
    SUM(soh.TotalDue) AS TotalVendas
FROM Sales.SalesOrderHeader soh
INNER JOIN Person.Address a ON soh.ShipToAddressID = a.AddressID
GROUP BY a.City
ORDER BY TotalVendas DESC;

-- ============================================
-- 9.9 Para cada subcategoria: produto com maior receita
--     no ano de 2012
-- ============================================

WITH ProdutoReceita AS (
    SELECT
        p.ProductSubcategoryID,
        p.ProductID,
        p.Name AS ProductName,
        SUM(sod.LineTotal) AS Receita,
        ROW_NUMBER() OVER (
            PARTITION BY p.ProductSubcategoryID
            ORDER BY SUM(sod.LineTotal) DESC
        ) AS Rank
    FROM Production.Product p
    INNER JOIN Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID
    INNER JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
    WHERE YEAR(soh.OrderDate) = 2012
      AND p.ProductSubcategoryID IS NOT NULL
    GROUP BY p.ProductSubcategoryID, p.ProductID, p.Name
)
SELECT
    psc.Name AS Subcategoria,
    pr.ProductName,
    pr.Receita
FROM ProdutoReceita pr
INNER JOIN Production.ProductSubcategory psc
    ON pr.ProductSubcategoryID = psc.ProductSubcategoryID
WHERE pr.Rank = 1
ORDER BY pr.Receita DESC;

-- ============================================
-- 9.10 Para cada vendedor: receita total e margem bruta aproximada
-- ============================================

SELECT
    sp.BusinessEntityID AS VendedorID,
    ISNULL(per.FirstName + ' ' + per.LastName, 'Vendedor ' + CAST(sp.BusinessEntityID AS VARCHAR)) AS NomeVendedor,
    SUM(soh.TotalDue) AS ReceitaTotal,
    SUM(soh.TotalDue - soh.SubTotal) AS MargemBruta,
    CASE
        WHEN SUM(soh.TotalDue) > 0
        THEN (SUM(soh.TotalDue - soh.SubTotal) / SUM(soh.TotalDue)) * 100
        ELSE 0
    END AS MargemPercentual
FROM Sales.SalesPerson sp
LEFT JOIN Sales.SalesOrderHeader soh ON sp.BusinessEntityID = soh.SalesPersonID
LEFT JOIN Person.Person per ON sp.BusinessEntityID = per.BusinessEntityID
GROUP BY sp.BusinessEntityID, per.FirstName, per.LastName
ORDER BY ReceitaTotal DESC;

-- ============================================
-- 9.11 Produtos que NUNCA foram vendidos
--      (sem linhas em SalesOrderDetail)
-- ============================================

SELECT
    p.ProductID,
    p.Name,
    p.ListPrice
FROM Production.Product p
LEFT JOIN Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID
WHERE sod.ProductID IS NULL
ORDER BY p.Name;

-- Alternativa com NOT EXISTS:
-- SELECT p.ProductID, p.Name, p.ListPrice
-- FROM Production.Product p
-- WHERE NOT EXISTS (
--     SELECT 1 FROM Sales.SalesOrderDetail sod
--     WHERE sod.ProductID = p.ProductID
-- );

-- ============================================
-- 9.12 Produtos cujo ListPrice e superior a media
--      do ListPrice da sua subcategoria
-- ============================================

SELECT
    p.ProductID,
    p.Name,
    p.ListPrice,
    psc.Name AS Subcategoria,
    subcat_avg.MediaPreco
FROM Production.Product p
INNER JOIN Production.ProductSubcategory psc
    ON p.ProductSubcategoryID = psc.ProductSubcategoryID
INNER JOIN (
    SELECT
        ProductSubcategoryID,
        AVG(ListPrice) AS MediaPreco
    FROM Production.Product
    WHERE ProductSubcategoryID IS NOT NULL
    GROUP BY ProductSubcategoryID
) subcat_avg ON p.ProductSubcategoryID = subcat_avg.ProductSubcategoryID
WHERE p.ListPrice > subcat_avg.MediaPreco
ORDER BY psc.Name, p.ListPrice DESC;

-- Alternativa com subconsulta correlacionada:
-- SELECT p.ProductID, p.Name, p.ListPrice
-- FROM Production.Product p
-- WHERE p.ProductSubcategoryID IS NOT NULL
--   AND p.ListPrice > (
--       SELECT AVG(p2.ListPrice)
--       FROM Production.Product p2
--       WHERE p2.ProductSubcategoryID = p.ProductSubcategoryID
--   );

-- ============================================
-- Notas:
-- - CTE (Common Table Expression): WITH ... AS
-- - ROW_NUMBER() OVER (PARTITION BY ... ORDER BY ...): Numerar linhas por grupo
-- - Subconsulta correlacionada: Subconsulta que referencia a query externa
-- - LEFT JOIN + IS NULL: Anti-join (encontrar registos sem correspondencia)
-- - YEAR(): Extrair ano de uma data
-- ============================================
