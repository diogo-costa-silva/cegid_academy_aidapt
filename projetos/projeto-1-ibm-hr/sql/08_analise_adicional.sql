-- ============================================
-- Projeto 1: IBM HR Analytics
-- Ficheiro: analise_adicional.sql
-- Descrição: Análises adicionais baseadas nas
--            questões específicas do grupo
-- ============================================

USE Projeto1_IBM_HR;
GO

-- ============================================
-- 1. JOBROLES EM VÁRIOS DEPARTAMENTOS
-- ============================================
-- Questão: Existem os mesmos JobRoles em vários departamentos?

-- Verificar quais JobRoles aparecem em múltiplos departamentos
SELECT
    JobRole AS Cargo,
    COUNT(DISTINCT Department) AS NumDepartamentos,
    STRING_AGG(Department, ', ') AS Departamentos
FROM (
    SELECT DISTINCT JobRole, Department
    FROM Colaboradores
) AS sub
GROUP BY JobRole
ORDER BY NumDepartamentos DESC;

-- Detalhe por cargo e departamento
SELECT
    Department AS Departamento,
    JobRole AS Cargo,
    COUNT(*) AS Total
FROM Colaboradores
GROUP BY Department, JobRole
ORDER BY JobRole, Department;

-- ============================================
-- 2. STOCK OPTIONS
-- ============================================
-- Questão: Só há stock options para certo tipo de colaborador?

-- Distribuição de Stock Options
SELECT
    StockOptionLevel AS NivelStockOptions,
    CASE StockOptionLevel
        WHEN 0 THEN 'Sem Stock Options'
        WHEN 1 THEN 'Básico'
        WHEN 2 THEN 'Médio'
        WHEN 3 THEN 'Alto'
    END AS Descricao,
    COUNT(*) AS Total,
    CAST(ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Colaboradores), 1) AS DECIMAL(5,1)) AS Percentagem
FROM Colaboradores
GROUP BY StockOptionLevel
ORDER BY StockOptionLevel;

-- Stock Options por JobLevel
SELECT
    JobLevel AS Nivel,
    SUM(CASE WHEN StockOptionLevel = 0 THEN 1 ELSE 0 END) AS [Sem_Stock],
    SUM(CASE WHEN StockOptionLevel = 1 THEN 1 ELSE 0 END) AS [Nivel_1],
    SUM(CASE WHEN StockOptionLevel = 2 THEN 1 ELSE 0 END) AS [Nivel_2],
    SUM(CASE WHEN StockOptionLevel = 3 THEN 1 ELSE 0 END) AS [Nivel_3],
    ROUND(AVG(CAST(StockOptionLevel AS FLOAT)), 2) AS MediaStockOptions
FROM Colaboradores
GROUP BY JobLevel
ORDER BY JobLevel;

-- Stock Options por JobRole
SELECT
    JobRole AS Cargo,
    COUNT(*) AS Total,
    SUM(CASE WHEN StockOptionLevel > 0 THEN 1 ELSE 0 END) AS ComStockOptions,
    CAST(ROUND(SUM(CASE WHEN StockOptionLevel > 0 THEN 1.0 ELSE 0 END) * 100 / COUNT(*), 1) AS DECIMAL(5,1)) AS PercComStock,
    ROUND(AVG(CAST(StockOptionLevel AS FLOAT)), 2) AS MediaStockOptions
FROM Colaboradores
GROUP BY JobRole
ORDER BY PercComStock DESC;

-- Stock Options por Department
SELECT
    Department AS Departamento,
    COUNT(*) AS Total,
    SUM(CASE WHEN StockOptionLevel > 0 THEN 1 ELSE 0 END) AS ComStockOptions,
    CAST(ROUND(SUM(CASE WHEN StockOptionLevel > 0 THEN 1.0 ELSE 0 END) * 100 / COUNT(*), 1) AS DECIMAL(5,1)) AS PercComStock
FROM Colaboradores
GROUP BY Department
ORDER BY PercComStock DESC;

-- ============================================
-- 3. DISTÂNCIA DE CASA
-- ============================================
-- Observação: Existe imensa gente a trabalhar a 1 unidade da empresa

-- Distribuição de DistanceFromHome
SELECT
    DistanceFromHome,
    COUNT(*) AS Total,
    CAST(ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Colaboradores), 1) AS DECIMAL(5,1)) AS Percentagem
FROM Colaboradores
GROUP BY DistanceFromHome
ORDER BY DistanceFromHome;

