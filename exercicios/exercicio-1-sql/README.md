# Exercicio 1 - Fundamentos SQL

Primeiro conjunto de exercicios SQL do programa AiDAPT da Cegid Academy.

## Conteudo

| Ficheiro | Descricao |
|----------|-----------|
| [enunciado.md](./enunciado.md) | Enunciado completo dos exercicios |
| [dados/schema.sql](./dados/schema.sql) | Criacao das tabelas (DDL) |
| [dados/seed.sql](./dados/seed.sql) | Insercao dos dados (INSERT) |
| [exercicios/](./exercicios/) | Resolucoes SQL e notebooks Jupyter |

## Exercicios

| # | Tema | Queries | Conceitos |
|---|------|---------|-----------|
| 1 | Criacao de Tabelas | 5 | CREATE TABLE, PRIMARY KEY, FOREIGN KEY |
| 2 | SELECT Basico | 5 | SELECT, ORDER BY, DISTINCT, TOP |
| 3 | WHERE | 7 | WHERE, LIKE, IN, DATEADD |
| 4 | GROUP BY / HAVING | 7 | GROUP BY, HAVING, AVG, COUNT, SUM |
| 5 | JOINs | 8 | INNER JOIN, LEFT JOIN, anti-join |
| 6 | UPDATE | 4 | UPDATE, SET, condicoes |
| 7 | DELETE | 4 | DELETE, subconsultas, NOT IN |
| 8 | Northwind | 15 | CASE WHEN, UPPER, ISNULL, BETWEEN |
| 9 | AdventureWorks | 12 | CTE, ROW_NUMBER, subconsultas avancadas |
| **Total** | | **62** | |

## Bases de Dados

### ExerciciosDB (Exercicios 1-7)

Base de dados criada para os exercicios, com o seguinte modelo:

```
Customers (1) ──< Orders (1) ──< OrderItems
                     │
                     └──< Payments

Products (1) ──< OrderItems
```

**Tabelas:**
- `Customers` - 8 clientes
- `Products` - 10 produtos (3 categorias)
- `Orders` - 12 pedidos
- `OrderItems` - 20 itens
- `Payments` - 7 pagamentos

### Northwind (Exercicio 8)

Base de dados classica de vendas de alimentos (1996-1998).

**Tabelas principais:** Employees, Suppliers, Customers, Orders, Products

### AdventureWorks2022 (Exercicio 9)

Base de dados completa de um fabricante de bicicletas.

**Schemas utilizados:**
- `Production` - Produtos e categorias
- `Sales` - Vendas e clientes
- `HumanResources` - Funcionarios
- `Person` - Pessoas e enderecos

## Como Executar

### 1. Configurar credenciais

```bash
cp ../../.env.example ../../.env
# Editar .env com a password do SQL Server
```

### 2. Criar base ExerciciosDB

```sql
-- Executar em ordem:
-- 1. dados/schema.sql
-- 2. dados/seed.sql
```

### 3. Executar exercicios

Os ficheiros `.sql` e `.ipynb` estao em `exercicios/`. Cada exercicio tem versao SQL pura e notebook Jupyter.

## Notas

- As queries foram testadas em SQL Server 2022
- Os exercicios 6 (UPDATE) e 7 (DELETE) modificam dados - usar com cuidado
- Recomenda-se usar transaccoes (`BEGIN TRAN` / `ROLLBACK`) para testar

---

*Programa AiDAPT - Cegid Academy 2025/2026*
