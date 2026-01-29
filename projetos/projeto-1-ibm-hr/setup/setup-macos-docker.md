# Setup do Projeto 1: IBM HR Analytics (macOS + Docker)

Guia passo-a-passo para configurar o ambiente de analise no macOS usando Docker e SQL Server.

## Pre-requisitos

- macOS (Intel ou Apple Silicon)
- Docker Desktop ou OrbStack instalado
- Terminal (ou iTerm2)
- Ficheiro `WA_Fn-UseC_-HR-Employee-Attrition.csv` disponivel

---

## Passo 1: Instalar e Configurar o Docker

### Se ainda nao tens Docker:

**Opcao A: Docker Desktop**
```bash
# Instalar via Homebrew
brew install --cask docker

# Abrir Docker Desktop
open -a Docker
```

**Opcao B: OrbStack (Recomendado - mais leve)**
```bash
# Instalar via Homebrew
brew install --cask orbstack

# Abrir OrbStack
open -a OrbStack
```

### Verificar que o Docker esta a funcionar:
```bash
docker --version
# Deve mostrar algo como: Docker version 24.x.x
```

---

## Passo 2: Criar o Container SQL Server

### Para Apple Silicon (M1/M2/M3):

```bash
docker run -e "ACCEPT_EULA=Y" \
  -e "MSSQL_SA_PASSWORD=MinhaPassword123!" \
  -p 1433:1433 \
  --name sqlserver \
  --hostname sqlserver \
  -d mcr.microsoft.com/mssql/server:2022-latest
```

### Para Intel Mac:

```bash
docker run -e "ACCEPT_EULA=Y" \
  -e "MSSQL_SA_PASSWORD=MinhaPassword123!" \
  -p 1433:1433 \
  --name sqlserver \
  --hostname sqlserver \
  -d mcr.microsoft.com/mssql/server:2022-latest
```

### Verificar que o container esta a correr:
```bash
docker ps
# Deve mostrar o container "sqlserver" com status "Up"
```

### Aguardar o SQL Server iniciar (30-60 segundos):
```bash
# Ver os logs do container
docker logs sqlserver

# Quando vires "SQL Server is now ready for client connections" esta pronto
```

---

## Passo 3: Testar a Ligacao

```bash
# Testar ligacao ao SQL Server
docker exec sqlserver /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'MinhaPassword123!' -C \
  -Q "SELECT @@VERSION"
```

Deves ver a versao do SQL Server (ex: "Microsoft SQL Server 2022").

**Nota**: A flag `-C` e necessaria para aceitar o certificado auto-assinado.

---

## Passo 4: Criar a Base de Dados

```bash
docker exec sqlserver /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'MinhaPassword123!' -C \
  -Q "CREATE DATABASE Projeto1_IBM_HR"
```

### Verificar que foi criada:
```bash
docker exec sqlserver /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'MinhaPassword123!' -C \
  -Q "SELECT name FROM sys.databases WHERE name = 'Projeto1_IBM_HR'"
```

---

## Passo 5: Criar a Tabela

Cria um ficheiro `schema.sql` com o seguinte conteudo:

```sql
USE Projeto1_IBM_HR;

-- Eliminar tabela se existir
IF OBJECT_ID('dbo.Colaboradores', 'U') IS NOT NULL
    DROP TABLE dbo.Colaboradores;

-- Criar tabela Colaboradores
-- IMPORTANTE: Ordem das colunas igual ao CSV
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
```

### Executar o schema:

**Opcao A: Copiar ficheiro para o container e executar**
```bash
# Copiar o ficheiro SQL para o container
docker cp schema.sql sqlserver:/tmp/schema.sql

# Executar o ficheiro
docker exec sqlserver /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'MinhaPassword123!' -C \
  -i /tmp/schema.sql
```

**Opcao B: Executar directamente (para comandos curtos)**
```bash
docker exec sqlserver /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'MinhaPassword123!' -C \
  -d Projeto1_IBM_HR \
  -Q "CREATE TABLE Colaboradores (Age INT NOT NULL, ...)"
```

