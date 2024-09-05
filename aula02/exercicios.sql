-- Nome do cliente terminando com "a":
SELECT *
FROM customers
WHERE contact_name LIKE '%a';

-- Nome do cliente que possui "or" em qualquer posição:
SELECT *
FROM customers
WHERE contact_name LIKE '%or%';

-- Nome do cliente com "r" na segunda posição:
SELECT *
FROM customers
WHERE contact_name LIKE '_r%';

-- Nome do cliente que começa com "A" e tem pelo menos 3 caracteres de comprimento
SELECT *
FROM customers
WHERE contact_name LIKE 'A_%';

-- Nome do contato que começa com "A" e termina com "o"
SELECT *
FROM customers
WHERE contact_name LIKE 'A%o';

-- Nome do cliente que NÃO começa com "a"
SELECT *
FROM customers
WHERE contact_name NOT LIKE 'A%';

-- localizado na "Alemanha", "França" ou "Reino Unido":
SELECT *
FROM customers
WHERE country IN ('Germany', 'France', 'UK');

-- NÃO localizado na "Alemanha", "França" ou "Reino Unido":
SELECT *
FROM customers
WHERE country NOT IN ('Germany', 'France', 'UK');

-- Só para dar um gostinho de uma subqueyr... Seleciona todos os clientes que são
-- mesdos mesmos países que os fornecedor:
SELECT *
FROM customers
WHERE country IN (
    SELECT country FROM suppliers
    );

SELECT c.country AS customer_country
FROM customers c
WHERE country IN (
    SELECT country FROM suppliers
    );

-- Exemplo com BETWEEN unit price 10 - 20
SELECT * FROM order_details;
SELECT
    product_id,
    unit_price
FROM order_details
WHERE unit_price BETWEEN 10 AND 20;

-- Exemplo com NOT BETWEEN unit price 10 -20
SELECT
    product_id,
    unit_price
FROM order_details
WHERE unit_price NOT BETWEEN 10 AND 20;

-- Seleciona todos os produtos com preço ENTRE 10 e 20.
-- Adicionalmente, não mostra produtos com CategoryID de 1, 2 ou 3:
SELECT
    product_name,
    unit_price,
    category_id
FROM products
WHERE (unit_price BETWEEN 10 AND 20) AND category_id NOT IN(1, 2, 3);

--selects todos os produtos entre 'Carnarvon Tigers' e 'Mozzarella di Giovanni':
SELECT product_name
FROM products
WHERE product_name BETWEEN 'Carnavon Tigers' AND 'Mozzarella di Giovanni'
ORDER BY product_name;

--Selecione todos os pedidos BETWEEN '04-July-1996' e '09-July-1996':
SELECT *
FROM orders
WHERE order_date BETWEEN '04-July-1996' AND '09-July-1996';

-- Exemplo de MIN() menor preco
SELECT
    MIN(unit_price)
FROM products;

SELECT
    product_name,
    unit_price
FROM products
WHERE unit_price = (SELECT MIN(unit_price) FROM products);

-- Exemplo de MAX() maior preco
SELECT MAX(products.unit_price)
FROM products;

-- Exemplo de COUNT() total de tipos de produtos
SELECT COUNT(product_id)
FROM products;

-- Exemplo de AVG() preco medio
SELECT AVG(products.unit_price)
FROM products;

-- Exemplo de SUM() quantidade total de itens vendidos
SELECT SUM(quantity)
FROM order_details;

-- Calcula o menor preço unitário de produtos em cada categoria
SELECT
    MIN(unit_price),
    category_id
FROM products
GROUP BY category_id
ORDER BY category_id;

-- Calcula o maior preço unitário de produtos em cada categoria
SELECT
    MAX(unit_price),
    category_id
FROM products
GROUP BY category_id
ORDER BY category_id;

-- Conta o número total de produtos em cada categoria
SELECT
    COUNT(product_id),
    category_id
FROM products
GROUP BY category_id
ORDER BY category_id;

-- Calcula o preço médio unitário de produtos em cada categoria
SELECT
    ROUND(AVG(unit_price)) AS preco_medio_categoria,
    category_id
FROM products
GROUP BY category_id
ORDER BY category_id;

-- Calcula a quantidade total de produtos pedidos por pedido
SELECT
    SUM(quantity),
    order_id
FROM order_details
GROUP BY order_id;

--Desafio
--Obter todas as colunas das tabelas Clientes, Pedidos e Fornecedores
SELECT * FROM customers;
SELECT * FROM orders;
SELECT * FROM suppliers;

--Obter todos os Clientes em ordem alfabética por país e nome
SELECT
    company_name,
    country
FROM customers
ORDER BY country, company_name;

--Obter os 5 pedidos mais antigos
SELECT
    order_id,
    order_date
FROM orders
ORDER BY order_date
LIMIT 10;

--Obter a contagem de todos os Pedidos feitos durante 1997
SELECT
    COUNT(order_id)
FROM orders
WHERE date_part('year', order_date) = '1997';

SELECT COUNT(*) AS "Number of Orders During 1997"
FROM orders
WHERE order_date BETWEEN '1997-1-1' AND '1997-12-31';

--Obter os nomes de todas as pessoas de contato onde a pessoa é um gerente, em ordem alfabética
SELECT * FROM customers;
SELECT
    contact_name,
    contact_title
FROM customers
WHERE contact_title LIKE '%Manager%'
ORDER BY contact_name;

--Obter todos os pedidos feitos em 19 de maio de 1997
SELECT *
FROM orders
WHERE order_date = '1997-05-19'

