-- Levenshtein distance for MySQL
-- https://github.com/zufuliu/algorithm.git
-- based on the C implementation in following wiki articles:
-- https://en.wikipedia.org/wiki/Levenshtein_distance
-- https://en.wikibooks.org/wiki/Algorithm_Implementation/Strings/Levenshtein_distance

DELIMITER $$

CREATE FUNCTION `levenshtein_long`(
	`s1` VARCHAR(16382) CHARSET utf32,
	`s2` VARCHAR(16382) CHARSET utf32
)
RETURNS INT
LANGUAGE SQL
DETERMINISTIC
CONTAINS SQL
COMMENT 'Levenshtein distance'
BEGIN
	DECLARE s1_len, s2_len INT;
	DECLARE x, y INT;
	DECLARE old_diag, last_diag INT;
	DECLARE s2_ch INT;
	DECLARE col VARCHAR(16383) CHARSET utf16 COLLATE utf16_bin DEFAULT ' ';

	-- https://en.wikipedia.org/wiki/Levenshtein_distance
	-- https://en.wikibooks.org/wiki/Algorithm_Implementation/Strings/Levenshtein_distance

	SET s1_len = CHAR_LENGTH(IFNULL(s1, ''));
	SET s2_len = CHAR_LENGTH(IFNULL(s2, ''));

	IF s1_len = 0 OR s2_len = 0 THEN
		RETURN GREATEST(s1_len, s2_len);
	END IF;

	SET y = 1;
	WHILE y <= s1_len DO
		SET col = CONCAT(SUBSTRING(col, 1, y), CHAR(y));
		SET y = y + 1;
	END WHILE;

	-- case insensitive
	SET s1 = LOWER(s1);
	SET s2 = LOWER(s2);

	SET x = 1;
	WHILE x <= s2_len DO
		SET col = CONCAT(CHAR(x), SUBSTRING(col, 2));
		SET s2_ch = ORD(SUBSTRING(s2, x, 1));
		SET last_diag = x - 1;
		SET y = 1;
		WHILE y <= s1_len DO
			SET old_diag = ORD(SUBSTRING(col, y + 1, 1));
			IF s2_ch != ORD(SUBSTRING(s1, y, 1)) THEN
				SET last_diag = last_diag + 1;
			END IF;
			SET last_diag = LEAST(LEAST(old_diag + 1, ORD(SUBSTRING(col, y, 1)) + 1), last_diag);
			-- SET col = replace_char_at(col, CHAR(last_diag), y + 1);
			SET col = CONCAT(SUBSTRING(col, 1, y), CHAR(last_diag), SUBSTRING(col, y + 2, s1_len - y));
			SET last_diag = old_diag;
			SET y = y + 1;
		END WHILE;
		SET x = x + 1;
	END WHILE;

	SET s1_len = ORD(SUBSTRING(col, s1_len + 1, 1));
	RETURN s1_len;
END$$

CREATE FUNCTION `levenshtein_long_ratio`(
	`s1` VARCHAR(16382) CHARSET utf32,
	`s2` VARCHAR(16382) CHARSET utf32
)
RETURNS INT
LANGUAGE SQL
DETERMINISTIC
CONTAINS SQL
COMMENT 'Levenshtein distance ratio'
BEGIN
	DECLARE s1_len, s2_len INT;
	DECLARE x, y INT;
	DECLARE old_diag, last_diag INT;
	DECLARE s2_ch INT;
	DECLARE col VARCHAR(16383) CHARSET utf16 COLLATE utf16_bin DEFAULT ' ';

	-- https://en.wikipedia.org/wiki/Levenshtein_distance
	-- https://en.wikibooks.org/wiki/Algorithm_Implementation/Strings/Levenshtein_distance

	SET s1_len = CHAR_LENGTH(IFNULL(s1, ''));
	SET s2_len = CHAR_LENGTH(IFNULL(s2, ''));

	IF s1_len = 0 OR s2_len = 0 THEN
		IF s1_len = 0 AND s2_len = 0 THEN
			RETURN 100;
		END IF;
		RETURN 0;
	END IF;

	SET y = 1;
	WHILE y <= s1_len DO
		SET col = CONCAT(SUBSTRING(col, 1, y), CHAR(y));
		SET y = y + 1;
	END WHILE;

	-- case insensitive
	SET s1 = LOWER(s1);
	SET s2 = LOWER(s2);

	SET x = 1;
	WHILE x <= s2_len DO
		SET col = CONCAT(CHAR(x), SUBSTRING(col, 2));
		SET s2_ch = ORD(SUBSTRING(s2, x, 1));
		SET last_diag = x - 1;
		SET y = 1;
		WHILE y <= s1_len DO
			SET old_diag = ORD(SUBSTRING(col, y + 1, 1));
			IF s2_ch != ORD(SUBSTRING(s1, y, 1)) THEN
				SET last_diag = last_diag + 1;
			END IF;
			SET last_diag = LEAST(LEAST(old_diag + 1, ORD(SUBSTRING(col, y, 1)) + 1), last_diag);
			-- SET col = replace_char_at(col, CHAR(last_diag), y + 1);
			SET col = CONCAT(SUBSTRING(col, 1, y), CHAR(last_diag), SUBSTRING(col, y + 2, s1_len - y));
			SET last_diag = old_diag;
			SET y = y + 1;
		END WHILE;
		SET x = x + 1;
	END WHILE;

	SET s2_len = GREATEST(s1_len, s2_len);
	SET s1_len = ORD(SUBSTRING(col, s1_len + 1, 1));
	RETURN ROUND(100 * (1 - s1_len / s2_len));
END$$

DELIMITER ;
