-- ==============================================================================================================================================================
-- CONSULTA 1: PRODUTOS VENDIDOS POR CATEGORIA
-- ==============================================================================================================================================================
-- PROBLEMA DE NEGÓCIO: A gerência quer entender a popularidade dos produtos por categoria para otimizar o cardápio e estoque.
-- OBJETIVO: Contar o número total de itens vendidos para cada categoria de produto (ex: Pizza, Bebida, Sobremesa).
-- FERRAMENTA UTILIZADA: Funções de agregação (COUNT) e GROUP BY.

SELECT
	c.nome_categoria,
	COUNT(ip.id_item) AS total_itens_vendidos -- Total de itens vendidos para a categoria
FROM
    item_pedido ip
JOIN
    produto p ON ip.id_produto = p.id_produto
JOIN
    categoria c ON p.id_categoria = c.id_categoria
GROUP BY
    c.nome_categoria -- Agrupa os resultados por nome da categoria
ORDER BY
    total_itens_vendidos DESC; -- Ordena pelas categorias com mais itens vendidos

-- ==============================================================================================================================================================
-- CONSULTA 2: CLIENTES COM MAIS PEDIDOS
-- ==============================================================================================================================================================
-- PROBLEMA DE NEGÓCIO: Identificar os clientes mais fiéis e engajados para programas de fidelidade ou promoções personalizadas
-- OBJETIVO: Listar os clientes que realizaram o maior número de pedidos.
-- FERRAMENTA UTILIZADA: Funções de agregação (COUNT) e GROUP BY

SELECT
	c.nome AS nome_cliente, -- Nome do cliente
	COUNT(p.id_pedido) AS qtd_pedidos -- Quantidade total de pedidos feitos pelo cliente
FROM
    pedido p
JOIN
    cliente c ON p.id_cliente = c.id_cliente
GROUP BY
    nome_cliente -- Agrupa os resultados por nome do cliente
ORDER BY
    qtd_pedidos DESC -- Ordena para mostrar os clientes com mais pedidos primeiro

-- ==============================================================================================================================================================
-- CONSULTA 3: PEDIDOS POR STATUS
-- ==============================================================================================================================================================
-- PROBLEMA DE NEGÓCIO: Monitorar o fluxo operacional dos pedidos e a distribuição dos status atuais.
-- OBJETIVO: Contar quantos pedidos estão em cada fase (ex: 'Pendente', 'Preparando', 'Entregue').
-- FERRAMENTA UTILIZADA: Funções de agregação (COUNT) e GROUP BY.

SELECT
	s.nome_status,
	COUNT(p.id_pedido) AS qtd_pedidos -- Quantidade de pedidos por status
FROM
    pedido p
JOIN
    status_pedido s ON p.id_status = s.id_status
GROUP BY
    s.nome_status -- Agrupa os resultados por nome do status
ORDER BY
    qtd_pedidos DESC; -- Ordena para mostrar os status com mais pedidos primeiro

-- ==============================================================================================================================================================
-- CONSULTA 4: FATURAMENTO POR MÊS/ANO
-- ==============================================================================================================================================================
-- PROBLEMA DE NEGÓCIO: Avaliar a performance de vendas ao longo do tempo para identificar tendências e sazonalidades.
-- OBJETIVO: Calcular o faturamento total da pizzaria por mês e ano.
-- FERRAMENTA UTILIZADA: Funções de extração de data (EXTRACT), funções de agregação (SUM) e GROUP BY.

SELECT
	EXTRACT(YEAR FROM p.data_pedido) AS ano, -- Extrai o ano da data do pedido
    EXTRACT(MONTH FROM p.data_pedido) AS mes, -- Extrai o mês da data do pedido
    TRUNC(SUM(vvp.valor_total), 2) AS faturamento_mensal -- Soma o valor total dos pedidos para o mês/ano
FROM
    pedido p
JOIN
    vw_valor_pedido vvp ON p.id_pedido = vvp.id_pedido
GROUP BY
    ano, mes -- Agrupa os resultados por ano e mês
