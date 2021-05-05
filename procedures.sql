DELIMITER //
DROP PROCEDURE IF EXISTS discounted_price//
CREATE PROCEDURE discounted_price (price INT)
BEGIN
	IF(price > 200000) THEN
		SELECT price * 0.9 AS discounted_price;
	END IF;
	IF(price < 200000 AND price > 100000) THEN
		SELECT price * 0.95 AS discounted_price;
	END IF;
	IF(price < 100000) THEN
		SELECT price AS discounted_price;
	END IF;
END//

CALL discounted_price(250000);

CALL discounted_price(150000);

CALL discounted_price(80000);


