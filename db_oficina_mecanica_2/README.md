# Projeto Banco de Dados – Oficina Mecânica



### 1. Descrição do Projeto




Este projeto tem como objetivo criar um **banco de dados relacional** para o gerenciamento de uma oficina mecânica. O projeto envolve todas as etapas de modelagem e implementação, desde o **modelo conceitual (ER)** até a implementação do **modelo lógico** e persistência de dados.

O foco do projeto é fornecer suporte para as operações diárias da oficina, incluindo:

- Gestão de **clientes** e seus veículos;
- Gestão de **mecânicos** e **equipes de trabalho**;
- Registro de **ordens de serviço** com peças e serviços associados;
- Análise de informações financeiras e operacionais da oficina.

O projeto foi desenvolvido para permitir consultas **simples e complexas**, incluindo filtragens, agregações, junções e operações entre conjuntos.

<br />

### 2. Objetivos




O desafio consiste em:

1. Criar o **esquema lógico** da oficina com base no modelo conceitual (ER).

2. Gerar o **script SQL** para criação do banco de dados.

3. Persistir dados de teste para validar consultas e operações.

4. Criar **queries SQL complexas** com as seguintes características:

   - Recuperações simples com `SELECT`;

   - Filtros com `WHERE`;

   - Criação de **atributos derivados** com `CASE` ou expressões;

   - Ordenações com `ORDER BY`;

   - Filtros aplicados a grupos com `HAVING`;

   - Junções entre tabelas para perspectivas mais complexas;

Além disso, explorar **operadores como EXISTS, NOT EXISTS, UNION, UNION ALL, DISTINCT, LIKE, BETWEEN**, garantindo que as consultas possam fornecer **informações estratégicas e detalhadas** sobre os dados da oficina.

<br />

### 3. Modelo Físico



<div align="center"><img src="https://i.imgur.com/yGhqDxI.png" alt="Diagrama - Modelo Conceitual"></div>

O banco de dados possui as seguintes entidades principais:

- **Clientes (`tb_clientes`)**: cadastra informações pessoais e contato dos clientes.
- **Veículos (`tb_veiculos`)**: cadastra veículos de cada cliente, incluindo placa, marca, modelo e ano.
- **Mecânicos (`tb_mecanicos`)**: registra mecânicos e suas especialidades, vinculando-os a equipes.
- **Equipes (`tb_equipes`)**: grupos de trabalho que podem ser alocados em ordens de serviço.
- **Ordens de Serviço (`tb_ordens_servicos`)**: registra serviços realizados nos veículos, com data, valor e status.
- **Peças (`tb_pecas`)**: lista de peças disponíveis e seus valores unitários.
- **Serviços (`tb_servicos`)**: serviços oferecidos pela oficina e seus valores.
- **Associações OS x Peças (`tb_os_pecas`)** e **OS x Serviços (`tb_os_servicos`)**: registram quais peças e serviços foram usados em cada ordem de serviço, com quantidade e valor total.

O esquema lógico foi desenvolvido garantindo **integridade referencial**, utilizando **chaves primárias, chaves estrangeiras e índices** para otimizar consultas.

<img src="https://i.imgur.com/yJLc38E.png" title="source: imgur.com" width="5%"/>**Script SQL**