ORDER BY
    ano, mes; -- Ordena cronologicamente por ano e mês

-- ==============================================================================================================================================================
-- CONSULTA 5: ANÁLISE DE VENDAS DETALHADA POR PERÍODO
-- ============================================================================================================================================================
-- PROBLEMA DE NEGÓCIO: A gerência precisa de um resumo diário da performance de vendas para tomar decisões rápidas.
-- OBJETIVO: Fornecer métricas essenciais como faturamento, número de pedidos e ticket médio para cada dia.
-- FERRAMENTAS UTILIZADAS: Funções de extração de data (DATE), funções de agregação (COUNT, SUM, AVG) e GROUP BY.

SELECT
	DATE(p.data_pedido) AS data_do_pedido, -- Extrai apenas a data do pedido (sem a hora)
    COUNT(p.id_pedido) AS qtd_pedidos, -- Quantidade total de pedidos no dia
    TRUNC(SUM(vvp.valor_total), 2) AS faturamento_diario, -- Faturamento total no dia
    TRUNC(AVG(vvp.valor_total), 2) AS ticket_medio_diario -- Ticket médio dos pedidos no dia
FROM
    pedido p
JOIN
    vw_valor_pedido vvp ON p.id_pedido = vvp.id_pedido
GROUP BY
    DATE(p.data_pedido) -- Agrupa os resultados por dia
ORDER BY
    data_do_pedido ASC; -- Ordena os resultados cronologicamente
	
-- ==============================================================================================================================================================
-- CONSULTA 6: SEGMENTAÇÃO DE PEDIDOS POR FAIXA DE VALOR (USANDO CASE)
-- ==============================================================================================================================================================
-- PROBLEMA DE NEGÓCIO: A gerência quer analisar o perfil de consumo para planejar promoções e estratégias de marketing.
-- OBJETIVO: Classificar os pedidos em diferentes faixas de valor (Baixo, Médio, Alto) e exibir a quantidade de pedidos e o ticket médio para cada faixa.
-- FERRAMENTA UTILIZADA: CASE para lógica condicional.

SELECT
    -- O CASE categoriza cada pedido com base no seu 'valor_total'.
    CASE
        WHEN valor_total < 50.00 THEN 'Baixo'
        WHEN valor_total BETWEEN 50.00 AND 150.00 THEN 'Medio'
        WHEN valor_total > 150.00 THEN 'Alto'
        ELSE 'Nao Classificado' -- Caso tenha valores nulos ou inesperados
    END AS faixa_valor_pedido,
    -- Conta o número de pedidos em cada faixa.
    COUNT(id_pedido) AS qtd_pedidos,
    -- Calcula o valor médio dos pedidos (ticket médio) para cada faixa, arredondando para 2 casas decimais.
    TRUNC(AVG(valor_total), 2) AS ticket_medio
FROM
    -- Utiliza a VIEW 'vw_valor_pedido' para obter o valor total de cada pedido, simplificando a consulta.
    vw_valor_pedido
GROUP BY
    -- Agrupa os resultados pela 'faixa_valor_pedido' para aplicar as funções de agregação (COUNT e AVG) a cada categoria.
    faixa_valor_pedido
ORDER BY
    -- Ordena os resultados pelo ticket médio de forma decrescente para ver as faixas de maior valor primeiro.
    ticket_medio DESC;

-- ==============================================================================================================================================================
-- CONSULTA 7: PRODUTOS MAIS VENDIDOS POR CATEGORIA E SUA REPRESENTATIVIDADE (USANDO CTE E WINDOW FUNCTION)
-- ==============================================================================================================================================================
-- PROBLEMA DE NEGÓCIO: A empresa quer identificar os produtos mais vendidos dentro de cada categoria e entender sua participação nas vendas totais da categoria.
-- OBJETIVO: Exibir os itens mais vendidos de cada categoria e calcular a porcentagem que cada um corresponde da venda total da categoria.
-- FERRAMENTAS UTILIZADAS: CTE para organização e Window Function para cálculos percentuais.

