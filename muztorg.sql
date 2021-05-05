USE muztorg;

CREATE TABLE customers(
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	first_name VARCHAR(100) NOT NULL,
	last_name VARCHAR(100) NOT NULL,
	birthday DATE,
	email VARCHAR(100) NOT NULL UNIQUE,
	phone VARCHAR(100) NOT NULL UNIQUE,
	city VARCHAR(100) NOT NULL,
	last_login DATETIME,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,  
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
	) COMMENT "Покупатели";


CREATE TABLE orders(
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	customer_id INT UNSIGNED NOT NULL,
	order_date DATE,
	order_status_id INT UNSIGNED NOT NULL,
	acquistion_type_id INT UNSIGNED NOT NULL,
	payment_type_id INT UNSIGNED NOT NULL,
	total_sum DECIMAL(10, 2)
	) COMMENT "Заказы";

UPDATE orders SET
  acquistion_type_id = FLOOR (1 + RAND() * 3);
 
UPDATE orders SET
	payment_type_id = FLOOR(RAND() * (6-3)+3) WHERE acquistion_type_id = 1;

UPDATE orders SET
	payment_type_id = 5 WHERE acquistion_type_id = 3;

SELECT FLOOR(RAND() * (6-3)+3);

ALTER TABLE orders 
	ADD CONSTRAINT orders_customer_id_fk
		FOREIGN KEY (customer_id) REFERENCES customers(id),
	ADD CONSTRAINT orders_order_status_id_fk
		FOREIGN KEY (order_status_id) REFERENCES order_statuses(id),
	ADD CONSTRAINT orders_acquistion_type_fk
		FOREIGN KEY (acquistion_type_id) REFERENCES acquisition_types(id),
	ADD CONSTRAINT orders_payment_type_id_fk
		FOREIGN KEY (payment_type_id) REFERENCES payment_types(id);

CREATE TABLE order_statuses (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(60) NOT NULL,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,  
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
	);

CREATE TABLE acquisition_types (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(60) NOT NULL,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,  
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
	);

CREATE TABLE payment_types(
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(60) NOT NULL,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,  
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
	);


-- Таблица связи заказов и их содержимого
CREATE TABLE orders_products(
	order_id INT UNSIGNED NOT NULL COMMENT "ссылка на номер заказа",
	product_id INT UNSIGNED NOT NULL COMMENT "ссылка на id товара",
	quantity INT UNSIGNED NOT NULL COMMENT "кол.во заказанных предметов",
	PRIMARY KEY (order_id, product_id) COMMENT "составной первичный ключ",
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP
	);

ALTER TABLE orders_products 
	ADD CONSTRAINT orders_products_order_id_fk
		FOREIGN KEY (order_id) REFERENCES orders(id),
	ADD CONSTRAINT orders_products_product_id_fk
		FOREIGN KEY (product_id) REFERENCES products(id);

-- Стоимость каждого заказа
SELECT orders.id, SUM(products.price * orders_products.quantity) as total_sum
	FROM orders 
		JOIN orders_products
			ON orders.id = orders_products.order_id
		JOIN products
			ON orders_products.product_id = products.id
		GROUP BY orders.id;


CREATE TABLE products (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	product_type_id INT UNSIGNED NOT NULL COMMENT "id типа товара, например, гитара, струны, флейта и т.д",
	item_id INT UNSIGNED NOT NULL COMMENT "id конкретного товара из определенной категории",
	price DECIMAL(10,2) NOT NULL,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,  
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
	);

ALTER TABLE products
	ADD CONSTRAINT products_product_type_id_fk
		FOREIGN KEY (product_type_id) REFERENCES product_types(id),
	ADD CONSTRAINT products_item_id_fk
		FOREIGN KEY (item_id) REFERENCES guitars(id);

INSERT INTO products (product_type_id, item_id, price)
		(SELECT product_type_id, id, price FROM guitars);

