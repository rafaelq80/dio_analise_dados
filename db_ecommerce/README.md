# Desafio de Banco de Dados – E-commerce



### 1. Objetivo

O objetivo deste documento é apresentar o **esquema conceitual e físico** de um sistema de E-commerce, detalhando as entidades, atributos e relacionamentos necessários para o correto funcionamento da plataforma, contemplando clientes, produtos, fornecedores, vendedores terceiros, pedidos, pagamentos e entregas.

<br />

### 2. Escopo e Contexto

O sistema visa gerenciar todo o ciclo de compra e venda em uma plataforma online, desde o cadastro do cliente e dos produtos até o processamento do pedido, pagamento e entrega. A solução abrange:

- Cadastro de clientes pessoa física (CPF) e pessoa jurídica (CNPJ).
- Cadastro de endereços de clientes (residencial, comercial, entrega).
- Cadastro de fornecedores e vendedores terceiros.
- Cadastro e gerenciamento de produtos.
- Criação e controle de pedidos, incluindo múltiplos produtos.
- Registro das formas de pagamento associadas a cada pedido.
- Controle do processo de entrega com status e código de rastreio.

<br />

### 3. Narrativa

- O cliente pode ser **Pessoa Física (CPF)** ou **Pessoa Jurídica (CNPJ)**, mas nunca os dois ao mesmo tempo.
- O cliente possui um ou mais endereços, que influenciam no cálculo do valor do frete.
- Produtos são cadastrados na plataforma com vínculo a um fornecedor.
- Produtos podem ser vendidos também por **vendedores terceiros**, que informam a quantidade disponível.
- Cada cliente pode realizar múltiplos pedidos, que são compostos por um ou mais produtos.
- O pedido contém informações como data, status, valor do frete, possibilidade de cancelamento e prazo para devolução.
- Cada pedido pode ter um ou mais pagamentos cadastrados (cartão, pix, boleto).
- A entrega de cada pedido é registrada com status e código de rastreio.

<br />

### 4. Observações Técnicas

- O sistema deve garantir a **integridade referencial** entre clientes, endereços, pedidos, produtos, pagamentos e entregas.
- As tabelas de associação (`tb_pedidos_produtos`, `tb_produtos_vendedores`) utilizam **chaves compostas** para representar corretamente os relacionamentos **N:N**.
- O modelo segue boas práticas de nomenclatura: banco `db_ecommerce`, tabelas no plural (`tb_clientes`, `tb_pedidos`, etc.), PK como `id BIGINT AUTO_INCREMENT`.

<br />

### 5. Modelo Físico

<br />

**Modelo Original**

<div align="center"><img src="https://i.imgur.com/5PTh3DL.png" alt="Diagrama - Modelo Conceitual"></div>

<br />

**Modelo Atualizado**

<div align="center"><img src="https://i.imgur.com/yvbS7gk.png" alt="Diagrama - Modelo Conceitual"></div>

<br />

### 6. Dicionário de Dados – Sistema de E-commerce

<br />

#### **Tabela: tb_clientes**

| Campo    | Tipo                  | Obrigatório | PK/FK | Descrição                |
| -------- | --------------------- | ----------- | ----- | ------------------------ |
| id       | BIGINT AUTO_INCREMENT | Sim         | 🔑     | Identificador do cliente |
| nome     | VARCHAR(255)          | Sim         |       | Nome completo do cliente |
| email    | VARCHAR(255) UNIQUE   | Não         |       | E-mail de contato        |
| telefone | VARCHAR(50)           | Não         |       | Telefone de contato      |

<br />

#### **Tabela: tb_clientes_pf**

| Campo      | Tipo                  | Obrigatório | PK/FK | Descrição                    |
| ---------- | --------------------- | ----------- | ----- | ---------------------------- |
| id         | BIGINT AUTO_INCREMENT | Sim         | 🔑     | Identificador único          |
| cliente_id | BIGINT                | Sim         | 🔶     | Referência ao cliente        |
| cpf        | VARCHAR(14) UNIQUE    | Sim         |       | CPF do cliente pessoa física |

<br />

#### **Tabela: tb_clientes_pj**

| Campo        | Tipo                  | Obrigatório | PK/FK | Descrição                       |
| ------------ | --------------------- | ----------- | ----- | ------------------------------- |
| id           | BIGINT AUTO_INCREMENT | Sim         | 🔑     | Identificador único             |
| cliente_id   | BIGINT                | Sim         | 🔶     | Referência ao cliente           |
| cnpj         | VARCHAR(18) UNIQUE    | Sim         |       | CNPJ do cliente pessoa jurídica |
| razao_social | VARCHAR(255)          | Sim         |       | Razão social da empresa         |

<br />

#### **Tabela: tb_enderecos**

| Campo      | Tipo                  | Obrigatório | PK/FK | Descrição                 |
| ---------- | --------------------- | ----------- | ----- | ------------------------- |
| id         | BIGINT AUTO_INCREMENT | Sim         | 🔑     | Identificador do endereço |
| cliente_id | BIGINT                | Sim         | 🔶     | Cliente associado         |
| logradouro | VARCHAR(255)          | Sim         |       | Rua, número, complemento  |
| cidade     | VARCHAR(100)          | Sim         |       | Cidade do endereço        |
| estado     | VARCHAR(2)            | Sim         |       | Unidade federativa        |
| cep        | VARCHAR(10)           | Sim         |       | CEP                       |
| tipo       | VARCHAR(50)           | Não         |       | Tipo (residencial, etc.)  |

