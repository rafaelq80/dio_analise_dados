# Projeto Banco de Dados – E-commerce



### 1. Descrição do Projeto



Este projeto tem como objetivo criar um **banco de dados relacional** para o gerenciamento de um **e-commerce**, incluindo clientes, produtos, pedidos, pagamentos e entregas. O projeto contempla todas as etapas de modelagem e implementação, desde o **modelo conceitual (ER)** até o **modelo lógico** e a persistência de dados.

O banco de dados foi projetado para dar suporte às operações do e-commerce, como:

- Gestão de **clientes pessoa física (PF) e jurídica (PJ)**, incluindo múltiplos **endereços**;
- Controle de **fornecedores**, **produtos** e **categorias**;
- Registro de **vendedores terceiros** e produtos que eles comercializam;
- Gerenciamento de **pedidos**, com produtos, quantidade, status, frete e prazo de devolução;
- Registro de **pagamentos** e **entregas**, com rastreamento de status;
- Permitir análises de **vendas, estoque e performance de fornecedores/vendedores**.

O projeto permite consultas **simples e complexas**, utilizando agregações, junções, filtros, operadores de conjunto e atributos derivados.

<br />

### 2. Objetivos



O projeto tem os seguintes objetivos:

1. Criar o **esquema lógico** com base no modelo relacional apresentado.
2. Gerar **script SQL** para criação do banco de dados.
3. Popular o banco com dados de teste para validar consultas e operações.
4. Desenvolver **queries SQL complexas**, incluindo:
   - Recuperações simples (`SELECT`) de clientes, produtos, pedidos e pagamentos;
   - Filtros (`WHERE`) por status, datas, valores e padrões (`LIKE`);
   - Atributos derivados (`CASE`) para classificação de pedidos, pagamentos ou produtos;
   - Ordenações (`ORDER BY`) por valor, nome ou quantidade;
   - Filtragem por grupos (`HAVING`) como clientes com mais de um pedido ou produtos mais vendidos;
   - Junções (`JOIN`) entre clientes, pedidos, produtos, fornecedores e entregas;
   - Operadores de conjuntos: `UNION`, `UNION ALL`, `DISTINCT`, `EXISTS`, `NOT EXISTS`;
   - Filtros avançados: intervalos de datas ou valores com `BETWEEN`.

<br />

### 3. Modelo Físico



<div align="center"><img src="https://i.imgur.com/yvbS7gk.png" alt="Diagrama - Modelo Conceitual"></div>

O banco possui as seguintes entidades principais:

- **Clientes (`tb_clientes`)**: informações gerais de todos os clientes;
- **Clientes PF (`tb_clientes_pf`)** e **Clientes PJ (`tb_clientes_pj`)**: dados específicos de pessoa física (CPF) e pessoa jurídica (CNPJ, razão social);
- **Endereços (`tb_enderecos`)**: múltiplos endereços por cliente (residencial, comercial, entrega);
- **Fornecedores (`tb_fornecedores`)**: empresas que fornecem produtos;
- **Produtos (`tb_produtos`)**: produtos vendidos no e-commerce;
- **Vendedores Terceiros (`tb_vendedores_terceiros`)** e **Produtos vendidos por terceiros (`tb_produtos_vendedores`)**: controle de produtos vendidos por parceiros;
- **Pedidos (`tb_pedidos`)**: registros de pedidos, com valor de frete, prazo de devolução e status;
- **Itens de Pedido (`tb_pedidos_produtos`)**: produtos incluídos em cada pedido e quantidade;
- **Pagamentos (`tb_pagamentos`)**: controle de pagamentos realizados pelos clientes;
- **Entregas (`tb_entregas`)**: rastreamento do envio e entrega dos pedidos.

O modelo garante **integridade referencial**, utilizando **chaves primárias, chaves estrangeiras e índices**, permitindo consultas complexas e consistentes.

<img src="https://i.imgur.com/yJLc38E.png" title="source: imgur.com" width="5%"/>**Script SQL**

```sql
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
```

<br />

### 4. Consultas SQL 



As consultas do banco de dados **e-commerce** foram desenvolvidas para atender aos seguintes requisitos:

1. **Recuperações simples (`SELECT`)**: listagem de clientes, produtos, fornecedores, pedidos, pagamentos e entregas.
   - Exemplo: listar todos os clientes cadastrados com seus dados básicos.
