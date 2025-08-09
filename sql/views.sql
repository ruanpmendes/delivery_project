-- view_valor_pedido

create view vw_valor_pedido as
SELECT
	p.id_pedido,
	SUM((pd.preco * ip.quantidade) + COALESCE(a.preco * ipa.quantidade, 0)) AS valor_total
FROM pedido p
JOIN item_pedido ip ON p.id_pedido = ip.id_pedido
JOIN produto pd ON ip.id_produto = pd.id_produto
LEFT JOIN item_pedido_adicional ipa ON ip.id_item = ipa.id_item_pedido
LEFT JOIN adicional a ON ipa.id_adicional = a.id_adicional
GROUP BY p.id_pedido
ORDER BY p.id_pedido ASC;

-- view clientes_vip

create view vw_categoria_cliente as
with valor_total_cliente as(
select
	c.nome,
	vvp.valor_total
from vw_valor_pedido vvp
join pedido p on vvp.id_pedido = p.id_pedido
join cliente c on p.id_cliente = c.id_cliente 
)

select
	nome,
	case
		when valor_total <300 then 'Bronze'
		when valor_total between 300 and 500 then 'Prata'
		when valor_total between 500 and 1000 then 'Ouro'
		when valor_total >1000 then 'Diamante'
		else 'Nao classificado'
	end as categoria_cliente
from valor_total_cliente

-- view produto detalhado
create view vw_produto_detalhado as
with valores_totais_produto as(
	select
		pd.id_produto,
		pd.nome_produto,
		c.nome_categoria,
		count(ip.id_produto) as qtd_vendida,
		sum(pd.custo*ip.quantidade) as custo_total,
		sum(pd.preco*ip.quantidade) as receita_total
	from produto pd
	join categoria c on pd.id_categoria = c.id_categoria
	join item_pedido ip on pd.id_produto = ip.id_produto
	group by pd.id_produto, pd.nome_produto, c.nome_categoria
)

select
	id_produto,
	nome_produto,
	nome_categoria,
	qtd_vendida,
	custo_total,
	receita_total,
	trunc(((receita_total - custo_total)/custo_total)*100,2) as markup
from valores_totais_produto

-- view pedido detalhado
create view vw_pedido_detalhado as
select
	p.id_pedido,
	p.data_pedido,
	p.observacao,
	vvp.valor_total,
	c.nome as cliente,
	e.nome as entregador,
	s.nome_status as status_pedido,
	fp.forma_pagamento,
	ed.cep,
	ed.numero as n_endereco,
	ed.complemento,
	b.bairro,
	STRING_AGG(CONCAT(pd.nome_produto, '(', ip.quantidade, 'x)'), ' | ') as itens_do_pedido,
	STRING_AGG(
		case
			 when a.nome_adicional is not null then CONCAT(a.nome_adicional, '(', ipa.quantidade, 'x)')
			 else ''
		end, ' | '
	) filter (where a.nome_adicional is not null) as adicionais_pedido
	
from pedido p
join vw_valor_pedido vvp on p.id_pedido = vvp.id_pedido
join cliente c on p.id_cliente = c.id_cliente
join entregador e on p.id_entregador = e.id_entregador
join status_pedido s on p.id_status = s.id_status
join forma_pagamento fp on p.id_forma_pagamento = fp.id_forma_pagamento
join endereco ed on p.id_cliente = ed.id_cliente
join cep ce on ed.cep = ce.cep
join bairro b on ce.id_bairro = b.id_bairro
left join item_pedido ip on p.id_pedido = ip.id_pedido
left join produto pd on ip.id_produto = pd.id_produto
left join item_pedido_adicional ipa on ip.id_item = ipa.id_item_pedido
left join adicional a on ipa.id_adicional = a.id_adicional
group by p.id_pedido, p.data_pedido, p.observacao, vvp.valor_total, cliente, entregador, status_pedido, fp.forma_pagamento, ed.cep, n_endereco, ed.complemento, b.bairro
