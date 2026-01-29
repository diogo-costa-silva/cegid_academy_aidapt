-- ============================================
-- Projeto 1: IBM HR Analytics
-- Ficheiro: analise_felicidade.sql
-- Descrição: Análise de Felicidade e Satisfação
-- Pergunta chave: "Somos felizes ou não?"
-- ============================================

USE Projeto1_IBM_HR;
GO

-- ============================================
-- LEGENDA DAS ESCALAS DE SATISFAÇÃO
-- ============================================
/*
EnvironmentSatisfaction, JobSatisfaction, RelationshipSatisfaction, JobInvolvement:
    1 = Low (Baixo)
    2 = Medium (Médio)
    3 = High (Alto)
    4 = Very High (Muito Alto)

WorkLifeBalance:
    1 = Bad (Mau)
    2 = Good (Bom)
    3 = Better (Melhor)
    4 = Best (Excelente)
*/

-- ============================================
-- 1. VISÃO GERAL DA SATISFAÇÃO
-- ============================================

-- Médias globais de satisfação
SELECT
    ROUND(AVG(CAST(EnvironmentSatisfaction AS FLOAT)), 2) AS MediaSatisfacaoAmbiente,
    ROUND(AVG(CAST(JobSatisfaction AS FLOAT)), 2) AS MediaSatisfacaoTrabalho,
    ROUND(AVG(CAST(RelationshipSatisfaction AS FLOAT)), 2) AS MediaSatisfacaoRelacoes,
    ROUND(AVG(CAST(WorkLifeBalance AS FLOAT)), 2) AS MediaWorkLifeBalance,
    ROUND(AVG(CAST(JobInvolvement AS FLOAT)), 2) AS MediaEnvolvimento
FROM Colaboradores;

-- Índice de Felicidade composto (média das 4 dimensões principais)
SELECT
    ROUND(AVG(
        (CAST(EnvironmentSatisfaction AS FLOAT) +
         CAST(JobSatisfaction AS FLOAT) +
         CAST(RelationshipSatisfaction AS FLOAT) +
         CAST(WorkLifeBalance AS FLOAT)) / 4.0
    ), 2) AS IndiceFelicidadeGlobal,
    CASE
        WHEN AVG((EnvironmentSatisfaction + JobSatisfaction + RelationshipSatisfaction + WorkLifeBalance) / 4.0) >= 3 THEN 'FELIZES'
        WHEN AVG((EnvironmentSatisfaction + JobSatisfaction + RelationshipSatisfaction + WorkLifeBalance) / 4.0) >= 2.5 THEN 'SATISFEITOS'
        ELSE 'INSATISFEITOS'
    END AS Classificacao
FROM Colaboradores;

-- ============================================
-- 2. DISTRIBUIÇÃO POR NÍVEL DE SATISFAÇÃO
-- ============================================

-- Satisfação com o Ambiente
SELECT
    EnvironmentSatisfaction AS Nivel,
    CASE EnvironmentSatisfaction
        WHEN 1 THEN 'Low'
        WHEN 2 THEN 'Medium'
        WHEN 3 THEN 'High'
        WHEN 4 THEN 'Very High'
    END AS Descricao,
    COUNT(*) AS Total,
    CAST(ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Colaboradores), 1) AS DECIMAL(5,1)) AS Percentagem
FROM Colaboradores
GROUP BY EnvironmentSatisfaction
ORDER BY EnvironmentSatisfaction;

-- Satisfação com o Trabalho
SELECT
    JobSatisfaction AS Nivel,
    CASE JobSatisfaction
        WHEN 1 THEN 'Low'
        WHEN 2 THEN 'Medium'
        WHEN 3 THEN 'High'
        WHEN 4 THEN 'Very High'
    END AS Descricao,
    COUNT(*) AS Total,
    CAST(ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Colaboradores), 1) AS DECIMAL(5,1)) AS Percentagem
