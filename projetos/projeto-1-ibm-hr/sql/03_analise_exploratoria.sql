-- ============================================
-- Projeto 1: IBM HR Analytics
-- Ficheiro: analise_exploratoria.sql
-- Descrição: Análise exploratória inicial - "Quem Somos"
-- ============================================

USE Projeto1_IBM_HR;
GO

-- ============================================
-- 1. VISÃO GERAL DA EMPRESA
-- ============================================

-- Total de colaboradores
SELECT COUNT(*) AS TotalColaboradores FROM Colaboradores;

-- Distribuição por Attrition (saídas)
SELECT
    Attrition,
    COUNT(*) AS Total,
    CAST(ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Colaboradores), 2) AS DECIMAL(5,2)) AS Percentagem
FROM Colaboradores
GROUP BY Attrition;

-- ============================================
-- 2. DEMOGRAFIA - IDADE
-- ============================================

-- Estatísticas de idade
SELECT
    MIN(Age) AS IdadeMinima,
    MAX(Age) AS IdadeMaxima,
    AVG(Age) AS IdadeMedia,
    STDEV(Age) AS DesvioPadrao
FROM Colaboradores;

-- Distribuição por faixa etária
SELECT
    CASE
        WHEN Age < 25 THEN '18-24 (Entrada)'
        WHEN Age < 30 THEN '25-29 (Jovem)'
        WHEN Age < 35 THEN '30-34'
        WHEN Age < 40 THEN '35-39'
        WHEN Age < 45 THEN '40-44'
        WHEN Age < 50 THEN '45-49'
        WHEN Age < 55 THEN '50-54'
        WHEN Age < 60 THEN '55-59 (Pré-reforma)'
        ELSE '60+ (Reforma próxima)'
    END AS FaixaEtaria,
    COUNT(*) AS Total,
    CAST(ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Colaboradores), 2) AS DECIMAL(5,2)) AS Percentagem
FROM Colaboradores
GROUP BY
    CASE
        WHEN Age < 25 THEN '18-24 (Entrada)'
        WHEN Age < 30 THEN '25-29 (Jovem)'
        WHEN Age < 35 THEN '30-34'
        WHEN Age < 40 THEN '35-39'
        WHEN Age < 45 THEN '40-44'
        WHEN Age < 50 THEN '45-49'
        WHEN Age < 55 THEN '50-54'
        WHEN Age < 60 THEN '55-59 (Pré-reforma)'
        ELSE '60+ (Reforma próxima)'
    END
ORDER BY MIN(Age);

-- ============================================
-- 3. DEMOGRAFIA - GÉNERO
-- ============================================

-- Distribuição por género
SELECT
    Gender AS Genero,
    COUNT(*) AS Total,
    CAST(ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Colaboradores), 2) AS DECIMAL(5,2)) AS Percentagem
FROM Colaboradores
GROUP BY Gender;

-- ============================================
-- 4. DEMOGRAFIA - ESTADO CIVIL
-- ============================================

SELECT
    MaritalStatus AS EstadoCivil,
    COUNT(*) AS Total,
    CAST(ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Colaboradores), 2) AS DECIMAL(5,2)) AS Percentagem
FROM Colaboradores
GROUP BY MaritalStatus
ORDER BY Total DESC;

-- ============================================
-- 5. EDUCAÇÃO
-- ============================================

-- Nível de educação
SELECT
    Education,
    CASE Education
        WHEN 1 THEN 'Below College'
        WHEN 2 THEN 'College'
        WHEN 3 THEN 'Bachelor'
        WHEN 4 THEN 'Master'
        WHEN 5 THEN 'Doctor'
    END AS NivelEducacao,
    COUNT(*) AS Total,
    CAST(ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Colaboradores), 2) AS DECIMAL(5,2)) AS Percentagem
FROM Colaboradores
GROUP BY Education
ORDER BY Education;

-- Área de educação
SELECT
    EducationField AS AreaEducacao,
    COUNT(*) AS Total,
    CAST(ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Colaboradores), 2) AS DECIMAL(5,2)) AS Percentagem
FROM Colaboradores
GROUP BY EducationField
ORDER BY Total DESC;

-- ============================================
-- 6. ESTRUTURA ORGANIZACIONAL
-- ============================================

-- Distribuição por departamento
SELECT
    Department AS Departamento,
    COUNT(*) AS Total,
    CAST(ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Colaboradores), 2) AS DECIMAL(5,2)) AS Percentagem
FROM Colaboradores
GROUP BY Department
ORDER BY Total DESC;

-- Distribuição por cargo (JobRole)
SELECT
    JobRole AS Cargo,
    COUNT(*) AS Total,
    CAST(ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Colaboradores), 2) AS DECIMAL(5,2)) AS Percentagem
