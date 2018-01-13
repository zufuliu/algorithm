DELIMITER $$

CREATE FUNCTION `lcs_distance`(
	`s1` VARCHAR(255) CHARSET utf32,
	`s2` VARCHAR(255) CHARSET utf32
)
RETURNS INT
LANGUAGE SQL
DETERMINISTIC
CONTAINS SQL
COMMENT 'Longest common subsequence distance'
BEGIN
	DECLARE s1_len, s2_len INT;
	DECLARE max_len INT;
	DECLARE i, j INT;
	DECLARE prev2, prev, old_diag, last_diag INT;
	DECLARE s1_ch INT;
	DECLARE col VARBINARY(255) DEFAULT '';

	SET s1_len = CHAR_LENGTH(IFNULL(s1, ''));
	SET s2_len = CHAR_LENGTH(IFNULL(s2, ''));
	SET max_len = GREATEST(s1_len, s2_len);

	IF s1_len = 0 OR s2_len = 0 THEN
		RETURN max_len;
	END IF;

	-- case insensitive
	SET s1 = LOWER(s1);
	SET s2 = LOWER(s2);

	SET i = 1;
	WHILE i <= s1_len DO
		SET s1_ch = ORD(SUBSTRING(s1, i, 1));
		SET prev2 = 0;
		SET prev = 0;
		SET j = 1;
		WHILE j <= s2_len DO
			SET old_diag = ORD(SUBSTRING(col, j, 1));
			IF s1_ch = ORD(SUBSTRING(s2, j, 1)) THEN
				SET last_diag = prev2 + 1;
			ELSE
				SET last_diag = GREATEST(old_diag, prev);
			END IF;
			-- SET col = replace_char_at(col, CHAR(last_diag), j);
			SET col = CONCAT(SUBSTRING(col, 1, j - 1), CHAR(last_diag), SUBSTRING(col, j + 1, s2_len - j));
			SET prev2 = old_diag;
			SET prev = last_diag;
			SET j = j + 1;
		END WHILE;
		SET i = i + 1;
	END WHILE;

	RETURN max_len - ORD(SUBSTRING(col, s2_len, 1));
END$$

CREATE FUNCTION `lcs_similarity`(
	`s1` VARCHAR(255) CHARSET utf32,
	`s2` VARCHAR(255) CHARSET utf32
)
RETURNS INT
LANGUAGE SQL
DETERMINISTIC
CONTAINS SQL
COMMENT 'Longest common subsequence similarity'
BEGIN
	DECLARE s1_len, s2_len INT;
	DECLARE sum_len INT;
	DECLARE i, j INT;
	DECLARE prev2, prev, old_diag, last_diag INT;
	DECLARE s1_ch INT;
	DECLARE col VARBINARY(255) DEFAULT '';

	SET s1_len = CHAR_LENGTH(IFNULL(s1, ''));
	SET s2_len = CHAR_LENGTH(IFNULL(s2, ''));
	SET sum_len = s1_len + s2_len;

	IF s1_len = 0 OR s2_len = 0 THEN
		IF sum_len = 0 THEN
			RETURN 100;
		END IF;
		RETURN 0;
	END IF;

	-- case insensitive
	SET s1 = LOWER(s1);
	SET s2 = LOWER(s2);

	SET i = 1;
	WHILE i <= s1_len DO
		SET s1_ch = ORD(SUBSTRING(s1, i, 1));
		SET prev2 = 0;
		SET prev = 0;
		SET j = 1;
		WHILE j <= s2_len DO
			SET old_diag = ORD(SUBSTRING(col, j, 1));
			IF s1_ch = ORD(SUBSTRING(s2, j, 1)) THEN
				SET last_diag = prev2 + 1;
			ELSE
				SET last_diag = GREATEST(old_diag, prev);
			END IF;
			-- SET col = replace_char_at(col, CHAR(last_diag), j);
			SET col = CONCAT(SUBSTRING(col, 1, j - 1), CHAR(last_diag), SUBSTRING(col, j + 1, s2_len - j));
			SET prev2 = old_diag;
			SET prev = last_diag;
			SET j = j + 1;
		END WHILE;
		SET i = i + 1;
	END WHILE;

	SET s1_len = ORD(SUBSTRING(col, s2_len, 1));
	RETURN ROUND(s1_len * 200.0 / sum_len);
END$$

DELIMITER ;
