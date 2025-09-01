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
