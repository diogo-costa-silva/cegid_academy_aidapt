-- ============================================
-- Projeto 1: IBM HR Analytics
-- Ficheiro: analise_attrition.sql
-- Descrição: Análise de Attrition (Saídas)
-- Pergunta: "Qual o perfil de quem sai?"
-- ============================================

USE Projeto1_IBM_HR;
GO

-- ============================================
-- 1. VISÃO GERAL DO ATTRITION
-- ============================================

-- Taxa global de attrition
SELECT
    Attrition,
    COUNT(*) AS Total,
    CAST(ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Colaboradores), 2) AS DECIMAL(5,2)) AS Percentagem
FROM Colaboradores
GROUP BY Attrition;

-- ============================================
-- 2. PERFIL DE QUEM SAI VS QUEM FICA
-- ============================================

-- Comparação de médias
SELECT
    Attrition,
    COUNT(*) AS Total,
    ROUND(AVG(CAST(Age AS FLOAT)), 1) AS IdadeMedia,
    ROUND(AVG(CAST(MonthlyIncome AS FLOAT)), 0) AS SalarioMedio,
    ROUND(AVG(CAST(YearsAtCompany AS FLOAT)), 1) AS AnosEmpresaMedia,
    ROUND(AVG(CAST(TotalWorkingYears AS FLOAT)), 1) AS ExperienciaMedia,
    ROUND(AVG(CAST(DistanceFromHome AS FLOAT)), 1) AS DistanciaMedia,
    ROUND(AVG(CAST(JobSatisfaction AS FLOAT)), 2) AS SatisfacaoMedia,
    ROUND(AVG(CAST(WorkLifeBalance AS FLOAT)), 2) AS WorkLifeMedia,
    ROUND(AVG(CAST(YearsSinceLastPromotion AS FLOAT)), 1) AS AnosSemPromocao
FROM Colaboradores
GROUP BY Attrition;

-- ============================================
-- 3. ATTRITION POR DEPARTAMENTO
-- ============================================

SELECT
    Department AS Departamento,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Saidas,
    SUM(CASE WHEN Attrition = 'No' THEN 1 ELSE 0 END) AS Permaneceram,
    COUNT(*) AS Total,
    CAST(ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1.0 ELSE 0 END) * 100 / COUNT(*), 1) AS DECIMAL(5,1)) AS TaxaAttrition
FROM Colaboradores
GROUP BY Department
ORDER BY TaxaAttrition DESC;

-- ============================================
-- 4. ATTRITION POR CARGO
-- ============================================

SELECT
    JobRole AS Cargo,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Saidas,
    COUNT(*) AS Total,
    CAST(ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1.0 ELSE 0 END) * 100 / COUNT(*), 1) AS DECIMAL(5,1)) AS TaxaAttrition
FROM Colaboradores
GROUP BY JobRole
ORDER BY TaxaAttrition DESC;

-- ============================================
-- 5. ATTRITION POR CARACTERÍSTICAS DEMOGRÁFICAS
-- ============================================

-- Por género
SELECT
    Gender AS Genero,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Saidas,
    COUNT(*) AS Total,
    CAST(ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1.0 ELSE 0 END) * 100 / COUNT(*), 1) AS DECIMAL(5,1)) AS TaxaAttrition
FROM Colaboradores
GROUP BY Gender;

-- Por estado civil
SELECT
    MaritalStatus AS EstadoCivil,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Saidas,
    COUNT(*) AS Total,
    CAST(ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1.0 ELSE 0 END) * 100 / COUNT(*), 1) AS DECIMAL(5,1)) AS TaxaAttrition
FROM Colaboradores
GROUP BY MaritalStatus
ORDER BY TaxaAttrition DESC;

