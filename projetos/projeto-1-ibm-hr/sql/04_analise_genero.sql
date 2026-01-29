-- ============================================
-- Projeto 1: IBM HR Analytics
-- Ficheiro: analise_genero.sql
-- Descrição: Análise de Igualdade de Género
-- Meta: 50% mulheres em todos os cargos
-- ============================================

USE Projeto1_IBM_HR;
GO

-- ============================================
-- 1. VISÃO GERAL DE GÉNERO
-- ============================================

-- Distribuição global
SELECT
    Gender AS Genero,
    COUNT(*) AS Total,
    CAST(ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Colaboradores), 2) AS DECIMAL(5,2)) AS Percentagem,
    CASE
        WHEN Gender = 'Female' THEN
            CAST(CAST(50 - ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Colaboradores), 2) AS DECIMAL(5,2)) AS VARCHAR(10)) + '% para meta'
        ELSE ''
    END AS GapParaMeta50
FROM Colaboradores
GROUP BY Gender;

-- ============================================
-- 2. GÉNERO POR DEPARTAMENTO
-- ============================================

-- Contagem e percentagem por departamento
SELECT
    Department AS Departamento,
    Gender AS Genero,
    COUNT(*) AS Total,
    CAST(ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY Department), 2) AS DECIMAL(5,2)) AS PercNoDepartamento
FROM Colaboradores
GROUP BY Department, Gender
ORDER BY Department, Gender;

-- Resumo por departamento (formato pivot)
SELECT
    Department AS Departamento,
    SUM(CASE WHEN Gender = 'Female' THEN 1 ELSE 0 END) AS Mulheres,
    SUM(CASE WHEN Gender = 'Male' THEN 1 ELSE 0 END) AS Homens,
    COUNT(*) AS Total,
    CAST(ROUND(SUM(CASE WHEN Gender = 'Female' THEN 1.0 ELSE 0 END) * 100 / COUNT(*), 1) AS DECIMAL(5,1)) AS PercMulheres,
    CAST(50 - ROUND(SUM(CASE WHEN Gender = 'Female' THEN 1.0 ELSE 0 END) * 100 / COUNT(*), 1) AS DECIMAL(5,1)) AS GapParaMeta50
FROM Colaboradores
GROUP BY Department
ORDER BY PercMulheres;

-- ============================================
-- 3. GÉNERO POR CARGO (JobRole)
-- ============================================

-- Detalhado por cargo
SELECT
    JobRole AS Cargo,
    SUM(CASE WHEN Gender = 'Female' THEN 1 ELSE 0 END) AS Mulheres,
    SUM(CASE WHEN Gender = 'Male' THEN 1 ELSE 0 END) AS Homens,
    COUNT(*) AS Total,
    CAST(ROUND(SUM(CASE WHEN Gender = 'Female' THEN 1.0 ELSE 0 END) * 100 / COUNT(*), 1) AS DECIMAL(5,1)) AS PercMulheres,
    CASE
        WHEN SUM(CASE WHEN Gender = 'Female' THEN 1.0 ELSE 0 END) * 100 / COUNT(*) < 50 THEN 'Défice Mulheres'
        WHEN SUM(CASE WHEN Gender = 'Female' THEN 1.0 ELSE 0 END) * 100 / COUNT(*) > 50 THEN 'Excesso Mulheres'
        ELSE 'Equilibrado'
    END AS Situacao
FROM Colaboradores
GROUP BY JobRole
ORDER BY PercMulheres;

-- ============================================
-- 4. GÉNERO POR NÍVEL HIERÁRQUICO
-- ============================================

-- Análise por nível (importante para ver se mulheres chegam a cargos de chefia)
SELECT
    JobLevel AS NivelHierarquico,
    CASE JobLevel
        WHEN 1 THEN 'Entry Level'
        WHEN 2 THEN 'Junior'
        WHEN 3 THEN 'Mid-Level'
        WHEN 4 THEN 'Senior'
        WHEN 5 THEN 'Executive'
    END AS DescricaoNivel,
    SUM(CASE WHEN Gender = 'Female' THEN 1 ELSE 0 END) AS Mulheres,
    SUM(CASE WHEN Gender = 'Male' THEN 1 ELSE 0 END) AS Homens,
    COUNT(*) AS Total,
    CAST(ROUND(SUM(CASE WHEN Gender = 'Female' THEN 1.0 ELSE 0 END) * 100 / COUNT(*), 1) AS DECIMAL(5,1)) AS PercMulheres
FROM Colaboradores
GROUP BY JobLevel
ORDER BY JobLevel;

-- ============================================
-- 5. ANÁLISE SALARIAL POR GÉNERO
-- ============================================

-- Salário médio global por género
SELECT
    Gender AS Genero,
    COUNT(*) AS NumColaboradores,
    AVG(MonthlyIncome) AS SalarioMedio,
    MIN(MonthlyIncome) AS SalarioMin,
    MAX(MonthlyIncome) AS SalarioMax
FROM Colaboradores
GROUP BY Gender;

-- Gap salarial geral
SELECT
    'Gap Salarial (Homens - Mulheres)' AS Metrica,
    (SELECT AVG(MonthlyIncome) FROM Colaboradores WHERE Gender = 'Male') -
    (SELECT AVG(MonthlyIncome) FROM Colaboradores WHERE Gender = 'Female') AS GapAbsoluto,
    CAST(ROUND(
        ((SELECT AVG(CAST(MonthlyIncome AS FLOAT)) FROM Colaboradores WHERE Gender = 'Male') -
         (SELECT AVG(CAST(MonthlyIncome AS FLOAT)) FROM Colaboradores WHERE Gender = 'Female')) /
        (SELECT AVG(CAST(MonthlyIncome AS FLOAT)) FROM Colaboradores WHERE Gender = 'Female') * 100
    , 2) AS DECIMAL(5,2)) AS GapPercentual;