CREATE TABLE guitars(
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(60) NOT NULL COMMENT "название конкретной гитары",
	guitar_brand_id INT UNSIGNED NOT NULL COMMENT "название бренда",
	product_type_id INT UNSIGNED NOT NULL COMMENT "тип гитары: акустика, классика, электро, бас и т.д",
	string_number_id INT UNSIGNED NOT NULL COMMENT "кол.во струн",
	color_id INT UNSIGNED NOT NULL COMMENT "цвет",
	fret_id INT UNSIGNED NOT NULL COMMENT "кол.во ладов",
	tremolo_type_id INT UNSIGNED NOT NULL COMMENT "тремоло система",
	price DECIMAL(10,2) NOT NULL,
	description TEXT,
	quantity INT UNSIGNED NOT NULL COMMENT "доступное количество",
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,  
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
	) COMMENT "таблица гитар";

ALTER TABLE guitars 
ADD CONSTRAINT guitars_guitar_brand_id_fk 
    FOREIGN KEY (guitar_brand_id) REFERENCES guitar_brands(id),
ADD CONSTRAINT guitars_product_type_id_fk 
    FOREIGN KEY (product_type_id) REFERENCES product_types(id),
ADD CONSTRAINT guitars_string_number_id_fk
	FOREIGN KEY (string_number_id) REFERENCES strings_number(id),
ADD CONSTRAINT guitars_color_id_fk
	FOREIGN KEY (color_id) REFERENCES colors(id),
ADD CONSTRAINT guitars_fret_id_fk
	FOREIGN KEY (fret_id) REFERENCES frets(id),
ADD CONSTRAINT guitars_tremolo_type_id_fk
	FOREIGN KEY (tremolo_type_id) REFERENCES tremolo_types(id);


CREATE TABLE guitar_brands(
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	brand_name VARCHAR(60) NOT NULL,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,  
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
	);

CREATE TABLE product_types(
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(60) NOT NULL,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,  
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
	);

CREATE TABLE strings_number(
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	strings_q INT UNSIGNED NOT NULL,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,  
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
	);
	
CREATE TABLE colors(
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(60),
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,  
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
	);
	
CREATE TABLE frets(
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	frets_q INT UNSIGNED NOT NULL COMMENT "число ладов",
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,  
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
	);
	
CREATE TABLE tremolo_types (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(60) NOT NULL,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,  
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
	);
	
INSERT INTO tremolo_types (name) VALUES
	('Фиксированный'),
	('Floyd Rose'),
	('Tune-o-Matic'),
	('Тремоло');
	
INSERT INTO frets (frets_q) VALUES
	('20'),
	('21'),
	('22'),
	('24');
	
INSERT INTO colors (name) VALUES
	('Белый'),
	('Черный'),
	('Серый'),
	('Красный'),
	('Голубой'),
	('Желтый'),
	('Санберст'),
	('Бордовый');
	
INSERT INTO strings_number (strings_q) VALUES
	('4'),
	('5'),
	('6'),
	('7'),
	('8'),
	('9');
TRUNCATE product_types; 
INSERT INTO product_types (name) VALUES
	('Акустическая гитара'),
	('Классическая гитара'),
	('Электрогитара'),
	('Бас-гитара'),
	('Струны');
UPDATE guitar_types SET guitar_type = 'Акустическая гитара' where guitar_type = 'Аккустическая гитара';

INSERT INTO guitar_brands (brand_name) VALUES
	('Gibson'),
	('Fender'),
	('Ibanez'),
	('Jackson'),
	('Cort');
	
INSERT INTO acquisition_types (name) VALUES
	('Доставка курьером'),
	('Самовывоз из магазина'),
	('Доставка почтой');
	
INSERT INTO payment_types (name) VALUES
	('Наличными в магазине'),
	('Картой в магазине'),
	('Наличными курьеру'),
	('Картой курьеру'),
	('Оплата на сайте');
	
INSERT INTO order_statuses (name) VALUES
	('Оформлен'),
	('Доставляется'),
	('В магазине'),
	('Отменен'),
	('Выдан');
	
