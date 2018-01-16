DELIMITER $$

CREATE FUNCTION `similar_text`(
	`s1` VARCHAR(255) CHARSET utf32,
	`s2` VARCHAR(255) CHARSET utf32
)
RETURNS INT
LANGUAGE SQL
DETERMINISTIC
CONTAINS SQL
COMMENT 'PHP similar_text'
BEGIN
	DECLARE s1_len, s2_len INT;
	DECLARE sim INT DEFAULT 0;
	DECLARE sum_len INT;

	DECLARE stack VARBINARY(208);
	DECLARE stack_size INT;

	DECLARE s1_off, s2_off INT;
	DECLARE pos1, pos2 INT;
	DECLARE max_com_len, com_count INT;
	DECLARE p, q INT;
	DECLARE com_len INT;
	DECLARE p1, q1 INT;

	SET s1_len = CHAR_LENGTH(IFNULL(s1, ''));
	SET s2_len = CHAR_LENGTH(IFNULL(s2, ''));
	SET sum_len = s1_len + s2_len;

	IF s1_len = 0 OR s2_len = 0 THEN
		RETURN sum_len;
	END IF;

	-- case insensitive
	SET s1 = LOWER(s1);
	SET s2 = LOWER(s2);

	SET stack = CONCAT('\0', CHAR(s1_len), '\0', CHAR(s2_len));
	SET stack_size = 4;
	WHILE stack_size > 0 DO
		-- pop stack
		SET s1_off = ORD(SUBSTRING(stack, stack_size - 3, 1));
		SET s1_len = ORD(SUBSTRING(stack, stack_size - 2, 1));
		SET s2_off = ORD(SUBSTRING(stack, stack_size - 1, 1));
		SET s2_len = ORD(SUBSTRING(stack, stack_size, 1));
		SET stack_size = stack_size - 4;

		-- php_similar_str
		SET pos1 = 0;
		SET pos2 = 0;
		SET max_com_len = 0;
		SET com_count = 0;

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

				IF com_len > max_com_len THEN
					SET max_com_len = com_len;
					SET pos1 = p;
					SET pos2 = q;
					SET com_count = com_count + 1;
				END IF;

				SET q = q + 1;
			END WHILE;
			SET p = p + 1;
		END WHILE;

		SET sim = sim + max_com_len;
		IF max_com_len != 0 THEN
			IF pos1 != 0 AND pos2 != 0 AND com_count > 1 THEN
				SET stack = CONCAT(SUBSTRING(stack, 1, stack_size), CONCAT(CHAR(s1_off), CHAR(pos1), CHAR(s2_off), CHAR(pos2)));
				SET stack_size = stack_size + 4;
			END IF;

			SET pos1 = pos1 + max_com_len;
			SET pos2 = pos2 + max_com_len;
			IF pos1 < s1_len AND pos2 < s2_len THEN
				SET stack = CONCAT(SUBSTRING(stack, 1, stack_size), CONCAT(CHAR(pos1), CHAR(s1_len), CHAR(pos2), CHAR(s2_len)));
				SET stack_size = stack_size + 4;
			END IF;
		END IF;
	END WHILE;

	RETURN sum_len - 2*sim;
END$$

CREATE FUNCTION `similar_text_ratio`(
	`s1` VARCHAR(255) CHARSET utf32,
	`s2` VARCHAR(255) CHARSET utf32
)
RETURNS INT
LANGUAGE SQL
DETERMINISTIC
CONTAINS SQL
COMMENT 'PHP similar_text'
BEGIN
	DECLARE s1_len, s2_len INT;
	DECLARE sim INT DEFAULT 0;
	DECLARE sum_len INT;

	DECLARE stack VARBINARY(208);
	DECLARE stack_size INT;

	DECLARE s1_off, s2_off INT;
	DECLARE pos1, pos2 INT;
	DECLARE max_com_len, com_count INT;
	DECLARE p, q INT;
	DECLARE com_len INT;
	DECLARE p1, q1 INT;

	SET s1_len = CHAR_LENGTH(IFNULL(s1, ''));
	SET s2_len = CHAR_LENGTH(IFNULL(s2, ''));
	SET sum_len = s1_len + s2_len;

	-- different from similar_text() in PHP
	IF s1_len = 0 OR s2_len = 0 THEN
		IF sum_len = 0 THEN
			RETURN 100;
		END IF;
		RETURN 0;
	END IF;

	-- case insensitive
	SET s1 = LOWER(s1);
	SET s2 = LOWER(s2);

	SET stack = CONCAT('\0', CHAR(s1_len), '\0', CHAR(s2_len));
	SET stack_size = 4;
	WHILE stack_size > 0 DO
		-- pop stack
		SET s1_off = ORD(SUBSTRING(stack, stack_size - 3, 1));
		SET s1_len = ORD(SUBSTRING(stack, stack_size - 2, 1));
		SET s2_off = ORD(SUBSTRING(stack, stack_size - 1, 1));
		SET s2_len = ORD(SUBSTRING(stack, stack_size, 1));
		SET stack_size = stack_size - 4;

		-- php_similar_str
		SET pos1 = 0;
		SET pos2 = 0;
		SET max_com_len = 0;
		SET com_count = 0;

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

				IF com_len > max_com_len THEN
					SET max_com_len = com_len;
					SET pos1 = p;
					SET pos2 = q;
					SET com_count = com_count + 1;
				END IF;

				SET q = q + 1;
			END WHILE;
			SET p = p + 1;
		END WHILE;

		SET sim = sim + max_com_len;
		IF max_com_len != 0 THEN
			IF pos1 != 0 AND pos2 != 0 AND com_count > 1 THEN
				SET stack = CONCAT(SUBSTRING(stack, 1, stack_size), CONCAT(CHAR(s1_off), CHAR(pos1), CHAR(s2_off), CHAR(pos2)));
				SET stack_size = stack_size + 4;
			END IF;

			SET pos1 = pos1 + max_com_len;
			SET pos2 = pos2 + max_com_len;
			IF pos1 < s1_len AND pos2 < s2_len THEN
				SET stack = CONCAT(SUBSTRING(stack, 1, stack_size), CONCAT(CHAR(pos1), CHAR(s1_len), CHAR(pos2), CHAR(s2_len)));
				SET stack_size = stack_size + 4;
			END IF;
		END IF;
	END WHILE;

	RETURN ROUND(sim * 200.0 / sum_len);
END$$

DELIMITER ;