2. **Filtros (`WHERE`)**: por status de pedidos, faixa de valores, nomes ou padrões (`LIKE`).
   - Exemplo: clientes cujo nome contém "Silva", ou produtos com valor entre 100 e 500 reais.
3. **Atributos derivados (`CASE`)**: classificação de produtos, status de pedidos ou valor de compras.
   - Exemplo: indicar se um produto é “Caro” ou “Barato” com base no valor.
4. **Ordenações (`ORDER BY`)**: ordenação por nome, quantidade de produtos, valor do pedido ou data.
   - Exemplo: listar clientes ou pedidos em ordem alfabética ou pelo valor total.
5. **Filtragem por grupos (`GROUP BY` e `HAVING`)**: agregações como quantidade de pedidos por cliente ou quantidade de produtos vendidos por fornecedor, aplicando condições sobre os grupos.
   - Exemplo: clientes que realizaram mais de um pedido.
6. **Junções (`JOIN`)**: relacionar clientes com pedidos, produtos com fornecedores, produtos vendidos por terceiros e entregas associadas aos pedidos.
   - Exemplo: listar os produtos de cada pedido ou os pedidos de cada cliente.
7. **Operações entre conjuntos**: uso de `UNION`, `UNION ALL`, `DISTINCT`, `EXISTS` e `NOT EXISTS` para consultas avançadas sobre dados distintos ou verificações de existência.
   - Exemplo: verificar se algum vendedor também é fornecedor (consulta obrigatória).
8. **Filtros avançados (`BETWEEN`)**: seleção por intervalos de datas ou valores.
   - Exemplo: pedidos realizados entre duas datas específicas ou produtos com preço dentro de uma faixa.

<br />

**Consultas obrigatórias**:

1. **Quantos pedidos foram feitos por cada cliente**
   - Consulta que usa `GROUP BY` e `COUNT` para mostrar a quantidade de pedidos de cada cliente.
2. **Algum vendedor também é fornecedor**
   - Consulta que utiliza `EXISTS` ou `JOIN` para verificar se algum vendedor também aparece na tabela de fornecedores.
3. **Relação de produtos fornecedores e estoques**
   - Consulta que mostra os produtos, fornecedores e quantidade em estoque, envolvendo `JOIN`.
4. **Relação de nomes dos fornecedores e nomes dos produtos**
   - Consulta simples com `JOIN` para listar cada produto com seu respectivo fornecedor.

<img src="https://i.imgur.com/yJLc38E.png" title="source: imgur.com" width="5%"/>**Script SQL**

