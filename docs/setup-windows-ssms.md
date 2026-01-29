# Setup do Projeto 1: IBM HR Analytics (Windows + SSMS)

Guia passo-a-passo para configurar o ambiente de analise no Windows usando SQL Server Management Studio.

## Pre-requisitos

- Windows 10/11
- SQL Server instalado (ou acesso a uma instancia)
- SQL Server Management Studio (SSMS) instalado
- Ficheiro `WA_Fn-UseC_-HR-Employee-Attrition.csv` disponivel

## Passo 1: Preparar o Ficheiro CSV

1. Localiza o ficheiro `WA_Fn-UseC_-HR-Employee-Attrition.csv`
2. Copia-o para um caminho simples, por exemplo:
   ```
   C:\Dados\WA_Fn-UseC_-HR-Employee-Attrition.csv
   ```
3. Confirma que o ficheiro tem 1471 linhas (1 cabecalho + 1470 registos)

**Nota**: Evita caminhos com espacos ou caracteres especiais.

---

## Passo 2: Abrir o SSMS e Ligar ao Servidor

1. Abre o **SQL Server Management Studio**
2. Na janela "Connect to Server":
   - Server type: Database Engine
   - Server name: `localhost` ou o nome do teu servidor
   - Authentication: Windows Authentication (ou SQL Server Authentication)
3. Clica **Connect**

---

## Passo 3: Criar a Base de Dados

### Opcao A: Via Interface Grafica

1. No Object Explorer (painel esquerdo), clica com o botao direito em **Databases**
2. Selecciona **New Database...**
3. No campo "Database name", escreve: `Projeto1_IBM_HR`
4. Clica **OK**

### Opcao B: Via Query SQL

1. Clica em **New Query** (barra de ferramentas)
2. Escreve e executa (F5):

```sql
CREATE DATABASE Projeto1_IBM_HR;
GO
```

3. No Object Explorer, clica direito em "Databases" → **Refresh** para ver a nova BD

---

## Passo 4: Criar a Tabela Colaboradores

1. Clica em **New Query**
2. Cola o seguinte codigo:

```sql
USE Projeto1_IBM_HR;
GO

-- Eliminar tabela se existir (para poder recriar)
IF OBJECT_ID('dbo.Colaboradores', 'U') IS NOT NULL
    DROP TABLE dbo.Colaboradores;
GO

-- Criar tabela Colaboradores
-- IMPORTANTE: Ordem das colunas igual ao CSV para facilitar importacao
CREATE TABLE Colaboradores (
    Age INT NOT NULL,
    Attrition VARCHAR(3),
    BusinessTravel VARCHAR(20),
    DailyRate INT,
    Department VARCHAR(50),
    DistanceFromHome INT,
    Education INT,
    EducationField VARCHAR(50),
    EmployeeCount INT,
    EmployeeNumber INT PRIMARY KEY,
    EnvironmentSatisfaction INT,
    Gender VARCHAR(10) NOT NULL,
    HourlyRate INT,
    JobInvolvement INT,
    JobLevel INT,
    JobRole VARCHAR(50),
    JobSatisfaction INT,
    MaritalStatus VARCHAR(20),
    MonthlyIncome INT,
    MonthlyRate INT,
    NumCompaniesWorked INT,
    Over18 VARCHAR(1),
    OverTime VARCHAR(3),
    PercentSalaryHike INT,
    PerformanceRating INT,
    RelationshipSatisfaction INT,
    StandardHours INT,
    StockOptionLevel INT,
    TotalWorkingYears INT,
    TrainingTimesLastYear INT,
    WorkLifeBalance INT,
    YearsAtCompany INT,
    YearsInCurrentRole INT,
    YearsSinceLastPromotion INT,
    YearsWithCurrManager INT
);
GO

PRINT 'Tabela Colaboradores criada com sucesso!';
GO
```

3. Executa com **F5** ou clicando em **Execute**
4. Deves ver a mensagem "Tabela Colaboradores criada com sucesso!"

---

## Passo 5: Importar o CSV

Tens duas opcoes. Recomendo a **Opcao A** para quem esta a comecar.

### Opcao A: Import Wizard (Interface Grafica)

1. No Object Explorer, expande **Databases** → **Projeto1_IBM_HR**
2. Clica com o botao direito em **Projeto1_IBM_HR**
3. Selecciona **Tasks** → **Import Data...**
4. No assistente "SQL Server Import and Export Wizard":

   **Pagina 1 - Choose a Data Source:**
   - Data source: `Flat File Source`
   - File name: Browse → selecciona o CSV
   - Locale: Portuguese (Portugal) ou English
   - Code page: 65001 (UTF-8)
   - Format: Delimited
   - Text qualifier: `"`
   - Header row delimiter: {CR}{LF}
   - Header rows to skip: 0
   - Column names in the first data row: **Marcado** ✓
   - Clica **Next**

   **Pagina 2 - Columns:**
   - Row delimiter: {CR}{LF}
   - Column delimiter: Comma {,}
   - Pre-visualiza os dados para confirmar que estao correctos
   - Clica **Next**

   **Pagina 3 - Choose a Destination:**
   - Destination: SQL Server Native Client 11.0
   - Server name: localhost (ou o teu servidor)
   - Database: Projeto1_IBM_HR
   - Clica **Next**

   **Pagina 4 - Select Source Tables and Views:**
   - Source: o teu ficheiro CSV
   - Destination: `[dbo].[Colaboradores]`
   - Clica **Edit Mappings...** para verificar se as colunas correspondem
   - Clica **Next**

   **Pagina 5 - Run Package:**
   - Run immediately: **Marcado** ✓
   - Clica **Finish**

