-- ============================================
-- Projeto 1: IBM HR Analytics
-- Ficheiro: import_data.sql
-- Descricao: Importacao do ficheiro CSV
-- ============================================

USE Projeto1_IBM_HR;
GO

-- ============================================
-- PREPARACAO
-- ============================================
-- Copiar o CSV para o container Docker:
-- docker cp "Projeto_1/enunciado/WA_Fn-UseC_-HR-Employee-Attrition.csv" sqlserver:/var/opt/mssql/data/

-- ============================================
-- IMPORTACAO VIA BULK INSERT
-- ============================================
BULK INSERT Colaboradores
FROM '/var/opt/mssql/data/WA_Fn-UseC_-HR-Employee-Attrition.csv'
WITH (
    FIRSTROW = 2,           -- Ignorar cabecalho
    FIELDTERMINATOR = ',',  -- Separador de campos
    ROWTERMINATOR = '\n',   -- Separador de linhas
    TABLOCK
);
GO

-- ============================================
-- VERIFICACAO APOS IMPORTACAO
-- ============================================

-- Contar registos (deve ser 1470)
SELECT COUNT(*) AS TotalRegistos FROM Colaboradores;

-- Verificar primeiros 10 registos
SELECT TOP 10
    EmployeeNumber, Age, Gender, Department, JobRole, MonthlyIncome, Attrition
FROM Colaboradores
ORDER BY EmployeeNumber;

-- Verificar estatisticas basicas
SELECT
    'Age' AS Coluna,
    MIN(Age) AS Min,
    MAX(Age) AS Max,
    AVG(CAST(Age AS FLOAT)) AS Media
FROM Colaboradores
UNION ALL
SELECT
    'MonthlyIncome',
    MIN(MonthlyIncome),
    MAX(MonthlyIncome),
    AVG(CAST(MonthlyIncome AS FLOAT))
FROM Colaboradores
UNION ALL
SELECT
    'YearsAtCompany',
    MIN(YearsAtCompany),
    MAX(YearsAtCompany),
    AVG(CAST(YearsAtCompany AS FLOAT))
FROM Colaboradores;

-- Verificar valores unicos das colunas categoricas
SELECT 'Gender' AS Coluna, Gender AS Valor, COUNT(*) AS Total FROM Colaboradores GROUP BY Gender
UNION ALL
SELECT 'Department', Department, COUNT(*) FROM Colaboradores GROUP BY Department
UNION ALL
SELECT 'Attrition', Attrition, COUNT(*) FROM Colaboradores GROUP BY Attrition;

-- Verificar se ha valores nulos nas colunas principais
SELECT
    SUM(CASE WHEN Age IS NULL THEN 1 ELSE 0 END) AS Age_Nulls,
    SUM(CASE WHEN Gender IS NULL THEN 1 ELSE 0 END) AS Gender_Nulls,
    SUM(CASE WHEN Department IS NULL THEN 1 ELSE 0 END) AS Department_Nulls,
    SUM(CASE WHEN MonthlyIncome IS NULL THEN 1 ELSE 0 END) AS MonthlyIncome_Nulls
FROM Colaboradores;

PRINT 'Importacao verificada com sucesso!';
GO