---

## Passo 6: Importar o CSV

### 6.1 Copiar o CSV para dentro do container:

```bash
# Navegar ate a pasta onde esta o CSV
cd /caminho/para/Projeto_1

# Copiar o CSV para o container
docker cp WA_Fn-UseC_-HR-Employee-Attrition.csv sqlserver:/var/opt/mssql/data/
```

### 6.2 Verificar que o ficheiro foi copiado:

```bash
docker exec sqlserver ls -la /var/opt/mssql/data/WA_Fn-UseC_-HR-Employee-Attrition.csv
```

### 6.3 Executar o BULK INSERT:

```bash
docker exec sqlserver /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'MinhaPassword123!' -C \
  -d Projeto1_IBM_HR \
  -Q "BULK INSERT Colaboradores
      FROM '/var/opt/mssql/data/WA_Fn-UseC_-HR-Employee-Attrition.csv'
      WITH (FIRSTROW = 2, FIELDTERMINATOR = ',', ROWTERMINATOR = '\n', TABLOCK)"
```

---

## Passo 7: Verificar a Importacao

```bash
# Contar registos (deve ser 1470)
docker exec sqlserver /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'MinhaPassword123!' -C \
  -d Projeto1_IBM_HR \
  -Q "SELECT COUNT(*) AS TotalRegistos FROM Colaboradores"

# Ver os primeiros 5 registos
docker exec sqlserver /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'MinhaPassword123!' -C \
  -d Projeto1_IBM_HR \
  -Q "SELECT TOP 5 EmployeeNumber, Age, Gender, Department FROM Colaboradores"

# Verificar distribuicao por genero
docker exec sqlserver /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'MinhaPassword123!' -C \
  -d Projeto1_IBM_HR \
  -Q "SELECT Gender, COUNT(*) AS Total FROM Colaboradores GROUP BY Gender"
```

**Resultados esperados:**
- Total: 1470 registos
- Female: 588, Male: 882

---

## Passo 8: Criar Indices

```bash
docker exec sqlserver /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'MinhaPassword123!' -C \
  -d Projeto1_IBM_HR \
  -Q "CREATE INDEX IX_Colaboradores_Department ON Colaboradores(Department);
      CREATE INDEX IX_Colaboradores_Gender ON Colaboradores(Gender);
      CREATE INDEX IX_Colaboradores_Attrition ON Colaboradores(Attrition);
      CREATE INDEX IX_Colaboradores_Age ON Colaboradores(Age);
      CREATE INDEX IX_Colaboradores_JobRole ON Colaboradores(JobRole);"
```

---

## Passo 9: Executar Queries de Analise

### Executar um ficheiro SQL:

```bash
# Copiar o ficheiro de analise para o container
docker cp analise_exploratoria.sql sqlserver:/tmp/

# Executar
docker exec sqlserver /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'MinhaPassword123!' -C \
  -d Projeto1_IBM_HR \
  -i /tmp/analise_exploratoria.sql
```

### Executar uma query directamente:

```bash
docker exec sqlserver /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'MinhaPassword123!' -C \
  -d Projeto1_IBM_HR \
  -Q "SELECT Department, Gender, COUNT(*) AS Total
      FROM Colaboradores
      GROUP BY Department, Gender
      ORDER BY Department"
```

---

## Comandos Uteis do Docker

### Gestao do Container

```bash
# Ver containers a correr
docker ps

# Ver todos os containers (incluindo parados)
docker ps -a

# Parar o container
docker stop sqlserver

# Iniciar o container
docker start sqlserver

# Reiniciar o container
docker restart sqlserver

# Ver logs do container
docker logs sqlserver

# Ver logs em tempo real
docker logs -f sqlserver
```

### Acesso Interactivo

```bash
# Entrar no container com bash
docker exec -it sqlserver bash

# Entrar directamente no sqlcmd (modo interactivo)
docker exec -it sqlserver /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'MinhaPassword123!' -C

# Dentro do sqlcmd:
# - Escreve queries e pressiona Enter
# - Escreve GO e pressiona Enter para executar
# - Escreve EXIT para sair
```