FROM Colaboradores
GROUP BY JobSatisfaction
ORDER BY JobSatisfaction;

-- Work-Life Balance
SELECT
    WorkLifeBalance AS Nivel,
    CASE WorkLifeBalance
        WHEN 1 THEN 'Bad'
        WHEN 2 THEN 'Good'
        WHEN 3 THEN 'Better'
        WHEN 4 THEN 'Best'
    END AS Descricao,
    COUNT(*) AS Total,
    CAST(ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Colaboradores), 1) AS DECIMAL(5,1)) AS Percentagem
FROM Colaboradores
GROUP BY WorkLifeBalance
ORDER BY WorkLifeBalance;

-- ============================================
-- 3. SATISFAÇÃO POR DEPARTAMENTO
-- ============================================

SELECT
    Department AS Departamento,
    COUNT(*) AS NumColaboradores,
    ROUND(AVG(CAST(EnvironmentSatisfaction AS FLOAT)), 2) AS Ambiente,
    ROUND(AVG(CAST(JobSatisfaction AS FLOAT)), 2) AS Trabalho,
    ROUND(AVG(CAST(RelationshipSatisfaction AS FLOAT)), 2) AS Relacoes,
    ROUND(AVG(CAST(WorkLifeBalance AS FLOAT)), 2) AS WorkLife,
    ROUND(AVG((CAST(EnvironmentSatisfaction AS FLOAT) + JobSatisfaction + RelationshipSatisfaction + WorkLifeBalance) / 4.0), 2) AS IndiceFelicidade
FROM Colaboradores
GROUP BY Department
ORDER BY IndiceFelicidade DESC;

-- ============================================
-- 4. SATISFAÇÃO POR CARGO
-- ============================================

SELECT
    JobRole AS Cargo,
    COUNT(*) AS NumColaboradores,
    ROUND(AVG(CAST(JobSatisfaction AS FLOAT)), 2) AS SatisfacaoTrabalho,
    ROUND(AVG(CAST(WorkLifeBalance AS FLOAT)), 2) AS WorkLife,
    ROUND(AVG((CAST(EnvironmentSatisfaction AS FLOAT) + JobSatisfaction + RelationshipSatisfaction + WorkLifeBalance) / 4.0), 2) AS IndiceFelicidade
FROM Colaboradores
GROUP BY JobRole
ORDER BY IndiceFelicidade DESC;

-- ============================================
-- 5. FACTORES QUE AFECTAM A FELICIDADE
-- ============================================

-- 5.1 Overtime vs Satisfação
SELECT
    OverTime,
    COUNT(*) AS NumColaboradores,
    ROUND(AVG(CAST(JobSatisfaction AS FLOAT)), 2) AS SatisfacaoMedia,
    ROUND(AVG(CAST(WorkLifeBalance AS FLOAT)), 2) AS WorkLifeMedia,
    ROUND(AVG((CAST(EnvironmentSatisfaction AS FLOAT) + JobSatisfaction + RelationshipSatisfaction + WorkLifeBalance) / 4.0), 2) AS IndiceFelicidade
FROM Colaboradores
GROUP BY OverTime;

-- 5.2 Business Travel vs Satisfação
SELECT
    BusinessTravel AS TipoViagem,
    COUNT(*) AS NumColaboradores,
    ROUND(AVG(CAST(JobSatisfaction AS FLOAT)), 2) AS SatisfacaoMedia,
    ROUND(AVG(CAST(WorkLifeBalance AS FLOAT)), 2) AS WorkLifeMedia,
    ROUND(AVG((CAST(EnvironmentSatisfaction AS FLOAT) + JobSatisfaction + RelationshipSatisfaction + WorkLifeBalance) / 4.0), 2) AS IndiceFelicidade
FROM Colaboradores
GROUP BY BusinessTravel
ORDER BY IndiceFelicidade DESC;