-- Distribuição por categorias
SELECT
    CASE
        WHEN DistanceFromHome = 1 THEN '1 (Muito Perto)'
        WHEN DistanceFromHome <= 5 THEN '2-5 (Perto)'
        WHEN DistanceFromHome <= 10 THEN '6-10'
        WHEN DistanceFromHome <= 15 THEN '11-15'
        WHEN DistanceFromHome <= 20 THEN '16-20'
        ELSE '21+ (Longe)'
    END AS DistanciaCategoria,
    COUNT(*) AS Total,
    CAST(ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Colaboradores), 1) AS DECIMAL(5,1)) AS Percentagem
FROM Colaboradores
GROUP BY
    CASE
        WHEN DistanceFromHome = 1 THEN '1 (Muito Perto)'
        WHEN DistanceFromHome <= 5 THEN '2-5 (Perto)'
        WHEN DistanceFromHome <= 10 THEN '6-10'
        WHEN DistanceFromHome <= 15 THEN '11-15'
        WHEN DistanceFromHome <= 20 THEN '16-20'
        ELSE '21+ (Longe)'
    END
ORDER BY MIN(DistanceFromHome);

-- Quantos vivem a 1 unidade?
SELECT
    'Colaboradores a 1 unidade de distância' AS Metrica,
    COUNT(*) AS Total,
    CAST(CAST(ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Colaboradores), 1) AS DECIMAL(5,1)) AS VARCHAR(10)) + '%' AS Percentagem
FROM Colaboradores
WHERE DistanceFromHome = 1;

-- ============================================
-- 4. PERFORMANCE RATING
-- ============================================
-- Observação: O PerformanceRating só tem 3 e 4 (vai de 1 a 4)

-- Verificar valores existentes
SELECT DISTINCT PerformanceRating
FROM Colaboradores
ORDER BY PerformanceRating;

-- Distribuição de Performance Rating
SELECT
    PerformanceRating,
    CASE PerformanceRating
        WHEN 1 THEN 'Low'
        WHEN 2 THEN 'Good'
        WHEN 3 THEN 'Excellent'
        WHEN 4 THEN 'Outstanding'
    END AS Descricao,
    COUNT(*) AS Total,
    CAST(ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Colaboradores), 1) AS DECIMAL(5,1)) AS Percentagem
FROM Colaboradores
GROUP BY PerformanceRating
ORDER BY PerformanceRating;

-- Performance por Department
SELECT
    Department AS Departamento,
    SUM(CASE WHEN PerformanceRating = 3 THEN 1 ELSE 0 END) AS Excellent,
    SUM(CASE WHEN PerformanceRating = 4 THEN 1 ELSE 0 END) AS Outstanding,
    ROUND(AVG(CAST(PerformanceRating AS FLOAT)), 2) AS MediaPerformance
FROM Colaboradores
GROUP BY Department;

-- ============================================
-- 5. CONFLITO DE GERAÇÕES
-- ============================================
-- Questão: Será que haverá conflito de gerações?

-- Satisfação por geração
SELECT
    CASE
        WHEN Age < 28 THEN 'Gen Z (< 28)'
        WHEN Age < 44 THEN 'Millennials (28-43)'
        WHEN Age < 60 THEN 'Gen X (44-59)'
        ELSE 'Baby Boomers (60+)'
    END AS Geracao,
    COUNT(*) AS Total,
    ROUND(AVG(CAST(JobSatisfaction AS FLOAT)), 2) AS SatisfacaoTrabalho,
    ROUND(AVG(CAST(WorkLifeBalance AS FLOAT)), 2) AS WorkLifeBalance,
    ROUND(AVG(CAST(EnvironmentSatisfaction AS FLOAT)), 2) AS SatisfacaoAmbiente,
    ROUND(AVG(CAST(RelationshipSatisfaction AS FLOAT)), 2) AS SatisfacaoRelacoes
FROM Colaboradores
GROUP BY
    CASE
        WHEN Age < 28 THEN 'Gen Z (< 28)'
        WHEN Age < 44 THEN 'Millennials (28-43)'
        WHEN Age < 60 THEN 'Gen X (44-59)'
        ELSE 'Baby Boomers (60+)'
    END
ORDER BY MIN(Age);