### Limpeza

```bash
# Remover o container (perde todos os dados!)
docker rm -f sqlserver

# Remover imagem do SQL Server
docker rmi mcr.microsoft.com/mssql/server:2022-latest
```

---

## Criar um Alias para Facilitar (Opcional)

Adiciona ao teu `~/.zshrc` ou `~/.bashrc`:

```bash
# Alias para executar queries SQL
alias sqlcmd='docker exec sqlserver /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P "MinhaPassword123!" -C'

# Uso:
# sqlcmd -Q "SELECT * FROM sys.databases"
# sqlcmd -d Projeto1_IBM_HR -Q "SELECT COUNT(*) FROM Colaboradores"
```

Depois executa `source ~/.zshrc` para activar.

---

## Alternativa: Usar Azure Data Studio

Se preferires uma interface grafica no Mac:

1. Instala o Azure Data Studio:
   ```bash
   brew install --cask azure-data-studio
   ```

2. Abre o Azure Data Studio

3. Nova Ligacao:
   - Server: `localhost,1433`
   - Authentication: SQL Login
   - User: `sa`
   - Password: `MinhaPassword123!`
   - Trust server certificate: Yes

4. Agora podes executar queries com interface grafica!

---

## Resolucao de Problemas

### Erro: "Cannot connect to server"
```bash
# Verificar se o container esta a correr
docker ps

# Se nao estiver, iniciar
docker start sqlserver

# Aguardar 30 segundos e tentar novamente
```

### Erro: "Login failed for user 'sa'"
- Verifica se a password esta correcta
- Verifica se usaste aspas simples a volta da password

### Erro: "Cannot bulk load - file does not exist"
```bash
# Verificar se o ficheiro esta no container
docker exec sqlserver ls -la /var/opt/mssql/data/

# Se nao estiver, copiar novamente
docker cp ficheiro.csv sqlserver:/var/opt/mssql/data/
```

### Erro: "The container name sqlserver is already in use"
```bash
# Remover o container antigo
docker rm -f sqlserver

# Criar novamente
docker run ... (comando do Passo 2)
```

### Container para apos reiniciar o Mac
```bash
# Iniciar o container manualmente
docker start sqlserver

# Ou configurar para iniciar automaticamente
docker update --restart unless-stopped sqlserver
```

---

## Estrutura Final

Apos completar o setup, tens:

```
Docker
└── Container: sqlserver
    └── SQL Server 2022
        └── Projeto1_IBM_HR (base de dados)
            └── Colaboradores (tabela)
                ├── 1470 registos
                ├── 35 colunas
                └── 5 indices
```

---

## Resumo de Comandos

```bash
# 1. Criar container
docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=MinhaPassword123!" \
  -p 1433:1433 --name sqlserver -d mcr.microsoft.com/mssql/server:2022-latest

# 2. Criar base de dados
docker exec sqlserver /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'MinhaPassword123!' -C \
  -Q "CREATE DATABASE Projeto1_IBM_HR"

# 3. Copiar ficheiros
docker cp schema.sql sqlserver:/tmp/
docker cp WA_Fn-UseC_-HR-Employee-Attrition.csv sqlserver:/var/opt/mssql/data/

# 4. Criar tabela
docker exec sqlserver /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'MinhaPassword123!' -C \
  -i /tmp/schema.sql

# 5. Importar dados
docker exec sqlserver /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'MinhaPassword123!' -C \
  -d Projeto1_IBM_HR \
  -Q "BULK INSERT Colaboradores FROM '/var/opt/mssql/data/WA_Fn-UseC_-HR-Employee-Attrition.csv' WITH (FIRSTROW=2, FIELDTERMINATOR=',', ROWTERMINATOR='\n')"

# 6. Verificar
docker exec sqlserver /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'MinhaPassword123!' -C \
  -d Projeto1_IBM_HR \
  -Q "SELECT COUNT(*) FROM Colaboradores"
```

---

*Documento criado em 28-Jan-2026 para o Projeto 1: IBM HR Analytics*
