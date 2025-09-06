# <img src="https://i.imgur.com/3CTEui8.png" alt="logo _ Power BI" width="6%"/> Dashboard de Recursos Humanos – Power BI



Este projeto apresenta um **dashboard interativo desenvolvido no Power BI**, utilizando a base de dados relacional **Azure Company** (modelada em SQL). O objetivo é fornecer uma visão clara sobre **colaboradores, departamentos, salários e projetos**, permitindo análises gerenciais e estratégicas.



## 🗂️ Estrutura do Projeto

- **Base de dados:** Banco de dados **Azure Company**, hospedado na nuvem Azure em uma instância **MySQL**, contendo:
  - Colaboradores (dados pessoais, salário, supervisor, departamento).
  - Departamentos e gerentes responsáveis.
  - Localizações de cada departamento.
  - Projetos e colaboradores alocados.
  - Dependentes dos colaboradores.

<div align="center"><img src="https://i.imgur.com/PHcry4Q.png" alt="logo _ Power BI"/></div>

- **Dashboard no Power BI:** Criado para consolidar as informações e permitir uma análise dinâmica sobre **estrutura hierárquica, salários e carga de trabalho por projeto**.



## <img src="https://i.imgur.com/LI9S2Bf.png" alt="logo _ Power BI" width="6%"/> Transformações no Power Query

Antes da construção do dashboard, os dados passaram pelas seguintes etapas de preparação:

1. **Verificação de tipos de dados**  
   - Datas → `Date`  
   - Números inteiros → `Whole Number`
   - Valores decimais → `Decimal Number`
   - Textos → `Text`  
2. **Ajustes em valores monetários**  
   - Conversão de salários e outros valores financeiros para `Decimal Number` com maior precisão.
3. **Tratamento de nulos**  
   - Na coluna `Super_ssn` os valores nulos foram **preenchidos com dados válidos. Dessa forma, todos os colaboradores ficaram associados a um supervisor ou gerente.
   - Verificação de nulos em `works_on` para garantir consistência.
4. **Junção de dados - `employee_manager`**  
   - `employee` ↔ `departament` (Dno = Dnumber).  
   - `employee` ↔ `employee` (*self-join* para trazer o nome do gerente).  
5. **Criação de colunas derivadas**  
   - `Name` = concatenação de nome e sobrenome.  
   - `Manager` = concatenação de nome e sobrenome do gerente via merge em `employee`.  
   - `Dept_Location` = concatenação do nome e do local do departamento.
6. **Agrupamentos e cálculos**  
   - Contagem de colaboradores por gerente.  
   - Média salarial por departamento.  
   - Total de horas por projeto.  
7. **Eliminação de colunas desnecessárias**  
   - Mantidas apenas colunas úteis para análise

> [!NOTE]
>
> No item 4, foi utilizada a opção **Mesclar (Merge)** porque ela cria uma **tabela relacionada sem sobrescrever dados originais**, preservando integridade.
>
> A opção **Atribuir (Replace Values/Add Column)** alteraria dados existentes de forma fixa, o que comprometeria a relação entre tabelas.



## 📈 Visão Geral do Dashboard

O dashboard é composto por diferentes elementos de análise:

- **Indicadores (cards):**
  - Média Salarial (R$ 35,13 mil).  
  - Total de Colaboradores (8).  
  - Total de Projetos (6).  

- **Tabela:** Lista colaboradores, departamentos e respectivos gerentes.

- **Gráfico de Colunas:** Horas trabalhadas por projeto.

- **Treemap:** Quantidade de colaboradores por gerente.

- **Gráfico de Pizza:** Distribuição de colaboradores por departamento.

- **Gráfico de Barras:** Salário médio por departamento.



## 🚀 Construção do Dashboard



O dashboard foi desenvolvido no **Power BI Desktop** com os seguintes passos:

1. Importação das tabelas a partir do banco **Azure Company**.
2. Modelagem e normalização dos dados no **Power Query**.
3. Criação de colunas calculadas e merges para relacionar colaboradores, departamentos e gerentes.
4. Eliminação de colunas não utilizadas e validação das relações.
5. Construção dos visuais (cards, tabelas, colunas, pizza, treemap).
6. Aplicação de filtros e segmentações interativas.



## 📊 Principais Insights Obtidos

- O **departamento Research** concentra a maior parte dos colaboradores.
- Diferenças salariais significativas existem entre os departamentos.
- A carga de trabalho não está uniformemente distribuída entre os projetos, apontando possíveis sobrecargas.
- A hierarquia de gerentes está clara, facilitando a visualização da supervisão de cada colaborador.
- O dashboard pode apoiar decisões estratégicas em alocação de recursos e política salarial.



## 🛠️ Tecnologias Utilizadas

- **MySQL** – criação e população do banco de dados.
- **Power BI Desktop** – ETL, modelagem e visualizações.



## 📌 Como Utilizar

1. Crie uma instância do banco de dados MySQL no Azure
2. Execute o script SQL ([`db_azure_company.sql`](db_azure_company.sql)) para criar e popular o banco de dados.  
3. Conecte o **Power BI Desktop** ao banco de dados MySQL.  
4. Carregue as tabelas no Power Query e aplique as transformações descritas.  
5. Explore o dashboard e utilize os filtros para obter diferentes visões da estrutura organizacional.  



## 📷 Pré-visualização

<div align="center"><img src="https://i.imgur.com/8S3LMcI.png" alt="Dashboard HR"/></div>
