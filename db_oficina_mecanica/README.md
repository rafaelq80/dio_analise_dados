# Desafio de Banco de dados - Oficina Mecânica



### 1. Objetivo

O objetivo deste documento é apresentar o **esquema conceitual** do sistema de controle e gerenciamento de ordens de serviço (OS) em uma oficina mecânica, detalhando as entidades, atributos e relacionamentos necessários para o correto funcionamento do sistema.

### 2. Escopo e Contexto

O sistema visa gerenciar todo o ciclo de atendimento de veículos na oficina, desde o registro do cliente e do veículo até a execução e conclusão das ordens de serviço. A solução abrange:

- Registro de clientes e veículos associados.
- Criação, acompanhamento e controle das ordens de serviço.
- Controle das equipes de mecânicos responsáveis pelos serviços.
- Registro detalhado de serviços e peças utilizadas em cada OS, incluindo cálculo de valores.
- Autorizações do cliente antes da execução dos serviços.

### 3. Narrativa

- Clientes levam seus veículos à oficina para consertos ou revisões periódicas.
- Cada veículo é designado a uma equipe de mecânicos, responsável por identificar os serviços a serem realizados e preencher a OS, informando a data prevista de conclusão.
- O valor de cada serviço é calculado com base em uma tabela de referência de mão-de-obra.
- O valor de cada peça utilizada também é incluído na OS, sendo a execução condicionada à autorização do cliente.
- A equipe designada avalia, executa e acompanha todos os serviços da OS.
- Cada mecânico possui os seguintes dados cadastrais: código, nome, endereço e especialidade.
- Cada ordem de serviço contém as seguintes informações: número da OS, data de emissão, valor total, status e data prevista de conclusão dos trabalhos.

### 4. Observações Técnicas

- O sistema deve garantir a integridade dos dados, relacionando corretamente clientes, veículos, equipes, mecânicos, serviços e peças.
- Cada entidade e relacionamento será representada no **esquema conceitual** por meio de entidades, atributos e relacionamentos, garantindo uma visão clara e estruturada do domínio do sistema.

<br />

### 5. **Modelo Conceitual (Diagrama Chen)**

<div align="center"><img src="https://i.imgur.com/PmRWCXV.png" alt="Diagrama - Modelo Conceitual"></div>

<br />

### 6. **Modelo Físico**

<div align="center"><img src="https://i.imgur.com/yGhqDxI.png" alt="Diagrama - Modelo Conceitual"></div>

<br />

### 7. **Dicionário de Dados – Sistema de Oficina**



### **Tabela: tb_clientes**

| Campo      | Tipo                     | Obrigatório | PK/FK | Descrição                      |
| ---------- | ------------------------ | :---------: | :---: | ------------------------------ |
| id_cliente | INT <br />AUTO_INCREMENT |     Sim     |   🔑   | Identificador único do cliente |
| nome       | VARCHAR(100)             |     Sim     |       | Nome completo do cliente       |
| email      | VARCHAR(100)             |     Sim     |       | E-mail do cliente              |
| endereco   | VARCHAR(200)             |     Sim     |       | Endereço do cliente            |
| telefone   | VARCHAR(20)              |     Não     |       | Telefone de contato            |

<br />

### **Tabela: tb_equipes**

| Coluna | Tipo                     | Obrigatório | PK/FK | Descrição                     |
| ------ | ------------------------ | :---------: | :---: | ----------------------------- |
| id     | INT <br />AUTO_INCREMENT |     Sim     |   🔑   | Identificador único da equipe |
| nome   | VARCHAR(100)             |     Sim     |       | Nome da equipe de mecânicos   |

<br />

### **Tabela: tb_mecanicos**

| Coluna        | Tipo                     | Obrigatório | PK/FK | Descrição                                          |
| ------------- | ------------------------ | :---------: | :---: | -------------------------------------------------- |
| id            | INT <br />AUTO_INCREMENT |     Sim     |   🔑   | Identificador único do mecânico                    |
| nome          | VARCHAR(100)             |     Sim     |       | Nome completo do mecânico                          |
| endereco      | VARCHAR(200)             |     Sim     |       | Endereço do mecânico                               |
| especialidade | VARCHAR(100)             |     Não     |       | Especialidade do mecânico                          |
| equipe_id     | INT                      |     Não     |   🔶   | Identificador da equipe à qual o mecânico pertence |

