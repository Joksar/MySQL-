-- Триггер не позволит добавить товар, id которого не содержится в тпблице product_types

DELIMITER //
CREATE TRIGGER validate_product_type
BEFORE INSERT
ON guitars
FOR EACH ROW
IF NEW.product_type_id NOT IN (SELECT id FROM product_types) THEN 
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = 'Недопустимый тип товара.';
END IF//

DELIMITER ;


SHOW TRIGGERS;