<br />

#### **Tabela: tb_fornecedores**

| Campo        | Tipo                  | Obrigatório | PK/FK | Descrição          |
| ------------ | --------------------- | ----------- | ----- | ------------------ |
| id           | BIGINT AUTO_INCREMENT | Sim         | 🔑     | Identificador      |
| razao_social | VARCHAR(255)          | Sim         |       | Nome/Razão social  |
| cnpj         | VARCHAR(18) UNIQUE    | Sim         |       | CNPJ do fornecedor |

<br />

#### **Tabela: tb_produtos**

| Campo         | Tipo                  | Obrigatório | PK/FK | Descrição                 |
| ------------- | --------------------- | ----------- | ----- | ------------------------- |
| id            | BIGINT AUTO_INCREMENT | Sim         | 🔑     | Identificador do produto  |
| descricao     | VARCHAR(255)          | Sim         |       | Nome/descrição do produto |
| categoria     | VARCHAR(100)          | Não         |       | Categoria do produto      |
| valor         | DECIMAL(10,2)         | Sim         |       | Valor unitário            |
| fornecedor_id | BIGINT                | Sim         | 🔶     | Fornecedor do produto     |

<br />

#### **Tabela: tb_vendedores_terceiros**

| Campo        | Tipo                  | Obrigatório | PK/FK | Descrição         |
| ------------ | --------------------- | ----------- | ----- | ----------------- |
| id           | BIGINT AUTO_INCREMENT | Sim         | 🔑     | Identificador     |
| razao_social | VARCHAR(255)          | Sim         |       | Nome/Razão social |
| local        | VARCHAR(255)          | Não         |       | Localização       |

<br />

#### **Tabela: tb_produtos_vendedores** (N:N Produtos ↔ Vendedores Terceiros)

| Campo                | Tipo   | Obrigatório | PK/FK | Descrição                        |
| -------------------- | ------ | ----------- | ----- | -------------------------------- |
| vendedor_terceiro_id | BIGINT | Sim         | 🔑🔶    | Vendedor associado ao produto    |
| produto_id           | BIGINT | Sim         | 🔑🔶    | Produto associado                |
| quantidade           | INT    | Sim         |       | Quantidade disponível para venda |

<br />

#### **Tabela: tb_pedidos**

| Campo           | Tipo                  | Obrigatório | PK/FK | Descrição                    |
| --------------- | --------------------- | ----------- | ----- | ---------------------------- |
| id              | BIGINT AUTO_INCREMENT | Sim         | 🔑     | Identificador do pedido      |
| cliente_id      | BIGINT                | Sim         | 🔶     | Cliente que realizou         |
| endereco_id     | BIGINT                | Sim         | 🔶     | Endereço de entrega          |
| data_pedido     | DATETIME              | Sim         |       | Data da compra               |
| status          | VARCHAR(50)           | Não         |       | Status do pedido             |
| valor_frete     | DECIMAL(10,2)         | Não         |       | Valor do frete               |
| prazo_devolucao | INT                   | Não         |       | Prazo em dias para devolução |
| cancelado       | BOOLEAN               | Não         |       | Indicador de cancelamento    |

<br />

#### **Tabela: tb_pedidos_produtos** (N:N Pedidos ↔ Produtos)

| Campo      | Tipo   | Obrigatório | PK/FK | Descrição                  |
| ---------- | ------ | ----------- | ----- | -------------------------- |
| pedido_id  | BIGINT | Sim         | 🔑🔶    | Pedido associado           |
| produto_id | BIGINT | Sim         | 🔑🔶    | Produto incluído no pedido |
| quantidade | INT    | Sim         |       | Quantidade do produto      |

<br />

#### **Tabela: tb_pagamentos**

| Campo          | Tipo                  | Obrigatório | PK/FK | Descrição                  |
| -------------- | --------------------- | ----------- | ----- | -------------------------- |
| id             | BIGINT AUTO_INCREMENT | Sim         | 🔑     | Identificador do pagamento |
| pedido_id      | BIGINT                | Sim         | 🔶     | Pedido relacionado         |
| tipo           | VARCHAR(50)           | Sim         |       | Tipo de pagamento          |
| status         | VARCHAR(50)           | Não         |       | Status do pagamento        |
| valor          | DECIMAL(10,2)         | Sim         |       | Valor pago                 |
| data_pagamento | DATETIME              | Não         |       | Data do pagamento          |

<br />

#### **Tabela: tb_entregas**

| Campo           | Tipo                  | Obrigatório | PK/FK | Descrição                |
| --------------- | --------------------- | ----------- | ----- | ------------------------ |
| id              | BIGINT AUTO_INCREMENT | Sim         | 🔑     | Identificador da entrega |
| pedido_id       | BIGINT                | Sim         | 🔶     | Pedido associado         |
| status          | VARCHAR(50)           | Não         |       | Status da entrega        |
| codigo_rastreio | VARCHAR(50)           | Não         |       | Código de rastreio       |
| data_envio      | DATETIME              | Não         |       | Data de envio            |
| data_entrega    | DATETIME              | Não         |       | Data de entrega          |