-- CTE: venda_por_produto
-- Calcula o total de unidades vendidas para cada produto, agrupado por categoria e nome do produto.
WITH venda_por_produto AS (
    SELECT
        c.nome_categoria,
        p.nome_produto,
        SUM(ip.quantidade) AS total_vendido -- Soma a quantidade vendida de cada item
    FROM
        item_pedido ip
    JOIN
        produto p ON ip.id_produto = p.id_produto
    JOIN
        categoria c ON p.id_categoria = c.id_categoria
    GROUP BY
        c.nome_categoria, p.nome_produto -- Agrupa por categoria e produto para somar as quantidades
)
SELECT
    nome_categoria,
    nome_produto,
    total_vendido,
    -- Calcula o percentual de vendas do produto em relação ao total vendido na sua categoria.
    -- SUM(total_vendido) OVER (PARTITION BY nome_categoria) calcula a soma total de vendas para cada categoria.
    -- CAST(total_vendido AS DECIMAL) garante que a divisão seja decimal para o cálculo percentual mais eficaz.
    TRUNC(CAST(total_vendido AS DECIMAL) / SUM(total_vendido) OVER (PARTITION BY nome_categoria) * 100, 2) AS percentual_na_categoria
FROM
    venda_por_produto -- Utiliza os resultados da CTE
ORDER BY
    nome_categoria, total_vendido DESC; -- Ordena primeiro por categoria e depois pelo total vendido (decrescente)

-- ==============================================================================================================================================================
-- CONSULTA 8: DESEMPENHO DOS ENTREGADORES (TEMPO MÉDIO DE ENTREGA)
-- ==============================================================================================================================================================
-- PROBLEMA DE NEGÓCIO: A empresa quer avaliar o desempenho dos entregadores com base no tempo médio de entrega.
-- OBJETIVO: Exibir a quantidade de entregas realizadas por cada entregador e seu tempo médio de entrega em minutos.
-- FERRAMENTAS UTILIZADAS: CTEs para organização de lógica e funções de agregação (AVG, COUNT).

-- CTE: pedido_inicio
-- Obtém a data/hora do status inicial de cada pedido.
WITH pedido_inicio AS (
    SELECT
        id_pedido,
        data_status AS data_inicio
    FROM
        historico_status_pedido
    WHERE
        id_status = 1 -- ID que marca inicio do pedido
),
-- CTE: pedido_fim
-- Obtém a data/hora do status final de cada pedido.
pedido_fim AS (
    SELECT
        id_pedido,
        data_status AS data_fim
    FROM
        historico_status_pedido
    WHERE
        id_status = 4 -- ID que marca entrega do pedido
),
-- CTE: tempo_entrega
-- Calcula a diferença de tempo em minutos entre o início e o fim do pedido.
-- EXTRACT(EPOCH FROM ...) retorna a diferença em segundos, dividimos por 60 para obter minutos.
-- TRUNC(..., 2) arredonda o resultado para duas casas decimais.
tempo_entrega AS (
    SELECT
        pi.id_pedido,
        TRUNC(EXTRACT(EPOCH FROM (pf.data_fim - pi.data_inicio)) / 60, 2) AS total_minutos
    FROM
        pedido_inicio pi
    JOIN
        pedido_fim pf ON pi.id_pedido = pf.id_pedido
),
-- CTE: pedidos_com_tempo_e_entregador
-- Junta as informações de tempo de entrega com os dados do entregador para cada pedido entregue.
pedidos_com_tempo_e_entregador AS (
    SELECT
        p.id_entregador,
        e.nome AS nome_entregador,
        te.total_minutos
    FROM
        pedido p
    JOIN
        entregador e ON p.id_entregador = e.id_entregador
    JOIN
        tempo_entrega te ON p.id_pedido = te.id_pedido
    WHERE
        p.id_status = 4 -- Filtra apenas pedidos que foram efetivamente entregues
)
-- Consulta final: Agrupa os resultados por entregador para exibir uma linha única para cada um.
SELECT
    id_entregador,
    nome_entregador,
    -- Conta o número de pedidos entregues por cada entregador.
    COUNT(total_minutos) AS qtd_entregas,
    -- Calcula o tempo médio de entrega para todos os pedidos daquele entregador, arredondando.
    TRUNC(AVG(total_minutos), 2) AS tempo_medio_minutos