-- Por faixa etária
SELECT
    CASE
        WHEN Age < 25 THEN '18-24'
        WHEN Age < 30 THEN '25-29'
        WHEN Age < 35 THEN '30-34'
        WHEN Age < 40 THEN '35-39'
        WHEN Age < 50 THEN '40-49'
        ELSE '50+'
    END AS FaixaEtaria,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Saidas,
    COUNT(*) AS Total,
    CAST(ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1.0 ELSE 0 END) * 100 / COUNT(*), 1) AS DECIMAL(5,1)) AS TaxaAttrition
FROM Colaboradores
GROUP BY
    CASE
        WHEN Age < 25 THEN '18-24'
        WHEN Age < 30 THEN '25-29'
        WHEN Age < 35 THEN '30-34'
        WHEN Age < 40 THEN '35-39'
        WHEN Age < 50 THEN '40-49'
        ELSE '50+'
    END
ORDER BY TaxaAttrition DESC;

-- ============================================
-- 6. FACTORES DE RISCO PARA ATTRITION
-- ============================================

-- 6.1 Overtime
SELECT
    OverTime,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Saidas,
    COUNT(*) AS Total,
    CAST(ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1.0 ELSE 0 END) * 100 / COUNT(*), 1) AS DECIMAL(5,1)) AS TaxaAttrition
FROM Colaboradores
GROUP BY OverTime;

-- 6.2 Business Travel
SELECT
    BusinessTravel AS TipoViagem,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Saidas,
    COUNT(*) AS Total,
    CAST(ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1.0 ELSE 0 END) * 100 / COUNT(*), 1) AS DECIMAL(5,1)) AS TaxaAttrition
FROM Colaboradores
GROUP BY BusinessTravel
ORDER BY TaxaAttrition DESC;

-- 6.3 Distância de Casa
SELECT
    CASE
        WHEN DistanceFromHome <= 5 THEN '0-5 (Muito Perto)'
        WHEN DistanceFromHome <= 10 THEN '6-10 (Perto)'
        WHEN DistanceFromHome <= 20 THEN '11-20 (Médio)'
        ELSE '20+ (Longe)'
    END AS Distancia,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Saidas,
    COUNT(*) AS Total,
    CAST(ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1.0 ELSE 0 END) * 100 / COUNT(*), 1) AS DECIMAL(5,1)) AS TaxaAttrition
FROM Colaboradores
GROUP BY
    CASE
        WHEN DistanceFromHome <= 5 THEN '0-5 (Muito Perto)'
        WHEN DistanceFromHome <= 10 THEN '6-10 (Perto)'
        WHEN DistanceFromHome <= 20 THEN '11-20 (Médio)'
        ELSE '20+ (Longe)'
    END
ORDER BY TaxaAttrition DESC;

-- 6.4 Anos sem Promoção
SELECT
    CASE
        WHEN YearsSinceLastPromotion = 0 THEN '0 anos'
        WHEN YearsSinceLastPromotion <= 2 THEN '1-2 anos'
        WHEN YearsSinceLastPromotion <= 5 THEN '3-5 anos'
        ELSE '5+ anos'
    END AS AnosSemPromocao,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Saidas,
    COUNT(*) AS Total,
    CAST(ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1.0 ELSE 0 END) * 100 / COUNT(*), 1) AS DECIMAL(5,1)) AS TaxaAttrition
FROM Colaboradores
GROUP BY
    CASE
        WHEN YearsSinceLastPromotion = 0 THEN '0 anos'
        WHEN YearsSinceLastPromotion <= 2 THEN '1-2 anos'
        WHEN YearsSinceLastPromotion <= 5 THEN '3-5 anos'
        ELSE '5+ anos'
    END
ORDER BY TaxaAttrition DESC;

-- 6.5 Nível de Satisfação
SELECT
    CASE
        WHEN JobSatisfaction = 1 THEN '1-Low'
        WHEN JobSatisfaction = 2 THEN '2-Medium'
        WHEN JobSatisfaction = 3 THEN '3-High'
        WHEN JobSatisfaction = 4 THEN '4-Very High'
    END AS SatisfacaoTrabalho,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Saidas,
    COUNT(*) AS Total,
    CAST(ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1.0 ELSE 0 END) * 100 / COUNT(*), 1) AS DECIMAL(5,1)) AS TaxaAttrition