INSERT INTO guitars (name, guitar_brand_id, product_type_id, 
					string_number_id, color_id, fret_id, tremolo_type_id, price, description, quantity)
			VALUES
					('Flying V', '1','3','3','2','3','3','48000','Просто великолепная гитара','5'),
					('Flying V', '1','3','3','1','3','3','48000','Просто великолепная гитара','5'),
					('Explorer', '1','3','3','2','3','3','48000','Просто великолепная гитара','5'),
					('Explorer', '1','3','3','1','3','3','48000','Просто великолепная гитара','5'),
					('Les Paul Studio', '1','3','3','2','3','3','48000','Просто великолепная гитара','8'),
					('Les Paul Studio', '1','3','3','1','3','3','48000','Просто великолепная гитара','7'),
					('Les Paul Studio', '1','3','3','7','3','3','48000','Просто великолепная гитара','6'),
					('Les Paul Standard', '1','3','3','7','3','3','90000','Просто великолепная гитара','3'),
					('SG Standard', '1','3','3','2','3','3','60000','Просто великолепная гитара','4'),
					('SG Standard', '1','3','3','4','3','3','48000','Просто великолепная гитара','7'),
					('AM PRO STRAT', '2','3','3','2','3','4','52000','Просто великолепная гитара','5'),
					('AM PRO STRAT', '2','3','3','7','3','4','52000','Просто великолепная гитара','5'),
					('AM PRO STRAT', '2','3','3','8','3','4','52000','Просто великолепная гитара','5'),
					('American Performer Stratocaster','2','3','3','7','3','4','45000','Просто великолепная гитара','6'),
					('American Performer Stratocaster','2','3','3','2','3','4','45000','Просто великолепная гитара','6'),
					('American Performer Telecaster','2','3','3','1','3','1','45000','Просто великолепная гитара','3'),
					('American Performer Telecaster','2','3','3','2','3','1','45000','Просто великолепная гитара','2'),
					('GRX20-JB', '3','3','3','5','4','4','12000','Подойдет для новичков', '10'),
					('RG350DXZ', '3','3','3','1','4','2','25000','Подойдет для новичков', '5'),
					('ART120-CRS', '3','3','3','7','3','1','30000','Просто великолепная гитара','3'),
					('GRG7221QA-TKS', '3','3','4','3','4','1','15000','7-ми струнка','2'),
					('JS32 RR', '4','3','3','2','3','2','32000','Агрессивная форма','4'),
					('DKAF8', '4','3','5','2','4','2','42000','8-ми струнка','1'),
					('X700-LBB DUALITY', '5','3','3','5','4','2','37000','Достойный инструмент','3'),
					('KX508MS-MBB', '5','3','5','2','4','2','41000','8-ми струнка','1');

INSERT INTO guitars (name, guitar_brand_id, product_type_id, 
					string_number_id, color_id, fret_id, tremolo_type_id, price, description, quantity)
			VALUES
					('Affinity PJ BASS', '2','4','1','2','3','4','15000','4-х струнный бас','5'),
					('GSR205-BK', '3','4','2','2','3','4','18000','5-ти струнный бас','3'),
					('Firebird', '1','4','1','7','3','4','20000','4-х струнный бас','5'),
					('SR306EB-WK', '3','4','3','2','4','4','25000','6-ти струнный бас','1');
				
INSERT INTO guitars (name, guitar_brand_id, product_type_id, 
					string_number_id, color_id, fret_id, tremolo_type_id, price, description, quantity)
			VALUES
					('CD-60 DREAD','2','1','3','2','3','1','10000','Хорошая акустика','15'),
					('PF15ECE','3','1','3','2','3','1','11000','Хорошая акустика','12'),
					('J-15 Standard','1','1','3','7','3','1','57000','Великолепная акустика','1'),
					('AF515CE-OP','5','1','3','7','3','1','8000','Хорошая акустика','20');

INSERT INTO guitars (name, guitar_brand_id, product_type_id, 
					string_number_id, color_id, fret_id, tremolo_type_id, price, description, quantity)
			VALUES		
					('Fender ESC-105', '2','2','3','7','3','1','7500','Классика для начинающих','8'),
					('Classic', '5','2','3','7','3','1','5500','Классика для начинающих','10'),
					('AEG50N-NT', '3','2','3','7','3','1','6600','Классика для начинающих','8');
				
INSERT INTO guitars (name, guitar_brand_id, product_type_id, 
					string_number_id, color_id, fret_id, tremolo_type_id, price, description, quantity)
			VALUES		
					('Fender BLA BLA', '2','6','3','7','3','1','7500','Классика для начинающих','8');
				
				
-- Индексы
CREATE INDEX customers_first_name_last_name_idx ON customers(first_name, last_name);
