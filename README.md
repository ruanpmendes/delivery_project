🍕 Daqui Sai Uma Pizza! (E Muitos Dados!)
Meu Primeiro Projeto SQL 📊
Olá! Que bom que você chegou por aqui!

Este é o meu projeto de portfólio de banco de dados e análise de dados, e confesso que estou super animado em compartilhar essa jornada. A ideia foi criar um sistema de delivery de pizzas desde o zero, mas não só para gerenciar pedidos, e sim para extrair insights reais do negócio.

Aqui você vai ver como transformei dados brutos em informações valiosas, explorando o mundo do SQL de uma forma prática e divertida!

🚀 Por Que Esse Projeto? (Meus Objetivos)
Esse projeto surgiu com um objetivo claro: ir além da teoria e colocar a mão na massa! Minhas metas principais foram:

Entender a fundo o Design de Banco de Dados: Modelar as tabelas (clientes, pizzas, entregadores, pedidos) de um jeito que faça sentido e seja eficiente.

Dominar o SQL na Prática: Aplicar comandos avançados para criar, manipular e, principalmente, analisar dados.

Construir um "Cérebro" para a Pizzaria: Implementar automações e garantir que os dados estejam sempre certinhos.

Transformar Números em Histórias: Mostrar que os dados não são só números, mas contam a história do negócio, revelando o que está dando certo e onde podemos melhorar.

🛠️ As Ferramentas que Usei
Para dar vida a essa pizzaria virtual, contei com:

PostgreSQL

PgAdmin

📊 Dando Uma Olhada no Mapa (Estrutura do Banco de Dados)
Tudo começa com uma boa base, certo? Pensei em como organizar as informações da pizzaria para que elas fizessem sentido. Aqui estão os "mapas" que criei para guiar a construção do banco:

Diagrama de Entidade-Relacionamento (ER)
Diagrama de Entidade-Relacionamento Detalhado (DER)
💻 Como Colocar a Mão na Massa e Ver Acontecer!
Quer ver a pizzaria funcionando no seu computador? É super fácil!

Tenha o PostgreSQL instalado: Se ainda não tem, baixe por aqui.

Crie seu Banco de Dados: Você pode criar o banco de dados usando seu cliente favorito (como pgAdmin). É super importante que ele use a codificação UTF-8 para que nossos acentos e caracteres especiais funcionem perfeitamente!

Abra o pgAdmin.

Clique com o botão direito em "Databases" (ou "Bancos de Dados") -> "Create" (Criar) -> "Database..." (Banco de Dados...).

No campo "Database" (Banco de Dados), digite o nome que você quer (ex: pizzaria_delivery_db).

Na aba "Definition" (Definição), certifique-se de que "Encoding" (Codificação) esteja definido como UTF8. Para "Collation" (Ordenação) e "Character Type" (Tipo de Caractere), selecione uma opção que contenha UTF-8 (ex: Portuguese_Brazil.1252 se for Windows ou pt_BR.UTF-8 se for Linux/Mac - ou as opções genéricas C ou en_US com UTF-8 se as específicas não aparecerem).

Rode os Scripts SQL: Agora, entre na pasta sql/ do projeto que você clonou e execute os arquivos na ordem certinha. Eles são a "receita" para montar e popular o banco:

schema_creation.sql: Cria todas as tabelas.

data_inserts.sql: Preenche as tabelas com clientes, pizzas, bebidas, pedidos, etc!

indexes.sql: Deixa tudo rapidinho para encontrar as informações.

triggers.sql: Ativa as automações e regras inteligentes do sistema.

views.sql: Cria atalhos para as análises mais complexas.

analysis_queries.sql: Onde a análise acontece.

📊 O Que os Dados Me Contaram (Minhas Análises!)
Depois de tudo pronto, chegou a hora de fazer as perguntas e deixar os dados responderem. Aqui estão algumas das análises mais legais que fiz:

Informações para uma Rodada de Investimentos (Métricas Financeiras)

A Dúvida: Quais dados podemos apresentar para potenciais investidores que mostrem a saúde financeira do negócio?

A Resposta dos Dados: Consolidei métricas financeiras essenciais como Faturamento Total, Custo Total dos Produtos Vendidos, Lucro Bruto e Margem de Markup. Além disso, incluí o Total de Pedidos e o Ticket Médio por Pedido, que são cruciais para entender o volume de negócios e o valor médio das transações.

Quem Gasta Mais? (Segmentação de Pedidos por Faixa de Valor)

A Dúvida: Como entender melhor o perfil de consumo dos clientes para criar promoções que realmente funcionem?

A Resposta dos Dados: Classifiquei os pedidos em "Baixo", "Médio" e "Alto" valor. Isso me ajudou a ver qual tipo de pedido é mais comum e o ticket médio de cada um. Imagina o marketing sabendo disso!

A Estrela do Cardápio (Produtos Mais Vendidos por Categoria)

A Dúvida: Qual pizza, bebida ou sobremesa é a queridinha dos clientes? E quanto ela representa nas vendas da sua categoria?

A Resposta dos Dados: Descobri quais são os itens que mais saem e qual a "fatia" deles no bolo de vendas de cada categoria. Essencial para decidir o que mais produzir!

Corrida Contra o Tempo (Desempenho dos Entregadores)

A Dúvida: Quem são os "Flashes" da entrega? E quem precisa de um empurrãozinho para otimizar o tempo?

A Resposta dos Dados: Calculei o tempo médio de entrega de cada entregador e vi quantas entregas cada um fez. Dá para otimizar as rotas e até dar um bônus para quem é mais rápido!

Clientes VIP (Ticket Médio por Cliente)

A Dúvida: Quais clientes merecem um tratamento especial? Aqueles que realmente movimentam a pizzaria!

A Resposta dos Dados: Calculei o gasto médio de cada cliente por pedido. Com isso, a pizzaria pode identificar seus clientes mais valiosos e criar programas de fidelidade super personalizados.

🛡️ Os Guardiões dos Dados (Automação e Integridade)
Para que tudo funcione liso, o banco de dados tem uns "guardiões" que automatizam tarefas e garantem que a informação seja sempre confiável:

trg_status_pedido_historico: Esse trigger é como um diário de bordo do pedido. A cada vez que o status de uma pizza muda (saiu para entrega, foi entregue), ele registra tudo automaticamente. Perfeito para saber a trajetória de cada pedido!

log_custo e log_preco: Esses são os auditores de preço. Se o preço ou custo de uma pizza mudar, eles registram essa alteração. Assim, a pizzaria sempre tem um histórico para saber como os valores evoluíram.

➡️ Próximos Passos (O Futuro da Pizzaria!)
Esse projeto é só o começo! Penso em algumas melhorias futuras para a pizzaria:

Conectar com Power BI/Tableau: Criar dashboards visuais e interativos para a gerência acompanhar tudo em tempo real.

Análises Mais Profundas: Prever a demanda de pizzas, calcular o "valor vitalício" de cada cliente (quanto ele vai gastar ao longo da vida na pizzaria).

Espero que você goste do projeto! Sinta-se à vontade para explorar, dar um feedback ou até sugerir novas funcionalidades.