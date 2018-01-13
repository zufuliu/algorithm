SELECT word, lcs_similarity(word, 'Baylor/M') AS ratio
FROM en_us_dict
ORDER BY ratio DESC
LIMIT 100;

SELECT word, similar_text_ratio(word, 'Baylor/M') AS ratio
FROM en_us_dict
ORDER BY ratio DESC
LIMIT 100;
