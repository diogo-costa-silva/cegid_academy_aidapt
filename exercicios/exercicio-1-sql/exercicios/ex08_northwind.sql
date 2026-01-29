-- ============================================
-- Exercicio 8 - SQL: Northwind
-- AiDAPT - Cegid Academy
-- ============================================
-- Conceitos: CASE WHEN, UPPER, ISNULL, BETWEEN, IS NULL, LIKE
-- Base de dados: Northwind
-- ============================================

USE Northwind;
GO

-- ============================================
-- 8.1 Mostrar primeiro nome, apelido e data de nascimento
--     dos empregados que sao Sales Managers,
--     ordenados por data de nascimento
-- ============================================

SELECT
    FirstName,
    LastName,
    BirthDate
FROM dbo.Employees
WHERE Title = 'Sales Manager'
ORDER BY BirthDate;

-- ============================================
-- 8.2 Lista de empregados com nome completo em maiusculas
--     e coluna Genero baseada em TitleOfCourtesy
--     (Mrs./Ms. = feminino, Mr. = masculino, outros = Desconhecido)
-- ============================================

SELECT
    UPPER(FirstName + ' ' + LastName) AS NomeCompleto,
    CASE
        WHEN TitleOfCourtesy IN ('Mrs.', 'Ms.') THEN 'Feminino'
        WHEN TitleOfCourtesy = 'Mr.' THEN 'Masculino'
        ELSE 'Desconhecido'
    END AS Genero
FROM dbo.Employees;

-- ============================================
-- 8.3 Empresas fornecedoras e pessoa de contacto da Alemanha
-- ============================================

SELECT
    CompanyName,
    ContactName,
    ContactTitle
FROM dbo.Suppliers
WHERE Country = 'Germany';

-- ============================================
-- 8.4 Nome da empresa fornecedora e pessoa de contacto
--     que nao sejam dos EUA
-- ============================================

SELECT
    CompanyName,
    ContactName
FROM dbo.Suppliers
WHERE Country <> 'USA';

-- ============================================
-- 8.5 IDs e nomes dos clientes do Reino Unido e de Londres
-- ============================================

SELECT
    CustomerID,
    CompanyName
FROM dbo.Customers
WHERE Country = 'UK'
  AND City = 'London';

-- ============================================
-- 8.6 Clientes do Reino Unido que nao estao sediados em Londres
-- ============================================

SELECT
    CustomerID,
    CompanyName,
    City
FROM dbo.Customers
WHERE Country = 'UK'
  AND City <> 'London';

-- ============================================
-- 8.7 Pessoas de contacto dos fornecedores cujo titulo
--     comeca por "Marketing" ou termina com "Marketing"
-- ============================================

SELECT
    ContactName,
    ContactTitle,
    CompanyName
FROM dbo.Suppliers
WHERE ContactTitle LIKE 'Marketing%'
   OR ContactTitle LIKE '%Marketing';

-- ============================================
-- 8.8 Fornecedores japoneses em marketing OU
--     proprietarios do negocio (business owners)
-- ============================================

SELECT
    CompanyName,
    ContactName,
    ContactTitle,
    Country
FROM dbo.Suppliers
WHERE (Country = 'Japan' AND ContactTitle LIKE '%Marketing%')
   OR ContactTitle = 'Owner';

-- ============================================
-- 8.9 Lista de clientes com nome, pais, regiao e cidade
--     (regiao NULL -> "Regiao nao definida")
-- ============================================

SELECT
    CompanyName,
    Country,
    ISNULL(Region, 'Regiao nao definida') AS Region,
    City
FROM dbo.Customers;

-- ============================================
-- 8.10 Fornecedores sem site nem numero de fax
-- ============================================

SELECT
    CompanyName,
    ContactName,
    Phone
FROM dbo.Suppliers
WHERE HomePage IS NULL
  AND Fax IS NULL;

-- ============================================
-- 8.11 Clientes que nao sejam de Italia, Franca ou Espanha
-- ============================================

SELECT
    CustomerID,
    CompanyName,
    Country
FROM dbo.Customers
WHERE Country NOT IN ('Italy', 'France', 'Spain');

-- ============================================
-- 8.12 Nome da empresa fornecedora, pessoa de contacto e titulo
--      (Owners -> "Owner - Nao especificado")
-- ============================================

SELECT
    CompanyName,
    ContactName,
    CASE
        WHEN ContactTitle = 'Owner' THEN 'Owner - Nao especificado'
        ELSE ContactTitle
    END AS ContactTitle
FROM dbo.Suppliers;

-- ============================================
-- 8.13 Encomendas com Freight entre 5 e 10,
--      enviadas para os EUA, com data de envio conhecida
-- ============================================

SELECT
    OrderID,
    CustomerID,
    Freight,
    ShipCountry,
    ShippedDate
FROM dbo.Orders
WHERE Freight BETWEEN 5 AND 10
  AND ShipCountry = 'USA'
  AND ShippedDate IS NOT NULL;

-- ============================================
-- 8.14 Encomendas sem data de envio e sem regiao conhecida
-- ============================================

SELECT
    OrderID,
    CustomerID,
    ShippedDate,
    ShipRegion
FROM dbo.Orders
WHERE ShippedDate IS NULL
  AND ShipRegion IS NULL;

-- ============================================
-- 8.15 Encomendas para UK com Freight < 40,
--      OU CustomerID="ALFKI" com Freight < 40
-- ============================================

SELECT
    OrderID,
    CustomerID,
    ShipCountry,
    Freight
FROM dbo.Orders
WHERE (ShipCountry = 'UK' AND Freight < 40)
   OR (CustomerID = 'ALFKI' AND Freight < 40);

-- ============================================
-- Notas:
-- - CASE WHEN: Condicional no SELECT
-- - UPPER(): Converte para maiusculas
-- - ISNULL(col, valor): Substitui NULL por valor
-- - BETWEEN: Intervalo inclusivo
-- - IS NULL / IS NOT NULL: Verificar valores nulos
-- - LIKE: Padroes com % (qualquer coisa) e _ (um caracter)
-- - NOT IN: Exclusao de lista
-- ============================================