FROM Colaboradores
GROUP BY JobSatisfaction
ORDER BY JobSatisfaction;

-- 6.6 Work-Life Balance
SELECT
    CASE
        WHEN WorkLifeBalance = 1 THEN '1-Bad'
        WHEN WorkLifeBalance = 2 THEN '2-Good'
        WHEN WorkLifeBalance = 3 THEN '3-Better'
        WHEN WorkLifeBalance = 4 THEN '4-Best'
    END AS WorkLifeBalance,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Saidas,
    COUNT(*) AS Total,
    CAST(ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1.0 ELSE 0 END) * 100 / COUNT(*), 1) AS DECIMAL(5,1)) AS TaxaAttrition
FROM Colaboradores
GROUP BY WorkLifeBalance
ORDER BY WorkLifeBalance;

-- 6.7 Faixa Salarial
SELECT
    CASE
        WHEN MonthlyIncome < 3000 THEN 'Baixo (<3000)'
        WHEN MonthlyIncome < 5000 THEN 'Médio-Baixo (3000-5000)'
        WHEN MonthlyIncome < 8000 THEN 'Médio (5000-8000)'
        WHEN MonthlyIncome < 12000 THEN 'Alto (8000-12000)'
        ELSE 'Muito Alto (>12000)'
    END AS FaixaSalarial,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Saidas,
    COUNT(*) AS Total,
    CAST(ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1.0 ELSE 0 END) * 100 / COUNT(*), 1) AS DECIMAL(5,1)) AS TaxaAttrition
FROM Colaboradores
GROUP BY
    CASE
        WHEN MonthlyIncome < 3000 THEN 'Baixo (<3000)'
        WHEN MonthlyIncome < 5000 THEN 'Médio-Baixo (3000-5000)'
        WHEN MonthlyIncome < 8000 THEN 'Médio (5000-8000)'
        WHEN MonthlyIncome < 12000 THEN 'Alto (8000-12000)'
        ELSE 'Muito Alto (>12000)'
    END
ORDER BY TaxaAttrition DESC;

-- ============================================
-- 7. ANÁLISE COMBINADA DE FACTORES DE RISCO
-- ============================================

-- Perfil completo de quem saiu
SELECT
    'Perfil de quem SAIU' AS Categoria,
    ROUND(AVG(CAST(Age AS FLOAT)), 1) AS IdadeMedia,
    CAST(ROUND(SUM(CASE WHEN OverTime = 'Yes' THEN 1.0 ELSE 0 END) * 100 / COUNT(*), 1) AS VARCHAR(10)) + '%' AS PercOvertime,
    CAST(ROUND(SUM(CASE WHEN BusinessTravel = 'Travel_Frequently' THEN 1.0 ELSE 0 END) * 100 / COUNT(*), 1) AS VARCHAR(10)) + '%' AS PercTravelFreq,
    CAST(ROUND(SUM(CASE WHEN MaritalStatus = 'Single' THEN 1.0 ELSE 0 END) * 100 / COUNT(*), 1) AS VARCHAR(10)) + '%' AS PercSolteiros,
    ROUND(AVG(CAST(JobSatisfaction AS FLOAT)), 2) AS SatisfacaoMedia,
    ROUND(AVG(CAST(MonthlyIncome AS FLOAT)), 0) AS SalarioMedio,
    ROUND(AVG(CAST(YearsAtCompany AS FLOAT)), 1) AS AnosEmpresaMedia
