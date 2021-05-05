CREATE TEMPORARY TABLE total(
	id INT,
	total_sum DECIMAL(10,2)
);
TRUNCATE total;
INSERT INTO total
	(SELECT orders.id, SUM(products.price * orders_products.quantity) as total_sum
	FROM orders 
		JOIN orders_products
			ON orders.id = orders_products.order_id
		JOIN products
			ON orders_products.product_id = products.id
		GROUP BY orders.id);

SELECT * FROM total;

UPDATE orders 
	 INNER JOIN total
		ON orders.id = total.id
	SET orders.total_sum = total.total_sum;
	
	
	
INSERT INTO orders (total_sum)
	SELECT total_sum FROM total;
	
UPDATE SET updated_at = NOW() WHERE updated_at < created_at;


-- Найти всех пользователей, которые ничего не заказали.
SELECT customers.id as customer_id
	FROM customers
		LEFT JOIN orders
			ON customers.id = orders.customer_id
			WHERE customers.id NOT IN (SELECT customer_id FROM orders)
		ORDER BY customers.id;
	
-- Найти всех пользователей, которые ничего не заказывали за последний год.
SELECT customers.id, MAX(orders.order_date) last_purchase
	FROM customers
		JOIN orders
			ON customers.id = orders.customer_id
			WHERE orders.order_date < DATE_SUB(CURDATE(), INTERVAL 12 MONTH) 
		GROUP BY customers.id
		ORDER BY customers.id;
	
-- Наиболее/наименее популярный брэнд гитар
SELECT guitar_brands.brand_name, SUM(orders_products.quantity) 
	FROM guitar_brands
		JOIN guitars
	 		ON guitar_brands.id = guitars.guitar_brand_id
	 	JOIN products
	 		ON guitars.id = products.item_id
	 	LEFT JOIN orders_products 
	 		ON products.item_id = orders_products.product_id
	 GROUP BY guitar_brands.brand_name;
	
-- Наиболее/наименее популярная модель гитары
SELECT guitar_brands.brand_name, guitars.name, SUM(orders_products.quantity) as quantity
	FROM guitar_brands
		JOIN guitars
	 		ON guitar_brands.id = guitars.guitar_brand_id
	 	JOIN products
	 		ON guitars.id = products.item_id
	 	LEFT JOIN orders_products 
	 		ON products.item_id = orders_products.product_id
	GROUP BY guitar_brands.brand_name, guitars.name
	ORDER BY quantity DESC;

-- Средняя сумма заказа у покупателя
SELECT customers.id as customer_id, AVG(orders.total_sum)
	FROM customers
		JOIN orders
			ON customers.id = orders.customer_id
		GROUP BY customers.id
		ORDER BY customers.id;

-- Представление на самую популярную гитару
CREATE VIEW best_selling_guitar AS
	SELECT guitar_brands.brand_name, guitars.name, SUM(orders_products.quantity) as quantity
	FROM guitar_brands
		JOIN guitars
	 		ON guitar_brands.id = guitars.guitar_brand_id
	 	JOIN products
	 		ON guitars.id = products.item_id
	 	LEFT JOIN orders_products 
	 		ON products.item_id = orders_products.product_id
	GROUP BY guitar_brands.brand_name, guitars.name
	ORDER BY quantity DESC;
	
SELECT * FROM best_selling_guitar;

-- ПРедставление на последнюю дату заказа у пользователя
CREATE VIEW last_purchase AS
	SELECT customers.id, MAX(orders.order_date) last_purchase
	FROM customers
		JOIN orders
			ON customers.id = orders.customer_id 
		GROUP BY customers.id
		ORDER BY customers.id;
		
SELECT * FROM last_purchase;