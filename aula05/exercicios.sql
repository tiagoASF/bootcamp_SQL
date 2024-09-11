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
    ROUND(SUM((od.unit_price * od.quantity) * (1 - od.discount))) AS total_gasto,
    NTILE(5) OVER (ORDER BY SUM((od.unit_price * od.quantity) * (1 - od.discount)) DESC) AS grupo
FROM orders o
INNER JOIN order_details od ON od.order_id = o.order_id
INNER JOIN customers c ON o.customer_id = c.customer_id
GROUP BY c.company_name
order by total_gasto DESC;

/*Agora somente os clientes que estão nos grupos 3, 4, 5
para que seja feita uma análise de Marketing especial com eles*/

WITH grupos_por_valores_pagos AS (
    SELECT
    c.company_name,
    ROUND(SUM((od.unit_price * od.quantity) * (1 - od.discount))) AS total_gasto,
    NTILE(5) OVER (ORDER BY SUM((od.unit_price * od.quantity) * (1 - od.discount)) DESC) AS grupo
    FROM orders o
    INNER JOIN order_details od ON od.order_id = o.order_id
    INNER JOIN customers c ON o.customer_id = c.customer_id
    GROUP BY c.company_name
    order by total_gasto DESC
)
SELECT * FROM grupos_por_valores_pagos
WHERE grupo >= 3;



--Identificar os 10 produtos mais vendidos por preço acumulado
SELECT
    p.product_name,
    ROUND(SUM((od.unit_price * od.quantity) * (1 - discount))) AS total_faturado_por_produto
FROM order_details od
INNER JOIN products p ON p.product_id = od.product_id
GROUP BY p.product_name
ORDER BY total_faturado_por_produto DESC
LIMIT 10;



--Identificar os 10 produtos mais vendidos por unidades vendidas
SELECT
    p.product_name AS produto,
    SUM(od.quantity) AS quantidade_vendida
FROM order_details od
INNER JOIN products p ON p.product_id = od.product_id
GROUP BY produto
ORDER BY quantidade_vendida DESC
LIMIT 10;


-- Quais clientes do Reino Unido pagaram mais de 1000 dólares?
SELECT
    c.company_name AS cliente,
    ROUND(SUM((od.quantity * od.unit_price) * (1 - od.discount))) AS total_gasto
FROM order_details od
INNER JOIN orders o ON o.order_id = od.order_id
INNER JOIN customers c ON c.customer_id = o.customer_id
WHERE c.country = 'UK'
GROUP BY cliente
HAVING SUM((od.quantity * od.unit_price) * (1 - od.discount)) >  1000
ORDER BY total_gasto DESC;