```sql
-- =====================================
-- Criação do banco de dados
-- =====================================
CREATE DATABASE db_oficina_mecanica;
USE db_oficina_mecanica;

-- =====================================
-- Criação das tabelas
-- =====================================

-- Tabela Clientes
CREATE TABLE tb_clientes (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  email VARCHAR(255) NOT NULL UNIQUE,
  endereco VARCHAR(200) NOT NULL,
  telefone VARCHAR(20) NOT NULL
);

-- Tabela Equipes
CREATE TABLE tb_equipes (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100) NOT NULL
);

-- Tabela Mecânicos
CREATE TABLE tb_mecanicos (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  endereco VARCHAR(200) NOT NULL,
  especialidade VARCHAR(100),
  equipe_id INT,
  FOREIGN KEY (equipe_id) REFERENCES tb_equipes(id)
);

-- Tabela Veículos
CREATE TABLE tb_veiculos (
  id INT AUTO_INCREMENT PRIMARY KEY,
  placa VARCHAR(10) NOT NULL,
  marca VARCHAR(50) NOT NULL,
  modelo VARCHAR(50) NOT NULL,
  ano INT NOT NULL,
  cliente_id INT NOT NULL,
  FOREIGN KEY (cliente_id) REFERENCES tb_clientes(id)
);

-- Tabela Ordens de Serviço
CREATE TABLE tb_ordens_servicos (
  id INT AUTO_INCREMENT PRIMARY KEY,
  num_os INT NOT NULL,
  data_emissao DATE NOT NULL,
  data_conclusao DATE,
  valor_total DECIMAL(10,2) DEFAULT 0.00,
  status ENUM('Aguardando', 'Em Andamento', 'Concluída', 'Cancelada') DEFAULT 'Aguardando',
  veiculo_id INT NOT NULL,
  equipe_id INT NOT NULL,
  FOREIGN KEY (veiculo_id) REFERENCES tb_veiculos(id),
  FOREIGN KEY (equipe_id) REFERENCES tb_equipes(id)
);

-- Tabela Peças
CREATE TABLE tb_pecas (
  id INT AUTO_INCREMENT PRIMARY KEY,
  nome VARCHAR(100) NOT NULL,
  valor_unitario DECIMAL(8,2) NOT NULL
);

-- Tabela Associação OS x Peças
CREATE TABLE tb_os_pecas (
  os_id INT NOT NULL,
  peca_id INT NOT NULL,
  quantidade INT DEFAULT 1,
  valor_total_peca DECIMAL(8,2),
  PRIMARY KEY (os_id, peca_id),
  FOREIGN KEY (os_id) REFERENCES tb_ordens_servicos(id) ON DELETE CASCADE,
  FOREIGN KEY (peca_id) REFERENCES tb_pecas(id)
);

-- Tabela Serviços
CREATE TABLE tb_servicos (
  id INT AUTO_INCREMENT PRIMARY KEY,
  descricao VARCHAR(200) NOT NULL,
  valor DECIMAL(8,2) NOT NULL
);

-- Tabela Associação OS x Serviços
CREATE TABLE tb_os_servicos (
  os_id INT NOT NULL,
  servico_id INT NOT NULL,
  quantidade INT DEFAULT 1,
  valor_total_servico DECIMAL(8,2),
  PRIMARY KEY (os_id, servico_id),
  FOREIGN KEY (os_id) REFERENCES tb_ordens_servicos(id) ON DELETE CASCADE,
  FOREIGN KEY (servico_id) REFERENCES tb_servicos(id)
);
```

<br />

### 4. Consultas SQL




As consultas foram desenvolvidas para atender aos seguintes requisitos:

1. **Recuperações simples**: listagem de clientes, veículos, mecânicos, peças e serviços.
2. **Filtros (`WHERE`)**: por status de OS, faixa de valores, nomes ou padrões (`LIKE`).
3. **Atributos derivados (`CASE`)**: classificação de serviços, status de ordens de serviço ou quantidade de veículos de clientes.
4. **Ordenações (`ORDER BY`)**: ordenação por nome, quantidade ou valor estimado.
5. **Filtragem por grupos (`HAVING`)**: clientes com mais de um veículo, ordens com valores específicos.
6. **Junções (`JOIN`)**: relacionar clientes com veículos, ordens de serviço com equipes, mecânicos e veículos.
7. **Operações entre conjuntos**: `UNION`, `UNION ALL`, `DISTINCT`, `EXISTS` e `NOT EXISTS`.
8. **Filtros avançados**: intervalos de datas ou valores com `BETWEEN`.

<img src="https://i.imgur.com/yJLc38E.png" title="source: imgur.com" width="5%"/>**Script SQL**

