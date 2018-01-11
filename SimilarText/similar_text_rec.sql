DELIMITER $$

CREATE PROCEDURE `php_similar_str`(
	IN `s1` VARCHAR(255) CHARSET utf32,
	IN `s1_off` INT,
	IN `s1_len` INT,
	IN `s2` VARCHAR(255) CHARSET utf32,
	IN `s2_off` INT,
	IN `s2_len` INT,
	OUT `pos1` INT,
	OUT `pos2` INT,
	OUT `max_len` INT
)
LANGUAGE SQL
DETERMINISTIC
CONTAINS SQL
COMMENT ''
BEGIN
	DECLARE p INT;
	DECLARE q INT;
	DECLARE com_len INT;

	DECLARE p1 INT;
	DECLARE q1 INT;

	SET pos1 = 0;
	SET pos2 = 0;
	SET max_len = 0;

	SET p = s1_off;
	WHILE p < s1_len DO
		SET q = s2_off;
		WHILE q < s2_len DO
			SET com_len = 0;
			SET p1 = p + 1;
			SET q1 = q + 1;

			WHILE p1 <= s1_len AND q1 <= s2_len AND ORD(SUBSTRING(s1, p1, 1)) = ORD(SUBSTRING(s2, q1, 1)) DO
				SET com_len = com_len + 1;
				SET p1 = p1 + 1;
				SET q1 = q1 + 1;
			END WHILE;

			IF com_len > max_len THEN
				SET max_len = com_len;
				SET pos1 = p;
				SET pos2 = q;
			END IF;

			SET q = q + 1;
		END WHILE;
		SET p = p + 1;
	END WHILE;
END$$

CREATE PROCEDURE `php_similar_char`(
	IN `s1` VARCHAR(255) CHARSET utf32,
	IN `s1_off` INT,
	IN `s1_len` INT,
	IN `s2` VARCHAR(255) CHARSET utf32,
	IN `s2_off` INT,
	IN `s2_len` INT,
	OUT `sim` INT
)
LANGUAGE SQL
DETERMINISTIC
CONTAINS SQL
COMMENT ''
BEGIN
	DECLARE pos1 INT;
	DECLARE pos2 INT;
	DECLARE max_len INT;
	DECLARE sim_sub INT;

	CALL php_similar_str(s1, s1_off, s1_len, s2, s2_off, s2_len, pos1, pos2, max_len);
	SET sim = max_len;
	IF max_len != 0 THEN
		IF pos1 != 0 AND pos2 != 0 THEN
			CALL php_similar_char(s1, s1_off, pos1, s2, s2_off, pos2, sim_sub);
			SET sim = sim + sim_sub;
		END IF;

		SET pos1 = pos1 + max_len;
		SET pos2 = pos2 + max_len;
		IF pos1 < s1_len AND pos2 < s2_len THEN
			CALL php_similar_char(s1, pos1, s1_len, s2, pos2, s2_len, sim_sub);
			SET sim = sim + sim_sub;
		END IF;
	END IF;
END$$

CREATE FUNCTION `php_similar_text`(
	`s1` VARCHAR(255) CHARSET utf32,
	`s2` VARCHAR(255) CHARSET utf32
)
RETURNS INT
LANGUAGE SQL
DETERMINISTIC
CONTAINS SQL
COMMENT 'PHP similar_text'
BEGIN
	DECLARE s1_len INT;
	DECLARE s2_len INT;
	DECLARE sim INT DEFAULT 0;

	SET s1_len = CHAR_LENGTH(IFNULL(s1, ''));
	SET s2_len = CHAR_LENGTH(IFNULL(s2, ''));

	IF s1_len != 0 AND s2_len != 0 THEN
		-- case insensitive
		SET s1 = LOWER(s1);
		SET s2 = LOWER(s2);	
		-- recursive
		SET max_sp_recursion_depth = 255;
		CALL php_similar_char(s1, 0, s1_len, s2, 0, s2_len, sim);
	END IF;

	RETURN sim;
END$$

CREATE FUNCTION `php_similar_text_ratio`(
	`s1` VARCHAR(255) CHARSET utf32,
	`s2` VARCHAR(255) CHARSET utf32
)
RETURNS INT
LANGUAGE SQL
DETERMINISTIC
CONTAINS SQL
COMMENT 'PHP similar_text'
BEGIN
	DECLARE s1_len INT;
	DECLARE s2_len INT;
	DECLARE sim INT;
	DECLARE percent INT;

	SET s1_len = CHAR_LENGTH(IFNULL(s1, ''));
	SET s2_len = CHAR_LENGTH(IFNULL(s2, ''));
	SET percent = s1_len + s2_len;

	-- different from similar_text() in PHP
	IF s1_len = 0 OR s2_len = 0 THEN
		IF percent = 0 THEN
			RETURN 100;
		END IF;
		RETURN 0;
	END IF;

	-- case insensitive
	SET s1 = LOWER(s1);
	SET s2 = LOWER(s2);	
	-- recursive
	SET max_sp_recursion_depth = 255;
	CALL php_similar_char(s1, 0, s1_len, s2, 0, s2_len, sim);
	SET percent = ROUND(sim * 200.0 / percent);
	RETURN percent;
END$$

DELIMITER ;