-- Attrition por geração
SELECT
    CASE
        WHEN Age < 28 THEN 'Gen Z (< 28)'
        WHEN Age < 44 THEN 'Millennials (28-43)'
        WHEN Age < 60 THEN 'Gen X (44-59)'
        ELSE 'Baby Boomers (60+)'
    END AS Geracao,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS Saidas,
    COUNT(*) AS Total,
    CAST(ROUND(SUM(CASE WHEN Attrition = 'Yes' THEN 1.0 ELSE 0 END) * 100 / COUNT(*), 1) AS DECIMAL(5,1)) AS TaxaAttrition
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
-- 6. CHEFIAS POR GÉNERO
-- ============================================
-- Observação: Chefias são mais do sexo masculino

-- Análise de níveis de chefia por género
SELECT
    JobLevel AS Nivel,
    CASE JobLevel
        WHEN 1 THEN 'Entry Level'
        WHEN 2 THEN 'Junior'
        WHEN 3 THEN 'Mid-Level'
        WHEN 4 THEN 'Senior'
        WHEN 5 THEN 'Executive'
    END AS DescricaoNivel,
    SUM(CASE WHEN Gender = 'Female' THEN 1 ELSE 0 END) AS Mulheres,
    SUM(CASE WHEN Gender = 'Male' THEN 1 ELSE 0 END) AS Homens,
    CAST(ROUND(SUM(CASE WHEN Gender = 'Female' THEN 1.0 ELSE 0 END) * 100 / COUNT(*), 1) AS DECIMAL(5,1)) AS PercMulheres
FROM Colaboradores
GROUP BY JobLevel
ORDER BY JobLevel;

-- Cargos de gestão por género
SELECT
    JobRole AS Cargo,
    SUM(CASE WHEN Gender = 'Female' THEN 1 ELSE 0 END) AS Mulheres,
    SUM(CASE WHEN Gender = 'Male' THEN 1 ELSE 0 END) AS Homens,
    CAST(ROUND(SUM(CASE WHEN Gender = 'Female' THEN 1.0 ELSE 0 END) * 100 / COUNT(*), 1) AS DECIMAL(5,1)) AS PercMulheres
FROM Colaboradores
WHERE JobRole LIKE '%Manager%' OR JobRole LIKE '%Director%'
GROUP BY JobRole
ORDER BY PercMulheres;

-- ============================================
-- 7. RELAÇÃO ANOS EXPERIÊNCIA VS FELICIDADE
-- ============================================
-- Questão: Como TotalWorkingYears e YearsAtCompany estão relacionados com felicidade?

-- Satisfação por anos na empresa
SELECT
    CASE
        WHEN YearsAtCompany = 0 THEN '0 (Novo)'
        WHEN YearsAtCompany <= 2 THEN '1-2 anos'
        WHEN YearsAtCompany <= 5 THEN '3-5 anos'
        WHEN YearsAtCompany <= 10 THEN '6-10 anos'
        ELSE '10+ anos'
    END AS AnosNaEmpresa,
    COUNT(*) AS Total,
    ROUND(AVG(CAST(JobSatisfaction AS FLOAT)), 2) AS SatisfacaoTrabalho,
    ROUND(AVG(CAST(WorkLifeBalance AS FLOAT)), 2) AS WorkLifeBalance
FROM Colaboradores
GROUP BY
    CASE
        WHEN YearsAtCompany = 0 THEN '0 (Novo)'
        WHEN YearsAtCompany <= 2 THEN '1-2 anos'
        WHEN YearsAtCompany <= 5 THEN '3-5 anos'
        WHEN YearsAtCompany <= 10 THEN '6-10 anos'
        ELSE '10+ anos'
    END
ORDER BY MIN(YearsAtCompany);

-- Satisfação por total de experiência
SELECT
    CASE
        WHEN TotalWorkingYears <= 5 THEN '0-5 anos'
        WHEN TotalWorkingYears <= 10 THEN '6-10 anos'
        WHEN TotalWorkingYears <= 20 THEN '11-20 anos'
        ELSE '20+ anos'
    END AS ExperienciaTotal,
    COUNT(*) AS Total,
    ROUND(AVG(CAST(JobSatisfaction AS FLOAT)), 2) AS SatisfacaoTrabalho,
    ROUND(AVG(CAST(WorkLifeBalance AS FLOAT)), 2) AS WorkLifeBalance
FROM Colaboradores
GROUP BY
    CASE
        WHEN TotalWorkingYears <= 5 THEN '0-5 anos'
        WHEN TotalWorkingYears <= 10 THEN '6-10 anos'
        WHEN TotalWorkingYears <= 20 THEN '11-20 anos'
        ELSE '20+ anos'
    END
ORDER BY MIN(TotalWorkingYears);