```sql
-- Selecionar o Banco de dados
USE db_oficina_mecanica;

-- ===========================
-- CLIENTES
-- ===========================

-- 1) Listar todos os clientes cadastrados
SELECT id, nome, email, telefone
FROM tb_clientes;

-- 2) Marcar os clientes que possuem mais de um veículo
SELECT c.nome,
       COUNT(v.id) AS qtd_veiculos,
       CASE 
           WHEN COUNT(v.id) > 1 THEN 'Possui mais de um veículo'
           ELSE 'Um veículo ou nenhum'
       END AS status_veiculos
FROM tb_clientes c
LEFT JOIN tb_veiculos v ON c.id = v.cliente_id
GROUP BY c.nome;

-- 3) Quais clientes possuem veículos registrados (EXISTS)
SELECT c.nome
FROM tb_clientes c
WHERE EXISTS (
    SELECT 1
    FROM tb_veiculos v
    WHERE v.cliente_id = c.id
);

-- 4) Quais clientes NÃO possuem veículos registrados (NOT EXISTS)
SELECT c.nome
FROM tb_clientes c
WHERE NOT EXISTS (
    SELECT 1
    FROM tb_veiculos v
    WHERE v.cliente_id = c.id
);

-- 5) Quais clientes têm veículos da marca "Ford"
SELECT DISTINCT c.nome
FROM tb_clientes c
JOIN tb_veiculos v ON c.id = v.cliente_id
WHERE v.marca = 'Ford';

-- 6) Quais clientes têm nomes que contêm "Silva"
SELECT nome, telefone
FROM tb_clientes
WHERE nome LIKE '%Silva%';

-- 7) Quais clientes possuem email com domínio "email.com"
SELECT nome, email
FROM tb_clientes
WHERE email LIKE '%@email.com';

-- ===========================
-- VEÍCULOS
-- ===========================

-- 8) Quais veículos são do cliente "Maria Souza"
SELECT v.id, v.placa, v.marca, v.modelo, v.ano
FROM tb_veiculos v
JOIN tb_clientes c ON v.cliente_id = c.id
WHERE c.nome = 'Maria Souza';

-- 9) Quais veículos têm placa que termina com "34"
SELECT placa, marca, modelo
FROM tb_veiculos
WHERE placa LIKE '%34';

-- 10) Listar todas as marcas de veículos distintas
SELECT DISTINCT marca
FROM tb_veiculos;

-- ===========================
-- MECÂNICOS E EQUIPES
-- ===========================

-- 11) Quais são os mecânicos e suas equipes, ordenados pelo nome
SELECT m.nome AS mecanico, e.nome AS equipe
FROM tb_mecanicos m
JOIN tb_equipes e ON m.equipe_id = e.id
ORDER BY m.nome ASC;

-- 12) Quais mecânicos pertencem a equipes com ordens de serviço registradas (EXISTS)
SELECT m.nome AS mecanico
FROM tb_mecanicos m
WHERE EXISTS (
    SELECT 1
    FROM tb_ordens_servicos os
    WHERE os.equipe_id = m.equipe_id
);

-- 13) Quais mecânicos NÃO possuem ordens de serviço associadas à sua equipe (NOT EXISTS)
SELECT m.nome AS mecanico
FROM tb_mecanicos m
WHERE NOT EXISTS (
    SELECT 1
    FROM tb_ordens_servicos os
    WHERE os.equipe_id = m.equipe_id
);

-- 14) Quais mecânicos têm especialidade relacionada a "Motor"
SELECT nome, especialidade
FROM tb_mecanicos
WHERE especialidade LIKE '%Motor%';

-- ===========================
-- ORDENS DE SERVIÇO
-- ===========================

-- 15) Quais ordens de serviço estão em andamento ou aguardando
SELECT id, num_os, status
FROM tb_ordens_servicos
WHERE status IN ('Em Andamento', 'Aguardando');

-- 16) Quais ordens de serviço foram emitidas entre 01/01/2025 e 31/08/2025
SELECT num_os, data_emissao, status
FROM tb_ordens_servicos
WHERE data_emissao BETWEEN '2025-01-01' AND '2025-08-31';

-- 17) Quais ordens de serviço têm valor total entre 50 e 200 reais
SELECT num_os, valor_total, status
FROM tb_ordens_servicos
WHERE valor_total BETWEEN 50 AND 200;

-- 18) Quais ordens de serviço e seus veículos associados estão registrados
SELECT os.num_os, os.status, v.placa, v.marca, v.modelo
FROM tb_ordens_servicos os
JOIN tb_veiculos v ON os.veiculo_id = v.id;

-- 19) Valor total de peças em cada ordem de serviço
SELECT os_id, SUM(valor_total_peca) AS total_pecas
FROM tb_os_pecas
GROUP BY os_id;

-- 20) Quais ordens de serviço possuem valor total superior a 100 reais em peças
SELECT os_id, SUM(valor_total_peca) AS total_pecas
FROM tb_os_pecas
GROUP BY os_id
HAVING SUM(valor_total_peca) > 100;

-- 21) Valor total estimado de cada ordem de serviço (peças + serviços)
SELECT os.id AS ordem_servico,
       COALESCE(SUM(DISTINCT osp.valor_total_peca), 0) +
       COALESCE(SUM(DISTINCT oss.valor_total_servico), 0) AS valor_estimado
FROM tb_ordens_servicos os
LEFT JOIN tb_os_pecas osp ON os.id = osp.os_id
LEFT JOIN tb_os_servicos oss ON os.id = oss.os_id
GROUP BY os.id;

-- 22) Classificar ordens de serviço de acordo com o status e valor estimado
SELECT os.num_os,
       os.status,
       COALESCE(SUM(DISTINCT osp.valor_total_peca), 0) +
       COALESCE(SUM(DISTINCT oss.valor_total_servico), 0) AS valor_estimado,
       CASE
           WHEN os.status = 'Concluída' THEN 'Finalizada'
           WHEN os.status = 'Cancelada' THEN 'Não concluída'
           ELSE 'Em processo'
       END AS situacao
FROM tb_ordens_servicos os
LEFT JOIN tb_os_pecas osp ON os.id = osp.os_id
LEFT JOIN tb_os_servicos oss ON os.id = oss.os_id
GROUP BY os.id;

-- ===========================
-- PEÇAS E SERVIÇOS
-- ===========================

-- 23) Listar todas as peças distintas cadastradas
SELECT DISTINCT nome
FROM tb_pecas;

-- 24) Listar todas as peças e serviços como "itens" da oficina
SELECT nome AS item, 'Peça' AS tipo FROM tb_pecas
UNION
SELECT descricao AS item, 'Serviço' AS tipo FROM tb_servicos;

-- 25) Valor médio dos serviços cadastrados
SELECT AVG(valor) AS valor_medio_servicos
FROM tb_servicos;

-- 26) Indicar se cada serviço é caro ou barato
SELECT descricao, valor,
       CASE
           WHEN valor > 100 THEN 'Caro'
           ELSE 'Barato'
       END AS classificacao
FROM tb_servicos;

-- ===========================
-- JUNÇÕES E AGRUPAMENTOS
-- ===========================

-- 27) Quantidade de veículos por cliente
SELECT c.nome AS cliente, COUNT(v.id) AS qtd_veiculos
FROM tb_clientes c
LEFT JOIN tb_veiculos v ON c.id = v.cliente_id
GROUP BY c.nome;

-- 28) Quantidade de ordens de serviço por equipe
SELECT e.nome AS equipe, COUNT(os.id) AS qtd_ordens
FROM tb_equipes e
JOIN tb_ordens_servicos os ON e.id = os.equipe_id
GROUP BY e.nome
ORDER BY qtd_ordens DESC;

-- ===========================
-- UNION
-- ===========================

-- 29) Listar todos os nomes de clientes e mecânicos (sem duplicados)
SELECT nome FROM tb_clientes
UNION
SELECT nome FROM tb_mecanicos;

-- 30) Listar todos os nomes de clientes e mecânicos (com duplicados)
SELECT nome FROM tb_clientes
UNION ALL
SELECT nome FROM tb_mecanicos;

```

Essa documentação fornece **contexto completo**, mostrando a **metodologia do projeto**, as **entidades envolvidas**, a **persistência de dados** e o **tipo de consultas desenvolvidas**.