# <img src="https://i.imgur.com/3CTEui8.png" alt="logo _ Power BI" width="6%"/> Dashboard Financeiro Criativo - Power BI

Este projeto apresenta um **dashboard interativo desenvolvido no Power BI**, utilizando a base de dados **financial_sample.xlsx**, que contém informações sobre vendas, produtos, países e segmentos de clientes.

O objetivo é fornecer uma visão clara e analítica sobre o desempenho de vendas, lucro e unidades vendidas, permitindo a análise por produto, segmento e país.



## 🗂️ Estrutura do Projeto

- **Base de dados:** `financial_sample.xlsx`. Contém informações sobre:
  - Produtos (Paseo, VTT, Amarilla, Montana, Velo, Carretera).
  - Segmentos de clientes (Government, Small Business, Channel Partners, Midmarket, Enterprise).
  - Países (United States, Canada, Germany, France, Mexico).
  - Dados de vendas, lucro, quantidade de unidades vendidas, descontos, custos (COGS) e períodos (2013 e 2014).

- **Dashboard no Power BI:** Criado para visualizar e explorar os dados de forma dinâmica, com filtros por ano/mês e segmentações.



## 📈 Visão Geral do Dashboard

O dashboard é dividido em **duas páginas principais**, cada uma com foco em diferentes análises:

### 🔹 Página 1 - Relatório de Vendas

- **Indicadores (cards):**  
  - Total de Vendas (R$ 118,73 milhões)  
  - Unidades Vendidas (1,13 milhão)  
  - Total de Descontos (R$ 9,21 milhões)  
  - Total de COGS (R$ 101,83 milhões)  
- **Gráfico de Linha:** Evolução mensal das vendas.  
- **Gráfico de Barras ou Pizza:** Vendas por segmento de clientes.  
- **Gráfico de Barras:** Vendas por produto.  
- **Treemap ou Mapa:** Vendas por país.  



### 🔹 Página 2 - Relatório de Lucro Detalhado

- **Indicador:** Lucro total (R$ 16,8 milhões no período).  
- **Gráfico de Radar:** Lucro por produto.  
- **Treemap:** Lucro por segmento de clientes.  
- **Gráfico de Cascata (Waterfall):** Evolução do lucro por trimestre.  
- **Segmentadores de dados:** Filtro por ano e país.  



## 🚀 Construção do Dashboard

O dashboard foi desenvolvido no **Power BI**, utilizando os seguintes passos:

1. **Importação dos dados** do arquivo `financial_sample.xlsx`.  
2. **Modelagem simples dos dados**, garantindo consistência em colunas de valores, categorias e datas.  
3. **Utilização de campos existentes** da base para calcular indicadores.  
4. **Construção de visuais interativos**, como gráficos de linha, barras, treemap, radar e cascata.  
5. **Aplicação de segmentações e filtros**, permitindo explorar dados por ano, mês, produto, segmento e país.  
6. **Design do dashboard**, com botões de navegação entre páginas e criação do layout mobile para uso em dispositivos móveis.  



## 📊 Principais Insights Obtidos

- O produto **Paseo** lidera em volume de vendas.  
- O segmento **Government** representa a maior fatia do lucro.  
- Os países com maior representatividade em vendas são **Estados Unidos, França e México**.  
- O lucro apresentou variações ao longo dos trimestres, com forte crescimento em 2014.  



## 🛠️ Tecnologias Utilizadas

- **Power BI Desktop** (criação e visualização do dashboard).  
- **Excel (financial_sample.xlsx)** (base de dados).  



## 📌 Como Utilizar

1. Baixe o arquivo **[financial_sample.xlsx](financial_sample.xlsx)**.  
2. Faça o download e abra o relatório no Power BI **[relatorio_criativo.pbix](relatorio_criativo.pbix)**.  
3. Instale as visualizações **[Chiclet Slicer](https://appsource.microsoft.com/pt-br/product/power-bi-visuals/wa104380756?tab=overview)** e **[RadarChart](https://appsource.microsoft.com/pt-br/product/power-bi-visuals/WA104380771?tab=Overview)** (disponível apenas em contas Pro ou Student do Power BI)
4. Navegue entre as páginas e explore os filtros para obter diferentes análises de vendas, lucros e unidades vendidas.  



## 📷 Pré-visualização

**Página 01 - Relatório de Vendas**

<div align="center"><img src="https://i.imgur.com/T9Xz4bm.png" alt="Sales Report"/></div>  



**Página 02 - Relatório de Lucro Detalhado**

<div align="center"><img src="https://i.imgur.com/9KECQjd.png" alt="Profit Report"/></div>  