-- ============================================
-- 8. RATES E INCOME
-- ============================================
-- Questões sobre DailyRate, MonthlyRate, MonthlyIncome

-- Estatísticas dos diferentes rates
SELECT
    'MonthlyIncome' AS Metrica,
    MIN(MonthlyIncome) AS Minimo,
    MAX(MonthlyIncome) AS Maximo,
    AVG(MonthlyIncome) AS Media,
    STDEV(MonthlyIncome) AS DesvioPadrao
FROM Colaboradores
UNION ALL
SELECT
    'MonthlyRate',
    MIN(MonthlyRate),
    MAX(MonthlyRate),
    AVG(MonthlyRate),
    STDEV(MonthlyRate)
FROM Colaboradores
UNION ALL
SELECT
    'DailyRate',
    MIN(DailyRate),
    MAX(DailyRate),
    AVG(DailyRate),
    STDEV(DailyRate)
FROM Colaboradores
UNION ALL
SELECT
    'HourlyRate',
    MIN(HourlyRate),
    MAX(HourlyRate),
    AVG(HourlyRate),
    STDEV(HourlyRate)
FROM Colaboradores;

-- Correlação entre MonthlyIncome e outros rates
SELECT TOP 20
    EmployeeNumber,
    MonthlyIncome,
    MonthlyRate,
    DailyRate,
    HourlyRate,
    JobLevel
FROM Colaboradores
ORDER BY MonthlyIncome DESC;

-- ============================================
-- 9. COLUNAS CONSTANTES (VERIFICAÇÃO)
-- ============================================
-- Over18, EmployeeCount, StandardHours são constantes?

SELECT
    'Over18' AS Coluna,
    COUNT(DISTINCT Over18) AS ValoresDistintos,
    MIN(Over18) AS ValorMinimo,
    MAX(Over18) AS ValorMaximo
FROM Colaboradores
UNION ALL
SELECT
    'EmployeeCount',
    COUNT(DISTINCT EmployeeCount),
    CAST(MIN(EmployeeCount) AS VARCHAR(10)),
    CAST(MAX(EmployeeCount) AS VARCHAR(10))
FROM Colaboradores
UNION ALL
SELECT
    'StandardHours',
    COUNT(DISTINCT StandardHours),
    CAST(MIN(StandardHours) AS VARCHAR(10)),
    CAST(MAX(StandardHours) AS VARCHAR(10))
FROM Colaboradores;

-- ============================================
-- 10. RESUMO DAS QUESTÕES DO GRUPO
-- ============================================

SELECT '=== RESPOSTAS ÀS QUESTÕES DO GRUPO ===' AS Info;

-- Q1: JobRoles em vários departamentos?
SELECT
    'Q1: JobRoles em múltiplos departamentos' AS Questao,
    COUNT(*) AS Resposta
FROM (
    SELECT JobRole
    FROM Colaboradores
    GROUP BY JobRole
    HAVING COUNT(DISTINCT Department) > 1
) AS multi;

-- Q2: Stock Options apenas para certos colaboradores?
SELECT
    'Q2: Colaboradores SEM Stock Options' AS Questao,
    CAST(ROUND(SUM(CASE WHEN StockOptionLevel = 0 THEN 1.0 ELSE 0 END) * 100 / COUNT(*), 1) AS VARCHAR(10)) + '%' AS Resposta
FROM Colaboradores;

-- Q3: Muita gente a 1 unidade de distância?
SELECT
    'Q3: Colaboradores a distância = 1' AS Questao,
    CAST(ROUND(SUM(CASE WHEN DistanceFromHome = 1 THEN 1.0 ELSE 0 END) * 100 / COUNT(*), 1) AS VARCHAR(10)) + '%' AS Resposta
FROM Colaboradores;

-- Q4: Performance Rating só 3 e 4?
SELECT
    'Q4: Performance Rating apenas 3 e 4' AS Questao,
    CASE WHEN MIN(PerformanceRating) >= 3 THEN 'CONFIRMADO' ELSE 'Existem outros valores' END AS Resposta
FROM Colaboradores;

-- Q5: Chefias mais masculinas?
SELECT
    'Q5: % Mulheres em níveis 4-5 (Senior/Executive)' AS Questao,
    CAST(ROUND(SUM(CASE WHEN Gender = 'Female' THEN 1.0 ELSE 0 END) * 100 / COUNT(*), 1) AS VARCHAR(10)) + '%' AS Resposta
FROM Colaboradores
WHERE JobLevel >= 4;

GO