FROM
    pedidos_com_tempo_e_entregador
GROUP BY
    id_entregador, nome_entregador -- Agrupa pelo ID e nome do entregador
ORDER BY
    tempo_medio_minutos ASC; -- Ordena pelo tempo médio para ver os mais rápidos primeiro

-- ==============================================================================================================================================================
-- CONSULTA 9: TICKET MÉDIO POR CLIENTE (USANDO VIEW)
-- ==============================================================================================================================================================
-- PROBLEMA DE NEGÓCIO: A gestão quer saber qual o ticket médio de pedidos por cliente para identificar clientes de alto valor.
-- OBJETIVO: Exibir a quantidade de pedidos realizados por cada cliente e seu ticket médio.
-- FERRAMENTA UTILIZADA: Utilização direta da VIEW 'vw_valor_pedido' para simplificar o cálculo do valor total do pedido.

SELECT
    c.nome AS nome_cliente,
    -- Conta o número total de pedidos feitos por cada cliente.
    COUNT(p.id_pedido) AS qtd_pedidos,
    -- Calcula o valor médio dos pedidos (ticket médio) para cada cliente, arredondando para 2 casas decimais.
    TRUNC(AVG(vvp.valor_total), 2) AS ticket_medio
FROM
    pedido p
JOIN
    cliente c ON p.id_cliente = c.id_cliente
JOIN
    -- A VIEW 'vw_valor_pedido' é usada aqui como uma tabela normal, fornecendo o 'valor_total' já calculado para cada pedido.
    -- Isso evita a necessidade de repetir toda a lógica de JOINs e SUMs para calcular o valor do pedido.
    vw_valor_pedido vvp ON p.id_pedido = vvp.id_pedido
GROUP BY
    c.nome -- Agrupa os resultados pelo nome do cliente
ORDER BY
    ticket_medio DESC; -- Ordena os clientes com base no seu ticket médio, do maior para o menor.

-- ==============================================================================================================================================================
-- CONSULTA 10: INFORMAÇÕES PARA RODADA DE INVESTIMENTOS (MÉTRICAS FINANCEIRAS GERAIS)
-- ============================================================================================================================================================
-- PROBLEMA DE NEGÓCIO: A empresa precisa de métricas financeiras consolidadas para apresentar a potenciais investidores.
-- OBJETIVO: Fornecer um resumo financeiro robusto, incluindo faturamento, custos, lucro, markup e indicadores de volume.
-- FERRAMENTAS UTILIZADAS: CTE para cálculo de custos e funções de agregação (SUM, AVG, COUNT).

with custo_pedido as(
SELECT
	p.id_pedido,
	SUM((pd.custo * ip.quantidade) + COALESCE(a.custo * ipa.quantidade, 0)) AS custo_total
FROM pedido p
JOIN item_pedido ip ON p.id_pedido = ip.id_pedido
JOIN produto pd ON ip.id_produto = pd.id_produto
LEFT JOIN item_pedido_adicional ipa ON ip.id_item = ipa.id_item_pedido
LEFT JOIN adicional a ON ipa.id_adicional = a.id_adicional
GROUP BY p.id_pedido
ORDER BY p.id_pedido ASC
)

select 
	sum(vvp.valor_total) as receita_bruta,
	sum(vvp.valor_total) - sum(cp.custo_total) as lucro_bruto,
	trunc(((sum(vvp.valor_total) - sum(cp.custo_total)) / NULLIF(sum(cp.custo_total), 0)) *100,2) as markup_media,
	count(cp.id_pedido) as qtd_pedidos,
	trunc(sum(vvp.valor_total) / count(cp.id_pedido),2) as ticket_medio
from custo_pedido cp
join vw_valor_pedido vvp on cp.id_pedido = vvp.id_pedido