```sql
-- Selecionar o Banco de dados
USE db_ecommerce;

-- ===========================
-- CLIENTES
-- ===========================

-- 1) Listar todos os clientes cadastrados
SELECT id, nome, email, telefone
FROM tb_clientes;
-- Lista todos os clientes com seus contatos.

-- 2) Marcar clientes PF e PJ
SELECT c.nome,
       CASE 
           WHEN pf.id IS NOT NULL THEN 'Pessoa Física'
           WHEN pj.id IS NOT NULL THEN 'Pessoa Jurídica'
           ELSE 'Não classificado'
       END AS tipo_cliente
FROM tb_clientes c
LEFT JOIN tb_clientes_pf pf ON c.id = pf.cliente_id
LEFT JOIN tb_clientes_pj pj ON c.id = pj.cliente_id;
-- Classifica cada cliente como PF ou PJ.

-- 3) Quais clientes possuem endereços registrados (EXISTS)
SELECT c.nome
FROM tb_clientes c
WHERE EXISTS (
    SELECT 1
    FROM tb_enderecos e
    WHERE e.cliente_id = c.id
);
-- Verifica quais clientes têm pelo menos um endereço registrado.

-- 4) Quais clientes NÃO possuem endereços registrados (NOT EXISTS)
SELECT c.nome
FROM tb_clientes c
WHERE NOT EXISTS (
    SELECT 1
    FROM tb_enderecos e
    WHERE e.cliente_id = c.id
);
-- Lista clientes que não têm nenhum endereço registrado.

-- 5) Quais clientes têm email com domínio "email.com"
SELECT nome, email
FROM tb_clientes
WHERE email LIKE '%@email.com';
-- Busca clientes com emails de um domínio específico.

-- 6) Listar clientes com nomes que contêm "Silva"
SELECT nome, telefone
FROM tb_clientes
WHERE nome LIKE '%Silva%';
-- Busca clientes pelo nome parcial.

-- 7) Quantos pedidos foram feitos por cada cliente
SELECT c.nome, COUNT(p.id) AS total_pedidos
FROM tb_clientes c
LEFT JOIN tb_pedidos p ON c.id = p.cliente_id
GROUP BY c.nome;
-- Conta a quantidade de pedidos de cada cliente.

-- ===========================
-- PRODUTOS E FORNECEDORES
-- ===========================

-- 8) Listar todos os produtos com fornecedor
SELECT pr.descricao AS produto, f.razao_social AS fornecedor, pr.valor
FROM tb_produtos pr
JOIN tb_fornecedores f ON pr.fornecedor_id = f.id;
-- Mostra produtos com seus fornecedores e valores.

-- 9) Relação de produtos fornecedores e estoques (terceiros)
SELECT pr.descricao AS produto, v.razao_social AS vendedor, pv.quantidade
FROM tb_produtos_vendedores pv
JOIN tb_vendedores_terceiros v ON pv.vendedor_terceiro_id = v.id
JOIN tb_produtos pr ON pv.produto_id = pr.id;
-- Lista produtos vendidos por terceiros com a quantidade em estoque.

-- 10) Relação de nomes dos fornecedores e nomes dos produtos
SELECT f.razao_social AS fornecedor, pr.descricao AS produto
FROM tb_produtos pr
JOIN tb_fornecedores f ON pr.fornecedor_id = f.id;
-- Mostra cada fornecedor e os produtos que fornece.

-- 11) Algum vendedor também é fornecedor?
SELECT v.razao_social AS nome
FROM tb_vendedores_terceiros v
WHERE EXISTS (
    SELECT 1 FROM tb_fornecedores f
    WHERE f.razao_social = v.razao_social
);
-- Verifica se algum vendedor também é fornecedor.

-- 12) Listar produtos de uma categoria específica
SELECT descricao, valor
FROM tb_produtos
WHERE categoria = 'Informática';
-- Filtra produtos por categoria.

-- 13) Produtos com valor entre 1000 e 5000
SELECT descricao, valor
FROM tb_produtos
WHERE valor BETWEEN 1000 AND 5000;
-- Filtra produtos por faixa de preço.

-- 14) Produtos com descrição que contém "Notebook"
SELECT descricao, valor
FROM tb_produtos
WHERE descricao LIKE '%Notebook%';
-- Busca produtos pelo nome parcial.

-- 15) Valor médio dos produtos por fornecedor
SELECT f.razao_social, AVG(pr.valor) AS valor_medio
FROM tb_produtos pr
JOIN tb_fornecedores f ON pr.fornecedor_id = f.id
GROUP BY f.razao_social;
-- Calcula o valor médio dos produtos de cada fornecedor.

-- ===========================
-- PEDIDOS E ITENS
-- ===========================

-- 16) Listar pedidos em processamento ou enviados
SELECT id, status, data_pedido
FROM tb_pedidos
WHERE status IN ('Em Processamento', 'Enviado');
-- Filtra pedidos por status.

-- 17) Pedidos realizados entre 01/01/2025 e 31/08/2025
SELECT id, cliente_id, data_pedido, status
FROM tb_pedidos
WHERE data_pedido BETWEEN '2025-01-01' AND '2025-08-31';
-- Filtra pedidos por intervalo de datas.

-- 18) Valor total de cada pedido (produtos + frete)
SELECT p.id AS pedido_id,
       COALESCE(SUM(pp.quantidade * pr.valor),0) + COALESCE(p.valor_frete,0) AS valor_total
FROM tb_pedidos p
LEFT JOIN tb_pedidos_produtos pp ON p.id = pp.pedido_id
LEFT JOIN tb_produtos pr ON pp.produto_id = pr.id
GROUP BY p.id;
-- Calcula o valor total de cada pedido somando produtos e frete.

-- 19) Classificação dos pedidos por valor
SELECT p.id AS pedido_id,
       CASE
           WHEN COALESCE(SUM(pp.quantidade * pr.valor),0) + COALESCE(p.valor_frete,0) > 5000 THEN 'Alto'
           ELSE 'Normal'
       END AS classificacao
FROM tb_pedidos p
LEFT JOIN tb_pedidos_produtos pp ON p.id = pp.pedido_id
LEFT JOIN tb_produtos pr ON pp.produto_id = pr.id
GROUP BY p.id;
-- Classifica pedidos como "Alto" ou "Normal" com base no valor.

-- 20) Pedidos com produtos específicos (EXISTS)
SELECT p.id, c.nome
FROM tb_pedidos p
JOIN tb_clientes c ON p.cliente_id = c.id
WHERE EXISTS (
    SELECT 1
    FROM tb_pedidos_produtos pp
    JOIN tb_produtos pr ON pp.produto_id = pr.id
    WHERE pp.pedido_id = p.id AND pr.descricao = 'Notebook Gamer'
);
-- Busca pedidos que contêm um produto específico.

-- 21) Pedidos sem entregas registradas (NOT EXISTS)
SELECT p.id, c.nome
FROM tb_pedidos p
JOIN tb_clientes c ON p.cliente_id = c.id
WHERE NOT EXISTS (
    SELECT 1 FROM tb_entregas e WHERE e.pedido_id = p.id
);
-- Lista pedidos que ainda não possuem entrega registrada.

-- 22) Quantidade de produtos por pedido
SELECT p.id AS pedido_id, SUM(pp.quantidade) AS total_produtos
FROM tb_pedidos p
JOIN tb_pedidos_produtos pp ON p.id = pp.pedido_id
GROUP BY p.id;
-- Conta quantos produtos foram pedidos em cada pedido.

-- ===========================
-- PAGAMENTOS E ENTREGAS
-- ===========================

-- 23) Total pago por pedido
SELECT p.id AS pedido_id, COALESCE(SUM(pg.valor),0) AS total_pago
FROM tb_pedidos p
LEFT JOIN tb_pagamentos pg ON p.id = pg.pedido_id
GROUP BY p.id;
-- Soma todos os pagamentos realizados por pedido.

-- 24) Pedidos com pagamentos aprovados
SELECT p.id AS pedido_id, c.nome, pg.valor, pg.tipo
FROM tb_pedidos p
JOIN tb_pagamentos pg ON p.id = pg.pedido_id
JOIN tb_clientes c ON p.cliente_id = c.id
WHERE pg.status = 'Aprovado';
-- Lista pedidos com pagamentos aprovados.

-- 25) Pedidos entregues ou em transporte
SELECT p.id AS pedido_id, e.status, e.codigo_rastreio
FROM tb_entregas e
JOIN tb_pedidos p ON e.pedido_id = p.id
WHERE e.status IN ('Em Transporte', 'Entregue');
-- Mostra status das entregas dos pedidos.

-- 26) Pedidos com atraso (data_envio maior que data_pedido + prazo_devolucao)
SELECT p.id AS pedido_id, p.data_pedido, e.data_envio, p.prazo_devolucao
FROM tb_pedidos p
JOIN tb_entregas e ON p.id = e.pedido_id
WHERE e.data_envio > DATE_ADD(p.data_pedido, INTERVAL p.prazo_devolucao DAY);
-- Identifica pedidos enviados após o prazo.

-- ===========================
-- JUNÇÕES E AGRUPAMENTOS
-- ===========================

-- 27) Quantidade de pedidos por cliente
SELECT c.nome AS cliente, COUNT(p.id) AS total_pedidos
FROM tb_clientes c
LEFT JOIN tb_pedidos p ON c.id = p.cliente_id
GROUP BY c.nome;
-- Conta pedidos feitos por cada cliente.

-- 28) Quantidade de produtos vendidos por fornecedor
SELECT f.razao_social AS fornecedor, COUNT(pp.produto_id) AS total_produtos
FROM tb_fornecedores f
JOIN tb_produtos pr ON f.id = pr.fornecedor_id
JOIN tb_pedidos_produtos pp ON pr.id = pp.produto_id
GROUP BY f.razao_social
ORDER BY total_produtos DESC;
-- Conta quantos produtos de cada fornecedor foram vendidos.

-- ===========================
-- UNION
-- ===========================

-- 29) Listar todos os nomes de clientes e vendedores (sem duplicados)
SELECT nome FROM tb_clientes
UNION
SELECT razao_social AS nome FROM tb_vendedores_terceiros;
-- Lista clientes e vendedores sem repetir nomes.

-- 30) Listar todos os nomes de clientes e vendedores (com duplicados)
SELECT nome FROM tb_clientes
UNION ALL
SELECT razao_social AS nome FROM tb_vendedores_terceiros;
-- Lista todos os nomes, permitindo duplicatas.

```

Essa documentação fornece **contexto completo**, mostrando a **metodologia do projeto**, as **entidades envolvidas**, a **persistência de dados** e o **tipo de consultas desenvolvidas**.