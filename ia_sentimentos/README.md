# <img src="https://i.imgur.com/pIpC3bT.png" alt="logo _ Power BI" width="6%"/>Lab Project 03 - Análise de Sentimentos com Azure Language Studio



Este repositório demonstra como utilizar o **Azure Language Studio** para realizar uma análise de sentimentos (*Sentiment and Opinion Mining*) em textos. O experimento faz parte das atividades do **Bootcamp Microsoft Azure AI Fundamentals (DIO)** e foi baseado nos guias oficiais da [Microsoft Learn](https://microsoftlearning.github.io/mslearn-ai-fundamentals/Instructions/Labs/06-text-analysis.html).

A solução permite identificar **sentimentos positivos, negativos e neutros** em frases ou textos, auxiliando em tarefas como análise de *feedbacks* de clientes, comentários e avaliações.



## 1. Criar um recurso no Azure Language Service

Antes de usar o Language Studio, é necessário criar um recurso na sua conta Azure:

1. Acesse [Azure Portal](https://portal.azure.com).  
2. Clique em **Create Resource** e pesquise por **Language Service**.  
3. Configure o recurso e aguarde a finalização do *deploy*.  



## 2. Conectar o recurso ao Language Studio

Com o recurso criado, é preciso conectá-lo ao Language Studio:

1. Acesse o [Azure Language Studio](https://language.cognitive.azure.com/home).  
2. Na tela inicial, clique em **Select a resource**.  
3. Informe os dados da assinatura e selecione o recurso criado anteriormente.  



## 3. Selecionar o serviço de Análise de Sentimentos

Dentro do Language Studio, após vincular o recurso:

1. Na aba **Classify text**, selecione **Analyze sentiment and mine opinions**.  
2. Insira o texto de teste no campo disponível.  
3. Defina o idioma (por exemplo, **Português**).  
4. Ative a opção de **Opinion Mining** (se desejado).  



## 4. Resultado da análise



Testar frases no **Azure Language Studio** evidencia como a ferramenta vai além de uma simples classificação, entregando insights granulares e reais — de acordo com a documentação oficial da Microsoft:

- **Frase claramente positiva**  
  *Entrada:* `"A interface do app é clara e funciona perfeitamente."`  
  *Saída esperada:* Sentimento **Positive**, com alta confiança.

- **Frase claramente negativa**  
  *Entrada:* `"O download falhou várias vezes e o suporte demorou a responder."`  
  *Saída esperada:* Sentimento **Negative**, com alta confiança.

- **Frase com nuances — sentimento misto**  
  *Entrada:* `"O café estava ótimo, mas a espera foi frustrante."`  
  *Saída esperada:*  
  - No documento, classificação **Mixed** (há positiva e negativa).  
  - No nível das sentenças, reconhecimento da parte **positiva** (“café ótimo”) e da parte **negativa** (“espera frustrante”).

- **Frase neutra**  
  *Entrada:* `"A palestra começou às 19h e terminou pontualmente."`  
  *Saída esperada:* Sentimento **Neutral**, com confiança equilibrada.

- **Frase com aspecto explícito (Opinion Mining)**  
  *Entrada:* `"O quarto tinha ótima limpeza, mas o ar-condicionado fazia muito barulho."`  
  *Com `opinionMining=true`, a análise identifica:*  
  - **Target:** “limpeza” → **Positive**  
  - **Target:** “ar-condicionado” → **Negative**.

Esses exemplos mostram que o **Azure Language Studio**, conforme documentado, permite:

- Classificar no nível do **documento** e das **sentenças**, com cálculo automático do rótulo “mixed” quando há polaridades diferentes.  
- Habilitar **Opinion Mining** para extrair opiniões específicas relacionadas a aspectos mencionados no texto.  
- Suportar análise em **Português do Brasil**, entre outros idiomas.



## 5. Conclusão e Insights

A análise de sentimentos no **Azure Language Studio** se mostra útil para:  
- Monitorar *feedbacks* de clientes;  
- Avaliar comentários em redes sociais;  
- Apoiar decisões baseadas em percepção do público.  

Por outro lado, a ferramenta apresenta algumas limitações:  
- O resultado pode não ser tão preciso quando o texto possui **expressões ambíguas** ou contexto implícito.  
- A análise é feita **sentença por sentença**, o que pode dificultar a interpretação do **contexto global**.  

Mesmo com essas restrições, o recurso é uma excelente introdução à aplicação de **IA em processamento de linguagem natural (NLP)**.  

