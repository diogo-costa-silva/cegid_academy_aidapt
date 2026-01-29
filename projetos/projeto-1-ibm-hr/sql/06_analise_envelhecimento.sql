-- ============================================
-- Projeto 1: IBM HR Analytics
-- Ficheiro: analise_envelhecimento.sql
-- Descrição: Análise de Envelhecimento e Reforma
-- Idade de reforma em Portugal: 67 anos
-- ============================================

USE Projeto1_IBM_HR;
GO

-- ============================================
-- 1. VISÃO GERAL DO ENVELHECIMENTO
-- ============================================

-- Estatísticas de idade
SELECT
    MIN(Age) AS IdadeMinima,
    MAX(Age) AS IdadeMaxima,
    AVG(Age) AS IdadeMedia,
    STDEV(Age) AS DesvioPadrao
FROM Colaboradores;

-- Distribuição por gerações
SELECT
    CASE
        WHEN Age < 28 THEN 'Gen Z (< 28)'
        WHEN Age < 44 THEN 'Millennials (28-43)'
        WHEN Age < 60 THEN 'Gen X (44-59)'
        ELSE 'Baby Boomers (60+)'
    END AS Geracao,
    COUNT(*) AS Total,
    CAST(ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Colaboradores), 1) AS DECIMAL(5,1)) AS Percentagem,
    AVG(Age) AS IdadeMedia
FROM Colaboradores
GROUP BY
    CASE
        WHEN Age < 28 THEN 'Gen Z (< 28)'
        WHEN Age < 44 THEN 'Millennials (28-43)'
        WHEN Age < 60 THEN 'Gen X (44-59)'
        ELSE 'Baby Boomers (60+)'
    END
ORDER BY MIN(Age);

-- ============================================
-- 2. COLABORADORES PERTO DA REFORMA
-- ============================================

-- Colaboradores com 55+ anos (próximos da reforma)
SELECT
    EmployeeNumber,
    Age,
    (67 - Age) AS AnosParaReforma,
    Department,
    JobRole,
    JobLevel,
    YearsAtCompany,
    MonthlyIncome
FROM Colaboradores
WHERE Age >= 55
ORDER BY Age DESC;

-- Contagem por faixa etária crítica
SELECT
    CASE
        WHEN Age >= 60 THEN '60+ (Reforma muito próxima: 0-7 anos)'
        WHEN Age >= 55 THEN '55-59 (Reforma próxima: 8-12 anos)'
        WHEN Age >= 50 THEN '50-54 (Pré-reforma: 13-17 anos)'
    END AS FaixaCritica,
    COUNT(*) AS Total,
    CAST(ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Colaboradores), 1) AS DECIMAL(5,1)) AS PercTotal
FROM Colaboradores
WHERE Age >= 50
GROUP BY
    CASE
        WHEN Age >= 60 THEN '60+ (Reforma muito próxima: 0-7 anos)'
        WHEN Age >= 55 THEN '55-59 (Reforma próxima: 8-12 anos)'
        WHEN Age >= 50 THEN '50-54 (Pré-reforma: 13-17 anos)'
    END
ORDER BY MIN(Age) DESC;

-- ============================================
-- 3. ENVELHECIMENTO POR DEPARTAMENTO
-- ============================================

-- Idade média por departamento
SELECT
    Department AS Departamento,
    COUNT(*) AS Total,
    AVG(Age) AS IdadeMedia,
    MIN(Age) AS IdadeMin,
    MAX(Age) AS IdadeMax,
    SUM(CASE WHEN Age >= 55 THEN 1 ELSE 0 END) AS Colaboradores55mais,
    CAST(ROUND(SUM(CASE WHEN Age >= 55 THEN 1.0 ELSE 0 END) * 100 / COUNT(*), 1) AS DECIMAL(5,1)) AS Perc55mais
FROM Colaboradores
GROUP BY Department
ORDER BY IdadeMedia DESC;

