-- Fazer uma análise de crescimento mensal e o cálculo de YTD usando CTE

WITH ReceitasMensais AS (
    SELECT
        EXTRACT(YEAR FROM o.order_date) AS ano,
        EXTRACT(MONTH FROM o.order_date) AS mes,
        ROUND(SUM((od.unit_price * od.quantity) * (1 - od.discount))) AS receita_mensal
    FROM orders o
    INNER JOIN order_details od ON od.order_id = o.order_id
    GROUP BY
        EXTRACT(YEAR FROM o.order_date),
        EXTRACT(MONTH FROM o.order_date)
),
ReceitasMensaisAcumuladas AS (
    SELECT
        ano,
        mes,
        receita_mensal,
        SUM(receita_mensal) OVER (PARTITION BY ano ORDER BY mes) AS receita_ytd
    FROM ReceitasMensais
)
SELECT
    ano,
    mes,
    receita_mensal,
    receita_mensal - LAG(receita_mensal) OVER (PARTITION BY ano ORDER BY mes) AS diferenca_mensal,
    receita_ytd,
    ROUND((receita_mensal - LAG(receita_mensal) OVER (PARTITION BY ano ORDER BY mes)) * 100 / LAG(receita_mensal) OVER (PARTITION BY ano ORDER BY mes)) AS percentual_mudanca_mensal
FROM ReceitasMensaisAcumuladas
ORDER BY ano, mes;




-- Valor total pago por cliente
SELECT
    c.company_name,
    ROUND(SUM((od.unit_price * od.quantity) * (1 - od.discount))) AS total_gasto
FROM orders o
INNER JOIN order_details od ON od.order_id = o.order_id
INNER JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.company_name
order by total_gasto DESC;


-- Cinco grupos de acordo com valor pago por cliente










SELECT
    c.company_name,
    ROUND(SUM((od.unit_price * od.quantity) * (1 - od.discount))) AS valor_pago_por_cliente,
    NTILE(5) OVER (ORDER BY SUM((od.unit_price * od.quantity) * (1 - od.discount)) DESC) AS group
FROM orders o
INNER JOIN order_details od ON od.order_id = o.order_id
INNER JOIN customers c ON c.customer_id = o.customer_id
GROUP BY c.company_name

-- Agora somente os clientes que estão nos grupos 3, 4, 5 para que seja feita uma análise de Marketing especial com eles
WITH clientes_para_marketing AS (
SELECT
    c.company_name,
    ROUND(SUM((od.unit_price * od.quantity) * (1 - od.discount))) AS valor_pago_por_cliente,
    NTILE(5) OVER (ORDER BY SUM((od.unit_price * od.quantity) * (1 - od.discount)) DESC) AS group_marketing
FROM orders o
INNER JOIN order_details od ON od.order_id = o.order_id
INNER JOIN customers c ON c.customer_id = o.customer_id
GROUP BY c.company_name
)
SELECT * FROM clientes_para_marketing
WHERE group_marketing >= 3;


--Identificar os 10 produtos mais vendidos por preço acumulado
SELECT
    p.product_name,
    SUM((od.unit_price * od.quantity) * (1 - od.discount))
FROM
    orders o
INNER JOIN order_details od ON od.order_id = o.order_id
INNER JOIN products p ON  p.product_id = od.product_id
GROUP BY p.product_name

--Identificar os 10 produtos mais vendidos por unidades vendidas
SELECT
    p.product_name,
    SUM(od.quantity) AS quantidade_vendida
FROM orders o
INNER JOIN order_details od ON od.order_id = o.order_id
INNER JOIN products p ON p.product_id = od.product_id
GROUP BY p.product_name
ORDER BY quantidade_vendida DESC

-- Quais clientes do Reino Unido pagaram mais de 1000 dólares?

SELECT
    c.company_name,
    SUM((od.quantity * od.unit_price) * (1 - od.discount)) total_pago
FROM
    orders o
INNER JOIN order_details od ON od.order_id = o.order_id
INNER JOIN customers c ON c.customer_id = o.customer_id
WHERE c.country = 'UK'
GROUP BY c.company_name
HAVING SUM((od.quantity * od.unit_price) * (1 - od.discount)) > 1000;