FROM Colaboradores
WHERE Attrition = 'Yes'
UNION ALL
SELECT
    'Perfil de quem FICOU',
    ROUND(AVG(CAST(Age AS FLOAT)), 1),
    CAST(ROUND(SUM(CASE WHEN OverTime = 'Yes' THEN 1.0 ELSE 0 END) * 100 / COUNT(*), 1) AS VARCHAR(10)) + '%',
    CAST(ROUND(SUM(CASE WHEN BusinessTravel = 'Travel_Frequently' THEN 1.0 ELSE 0 END) * 100 / COUNT(*), 1) AS VARCHAR(10)) + '%',
    CAST(ROUND(SUM(CASE WHEN MaritalStatus = 'Single' THEN 1.0 ELSE 0 END) * 100 / COUNT(*), 1) AS VARCHAR(10)) + '%',
    ROUND(AVG(CAST(JobSatisfaction AS FLOAT)), 2),
    ROUND(AVG(CAST(MonthlyIncome AS FLOAT)), 0),
    ROUND(AVG(CAST(YearsAtCompany AS FLOAT)), 1)
FROM Colaboradores
WHERE Attrition = 'No';

-- Colaboradores em maior risco (múltiplos factores)
SELECT
    EmployeeNumber,
    Department,
    JobRole,
    Age,
    MonthlyIncome,
    OverTime,
    BusinessTravel,
    JobSatisfaction,
    WorkLifeBalance,
    YearsSinceLastPromotion,
    -- Contagem de factores de risco
    (CASE WHEN OverTime = 'Yes' THEN 1 ELSE 0 END +
     CASE WHEN BusinessTravel = 'Travel_Frequently' THEN 1 ELSE 0 END +
     CASE WHEN JobSatisfaction <= 2 THEN 1 ELSE 0 END +
     CASE WHEN WorkLifeBalance <= 2 THEN 1 ELSE 0 END +
     CASE WHEN YearsSinceLastPromotion >= 5 THEN 1 ELSE 0 END +
     CASE WHEN MonthlyIncome < 3000 THEN 1 ELSE 0 END) AS NumFactoresRisco
FROM Colaboradores
WHERE Attrition = 'No'  -- Colaboradores que ainda não saíram
ORDER BY NumFactoresRisco DESC, JobSatisfaction ASC;

-- ============================================
-- 8. RESUMO EXECUTIVO - ATTRITION
-- ============================================

SELECT '=== RESUMO ATTRITION ===' AS Info;

-- Taxa global
SELECT
    'Taxa de Attrition Global' AS Metrica,
    CAST(ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1.0 ELSE 0 END) * 100 / COUNT(*), 1) AS VARCHAR(10)) + '%' AS Valor
FROM Colaboradores;

-- Top 3 factores de risco
SELECT
    'TOP FACTORES DE RISCO' AS Categoria,
    'Overtime' AS Factor1,
    'Viagens Frequentes' AS Factor2,
    'Salário Baixo' AS Factor3;

-- Cargo com maior attrition
SELECT TOP 1
    'Cargo com Maior Attrition' AS Metrica,
    JobRole AS Cargo,
    CAST(ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1.0 ELSE 0 END) * 100 / COUNT(*), 1) AS VARCHAR(10)) + '%' AS TaxaAttrition
FROM Colaboradores
GROUP BY JobRole
ORDER BY SUM(CASE WHEN Attrition = 'Yes' THEN 1.0 ELSE 0 END) * 100 / COUNT(*) DESC;

-- Número de colaboradores em risco (3+ factores)
SELECT
    'Colaboradores em Risco (3+ factores)' AS Metrica,
    COUNT(*) AS Total
FROM Colaboradores
WHERE Attrition = 'No'
  AND (CASE WHEN OverTime = 'Yes' THEN 1 ELSE 0 END +
       CASE WHEN BusinessTravel = 'Travel_Frequently' THEN 1 ELSE 0 END +
       CASE WHEN JobSatisfaction <= 2 THEN 1 ELSE 0 END +
       CASE WHEN WorkLifeBalance <= 2 THEN 1 ELSE 0 END +
       CASE WHEN YearsSinceLastPromotion >= 5 THEN 1 ELSE 0 END +
       CASE WHEN MonthlyIncome < 3000 THEN 1 ELSE 0 END) >= 3;

GO
