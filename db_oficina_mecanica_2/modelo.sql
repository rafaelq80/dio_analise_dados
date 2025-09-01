-- Criação do banco de dados
CREATE DATABASE db_oficina_mecanica;
USE db_oficina_mecanica;

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

-- ===========================================
-- Inserção de dados iniciais
-- ===========================================

-- Clientes
INSERT INTO tb_clientes (nome, email, endereco, telefone) VALUES
('João Silva', 'joao@email.com', 'Rua A, 123', '11999990000'),
('Maria Souza', 'maria@email.com', 'Av. B, 456', '11988887777');

-- Equipes
INSERT INTO tb_equipes (nome) VALUES
('Equipe A'),
('Equipe B');

-- Mecânicos
INSERT INTO tb_mecanicos (nome, endereco, especialidade, equipe_id) VALUES
('Carlos Mecânico', 'Rua C, 789', 'Motor', 1),
('Ana Técnica', 'Av. D, 321', 'Suspensão', 2);

-- Veículos
INSERT INTO tb_veiculos (placa, marca, modelo, ano, cliente_id) VALUES
('ABC1234', 'Ford', 'Fiesta', 2018, 1),
('XYZ9876', 'Chevrolet', 'Onix', 2020, 2);

-- Ordens de Serviço
INSERT INTO tb_ordens_servicos (num_os, data_emissao, valor_total, status, veiculo_id, equipe_id) VALUES
(1001, '2025-09-01', 0.00, 'Aguardando', 1, 1);

-- Peças
INSERT INTO tb_pecas (nome, valor_unitario) VALUES
('Filtro de Óleo', 50.00),
('Pastilha de Freio', 120.00);

-- Serviços
INSERT INTO tb_servicos (descricao, valor) VALUES
('Troca de óleo', 80.00),
('Revisão de freios', 150.00);

-- Associações OS x Peças
INSERT INTO tb_os_pecas (os_id, peca_id, quantidade, valor_total_peca) VALUES
(1, 1, 1, 50.00);

-- Associações OS x Serviços
INSERT INTO tb_os_servicos (os_id, servico_id, quantidade, valor_total_servico) VALUES
(1, 1, 1, 80.00);
