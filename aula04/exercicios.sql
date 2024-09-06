-- Quantos produtos únicos há por pedido?
-- Quantos itens no total?
-- Qual o valor total pago?

SELECT * FROM order_details;

SELECT
    order_id,
    COUNT(DISTINCT(product_id)),
    SUM(quantity) AS total_itens,
    SUM((quantity * unit_price) * (1 - discount)) AS total_em_vendas
FROM order_details
GROUP BY order_id
ORDER BY order_id;

-- As window functions sao úteis quando se quer manter valores agregados como médias, máximo e mínimos
-- visíveis para fins de comparação com valores unitários. As funções de agregação ocasionam a perda dessas
-- informações atômicas.

-- window function
SELECT
    DISTINCT order_id,
    COUNT(product_id) OVER (PARTITION BY order_id) AS total_tipos_itens,
    SUM(quantity) OVER (PARTITION BY order_id) AS total_itens_pedido,
    SUM((quantity * unit_price) * (1 - discount)) OVER (PARTITION BY order_id) AS total_pedido
FROM order_details
ORDER BY order_id;

--frete minimo,maximo e media por cliente
SELECT * FROM orders;

SELECT
    customer_id AS cliente,
    MIN(freight) AS frete_mais_barato,
    MAX(freight) AS frete_mais_caro,
    AVG(freight) AS frete_medio
FROM orders
GROUP BY customer_id
ORDER BY customer_id;

-- window function
SELECT
    customer_id,
    MIN(freight) OVER (PARTITION BY customer_id),
    MAX(freight) OVER (PARTITION BY customer_id),
    AVG(freight) OVER (PARTITION BY customer_id)
FROM orders
ORDER BY customer_id;

-- mostrar min, max, avg ao lado de cada pedido
SELECT
    order_id,
    customer_id,
    freight,
    MIN(freight) OVER (PARTITION BY customer_id),
    MAX(freight) OVER (PARTITION BY customer_id),
    AVG(freight) OVER (PARTITION BY customer_id)
FROM orders
ORDER BY customer_id, order_id;

-- ranking com windows functions para compras mais cara de itens do mesmo tipo
SELECT
    od.order_id,
    p.product_name,
    (od.unit_price * od.quantity) AS total_per_order,
    ROW_NUMBER() OVER (ORDER BY (od.unit_price * od.quantity) DESC) AS order_by_row,
    RANK() OVER (ORDER BY (od.unit_price * od.quantity) DESC) AS order_rank,
    DENSE_RANK() OVER (ORDER BY (od.unit_price * od.quantity) DESC) AS order_dense
FROM order_details od
INNER JOIN products p ON p.product_id = od.product_id;


SELECT first_name, last_name, title,
       NTILE(3) OVER (ORDER BY first_name) AS group_name
FROM employees;


/*DESAFIO 01
Faça a classificação dos produtos mais vendidos usando usando RANK(), DENSE_RANK() e ROW_NUMBER()
Essa questão tem 2 implementações, veja uma que utiliza subquery e uma que não utiliza.
*/

SELECT
    p.product_id AS id,
    p.product_name AS produto,
    SUM(od.quantity),
    RANK() OVER (ORDER BY SUM(od.quantity) DESC)
FROM order_details od
INNER JOIN products p ON p.product_id = od.product_id
GROUP BY p.product_id, p.product_name;



/*DESAFIO 02
Listar funcionários dividindo-os em 3 grupos usando NTILE
F*/




















SELECT
    title,
    first_name,
    last_name,
    NTILE(3) OVER (ORDER BY first_name) AS group
FROM employees
*/













/*DESAFIO 03
Ordenando os custos de envio pagos pelos clientes de acordo
com suas datas de pedido, mostrando o custo anterior e o custo posterior usando LAG e LEAD:
FROM orders JOIN shippers ON shippers.shipper_id = orders.ship_via;
*/

SELECT * FROM orders;
SELECT * FROM shippers;


SELECT
    customer_id,
    order_date,
    LAG(freight) OVER (PARTITION BY customer_id ORDER BY order_date) AS previous_order_freight,
    freight AS order_freight,
    LEAD(freight) OVER (PARTITION BY customer_id ORDER BY order_date) AS next_order_freight
FROM orders



