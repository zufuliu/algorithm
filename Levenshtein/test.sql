SELECT levenshtein_case('Hello','hello'), levenshtein_case_ratio('Hello','hello'),
	levenshtein('Hello','hello'), levenshtein_ratio('Hello','hello'),
	levenshtein_long_case('Hello','hello'), levenshtein_long_case_ratio('Hello','hello'),
	levenshtein_long('Hello','hello'), levenshtein_long_ratio('Hello','hello');

SELECT word, levenshtein_case_ratio(word, 'Baylor/M') AS ratio
FROM en_us_dict
ORDER BY ratio DESC
LIMIT 100;

SELECT word, levenshtein_ratio(word, 'Baylor/M') AS ratio
FROM en_us_dict
ORDER BY ratio DESC
LIMIT 100;

SELECT word, levenshtein_long_case_ratio(word, 'Baylor/M') AS ratio
FROM en_us_dict
ORDER BY ratio DESC
LIMIT 100;

SELECT word, levenshtein_long_ratio(word, 'Baylor/M') AS ratio
FROM en_us_dict
ORDER BY ratio DESC
LIMIT 100;