FROM Colaboradores
GROUP BY JobRole
ORDER BY Total DESC;

-- Distribuição por nível hierárquico
SELECT
    JobLevel AS NivelHierarquico,
    COUNT(*) AS Total,
    CAST(ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Colaboradores), 2) AS DECIMAL(5,2)) AS Percentagem
FROM Colaboradores
GROUP BY JobLevel
ORDER BY JobLevel;

-- Cargos por departamento
SELECT
    Department AS Departamento,
    JobRole AS Cargo,
    COUNT(*) AS Total
FROM Colaboradores
GROUP BY Department, JobRole
ORDER BY Department, Total DESC;

-- ============================================
-- 7. ANTIGUIDADE
-- ============================================

-- Estatísticas de antiguidade na empresa
SELECT
    MIN(YearsAtCompany) AS MinAnosEmpresa,
    MAX(YearsAtCompany) AS MaxAnosEmpresa,
    AVG(YearsAtCompany) AS MediaAnosEmpresa,
    AVG(TotalWorkingYears) AS MediaExperienciaTotal
FROM Colaboradores;

-- Distribuição por anos na empresa
SELECT
    CASE
        WHEN YearsAtCompany = 0 THEN '0 (Recém-chegado)'
        WHEN YearsAtCompany <= 2 THEN '1-2 anos'
        WHEN YearsAtCompany <= 5 THEN '3-5 anos'
        WHEN YearsAtCompany <= 10 THEN '6-10 anos'
        WHEN YearsAtCompany <= 20 THEN '11-20 anos'
        ELSE '20+ anos'
    END AS AnosNaEmpresa,
    COUNT(*) AS Total,
    CAST(ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Colaboradores), 2) AS DECIMAL(5,2)) AS Percentagem
FROM Colaboradores
GROUP BY
    CASE
        WHEN YearsAtCompany = 0 THEN '0 (Recém-chegado)'
        WHEN YearsAtCompany <= 2 THEN '1-2 anos'
        WHEN YearsAtCompany <= 5 THEN '3-5 anos'
        WHEN YearsAtCompany <= 10 THEN '6-10 anos'
        WHEN YearsAtCompany <= 20 THEN '11-20 anos'
        ELSE '20+ anos'
    END
ORDER BY MIN(YearsAtCompany);

-- ============================================
-- 8. SALÁRIOS
-- ============================================

-- Estatísticas salariais gerais
SELECT
    MIN(MonthlyIncome) AS SalarioMinimo,
    MAX(MonthlyIncome) AS SalarioMaximo,
    AVG(MonthlyIncome) AS SalarioMedio,
    STDEV(MonthlyIncome) AS DesvioPadrao
FROM Colaboradores;

-- Salário médio por departamento
SELECT
    Department AS Departamento,
    COUNT(*) AS NumColaboradores,
    MIN(MonthlyIncome) AS SalarioMin,
    AVG(MonthlyIncome) AS SalarioMedio,
    MAX(MonthlyIncome) AS SalarioMax
FROM Colaboradores
GROUP BY Department
ORDER BY SalarioMedio DESC;

-- Salário médio por nível hierárquico
SELECT
    JobLevel AS Nivel,
    COUNT(*) AS NumColaboradores,
    AVG(MonthlyIncome) AS SalarioMedio
FROM Colaboradores
GROUP BY JobLevel
ORDER BY JobLevel;

-- ============================================
-- 9. RESUMO EXECUTIVO - "QUEM SOMOS"
-- ============================================

SELECT
    'Total de Colaboradores' AS Metrica,
    CAST(COUNT(*) AS VARCHAR(50)) AS Valor
FROM Colaboradores
UNION ALL
SELECT
    'Média de Idade',
    CAST(ROUND(AVG(CAST(Age AS FLOAT)), 1) AS VARCHAR(50)) + ' anos'
FROM Colaboradores
UNION ALL
SELECT
    '% Mulheres',
    CAST(ROUND(SUM(CASE WHEN Gender = 'Female' THEN 1.0 ELSE 0.0 END) * 100 / COUNT(*), 1) AS VARCHAR(50)) + '%'
FROM Colaboradores
UNION ALL
SELECT
    '% Attrition (Saídas)',
    CAST(ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1.0 ELSE 0.0 END) * 100 / COUNT(*), 1) AS VARCHAR(50)) + '%'
FROM Colaboradores
UNION ALL
SELECT
    'Salário Médio',
    CAST(ROUND(AVG(CAST(MonthlyIncome AS FLOAT)), 0) AS VARCHAR(50))
FROM Colaboradores
UNION ALL
SELECT
    'Média Anos na Empresa',
    CAST(ROUND(AVG(CAST(YearsAtCompany AS FLOAT)), 1) AS VARCHAR(50)) + ' anos'
FROM Colaboradores;

GO
