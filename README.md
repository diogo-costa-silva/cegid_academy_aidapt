# Cegid Academy - Programa AiDAPT

Exercicios e projetos de SQL e Data Analytics do programa **AiDAPT** da [Cegid Academy](https://www.cegid.com/pt/cegid-academy/).

Formacao em Data Analytics e Business Intelligence (2025/2026).

## Conteudo

| Tipo | Nome | Descricao |
|------|------|-----------|
| [Exercicio 1](./exercicios/exercicio-1-sql/) | Fundamentos SQL | 62 queries SQL cobrindo DDL, DML, JOINs, agregacoes |
| [Projeto 1](./projetos/projeto-1-ibm-hr/) | IBM HR Analytics | Analise de 1470 colaboradores - 129 queries, 46 questoes |
| [Docs](./docs/) | Guias de setup | Configuracao de ambiente (Docker, SSMS) |

## Setup

### 1. SQL Server (Docker)

```bash
docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=<your_password>" \
  -p 1433:1433 --name sqlserver \
  -d mcr.microsoft.com/mssql/server:2022-latest
```

### 2. Dependencias Python

```bash
# Instalar uv (se necessario)
curl -LsSf https://astral.sh/uv/install.sh | sh

# Instalar dependencias
uv sync
```

### 3. Credenciais

```bash
cp .env.example .env
# Editar .env com a password do SQL Server
```

### 4. Jupyter Notebooks

Os notebooks usam [JupySQL](https://jupysql.ploomber.io/) para executar queries SQL directamente. A conexao e configurada via `.env`.

## Bases de Dados

| Base de Dados | Exercicio/Projeto | Descricao |
|---------------|-------------------|-----------|
| ExerciciosDB | Exercicio 1 (ex01-ex07) | Base criada para exercicios (5 tabelas) |
| Northwind | Exercicio 1 (ex08) | Classica, vendas de alimentos (1996-1998) |
| AdventureWorks2022 | Exercicio 1 (ex09) | Fabricante de bicicletas (OLTP) |
| Projeto1_IBM_HR | Projeto 1 | IBM HR Analytics (1470 colaboradores) |

## Tecnologias

- **SQL Server 2022** (Docker)
- **Python 3.12** + JupySQL + pymssql
- **UV** (gestor de pacotes)

## Autor

**Diogo Silva** - Formando AiDAPT 2025/2026

---

*Programa AiDAPT - Cegid Academy 2025/2026*
