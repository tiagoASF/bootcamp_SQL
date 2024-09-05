SELECT * FROM customers

-- Exibe o nome de contato e a cidade dos clientes
SELECT
    contact_name,
    city
FROM customers

-- Lista todos os países dos clientes
SELECT
    company_name,
    country
from customers

-- Lista os países sem repetição
SELECT DISTINCT(country)
FROM customers

-- Conta quantos países únicos existem
SELECT COUNT(DISTINCT(country))
FROM customers

-- Seleciona todos os clientes do México
SELECT *
FROM customers
WHERE country = 'Mexico'


-- Seleciona clientes com ID específico ANATR
SELECT *
FROM customers
WHERE customer_id = 'ANATR'

-- Utiliza AND para múltiplos critérios
SELECT customer_id, company_name, country, city
FROM customers
WHERE country = 'Germany' AND city = 'Berlin'

-- Utiliza OR para mais de uma cidade
SELECT
    customer_id,
    company_name,
    country, city
FROM customers
WHERE country = 'Germany' OR country = 'Mexico'

-- Utiliza NOT para excluir a Alemanha
SELECT *
FROM customers
WHERE country <> 'Germany'

-- Combina AND, OR e NOT
SELECT *
FROM customers
WHERE country = 'Brazil' OR (country = 'Germany' AND city <> 'Berlin')

-- Exclui clientes da Alemanha e EUA
SELECT *
FROM customers
WHERE country NOT IN ('Germany', 'EUA')

-- Ordena clientes pelo país
SELECT *
FROM customers
ORDER BY country

-- Ordena por país em ordem descendente
SELECT *
FROM customers
ORDER BY country DESC

-- Ordena por país e nome do contato
SELECT contact_name, country
FROM customers
ORDER BY country, contact_name

-- Ordena por país em ordem ascendente e nome em ordem descendente
SELECT
    contact_name,
    country
FROM customers
ORDER BY country ASC, contact_name DESC

-- Clientes com nome de contato começando por "a"
SELECT * FROM customers
WHERE contact_name LIKE 'A%'

-- Clientes com nome de contato não começando por "a"
SELECT * FROM customers
WHERE contact_name NOT LIKE 'A%'
ORDER BY contact_name

-- Clientes de países específicos
SELECT * FROM customers
WHERE country IN ('Brazil', 'Germany', 'Japan')

-- Clientes não localizados em 'Germany', 'France', 'UK'
SELECT * FROM customers
WHERE country NOT IN ('France', 'Germany', 'UK')




