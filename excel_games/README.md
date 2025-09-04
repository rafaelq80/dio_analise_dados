# Dashboard de Vendas de Jogos Xbox



Este repositório contém um **dashboard em Excel** desenvolvido para analisar dados de vendas de assinaturas e passes relacionados ao **Xbox Game Pass**. O objetivo é fornecer uma visão clara e organizada do desempenho de vendas, bem como responder a perguntas de negócio por meio de indicadores visuais e cálculos automatizados.



## Estrutura da Planilha

A planilha é composta por quatro abas principais:

### 1. **Assets**

- Contém a **paleta de cores** e elementos visuais utilizados para padronizar o design do dashboard.
- Inclui referências de cores da marca Xbox e tons complementares para manter consistência visual.

### 2. **Bases**

- Base de dados com informações sobre assinantes e vendas.
- Campos principais:
  - **Subscriber ID** → identificador único do assinante.
  - **Name** → nome do cliente.
  - **Plan** → tipo de plano adquirido (Core, Standard, Ultimate).
  - **Start Date** → data de início da assinatura.
  - **Auto Renewal** → se a renovação automática está ativa.
  - **Subscription Price** → valor da assinatura.
  - **Subscription Type** → periodicidade (mensal, anual, trimestral).
  - **EA Play Season Pass** e **Minecraft Season Pass** → adicionais contratados.
  - **Coupon Value** → descontos aplicados.
  - **Total Value** → valor total calculado considerando assinatura, passes e descontos.

### 3. **Cálculos**

- Aba dedicada às **perguntas de negócio** e métricas derivadas.
- Exemplos de cálculos presentes:
  - Faturamento total por período.
  - Quantidade de assinantes ativos.
  - Receita por tipo de plano (Core, Standard, Ultimate).
  - Impacto de cupons e descontos.
  - Participação dos passes adicionais (EA Play, Minecraft) no faturamento.

### 4. **Dashboard**



<div align="center"><img src="https://i.imgur.com/UZuLDb4.png" alt="Dashboard - Games" /></div>

- Área final do relatório com **gráficos, indicadores e KPIs**.
- Visualizações destacam:
  - Receita total e distribuída por tipo de plano.
  - Comparativo de assinantes com e sem passes adicionais.
  - Percentual de assinaturas com renovação automática.
  - Impacto dos cupons sobre a receita.



## Construção do Dashboard

1. **Coleta de dados**: os dados brutos foram organizados na aba *Bases*.
2. **Transformação e cálculos**: métricas derivadas foram desenvolvidas na aba *Cálculos* para responder a perguntas de negócio.
3. **Design visual**: a aba *Assets* definiu a identidade visual e cores aplicadas.
4. **Visualização final**: todos os indicadores foram consolidados na aba *Dashboard*, usando gráficos e tabelas dinâmicas.



## Objetivo

O dashboard permite que gestores e analistas acompanhem:

- O desempenho de vendas de assinaturas Xbox.
- A contribuição dos planos (Core, Standard, Ultimate) para a receita.
- O efeito de passes adicionais e cupons no faturamento.
- O comportamento dos clientes em relação à renovação automática.

Essa abordagem garante uma visão completa do negócio, facilitando a tomada de decisão estratégica.



## Tecnologias Utilizadas

- **Microsoft Excel** (gráficos, tabelas dinâmicas, fórmulas).
- Estrutura modular dividida em *Assets*, *Bases*, *Cálculos* e *Dashboard*.



## Como Usar

1. Faça o downloa e abra o arquivo **[dash_games.xlsx](dash_games.xlsx)** no Excel.
2. Navegue pela aba **Dashboard** para visualizar os indicadores.
3. Consulte as abas **Bases** e **Cálculos** para entender os dados e fórmulas aplicadas.