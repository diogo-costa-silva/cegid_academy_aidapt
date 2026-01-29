-- ============================================
-- Exercicio 1 - Criacao de Tabelas (REFERENCIA)
-- AiDAPT - Cegid Academy
-- ============================================
--
-- NOTA: Este ficheiro e apenas uma REFERENCIA DIDACTICA.
-- Para executar e criar as tabelas, usar: ../dados/schema.sql
--
-- ============================================
-- Conceitos abordados:
-- - CREATE TABLE
-- - PRIMARY KEY com IDENTITY (auto-incremento)
-- - FOREIGN KEY (relacoes entre tabelas)
-- - Tipos de dados: INT, NVARCHAR, DECIMAL, DATETIME, BIT
-- - DEFAULT (valores por omissao)
-- - NOT NULL (campos obrigatorios)
-- ============================================

-- ============================================
-- MODELO DE DADOS
-- ============================================
--
-- Customers (1) ──< Orders (1) ──< OrderItems >── Products (1)
--                       │
--                       └──< Payments
--
-- Legenda: (1) = lado "um", < = lado "muitos"
-- ============================================

-- ============================================
-- 1. Tabela Customers (Clientes)
-- ============================================
-- Armazena informacao dos clientes
-- CustomerID e gerado automaticamente (IDENTITY)

CREATE TABLE dbo.Customers (
    CustomerID INT PRIMARY KEY IDENTITY(1,1),  -- PK auto-incremento
    FullName NVARCHAR(100) NOT NULL,           -- Nome obrigatorio
    Email NVARCHAR(100) NOT NULL,
    City NVARCHAR(50) NOT NULL,
    CreatedAt DATETIME DEFAULT GETDATE()       -- Data actual por omissao
);

-- ============================================
-- 2. Tabela Products (Produtos)
-- ============================================
-- Catalogo de produtos disponiveis
-- Active = 1 (activo) ou 0 (inactivo)

CREATE TABLE dbo.Products (
    ProductID INT PRIMARY KEY IDENTITY(1,1),
    ProductName NVARCHAR(100) NOT NULL,
    Category NVARCHAR(50) NOT NULL,            -- Ex: 'Courses', 'Hardware'
    Price DECIMAL(10,2) NOT NULL,              -- Preco com 2 casas decimais
    Active BIT DEFAULT 1                       -- 1=activo, 0=inactivo
);

-- ============================================
-- 3. Tabela Orders (Pedidos)
-- ============================================
-- Cada pedido pertence a UM cliente (FK)
-- Status: 'NEW', 'PAID', 'SHIPPED', 'CANCELLED'

CREATE TABLE dbo.Orders (
    OrderID INT PRIMARY KEY IDENTITY(1,1),
    CustomerID INT NOT NULL,                   -- FK para Customers
    OrderDate DATETIME NOT NULL,
    Status NVARCHAR(20) NOT NULL,

    -- Foreign Key: liga ao cliente
    CONSTRAINT FK_Orders_Customers
        FOREIGN KEY (CustomerID)
        REFERENCES dbo.Customers(CustomerID)
);

-- ============================================
-- 4. Tabela OrderItems (Itens do Pedido)
-- ============================================
-- Tabela de ligacao N:M entre Orders e Products
-- Cada linha = 1 produto num pedido

CREATE TABLE dbo.OrderItems (
    OrderItemID INT PRIMARY KEY IDENTITY(1,1),
    OrderID INT NOT NULL,                      -- FK para Orders
    ProductID INT NOT NULL,                    -- FK para Products
    Quantity INT NOT NULL,
    UnitPrice DECIMAL(10,2) NOT NULL,          -- Preco no momento da compra

    -- Foreign Keys
    CONSTRAINT FK_OrderItems_Orders
        FOREIGN KEY (OrderID)
        REFERENCES dbo.Orders(OrderID),

    CONSTRAINT FK_OrderItems_Products
        FOREIGN KEY (ProductID)
        REFERENCES dbo.Products(ProductID)
);

-- ============================================
-- 5. Tabela Payments (Pagamentos)
-- ============================================
-- Cada pagamento pertence a UM pedido
-- Method: 'CARD', 'TRANSFER', 'PIX', 'CASH'
-- Status: 'CONFIRMED', 'FAILED', 'PENDING'

CREATE TABLE dbo.Payments (
    PaymentID INT PRIMARY KEY IDENTITY(1,1),
    OrderID INT NOT NULL,                      -- FK para Orders
    PaymentDate DATETIME NOT NULL,
    Amount DECIMAL(10,2) NOT NULL,
    Method NVARCHAR(20) NOT NULL,
    Status NVARCHAR(20) NOT NULL,

    -- Foreign Key
    CONSTRAINT FK_Payments_Orders
        FOREIGN KEY (OrderID)
        REFERENCES dbo.Orders(OrderID)
);

-- ============================================
-- RESUMO DE CONCEITOS
-- ============================================
--
-- PRIMARY KEY IDENTITY(1,1)
--   - Chave primaria com auto-incremento
--   - Comeca em 1, incrementa de 1 em 1
--
-- FOREIGN KEY ... REFERENCES
--   - Cria relacao entre tabelas
--   - Garante integridade referencial
--   - Nao permite apagar pai se tiver filhos
--
-- NVARCHAR vs VARCHAR
--   - NVARCHAR suporta Unicode (acentos, etc.)
--   - VARCHAR apenas ASCII
--
-- DECIMAL(10,2)
--   - 10 digitos no total, 2 decimais
--   - Ideal para valores monetarios
--
-- BIT
--   - Tipo booleano: 0 ou 1
--   - Usado para flags (activo/inactivo)
--
-- DEFAULT GETDATE()
--   - Se nao especificado, usa data/hora actual
-- ============================================
