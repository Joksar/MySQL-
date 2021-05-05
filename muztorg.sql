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
	) COMMENT "����������";


CREATE TABLE orders(
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	customer_id INT UNSIGNED NOT NULL,
	order_date DATE,
	order_status_id INT UNSIGNED NOT NULL,
	acquistion_type_id INT UNSIGNED NOT NULL,
	payment_type_id INT UNSIGNED NOT NULL,
	total_sum DECIMAL(10, 2)
	) COMMENT "������";

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


-- ������� ����� ������� � �� �����������
CREATE TABLE orders_products(
	order_id INT UNSIGNED NOT NULL COMMENT "������ �� ����� ������",
	product_id INT UNSIGNED NOT NULL COMMENT "������ �� id ������",
	quantity INT UNSIGNED NOT NULL COMMENT "���.�� ���������� ���������",
	PRIMARY KEY (order_id, product_id) COMMENT "��������� ��������� ����",
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP
	);

ALTER TABLE orders_products 
	ADD CONSTRAINT orders_products_order_id_fk
		FOREIGN KEY (order_id) REFERENCES orders(id),
	ADD CONSTRAINT orders_products_product_id_fk
		FOREIGN KEY (product_id) REFERENCES products(id);

-- ��������� ������� ������
SELECT orders.id, SUM(products.price * orders_products.quantity) as total_sum
	FROM orders 
		JOIN orders_products
			ON orders.id = orders_products.order_id
		JOIN products
			ON orders_products.product_id = products.id
		GROUP BY orders.id;


CREATE TABLE products (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	product_type_id INT UNSIGNED NOT NULL COMMENT "id ���� ������, ��������, ������, ������, ������ � �.�",
	item_id INT UNSIGNED NOT NULL COMMENT "id ����������� ������ �� ������������ ���������",
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
	name VARCHAR(60) NOT NULL COMMENT "�������� ���������� ������",
	guitar_brand_id INT UNSIGNED NOT NULL COMMENT "�������� ������",
	product_type_id INT UNSIGNED NOT NULL COMMENT "��� ������: ��������, ��������, �������, ��� � �.�",
	string_number_id INT UNSIGNED NOT NULL COMMENT "���.�� �����",
	color_id INT UNSIGNED NOT NULL COMMENT "����",
	fret_id INT UNSIGNED NOT NULL COMMENT "���.�� �����",
	tremolo_type_id INT UNSIGNED NOT NULL COMMENT "������� �������",
	price DECIMAL(10,2) NOT NULL,
	description TEXT,
	quantity INT UNSIGNED NOT NULL COMMENT "��������� ����������",
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,  
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
	) COMMENT "������� �����";

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
	frets_q INT UNSIGNED NOT NULL COMMENT "����� �����",
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
	('�������������'),
	('Floyd Rose'),
	('Tune-o-Matic'),
	('�������');
	
INSERT INTO frets (frets_q) VALUES
	('20'),
	('21'),
	('22'),
	('24');
	
INSERT INTO colors (name) VALUES
	('�����'),
	('������'),
	('�����'),
	('�������'),
	('�������'),
	('������'),
	('��������'),
	('��������');
	
INSERT INTO strings_number (strings_q) VALUES
	('4'),
	('5'),
	('6'),
	('7'),
	('8'),
	('9');
TRUNCATE product_types; 
INSERT INTO product_types (name) VALUES
	('������������ ������'),
	('������������ ������'),
	('�������������'),
	('���-������'),
	('������');
UPDATE guitar_types SET guitar_type = '������������ ������' where guitar_type = '������������� ������';

INSERT INTO guitar_brands (brand_name) VALUES
	('Gibson'),
	('Fender'),
	('Ibanez'),
	('Jackson'),
	('Cort');
	
INSERT INTO acquisition_types (name) VALUES
	('�������� ��������'),
	('��������� �� ��������'),
	('�������� ������');
	
INSERT INTO payment_types (name) VALUES
	('��������� � ��������'),
	('������ � ��������'),
	('��������� �������'),
	('������ �������'),
	('������ �� �����');
	
INSERT INTO order_statuses (name) VALUES
	('��������'),
	('������������'),
	('� ��������'),
	('�������'),
	('�����');
	
