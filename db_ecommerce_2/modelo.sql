-- =======================================================
-- Criação do Banco de Dados
-- =======================================================
CREATE DATABASE db_ecommerce;
USE db_ecommerce;

-- =======================================================
-- Tabela Clientes
-- =======================================================
CREATE TABLE tb_clientes (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE,
    telefone VARCHAR(50)
);

-- =======================================================
-- Cliente Pessoa Física
-- =======================================================
CREATE TABLE tb_clientes_pf (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    cliente_id BIGINT NOT NULL,
    cpf VARCHAR(14) UNIQUE NOT NULL,
    FOREIGN KEY (cliente_id) REFERENCES tb_clientes(id)
);

-- =======================================================
-- Cliente Pessoa Jurídica
-- =======================================================
CREATE TABLE tb_clientes_pj (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    cliente_id BIGINT NOT NULL,
    cnpj VARCHAR(18) UNIQUE NOT NULL,
    razao_social VARCHAR(255) NOT NULL,
    FOREIGN KEY (cliente_id) REFERENCES tb_clientes(id)
);

-- =======================================================
-- Endereços
-- =======================================================
CREATE TABLE tb_enderecos (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    cliente_id BIGINT NOT NULL,
    logradouro VARCHAR(255),
    cidade VARCHAR(100),
    estado VARCHAR(2),
    cep VARCHAR(10),
    tipo VARCHAR(50), -- residencial, comercial, entrega
    FOREIGN KEY (cliente_id) REFERENCES tb_clientes(id)
);

-- =======================================================
-- Fornecedores
-- =======================================================
CREATE TABLE tb_fornecedores (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    razao_social VARCHAR(255) NOT NULL,
    cnpj VARCHAR(18) UNIQUE NOT NULL
);

-- =======================================================
-- Produtos
-- =======================================================
CREATE TABLE tb_produtos (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    descricao VARCHAR(255),
    categoria VARCHAR(100),
    valor DECIMAL(10,2) NOT NULL,
    fornecedor_id BIGINT NOT NULL,
    FOREIGN KEY (fornecedor_id) REFERENCES tb_fornecedores(id)
);

-- =======================================================
-- Vendedores Terceiros
-- =======================================================
CREATE TABLE tb_vendedores_terceiros (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    razao_social VARCHAR(255) NOT NULL,
    local VARCHAR(255)
);

-- =======================================================
-- Produtos Vendidos por Terceiros (PK composta)
-- =======================================================
CREATE TABLE tb_produtos_vendedores (
    vendedor_terceiro_id BIGINT NOT NULL,
    produto_id BIGINT NOT NULL,
    quantidade INT NOT NULL,
    PRIMARY KEY (vendedor_terceiro_id, produto_id),
    FOREIGN KEY (vendedor_terceiro_id) REFERENCES tb_vendedores_terceiros(id),
    FOREIGN KEY (produto_id) REFERENCES tb_produtos(id)
);

-- =======================================================
-- Pedidos
-- =======================================================
CREATE TABLE tb_pedidos (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    cliente_id BIGINT NOT NULL,
    data_pedido DATETIME DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(50),
    valor_frete DECIMAL(10,2),
    prazo_devolucao INT, -- dias
    cancelado BOOLEAN DEFAULT FALSE,
    endereco_id BIGINT NOT NULL,
    FOREIGN KEY (cliente_id) REFERENCES tb_clientes(id),
    FOREIGN KEY (endereco_id) REFERENCES tb_enderecos(id)
);

-- =======================================================
-- Relacionamento Pedidos - Produtos (PK composta)
-- =======================================================
CREATE TABLE tb_pedidos_produtos (
    pedido_id BIGINT NOT NULL,
    produto_id BIGINT NOT NULL,
    quantidade INT NOT NULL,
    PRIMARY KEY (pedido_id, produto_id),
    FOREIGN KEY (pedido_id) REFERENCES tb_pedidos(id),
    FOREIGN KEY (produto_id) REFERENCES tb_produtos(id)
);

-- =======================================================
-- Pagamentos
-- =======================================================
CREATE TABLE tb_pagamentos (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    pedido_id BIGINT NOT NULL,
    tipo VARCHAR(50), -- cartão, pix, boleto
    status VARCHAR(50),
    valor DECIMAL(10,2) NOT NULL,
    data_pagamento DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (pedido_id) REFERENCES tb_pedidos(id)
);