-- 5.3 Distância de Casa vs Satisfação
SELECT
    CASE
        WHEN DistanceFromHome <= 5 THEN '0-5 (Muito Perto)'
        WHEN DistanceFromHome <= 10 THEN '6-10 (Perto)'
        WHEN DistanceFromHome <= 15 THEN '11-15 (Médio)'
        ELSE '16+ (Longe)'
    END AS DistanciaCategoria,
    COUNT(*) AS NumColaboradores,
    ROUND(AVG(CAST(JobSatisfaction AS FLOAT)), 2) AS SatisfacaoMedia,
    ROUND(AVG(CAST(WorkLifeBalance AS FLOAT)), 2) AS WorkLifeMedia
FROM Colaboradores
GROUP BY
    CASE
        WHEN DistanceFromHome <= 5 THEN '0-5 (Muito Perto)'
        WHEN DistanceFromHome <= 10 THEN '6-10 (Perto)'
        WHEN DistanceFromHome <= 15 THEN '11-15 (Médio)'
        ELSE '16+ (Longe)'
    END
ORDER BY MIN(DistanceFromHome);

-- 5.4 Anos sem Promoção vs Satisfação
SELECT
    CASE
        WHEN YearsSinceLastPromotion = 0 THEN '0 (Promovido recentemente)'
        WHEN YearsSinceLastPromotion <= 2 THEN '1-2 anos'
        WHEN YearsSinceLastPromotion <= 5 THEN '3-5 anos'
        ELSE '5+ anos'
    END AS AnosSemPromocao,
    COUNT(*) AS NumColaboradores,
    ROUND(AVG(CAST(JobSatisfaction AS FLOAT)), 2) AS SatisfacaoMedia
FROM Colaboradores
GROUP BY
    CASE
        WHEN YearsSinceLastPromotion = 0 THEN '0 (Promovido recentemente)'
        WHEN YearsSinceLastPromotion <= 2 THEN '1-2 anos'
        WHEN YearsSinceLastPromotion <= 5 THEN '3-5 anos'
        ELSE '5+ anos'
    END
ORDER BY MIN(YearsSinceLastPromotion);

-- 5.5 Salário vs Satisfação
SELECT
    CASE
        WHEN MonthlyIncome < 3000 THEN 'Baixo (<3000)'
        WHEN MonthlyIncome < 6000 THEN 'Médio (3000-6000)'
        WHEN MonthlyIncome < 10000 THEN 'Alto (6000-10000)'
        ELSE 'Muito Alto (>10000)'
    END AS FaixaSalarial,
    COUNT(*) AS NumColaboradores,
    ROUND(AVG(CAST(JobSatisfaction AS FLOAT)), 2) AS SatisfacaoMedia,
    ROUND(AVG((CAST(EnvironmentSatisfaction AS FLOAT) + JobSatisfaction + RelationshipSatisfaction + WorkLifeBalance) / 4.0), 2) AS IndiceFelicidade
FROM Colaboradores
GROUP BY
    CASE
        WHEN MonthlyIncome < 3000 THEN 'Baixo (<3000)'
        WHEN MonthlyIncome < 6000 THEN 'Médio (3000-6000)'
        WHEN MonthlyIncome < 10000 THEN 'Alto (6000-10000)'
        ELSE 'Muito Alto (>10000)'
    END
ORDER BY MIN(MonthlyIncome);

-- ============================================
-- 6. COLABORADORES MAIS E MENOS FELIZES
-- ============================================

-- Top 10 mais felizes
SELECT TOP 10
    EmployeeNumber,
    Department,
    JobRole,
    Age,
    (EnvironmentSatisfaction + JobSatisfaction + RelationshipSatisfaction + WorkLifeBalance) / 4.0 AS IndiceFelicidade,
    OverTime,
    YearsAtCompany
FROM Colaboradores
ORDER BY IndiceFelicidade DESC, YearsAtCompany DESC;