-- Distribuição etária por departamento
SELECT
    Department AS Departamento,
    SUM(CASE WHEN Age < 30 THEN 1 ELSE 0 END) AS [18-29],
    SUM(CASE WHEN Age >= 30 AND Age < 40 THEN 1 ELSE 0 END) AS [30-39],
    SUM(CASE WHEN Age >= 40 AND Age < 50 THEN 1 ELSE 0 END) AS [40-49],
    SUM(CASE WHEN Age >= 50 AND Age < 60 THEN 1 ELSE 0 END) AS [50-59],
    SUM(CASE WHEN Age >= 60 THEN 1 ELSE 0 END) AS [60+],
    COUNT(*) AS Total
FROM Colaboradores
GROUP BY Department;

-- ============================================
-- 4. ENVELHECIMENTO POR CARGO
-- ============================================

-- Idade média por cargo
SELECT
    JobRole AS Cargo,
    COUNT(*) AS Total,
    AVG(Age) AS IdadeMedia,
    SUM(CASE WHEN Age >= 55 THEN 1 ELSE 0 END) AS Colaboradores55mais,
    CAST(ROUND(SUM(CASE WHEN Age >= 55 THEN 1.0 ELSE 0 END) * 100 / COUNT(*), 1) AS DECIMAL(5,1)) AS Perc55mais
FROM Colaboradores
GROUP BY JobRole
ORDER BY IdadeMedia DESC;

-- ============================================
-- 5. RISCO DE PERDA DE CONHECIMENTO
-- ============================================

-- Colaboradores seniores com muitos anos de experiência
SELECT
    EmployeeNumber,
    Age,
    (67 - Age) AS AnosParaReforma,
    Department,
    JobRole,
    TotalWorkingYears AS ExperienciaTotal,
    YearsAtCompany AS AnosNaEmpresa,
    YearsInCurrentRole AS AnosNoCargo,
    JobLevel AS Nivel
FROM Colaboradores
WHERE Age >= 55
  AND (TotalWorkingYears >= 20 OR YearsAtCompany >= 15 OR JobLevel >= 4)
ORDER BY Age DESC, TotalWorkingYears DESC;

-- Análise de risco por departamento
SELECT
    Department AS Departamento,
    COUNT(*) AS ColaboradoresEmRisco,
    AVG(TotalWorkingYears) AS MediaExperiencia,
    AVG(YearsAtCompany) AS MediaAnosEmpresa,
    SUM(CASE WHEN JobLevel >= 4 THEN 1 ELSE 0 END) AS SenioresAltoNivel
FROM Colaboradores
WHERE Age >= 55
GROUP BY Department
ORDER BY ColaboradoresEmRisco DESC;

-- ============================================
-- 6. PLANEAMENTO DE SUCESSÃO
-- ============================================

-- Cargos com colaboradores perto da reforma e sem substitutos óbvios
SELECT
    JobRole AS Cargo,
    SUM(CASE WHEN Age >= 55 THEN 1 ELSE 0 END) AS PertoDaReforma,
    SUM(CASE WHEN Age < 35 THEN 1 ELSE 0 END) AS Jovens,
    COUNT(*) AS Total,
    CASE
        WHEN SUM(CASE WHEN Age >= 55 THEN 1 ELSE 0 END) > SUM(CASE WHEN Age < 35 THEN 1 ELSE 0 END)
        THEN 'RISCO: Mais seniores que jovens'
        ELSE 'OK'
    END AS AlertaSucessao
FROM Colaboradores
GROUP BY JobRole
HAVING SUM(CASE WHEN Age >= 55 THEN 1 ELSE 0 END) > 0
ORDER BY PertoDaReforma DESC;

-- Pirâmide etária por nível hierárquico
SELECT
    JobLevel AS Nivel,
    CASE JobLevel
        WHEN 1 THEN 'Entry Level'
        WHEN 2 THEN 'Junior'
        WHEN 3 THEN 'Mid-Level'
        WHEN 4 THEN 'Senior'
        WHEN 5 THEN 'Executive'
    END AS DescricaoNivel,
    SUM(CASE WHEN Age < 35 THEN 1 ELSE 0 END) AS [<35],
    SUM(CASE WHEN Age >= 35 AND Age < 50 THEN 1 ELSE 0 END) AS [35-49],
    SUM(CASE WHEN Age >= 50 THEN 1 ELSE 0 END) AS [50+],
    AVG(Age) AS IdadeMedia