-- =======================================================
-- Entregas
-- =======================================================
CREATE TABLE tb_entregas (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    pedido_id BIGINT NOT NULL,
    status VARCHAR(50),
    codigo_rastreio VARCHAR(50),
    data_envio DATETIME,
    data_entrega DATETIME,
    FOREIGN KEY (pedido_id) REFERENCES tb_pedidos(id)
);

-- =======================================================
-- Inserts de Exemplo
-- =======================================================

-- Clientes
INSERT INTO tb_clientes (nome, email, telefone) VALUES
('João Silva', 'joao@email.com', '11999999999'),
('EXperience', 'contato@empresa.com', '1133334444'),
('Maria Souza', 'maria@email.com', '11988887777'),
('Carlos Pereira', 'carlos@empresa.com', '11977776666'),
('Startup Tech', 'contato@startup.com', '1133335555');

-- Cliente PF
INSERT INTO tb_clientes_pf (cliente_id, cpf) VALUES
(1, '123.456.789-00'),
(3, '987.654.321-00'),
(4, '456.789.123-99');

-- Cliente PJ
INSERT INTO tb_clientes_pj (cliente_id, cnpj, razao_social) VALUES
(2, '12.345.678/0001-90', 'Empresa X Ltda'),
(5, '98.765.432/0001-11', 'Startup Tech Ltda');

-- Endereços
INSERT INTO tb_enderecos (cliente_id, logradouro, cidade, estado, cep, tipo) VALUES
(1, 'Rua A, 123', 'São Paulo', 'SP', '01000-000', 'residencial'),
(2, 'Av. Central, 500', 'São Paulo', 'SP', '02000-000', 'comercial'),
(3, 'Rua B, 456', 'São Paulo', 'SP', '01100-000', 'residencial'),
(4, 'Av. Paulista, 1500', 'São Paulo', 'SP', '01310-000', 'residencial'),
(5, 'Av. das Nações, 200', 'São Paulo', 'SP', '01420-000', 'comercial');

-- Fornecedores
INSERT INTO tb_fornecedores (razao_social, cnpj) VALUES
('Fornecedor Alpha', '11.111.111/0001-11'),
('Fornecedor Beta', '22.222.222/0001-22'),
('Fornecedor Gama', '33.333.333/0001-33'),
('Fornecedor Delta', '44.444.444/0001-44');

-- Produtos
INSERT INTO tb_produtos (descricao, categoria, valor, fornecedor_id) VALUES
('Notebook Gamer', 'Informática', 5500.00, 1),
('Smartphone XYZ', 'Telefonia', 2500.00, 2),
('Teclado Mecânico', 'Informática', 350.00, 3),
('Mouse Gamer', 'Informática', 150.00, 3),
('Monitor 24"', 'Informática', 1200.00, 4),
('Cadeira Gamer', 'Móveis', 900.00, 4);

-- Vendedores Terceiros
INSERT INTO tb_vendedores_terceiros (razao_social, local) VALUES
('Loja Tech', 'São Paulo'),
('Distribuidora Digital', 'Rio de Janeiro'),
('Loja Games', 'São Paulo'),
('Distribuidora Tech', 'Rio de Janeiro');

-- Produtos vendidos por Terceiros
INSERT INTO tb_produtos_vendedores (vendedor_terceiro_id, produto_id, quantidade) VALUES
(1, 1, 10),
(2, 2, 20),
(3, 3, 15),
(3, 4, 10),
(4, 1, 5),
(4, 2, 8);

-- Pedidos
INSERT INTO tb_pedidos (cliente_id, status, valor_frete, prazo_devolucao, endereco_id) VALUES
(1, 'Em Processamento', 50.00, 7, 1),
(3, 'Em Processamento', 30.00, 7, 3),
(4, 'Enviado', 50.00, 10, 4),
(5, 'Entregue', 80.00, 15, 5);

-- Pedidos Produtos
INSERT INTO tb_pedidos_produtos (pedido_id, produto_id, quantidade) VALUES
(1, 1, 1),
(1, 2, 2),
(2, 3, 2),
(2, 4, 1),
(3, 1, 1),
(3, 3, 1);

-- Pagamentos
INSERT INTO tb_pagamentos (pedido_id, tipo, status, valor) VALUES
(1, 'Cartão de Crédito', 'Aprovado', 10550.00),
(2, 'Pix', 'Aprovado', 1600.00),
(3, 'Boleto', 'Aguardando', 1700.00);

-- Entregas
INSERT INTO tb_entregas (pedido_id, status, codigo_rastreio, data_envio) VALUES
(1, 'Em Transporte', 'BR123456789', NOW()),
(2, 'Em Transporte', 'BR987654321', NOW()),
(3, 'Entregue', 'BR112233445', NOW());