5. Aguarda a importacao. Deves ver "1470 rows transferred"
6. Clica **Close**

### Opcao B: BULK INSERT (Query SQL)

1. Clica em **New Query**
2. Cola e executa:

```sql
USE Projeto1_IBM_HR;
GO

BULK INSERT Colaboradores
FROM 'C:\Dados\WA_Fn-UseC_-HR-Employee-Attrition.csv'
WITH (
    FIRSTROW = 2,           -- Ignora a linha de cabecalho
    FIELDTERMINATOR = ',',  -- Separador de campos
    ROWTERMINATOR = '\n',   -- Separador de linhas (ou '\r\n' no Windows)
    CODEPAGE = '65001'      -- UTF-8
);
GO

PRINT 'Importacao concluida!';
GO
```

**Nota**: Se der erro de permissoes, tenta:
- Mover o CSV para `C:\Temp\` ou `C:\`
- Ou executar o SSMS como Administrador

---

## Passo 6: Verificar a Importacao

Executa estas queries para confirmar que os dados foram importados correctamente:

```sql
USE Projeto1_IBM_HR;
GO

-- Deve retornar 1470
SELECT COUNT(*) AS TotalRegistos FROM Colaboradores;

-- Ver os primeiros 10 registos
SELECT TOP 10
    EmployeeNumber, Age, Gender, Department, JobRole, MonthlyIncome, Attrition
FROM Colaboradores
ORDER BY EmployeeNumber;

-- Verificar distribuicao por genero
SELECT Gender, COUNT(*) AS Total FROM Colaboradores GROUP BY Gender;

-- Verificar distribuicao por departamento
SELECT Department, COUNT(*) AS Total FROM Colaboradores GROUP BY Department;
```

**Resultados esperados:**
- Total: 1470 registos
- Female: 588, Male: 882
- R&D: 961, Sales: 446, HR: 63

---

## Passo 7: Criar Indices (Opcional mas Recomendado)

Os indices aceleram as consultas. Executa:

```sql
USE Projeto1_IBM_HR;
GO

CREATE INDEX IX_Colaboradores_Department ON Colaboradores(Department);
CREATE INDEX IX_Colaboradores_Gender ON Colaboradores(Gender);
CREATE INDEX IX_Colaboradores_Attrition ON Colaboradores(Attrition);
CREATE INDEX IX_Colaboradores_Age ON Colaboradores(Age);
CREATE INDEX IX_Colaboradores_JobRole ON Colaboradores(JobRole);
GO

PRINT 'Indices criados com sucesso!';
GO
```

---

## Passo 8: Executar as Analises

Agora podes executar os ficheiros de analise SQL:

1. Abre cada ficheiro no SSMS (File → Open → File...)
2. Ou cola o conteudo numa New Query
3. Executa com F5

Ficheiros de analise disponiveis:
- `analise_exploratoria.sql` - Visao geral da populacao
- `analise_genero.sql` - Igualdade de genero
- `analise_felicidade.sql` - Indicadores de satisfacao
- `analise_envelhecimento.sql` - Idade e reforma
- `analise_attrition.sql` - Perfil de quem sai
- `analise_adicional.sql` - Questoes especificas

---

## Resolucao de Problemas

### Erro: "Cannot bulk load"
- Verifica se o caminho do CSV esta correcto
- Tenta mover o CSV para `C:\Temp\`
- Executa SSMS como Administrador

### Erro: "Column name or number of supplied values does not match"
- A ordem das colunas na tabela tem de ser igual a ordem no CSV
- Recria a tabela usando o script do Passo 4

### Erro: "String or binary data would be truncated"
- Algum campo no CSV e maior que o definido na tabela
- Verifica os tamanhos dos VARCHAR

### Import Wizard nao aparece
- Pode ser necessario instalar o SQL Server Integration Services (SSIS)
- Usa o BULK INSERT como alternativa

---

## Estrutura Final

Apos completar o setup, tens:

```
SQL Server
└── Projeto1_IBM_HR (base de dados)
    └── Colaboradores (tabela)
        ├── 1470 registos
        ├── 35 colunas
        └── 5 indices
```

---

## Proximos Passos

1. Executar os ficheiros de analise SQL
2. Exportar resultados para Excel (clique direito nos resultados → Save Results As...)
3. Criar visualizacoes no Power BI
4. Preparar apresentacao executiva

---

*Documento criado em 28-Jan-2026 para o Projeto 1: IBM HR Analytics*
