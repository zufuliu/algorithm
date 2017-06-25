SELECT edit_distance_case('Hello','hello'), edit_distance_case_ratio('Hello','hello'),
	edit_distance('Hello','hello'), edit_distance_ratio('Hello','hello'),
	edit_distance_long_case('Hello','hello'), edit_distance_long_case_ratio('Hello','hello'),
	edit_distance_long('Hello','hello'), edit_distance_long_ratio('Hello','hello'),
	levenshtein('Hello','hello'), levenshtein_ratio('Hello','hello');

SELECT word, edit_distance_case_ratio(word, 'Baylor/M') AS ratio
FROM en_us_dict
ORDER BY ratio DESC
LIMIT 100;

SELECT word, edit_distance_ratio(word, 'Baylor/M') AS ratio
FROM en_us_dict
ORDER BY ratio DESC
LIMIT 100;

SELECT word, edit_distance_long_case_ratio(word, 'Baylor/M') AS ratio
FROM en_us_dict
ORDER BY ratio DESC
LIMIT 100;

SELECT word, edit_distance_long_ratio(word, 'Baylor/M') AS ratio
FROM en_us_dict
ORDER BY ratio DESC
LIMIT 100;

SELECT word, levenshtein_ratio(word, 'Baylor/M') AS ratio
FROM en_us_dict
ORDER BY ratio DESC
LIMIT 100;