<br />

### **Tabela: tb_veiculos**

| Campo      | Tipo                         | Obrigatório | PK/FK | Descrição                          |
| ---------- | ---------------------------- | :---------: | :---: | ---------------------------------- |
| id         | INT (PK)<br />AUTO_INCREMENT |     Sim     |   🔑   | Identificador único do veículo     |
| placa      | VARCHAR(10)                  |     Sim     |       | Placa do veículo                   |
| marca      | VARCHAR(50)                  |     Sim     |       |                                    |
| modelo     | VARCHAR(50)                  |     Sim     |       | Modelo do veículo                  |
| ano        | INT                          |     Sim     |       | Ano de fabricação                  |
| cliente_id | INT (FK)                     |     Sim     |   🔶   | Referência ao cliente proprietário |

<br />

### **Tabela: tb_ordens_servicos**

| Coluna         | Tipo                                                         | Obrigatório | PK/FK | Descrição                            |
| -------------- | ------------------------------------------------------------ | :---------: | :---: | ------------------------------------ |
| id             | INT <br />AUTO_INCREMENT                                     |     Sim     |   🔑   | Identificador único da OS            |
| num_os         | INT<br />UNIQUE                                              |     Sim     |       | Número da OS                         |
| data_emissao   | DATE                                                         |     Sim     |       | Data de emissão da OS                |
| data_conclusao | DATE                                                         |     Não     |       | Data prevista ou real de conclusão   |
| valor_total    | DECIMAL(10,2)                                                |     Não     |       | Valor total da OS (serviços + peças) |
| status         | ENUM('Aguardando', 'Em Andamento', 'Concluída', 'Cancelada')<br />Default: Aguardando |     Não     |       | Status da OS                         |
| veiculo_id     | INT                                                          |     Sim     |   🔶   | Veículo associado à OS               |
| equipe_id      | INT                                                          |     Sim     |   🔶   | Equipe responsável pela OS           |

<br />

### **Tabela: tb_servicos**

| Coluna    | Tipo                     | Obrigatório | PK/FK | Descrição                       |
| --------- | ------------------------ | :---------: | :---: | ------------------------------- |
| id        | INT <br />AUTO_INCREMENT |     Sim     |   🔑   | Identificador único do serviço  |
| descricao | VARCHAR(200)             |     Sim     |       | Descrição detalhada do serviço  |
| valor     | DECIMAL(8,2)             |     Sim     |       | Valor da mão-de-obra do serviço |

<br />

### **Tabela: tb_pecas**

| Coluna         | Tipo                     | Obrigatório | PK/FK | Descrição                   |
| -------------- | ------------------------ | :---------: | :---: | --------------------------- |
| id             | INT <br />AUTO_INCREMENT |     Sim     |   🔑   | Identificador único da peça |
| nome           | VARCHAR(100)             |     Sim     |       | Nome da peça                |
| valor_unitario | DECIMAL(8,2)             |     Sim     |       | Valor unitário da peça      |

<br />

### **Tabela: tb_os_servicos** (N:N OS ↔ Serviços)

| Coluna              | Tipo         | Obrigatório | PK/FK | Descrição                                                    |
| ------------------- | ------------ | :---------: | :---: | ------------------------------------------------------------ |
| os_id               | INT          |     Sim     |  🔑🔶   | OS associada ao serviço                                      |
| servico_id          | INT          |     Sim     |  🔑🔶   | Serviço incluído na OS                                       |
| quantidade          | INT          |     Não     |       | Quantidade de vezes que o serviço foi aplicado               |
| valor_total_servico | DECIMAL(8,2) |     Não     |       | Valor do serviço aplicado à OS (quantidade × valor_mao_obra) |

<br />

### **Tabela: tb_os_pecas** (N:N OS ↔ Peças)

| Coluna           | Tipo         | Obrigatório | PK/FK | Descrição                                           |
| ---------------- | ------------ | ----------- | :---: | --------------------------------------------------- |
| os_id            | INT          | Sim         |  🔑🔶   | OS associada à peça                                 |
| peca_id          | INT          | Sim         |  🔑🔶   | Peça utilizada na OS                                |
| quantidade       | INT          | Não         |       | Quantidade de peças utilizadas                      |
| valor_total_peca | DECIMAL(8,2) | Não         |       | Valor total das peças (quantidade × valor_unitario) |

