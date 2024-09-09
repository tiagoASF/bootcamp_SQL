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













WITH receitas_mensais AS (
    SELECT
        EXTRACT(YEAR FROM o.order_date) AS Ano,
        EXTRACT(MONTH FROM o.order_date) AS Mes,
        ROUND(SUM((od.unit_price * od.quantity) * (1 - od.discount))) AS Receita_Mensal
    FROM order_details od
    INNER JOIN orders o ON o.order_id = od.order_id
    GROUP BY
        EXTRACT(YEAR FROM o.order_date),
        EXTRACT(MONTH FROM o.order_date)
),
ReceitasAcumuladas AS (
    SELECT
        Ano,
        Mes,
        Receita_Mensal,
        SUM(Receita_Mensal) OVER (PARTITION BY Ano ORDER BY Mes) AS Receita_YTD
    FROM
        receitas_mensais
)
SELECT
    Ano,
    Mes,
    Receita_Mensal,
    Receita_Mensal - LAG(Receita_Mensal) OVER (PARTITION BY Ano ORDER BY Mes) AS Diferenca_Mensal,
    Receita_YTD,
    (Receita_Mensal - LAG(Receita_Mensal) OVER (PARTITION BY Ano ORDER BY Mes)) / LAG(Receita_Mensal) OVER (PARTITION BY Ano ORDER BY Mes) * 100 AS Percentual_Mudanca_Mensal
FROM
    ReceitasAcumuladas
ORDER BY Ano, Mes;