-- Salário médio por cargo e género
SELECT
    JobRole AS Cargo,
    AVG(CASE WHEN Gender = 'Female' THEN MonthlyIncome END) AS SalarioMedioMulheres,
    AVG(CASE WHEN Gender = 'Male' THEN MonthlyIncome END) AS SalarioMedioHomens,
    AVG(CASE WHEN Gender = 'Male' THEN MonthlyIncome END) -
    AVG(CASE WHEN Gender = 'Female' THEN MonthlyIncome END) AS GapSalarial
FROM Colaboradores
GROUP BY JobRole
ORDER BY GapSalarial DESC;

-- Salário médio por nível e género
SELECT
    JobLevel AS Nivel,
    AVG(CASE WHEN Gender = 'Female' THEN MonthlyIncome END) AS SalarioMedioMulheres,
    AVG(CASE WHEN Gender = 'Male' THEN MonthlyIncome END) AS SalarioMedioHomens,
    AVG(CASE WHEN Gender = 'Male' THEN MonthlyIncome END) -
    AVG(CASE WHEN Gender = 'Female' THEN MonthlyIncome END) AS GapSalarial
FROM Colaboradores
GROUP BY JobLevel
ORDER BY JobLevel;

-- ============================================
-- 6. PROMOÇÕES POR GÉNERO
-- ============================================

-- Anos desde última promoção por género
SELECT
    Gender AS Genero,
    AVG(YearsSinceLastPromotion) AS MediaAnosSemPromocao,
    MAX(YearsSinceLastPromotion) AS MaxAnosSemPromocao
FROM Colaboradores
GROUP BY Gender;

-- Distribuição de tempo sem promoção
SELECT
    Gender AS Genero,
    CASE
        WHEN YearsSinceLastPromotion = 0 THEN 'Promovido este ano'
        WHEN YearsSinceLastPromotion <= 2 THEN '1-2 anos'
        WHEN YearsSinceLastPromotion <= 5 THEN '3-5 anos'
        ELSE '5+ anos sem promoção'
    END AS TempoSemPromocao,
    COUNT(*) AS Total
FROM Colaboradores
GROUP BY Gender,
    CASE
        WHEN YearsSinceLastPromotion = 0 THEN 'Promovido este ano'
        WHEN YearsSinceLastPromotion <= 2 THEN '1-2 anos'
        WHEN YearsSinceLastPromotion <= 5 THEN '3-5 anos'
        ELSE '5+ anos sem promoção'
    END
ORDER BY Gender, MIN(YearsSinceLastPromotion);

-- ============================================
-- 7. ATTRITION POR GÉNERO
-- ============================================

-- Taxa de saída por género
SELECT
    Gender AS Genero,
    Attrition,
    COUNT(*) AS Total,
    CAST(ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY Gender), 2) AS DECIMAL(5,2)) AS PercNoGenero
FROM Colaboradores
GROUP BY Gender, Attrition
ORDER BY Gender, Attrition;

-- ============================================
-- 8. OVERTIME E BUSINESS TRAVEL POR GÉNERO
-- ============================================

-- Overtime por género
SELECT
    Gender AS Genero,
    OverTime,
    COUNT(*) AS Total,
    CAST(ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY Gender), 2) AS DECIMAL(5,2)) AS Percentagem
FROM Colaboradores
GROUP BY Gender, OverTime
ORDER BY Gender, OverTime;

-- Business Travel por género
SELECT
    Gender AS Genero,
    BusinessTravel AS TipoViagem,
    COUNT(*) AS Total,
    CAST(ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY Gender), 2) AS DECIMAL(5,2)) AS Percentagem
FROM Colaboradores
GROUP BY Gender, BusinessTravel
ORDER BY Gender, BusinessTravel;

-- ============================================
-- 9. RESUMO EXECUTIVO - IGUALDADE DE GÉNERO
-- ============================================

SELECT '=== RESUMO IGUALDADE DE GÉNERO ===' AS Info;

SELECT
    'Percentagem de Mulheres na Empresa' AS Metrica,
    CAST(ROUND(SUM(CASE WHEN Gender = 'Female' THEN 1.0 ELSE 0.0 END) * 100 / COUNT(*), 1) AS VARCHAR(10)) + '%' AS Valor,
    CAST(50 - ROUND(SUM(CASE WHEN Gender = 'Female' THEN 1.0 ELSE 0.0 END) * 100 / COUNT(*), 1) AS VARCHAR(10)) + '% para meta' AS GapParaMeta
FROM Colaboradores;

-- Departamento com MENOS mulheres
SELECT TOP 1
    'Departamento com Menos Mulheres' AS Metrica,
    Department AS Departamento,
    CAST(ROUND(SUM(CASE WHEN Gender = 'Female' THEN 1.0 ELSE 0 END) * 100 / COUNT(*), 1) AS VARCHAR(10)) + '%' AS PercMulheres
FROM Colaboradores
GROUP BY Department
ORDER BY SUM(CASE WHEN Gender = 'Female' THEN 1.0 ELSE 0 END) * 100 / COUNT(*);

-- Cargo com MENOS mulheres
SELECT TOP 1
    'Cargo com Menos Mulheres' AS Metrica,
    JobRole AS Cargo,
    CAST(ROUND(SUM(CASE WHEN Gender = 'Female' THEN 1.0 ELSE 0 END) * 100 / COUNT(*), 1) AS VARCHAR(10)) + '%' AS PercMulheres
FROM Colaboradores
GROUP BY JobRole
ORDER BY SUM(CASE WHEN Gender = 'Female' THEN 1.0 ELSE 0 END) * 100 / COUNT(*);

GO
