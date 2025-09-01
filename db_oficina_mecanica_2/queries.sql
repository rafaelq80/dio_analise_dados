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