FROM Colaboradores
GROUP BY JobLevel
ORDER BY JobLevel;

-- ============================================
-- 7. EXPERIÊNCIA E CONHECIMENTO INSTITUCIONAL
-- ============================================

-- Anos médios na empresa por faixa etária
SELECT
    CASE
        WHEN Age < 30 THEN '18-29'
        WHEN Age < 40 THEN '30-39'
        WHEN Age < 50 THEN '40-49'
        WHEN Age < 60 THEN '50-59'
        ELSE '60+'
    END AS FaixaEtaria,
    COUNT(*) AS Total,
    AVG(YearsAtCompany) AS MediaAnosEmpresa,
    AVG(YearsInCurrentRole) AS MediaAnosCargo,
    AVG(TotalWorkingYears) AS MediaExperienciaTotal
FROM Colaboradores
GROUP BY
    CASE
        WHEN Age < 30 THEN '18-29'
        WHEN Age < 40 THEN '30-39'
        WHEN Age < 50 THEN '40-49'
        WHEN Age < 60 THEN '50-59'
        ELSE '60+'
    END
ORDER BY MIN(Age);

-- ============================================
-- 8. ATTRITION POR FAIXA ETÁRIA
-- ============================================

-- Quem está a sair por idade?
SELECT
    CASE
        WHEN Age < 30 THEN '18-29'
        WHEN Age < 40 THEN '30-39'
        WHEN Age < 50 THEN '40-49'
        ELSE '50+'
    END AS FaixaEtaria,
    Attrition,
    COUNT(*) AS Total,
    CAST(ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY
        CASE
            WHEN Age < 30 THEN '18-29'
            WHEN Age < 40 THEN '30-39'
            WHEN Age < 50 THEN '40-49'
            ELSE '50+'
        END
    ), 1) AS DECIMAL(5,1)) AS PercNaFaixa
FROM Colaboradores
GROUP BY
    CASE
        WHEN Age < 30 THEN '18-29'
        WHEN Age < 40 THEN '30-39'
        WHEN Age < 50 THEN '40-49'
        ELSE '50+'
    END,
    Attrition
ORDER BY MIN(Age), Attrition;

-- ============================================
-- 9. RESUMO EXECUTIVO - ENVELHECIMENTO
-- ============================================

SELECT '=== RESUMO ENVELHECIMENTO ===' AS Info;

-- Números chave
SELECT
    'Total 55+ anos' AS Metrica,
    COUNT(*) AS Valor,
    CAST(CAST(ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Colaboradores), 1) AS DECIMAL(5,1)) AS VARCHAR(10)) + '%' AS Percentagem
FROM Colaboradores
WHERE Age >= 55
UNION ALL
SELECT
    'Total 60+ anos',
    COUNT(*),
    CAST(CAST(ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Colaboradores), 1) AS DECIMAL(5,1)) AS VARCHAR(10)) + '%'
FROM Colaboradores
WHERE Age >= 60
UNION ALL
SELECT
    'Reforma nos próximos 5 anos (62+)',
    COUNT(*),
    CAST(CAST(ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Colaboradores), 1) AS DECIMAL(5,1)) AS VARCHAR(10)) + '%'
FROM Colaboradores
WHERE Age >= 62;

-- Departamento mais envelhecido
SELECT TOP 1
    'Departamento mais envelhecido' AS Metrica,
    Department AS Departamento,
    CAST(AVG(Age) AS VARCHAR(10)) + ' anos média' AS IdadeMedia
FROM Colaboradores
GROUP BY Department
ORDER BY AVG(Age) DESC;

-- Alerta de conhecimento em risco
SELECT
    'Colaboradores seniores (55+) com 20+ anos experiência' AS Alerta,
    COUNT(*) AS Total
FROM Colaboradores
WHERE Age >= 55 AND TotalWorkingYears >= 20;

GO