-- Top 10 menos felizes
SELECT TOP 10
    EmployeeNumber,
    Department,
    JobRole,
    Age,
    (EnvironmentSatisfaction + JobSatisfaction + RelationshipSatisfaction + WorkLifeBalance) / 4.0 AS IndiceFelicidade,
    OverTime,
    YearsAtCompany
FROM Colaboradores
ORDER BY IndiceFelicidade ASC, YearsAtCompany DESC;

-- ============================================
-- 7. SATISFAÇÃO VS ATTRITION
-- ============================================

-- Quem saiu era mais ou menos feliz?
SELECT
    Attrition,
    COUNT(*) AS Total,
    ROUND(AVG(CAST(JobSatisfaction AS FLOAT)), 2) AS SatisfacaoMedia,
    ROUND(AVG(CAST(WorkLifeBalance AS FLOAT)), 2) AS WorkLifeMedia,
    ROUND(AVG((CAST(EnvironmentSatisfaction AS FLOAT) + JobSatisfaction + RelationshipSatisfaction + WorkLifeBalance) / 4.0), 2) AS IndiceFelicidade
FROM Colaboradores
GROUP BY Attrition;

-- ============================================
-- 8. RESUMO EXECUTIVO - "SOMOS FELIZES?"
-- ============================================

SELECT '=== SOMOS FELIZES? ===' AS Pergunta;

-- Resposta global
SELECT
    ROUND(AVG((CAST(EnvironmentSatisfaction AS FLOAT) + JobSatisfaction + RelationshipSatisfaction + WorkLifeBalance) / 4.0), 2) AS IndiceFelicidadeGlobal,
    CASE
        WHEN AVG((EnvironmentSatisfaction + JobSatisfaction + RelationshipSatisfaction + WorkLifeBalance) / 4.0) >= 3 THEN 'SIM - Colaboradores FELIZES (média >= 3)'
        WHEN AVG((EnvironmentSatisfaction + JobSatisfaction + RelationshipSatisfaction + WorkLifeBalance) / 4.0) >= 2.5 THEN 'MODERADO - Colaboradores SATISFEITOS (média 2.5-3)'
        ELSE 'NÃO - Colaboradores INSATISFEITOS (média < 2.5)'
    END AS Resposta
FROM Colaboradores;

-- Percentagem com satisfação alta ou muito alta
SELECT
    'Colaboradores com Satisfação Alta/Muito Alta (3 ou 4)' AS Metrica,
    CAST(ROUND(SUM(CASE WHEN JobSatisfaction >= 3 THEN 1.0 ELSE 0 END) * 100 / COUNT(*), 1) AS VARCHAR(10)) + '%' AS JobSatisfaction,
    CAST(ROUND(SUM(CASE WHEN WorkLifeBalance >= 3 THEN 1.0 ELSE 0 END) * 100 / COUNT(*), 1) AS VARCHAR(10)) + '%' AS WorkLifeBalance,
    CAST(ROUND(SUM(CASE WHEN EnvironmentSatisfaction >= 3 THEN 1.0 ELSE 0 END) * 100 / COUNT(*), 1) AS VARCHAR(10)) + '%' AS EnvironmentSatisfaction
FROM Colaboradores;

-- Factores de preocupação
SELECT
    'Colaboradores com Overtime' AS FactorRisco,
    COUNT(*) AS Total,
    CAST(ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Colaboradores), 1) AS DECIMAL(5,1)) AS Percentagem
FROM Colaboradores
WHERE OverTime = 'Yes'
UNION ALL
SELECT
    'Colaboradores com WorkLife Balance "Bad"',
    COUNT(*),
    CAST(ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Colaboradores), 1) AS DECIMAL(5,1))
FROM Colaboradores
WHERE WorkLifeBalance = 1
UNION ALL
SELECT
    'Colaboradores com Job Satisfaction "Low"',
    COUNT(*),
    CAST(ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Colaboradores), 1) AS DECIMAL(5,1))
FROM Colaboradores
WHERE JobSatisfaction = 1;

GO
