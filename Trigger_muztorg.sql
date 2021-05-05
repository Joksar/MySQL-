-- ������� �� �������� �������� �����, id �������� �� ���������� � ������� product_types

DELIMITER //
CREATE TRIGGER validate_product_type
BEFORE INSERT
ON guitars
FOR EACH ROW
IF NEW.product_type_id NOT IN (SELECT id FROM product_types) THEN 
SIGNAL SQLSTATE '45000'
SET MESSAGE_TEXT = '������������ ��� ������.';
END IF//

DELIMITER ;


SHOW TRIGGERS;