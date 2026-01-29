# AiDAPT - Bases de Dados SQL - Exercicios

Programa de formacao em Data Analytics e Business Intelligence da **Cegid Academy**.

---

## Exercicio 1 - Desafio Inicial

### Criar as tabelas

| Tabela | Colunas |
|--------|---------|
| `Customers` | CustomerID, FullName, Email, City, CreatedAt |
| `Products` | ProductID, ProductName, Category, Price, Active |
| `Orders` | OrderID, CustomerID, OrderDate, Status |
| `OrderItems` | OrderItemID, OrderID, ProductID, Quantity, UnitPrice |
| `Payments` | PaymentID, OrderID, PaymentDate, Amount, Method, Status |

### Relacionamentos (Foreign Keys)

- `Orders.CustomerID` → `Customers.CustomerID`
- `OrderItems.OrderID` → `Orders.OrderID`
- `OrderItems.ProductID` → `Products.ProductID`
- `Payments.OrderID` → `Orders.OrderID`

### Inserir dados

Ver ficheiros em `dados/`:
- `schema.sql` - Criacao das tabelas
- `seed.sql` - Insercao dos dados

---

## Exercicio 2 - SELECT: A Jornada Comeca

1. Liste todos os clientes
2. Liste FullName, Email, City
3. Liste os produtos ordenados por Price DESC
4. Liste as categorias distintas
5. Liste os 5 produtos mais caros (TOP 5)

---

## Exercicio 3 - WHERE

1. Produtos com preco maior que 100
2. Clientes da cidade "Porto"
3. Pedidos com status CANCELLED
4. Pedidos dos ultimos 30 dias (DATEADD)
5. Produtos das categorias "Accessories" ou "Hardware"
6. Produtos com nome contendo "Course"
7. Clientes com email terminando em ".com"

---

## Exercicio 4 - GROUP BY / HAVING

1. Preco medio por categoria
2. Quantidade de produtos por categoria
3. Quantidade de pedidos por status
4. Total confirmado recebido (SUM payments)
5. Total pago por cliente
6. Clientes com total gasto > 300 (HAVING)
7. Total de cada pedido (somar itens)

---

## Exercicio 5 - JOINs

1. INNER JOIN: pedidos + nome do cliente
2. INNER JOIN: itens + nome do produto
3. Total do pedido com nome do cliente
4. Pagamentos com nome do cliente e status do pedido
5. LEFT JOIN: clientes e seus pedidos
6. Clientes que NAO possuem pedidos (anti-join)
7. Pedidos SEM pagamento confirmado
8. Pedidos com mais de 2 itens

---

## Exercicio 6 - UPDATE

1. Aumentar em 10% produtos da categoria "Accessories"
2. Marcar Active=0 para produtos com preco < 5
3. Alterar status de pedidos NEW para CANCELLED se tiverem mais de 7 dias
4. Corrigir o email de um cliente

---

## Exercicio 7 - DELETE

1. Remover pagamentos FAILED
2. Remover pedidos CANCELLED (se nao houver pagamentos confirmados)
3. Remover produtos inativos que nunca foram vendidos
4. Remover clientes sem pedido

---

## Exercicio 8 - SQL: Northwind

> **Base de dados**: Northwind (classica, vendas de alimentos)

1. Mostrar o primeiro nome, apelido e data de nascimento dos empregados que sao Sales Managers, ordenados por data de nascimento
2. Criar uma lista de empregados com o nome completo em maiusculas numa unica coluna e criar uma coluna de saida chamada Genero, com base no campo Title of Courtesy (Mrs. e Ms. sao do sexo feminino e Mr. do sexo masculino). Considerar que pode existir um empregado sem genero definido, que deve aparecer como "Desconhecido"
3. Selecionar todas as empresas fornecedoras e respetiva pessoa de contacto que sejam da Alemanha
4. Criar uma lista com o nome da empresa fornecedora e a pessoa de contacto que nao sejam dos Estados Unidos
5. Selecionar todos os IDs e nomes dos clientes que sejam do Reino Unido e de Londres
6. Identificar os clientes do Reino Unido que nao estao sediados em Londres
7. Selecionar as pessoas de contacto dos fornecedores cujo titulo de contacto comeca por "Marketing" ou termina com "Marketing"
8. Mostrar todos os fornecedores que sejam japoneses e trabalhem em marketing ou todos os fornecedores que sejam proprietarios do negocio (business owners)
9. Criar uma lista de clientes com o nome do cliente numa coluna, pais, regiao e cidade. Quando o campo regiao for nulo, mostrar "Regiao nao definida"
10. Identificar os fornecedores com quem trabalhamos que nao tem site nem numero de fax
11. Selecionar todos os clientes que nao sejam de Italia, Franca ou Espanha
12. Mostrar o nome da empresa fornecedora, o nome da pessoa de contacto e o titulo de contacto, considerando que os que sao Owners devem aparecer como "Owner - Nao especificado"
13. Mostrar todas as encomendas cujo valor do Freight (porte) seja maior ou igual a 5 e menor ou igual a 10, que tenham sido enviadas para os Estados Unidos e para as quais ja conhecemos a data de envio
14. Selecionar as encomendas para as quais nao temos a data de envio e tambem nao conhecemos a regiao
15. Criar uma lista de encomendas que foram enviadas para o Reino Unido (UK) e cujo Freight seja inferior a 40, ou encomendas cujo CustomerID seja "ALFKI" e Freight tambem seja inferior a 40

---

## Exercicio 9 - SQL: AdventureWorks

> **Base de dados**: AdventureWorks2022 (fabricante de bicicletas)

1. Qual e o produto mais vendido em termos de valor total?
2. Quantos produtos tiveram mais de 100 unidades vendidas?
3. Que produtos venderam mais de 100 unidades no 1.o trimestre de 2013?
4. Quais sao as subcategorias de produtos com pelo menos 5 produtos e qual a media do preco por subcategoria?
5. Quantas pessoas existem por titulo e qual o titulo menos e mais frequente?
6. Quantos funcionarios existem por nivel organizacional e qual a media de horas de ferias?
7. Para cada cliente, qual o numero de encomendas e o valor total faturado em 2013?
8. Quais sao as 10 cidades com maior valor de vendas, considerando a morada de envio?
9. Para cada subcategoria, qual e o produto com maior receita no ano de 2012?
10. Para cada vendedor, qual a receita total e uma margem bruta aproximada?
11. Produtos que NUNCA foram vendidos (sem linhas em SalesOrderDetail)
12. Produtos cujo ListPrice e superior a media do ListPrice da sua subcategoria

---

## Resumo de Conceitos por Exercicio

| Exercicio | Conceitos SQL |
|-----------|---------------|
| 1 | CREATE TABLE, PRIMARY KEY, FOREIGN KEY, INSERT |
| 2 | SELECT, FROM, ORDER BY, DISTINCT, TOP |
| 3 | WHERE, operadores, LIKE, IN, DATEADD |
| 4 | GROUP BY, HAVING, AVG, COUNT, SUM |
| 5 | INNER JOIN, LEFT JOIN, anti-join |
| 6 | UPDATE, SET, condicoes complexas |
| 7 | DELETE, subconsultas, NOT IN, NOT EXISTS |
| 8 | CASE WHEN, UPPER, ISNULL, BETWEEN, IS NULL |
| 9 | Subconsultas, ROW_NUMBER, CTE, agregacoes avancadas |

---

*Documento original: AiDAPT_BasesDadosSQL_Exercicios.docx*
