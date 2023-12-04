-- 1)Realize as seguintes consultas na tabela books:

-- a)Selecione o título e o autor de todos os livros.
SELECT title "Título do Livro", author "Nome do Autor"
FROM books;

-- b)Selecione os livros escritos por Henry Davis.
SELECT title "Título do Livro"
FROM books
WHERE author ILIKE 'henry davis';

-- c)Selecione o título, autor e ano dos livros publicados antes de 1900.
SELECT 
	title "Título do Livro",
	author "Nome do Autor",
	release_year "Ano de publicação"
FROM books
WHERE release_year < 1900
ORDER BY 3;

-- d)Selecione todos os livros cujo título comece com a letra "O".
SELECT *
FROM books 
WHERE title ILIKE 'o%';

-- e)Selecione o título e o autor dos livros cujo ano seja posterior a 1950.
SELECT
	title "Título do Livro",
	author "Autor do Autor"
FROM books
WHERE release_year > 1950
ORDER BY release_year;

-- f)Selecione o número total de livros na tabela.
SELECT
	COUNT(*) "Total de livros"
FROM books;

-- g)Selecione o autor com o maior número de livros publicados.
SELECT author "Nome do Autor", COUNT(*) "Quantidade de livros"
FROM books
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

-- h)Selecione os livros ordenados por ano em ordem ascendente.
SELECT * 
FROM books
ORDER BY release_year;

-- i)Selecione o título do livro mais antigo.
SELECT 
	title "Título do livro"
FROM books
WHERE release_year = (SELECT MIN(release_year) FROM books);

SELECT 
	title "Título do livro"
FROM books
ORDER BY release_year
LIMIT 1;

-- j)Selecione o título do livro mais recente.
SELECT 
	title "Título do livro"
FROM books
WHERE release_year = (SELECT MAX(release_year) FROM books);

SELECT 
	title "Título do livro"
FROM books
ORDER BY release_year DESC
LIMIT 1;

-- k)Selecione o título e o autor dos três últimos livros na tabela.
SELECT 
	title "Título do Livro",
	author "Nome do Autor"
FROM books
ORDER BY id DESC
LIMIT 3;

-- 2)Com base na tabela products, faça as consultas solicitadas:

SET lc_monetary = 'pt_BR';

-- a)Selecione a quantidade total de produtos em estoque.
SELECT SUM(quantity_in_stock) "Quantidade em estoque"
FROM products;

-- b)Selecione o preço médio dos produtos.
SELECT ROUND(AVG(price::numeric), 2)::money "Média do preço"
FROM products;

-- c)Selecione o produto mais caro da tabela.
SELECT product "Nome do Produto"
FROM products
WHERE price = (SELECT MAX(price) FROM products);

SELECT product "Nome do Produto"
FROM products
ORDER by price DESC
LIMIT 1;

-- d)Selecione o produto mais barato da tabela.
SELECT product "Nome do Produto"
FROM products
WHERE price = (SELECT MIN(price) FROM products);

SELECT product "Nome do Produto"
FROM products
ORDER by price
LIMIT 1;

-- e)Selecione o valor do total do estoque (preço * estoque) para cada produto.
SELECT
	product "Nome do Produto",
	price "Preço unitário",
	quantity_in_stock "Quantidade em estoque",
	price * quantity_in_stock "Valor do estoque"
FROM products;

-- f)Selecione a quantidade de produtos que possuem estoque menor que 20.
SELECT COUNT(*)
FROM products
WHERE quantity_in_stock < 20;

-- g)Selecione o produto com o maior retorno após a venda de todas as unidades em estoque.
SELECT 
	product "Nome do produto"
FROM products
ORDER BY (price * quantity_in_stock) DESC
LIMIT 1;

-- 3) Com base nas tabelas: employees, projects e departments.
-- Faça as consultas abaixo:

-- a)Selecione o nome e cargo de cada funcionário, juntamente com o departamento em que trabalham.
SELECT 
	e.name "Nome do funcionário",
	e.role "Cargo do funcionário",
	d.name "Nome do departamento do funcionário"
FROM employees e
INNER JOIN departments d
ON e.department_id = d.id
ORDER BY 1;

-- b)Selecione o nome, o cargo e o salário dos funcionários do departamento de vendas.
SELECT 
	e.name "Nome do funcionário",
	e.role "Cargo do funcionário",
	e.salary "Salário do funcionário"
FROM employees e
INNER JOIN departments d
ON e.department_id = d.id
WHERE d.name ILIKE 'vendas';

-- c)Selecione o nome, o cargo e o salário dos funcionários cujo salário seja maior que 3500 e que trabalham no departamento de vendas.
SELECT 
	e.name "Nome do funcionário",
	e.role "Cargo do funcionário",
	e.salary "Salário do funcionário"
