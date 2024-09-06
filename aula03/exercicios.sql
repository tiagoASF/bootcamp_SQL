-- Cria um relatório para todos os pedidos de 1996 e seus clientes (152 linhas)
SELECT
    o.order_id,
    o.order_date,
    c.company_name
FROM orders o
INNER JOIN customers c ON c.customer_id = o.customer_id
ORDER BY o.order_date;

-- Cria um relatório que mostra o número de funcionários e clientes de cada cidade que tem funcionários (5 linhas)
SELECT
    e.city,
    COUNT(e.employee_id) AS numero_funcionarios,
    COUNT(c.customer_id) AS numero_clientes
FROM employees e
LEFT JOIN customers c ON c.city = e.city
GROUP BY e.city;

-- Cria um relatório que mostra o número de funcionários e clientes de cada cidade que tem clientes (69 linhas)
SELECT
    c.city,
    COUNT(e.employee_id) AS numero_funcionarios,
    COUNT(c.customer_id) AS numero_clientes
FROM customers c
LEFT JOIN employees e ON e.city = c.city
GROUP BY c.city;

-- Cria um relatório que mostra o número de funcionários e clientes de cada cidade (71 linhas)
SELECT
    COALESCE(e.city, c.city) AS cidade,
    COUNT(c.customer_id) AS numero_clientes,
    COUNT(e.employee_id) AS numero_empregados
FROM customers c
FULL OUTER JOIN employees e ON e.city = c.city
GROUP BY cidade;

-- Mostra apenas registros para produtos para os quais a quantidade encomendada é menor que 200 (5 linhas)
SELECT
    od.product_id AS id_produto,
    p.product_name AS nome_produto,
    SUM(od.quantity) AS quantidade
FROM order_details od
INNER JOIN products p ON p.product_id = od.product_id
GROUP BY id_produto, nome_produto
HAVING SUM(od.quantity) < 200
ORDER BY quantidade;

-- Cria um relatório que mostra o total de pedidos por cliente desde 31 de dezembro de 1996.
SELECT
    customer_id,
    COUNT(order_id) total_pedidos
FROM orders
WHERE order_date >= '1996-12-31'
GROUP BY customer_id
ORDER BY total_pedidos DESC;

-- O relatório deve retornar apenas linhas para as quais o total de pedidos é maior que 15 (5 linhas)
SELECT
    customer_id,
    COUNT(order_id) total_pedidos
FROM orders
WHERE order_date >= '1996-12-31'
GROUP BY customer_id
HAVING COUNT(order_id) > 15