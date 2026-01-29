-- ============================================
-- Projeto 1: IBM HR Analytics
-- Ficheiro: schema.sql
-- Descricao: Criacao da base de dados e tabela
-- ============================================

-- Criar base de dados (executar apenas uma vez)
-- NOTA: Executar via sqlcmd ou SSMS, nao funciona em transaccoes
-- CREATE DATABASE Projeto1_IBM_HR;
-- GO

-- Usar a base de dados
USE Projeto1_IBM_HR;
GO

-- Eliminar tabela se existir (para recriacao)
IF OBJECT_ID('dbo.Colaboradores', 'U') IS NOT NULL
    DROP TABLE dbo.Colaboradores;
GO

-- Criar tabela Colaboradores
-- NOTA: Ordem das colunas igual ao CSV para facilitar BULK INSERT
CREATE TABLE Colaboradores (
    -- Dados Demograficos
    Age INT NOT NULL,
    Attrition VARCHAR(3),               -- Yes/No (saiu da empresa)
    BusinessTravel VARCHAR(20),         -- Non-Travel, Travel_Rarely, Travel_Frequently
    DailyRate INT,                      -- Taxa diaria
    Department VARCHAR(50),
    DistanceFromHome INT,               -- 1-29 (distancia casa-trabalho)
    Education INT,                      -- 1=Below College, 2=College, 3=Bachelor, 4=Master, 5=Doctor
    EducationField VARCHAR(50),
    EmployeeCount INT,                  -- Sempre 1 (pode ser ignorado)
    EmployeeNumber INT PRIMARY KEY,
    EnvironmentSatisfaction INT,        -- 1-4: Low, Medium, High, Very High
    Gender VARCHAR(10) NOT NULL,
    HourlyRate INT,                     -- Taxa horaria
    JobInvolvement INT,                 -- 1-4: Low, Medium, High, Very High
    JobLevel INT,                       -- 1-5 (nivel hierarquico)
    JobRole VARCHAR(50),
    JobSatisfaction INT,                -- 1-4: Low, Medium, High, Very High
    MaritalStatus VARCHAR(20),
    MonthlyIncome INT,                  -- Salario mensal
    MonthlyRate INT,                    -- Taxa mensal (salario + beneficios)
    NumCompaniesWorked INT,             -- Numero de empresas onde trabalhou
    Over18 VARCHAR(1),                  -- Sempre 'Y' (pode ser ignorado)
    OverTime VARCHAR(3),                -- Yes/No
    PercentSalaryHike INT,              -- % de aumento salarial
    PerformanceRating INT,              -- 3=Excellent, 4=Outstanding (so estes no dataset)
    RelationshipSatisfaction INT,       -- 1-4: Low, Medium, High, Very High
    StandardHours INT,                  -- Sempre 80 (pode ser ignorado)
    StockOptionLevel INT,               -- 0=Nenhum, 1=Basico, 2=Medio, 3=Alto
    TotalWorkingYears INT,              -- Total de anos de experiencia
    TrainingTimesLastYear INT,          -- Vezes que teve formacao no ultimo ano
    WorkLifeBalance INT,                -- 1=Bad, 2=Good, 3=Better, 4=Best
    YearsAtCompany INT,                 -- Anos na empresa atual
    YearsInCurrentRole INT,             -- Anos no cargo atual
    YearsSinceLastPromotion INT,        -- Anos desde ultima promocao
    YearsWithCurrManager INT            -- Anos com o manager atual
);
GO

-- Criar indices para melhorar performance das queries
CREATE INDEX IX_Colaboradores_Department ON Colaboradores(Department);
CREATE INDEX IX_Colaboradores_Gender ON Colaboradores(Gender);
CREATE INDEX IX_Colaboradores_Attrition ON Colaboradores(Attrition);
CREATE INDEX IX_Colaboradores_Age ON Colaboradores(Age);
CREATE INDEX IX_Colaboradores_JobRole ON Colaboradores(JobRole);
GO

PRINT 'Tabela Colaboradores criada com sucesso!';
GO