FROM employees e
INNER JOIN departments d
ON e.department_id = d.id
WHERE d.name ILIKE 'Vendas' AND e.salary::numeric > 3500;

-- d)Selecione o nome, o cargo, o salário e o nome do projeto associado a cada funcionário.
SELECT
	e.name "Nome do funcionário",
	e.role "Cargo do funcionário",
	e.salary "Salário do funcionário",
	STRING_AGG(p.name, ', ') "Projetos"
FROM employees e
INNER JOIN departments d
ON e.department_id = d.id
INNER JOIN projects p
ON p.department_id = d.id
GROUP BY e.id;

-- e)Liste o total gasto pela empresa no pagamento dos funcionários.
SELECT SUM(salary) "Salário total dos funcionários"
FROM employees;

-- f)Liste o total de salário pago para os funcionários de cada departamento.
SELECT
	d.name "Nome do departamento",
	SUM(e.salary) "Total do salário do departamento"
FROM departments d
INNER JOIN employees e
ON e.department_id = d.id
GROUP BY d.id
ORDER BY d.id;

-- g)Liste o maior salário de cada departamento.
SELECT
	d.name "Nome do departamento",
	MAX(e.salary) "Maior salário"
FROM employees e
RIGHT JOIN departments d
ON e.department_id = d.id
GROUP BY d.id;

--4) Com base nas tabelas foods, categories, nutritional_information, diets e diets_foods.
--Faça as seguintes consultas:

-- a)Listar todos os alimentos e as suas respectivas categorias.
SELECT
	f.name "Nome do alimento",
	c.name "Categoria do alimento"
FROM foods f
LEFT JOIN categories c
ON f.category_id = c.id;

-- b)Encontre o total de calorias para cada categoria de alimento.
SELECT
	c.name "Categoria do alimento",
	n.calories "Total de calorias"
FROM categories c
INNER JOIN foods f
ON f.category_id = c.id
INNER JOIN nutritional_information n
ON n.food_id = f.id
ORDER BY 1;

-- c)Listar as dietas que incluem alimentos com mais de 500 calorias.
SELECT
	d.name "Nome da dieta"
FROM diets d
INNER JOIN diets_foods df
ON df.diet_id = d.id
INNER JOIN nutritional_information n
ON df.food_id = n.food_id
WHERE n.calories > 500;

-- d)Calcular a média de proteínas por categoria de alimento.
SELECT 
	c.name "Categoria do alimento",
	ROUND(AVG(n.proteins), 2) "Média de proteínas"
FROM categories c
INNER JOIN foods f
ON c.id = f.category_id
INNER JOIN nutritional_information n
ON f.id = n.food_id
GROUP BY 1;

-- e)Identificar os alimentos que têm um teor de gordura superior à média de gordura de todos os alimentos.
SELECT 
	f.name "Nome do alimento"
FROM foods f
INNER JOIN nutritional_information n
ON f.id = n.food_id
WHERE n.fats > (SELECT AVG(n.fats) FROM nutritional_information n);

-- f)Listar as três categorias de alimentos com o maior número de itens.
SELECT
	c.name "Categoria do alimento",
	COUNT (*) "Quantidade de alimentos"
FROM categories c
INNER JOIN foods f
ON f.category_id = c.id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 3;

-- g)Encontrar a dieta que tem o menor teor total de carboidratos.
SELECT
	d.name "Nome da dieta",
	n.carbohydrates "Quantidade de carboidratos"
FROM diets d
INNER JOIN diets_foods df
ON df.diet_id = d.id
INNER JOIN nutritional_information n
ON n.food_id = df.food_id
ORDER BY 2
LIMIT 1;

-- h)Listar todos os alimentos que não estão incluídos em nenhuma dieta.
SELECT
	f.name "Nome do Alimento"
FROM foods f
LEFT JOIN diets_foods df
ON df.food_id = f.id
WHERE df.food_id is NULL;

-- i)Determinar a proporção de proteínas, carboidratos e gorduras (em porcentagem de calorias fornecidas) de cada alimento.
SELECT
	f.name "Nome do Alimento",
	ROUND((n.proteins * 4 / n.proteins * 4 + n.carbohydrates * 4 + n.fats * 9)*100, 2) "% de Proteína",
	ROUND((n.carbohydrates * 4 / n.proteins * 4 + n.carbohydrates * 4 + n.fats * 9) * 100, 2) "% de Carboidrato",
	ROUND((n.fats * 9 / n.proteins * 4 + n.carbohydrates * 4 + n.fats * 9) * 100, 2) "% de Gordura"
FROM foods f
INNER JOIN nutritional_information n
ON n.food_id = f.id
ORDER BY 1;