INSERT INTO guitars (name, guitar_brand_id, product_type_id, 
					string_number_id, color_id, fret_id, tremolo_type_id, price, description, quantity)
			VALUES
					('Flying V', '1','3','3','2','3','3','48000','������ ������������ ������','5'),
					('Flying V', '1','3','3','1','3','3','48000','������ ������������ ������','5'),
					('Explorer', '1','3','3','2','3','3','48000','������ ������������ ������','5'),
					('Explorer', '1','3','3','1','3','3','48000','������ ������������ ������','5'),
					('Les Paul Studio', '1','3','3','2','3','3','48000','������ ������������ ������','8'),
					('Les Paul Studio', '1','3','3','1','3','3','48000','������ ������������ ������','7'),
					('Les Paul Studio', '1','3','3','7','3','3','48000','������ ������������ ������','6'),
					('Les Paul Standard', '1','3','3','7','3','3','90000','������ ������������ ������','3'),
					('SG Standard', '1','3','3','2','3','3','60000','������ ������������ ������','4'),
					('SG Standard', '1','3','3','4','3','3','48000','������ ������������ ������','7'),
					('AM PRO STRAT', '2','3','3','2','3','4','52000','������ ������������ ������','5'),
					('AM PRO STRAT', '2','3','3','7','3','4','52000','������ ������������ ������','5'),
					('AM PRO STRAT', '2','3','3','8','3','4','52000','������ ������������ ������','5'),
					('American Performer Stratocaster','2','3','3','7','3','4','45000','������ ������������ ������','6'),
					('American Performer Stratocaster','2','3','3','2','3','4','45000','������ ������������ ������','6'),
					('American Performer Telecaster','2','3','3','1','3','1','45000','������ ������������ ������','3'),
					('American Performer Telecaster','2','3','3','2','3','1','45000','������ ������������ ������','2'),
					('GRX20-JB', '3','3','3','5','4','4','12000','�������� ��� ��������', '10'),
					('RG350DXZ', '3','3','3','1','4','2','25000','�������� ��� ��������', '5'),
					('ART120-CRS', '3','3','3','7','3','1','30000','������ ������������ ������','3'),
					('GRG7221QA-TKS', '3','3','4','3','4','1','15000','7-�� �������','2'),
					('JS32 RR', '4','3','3','2','3','2','32000','����������� �����','4'),
					('DKAF8', '4','3','5','2','4','2','42000','8-�� �������','1'),
					('X700-LBB DUALITY', '5','3','3','5','4','2','37000','��������� ����������','3'),
					('KX508MS-MBB', '5','3','5','2','4','2','41000','8-�� �������','1');

INSERT INTO guitars (name, guitar_brand_id, product_type_id, 
					string_number_id, color_id, fret_id, tremolo_type_id, price, description, quantity)
			VALUES
					('Affinity PJ BASS', '2','4','1','2','3','4','15000','4-� �������� ���','5'),
					('GSR205-BK', '3','4','2','2','3','4','18000','5-�� �������� ���','3'),
					('Firebird', '1','4','1','7','3','4','20000','4-� �������� ���','5'),
					('SR306EB-WK', '3','4','3','2','4','4','25000','6-�� �������� ���','1');
				
INSERT INTO guitars (name, guitar_brand_id, product_type_id, 
					string_number_id, color_id, fret_id, tremolo_type_id, price, description, quantity)
			VALUES
					('CD-60 DREAD','2','1','3','2','3','1','10000','������� ��������','15'),
					('PF15ECE','3','1','3','2','3','1','11000','������� ��������','12'),
					('J-15 Standard','1','1','3','7','3','1','57000','������������ ��������','1'),
					('AF515CE-OP','5','1','3','7','3','1','8000','������� ��������','20');

INSERT INTO guitars (name, guitar_brand_id, product_type_id, 
					string_number_id, color_id, fret_id, tremolo_type_id, price, description, quantity)
			VALUES		
					('Fender ESC-105', '2','2','3','7','3','1','7500','�������� ��� ����������','8'),
					('Classic', '5','2','3','7','3','1','5500','�������� ��� ����������','10'),
					('AEG50N-NT', '3','2','3','7','3','1','6600','�������� ��� ����������','8');
				
INSERT INTO guitars (name, guitar_brand_id, product_type_id, 
					string_number_id, color_id, fret_id, tremolo_type_id, price, description, quantity)
			VALUES		
					('Fender BLA BLA', '2','6','3','7','3','1','7500','�������� ��� ����������','8');
				
				
-- �������
CREATE INDEX customers_first_name_last_name_idx ON customers(first_name, last_name);
