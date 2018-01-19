# Text Similarity

## Algorithm List

* PHP's `similar_text()`
* Longest Common Subsequence
* Sørensen–Dice coefficient

## File List

* lcs.c

	The C implementation of LCS.

* lcs.py

	The Python implementation of LCS.

* lcs.sql, lcs\_long.sql, 

	The MySQL implementation of LCS.

* similar\_text.c

	The C implementation of PHP's `similar_text()`.

* similar\_text.py

	The Python implementation of PHP's `similar_text()`.

* similar\_text.sql

	The MySQL implementation of PHP's `similar_text()`.

* similar\_text\_rec.sql

	The MySQL implementation of PHP's `similar_text()` using recursion, which may result in "MySQL error 1436: Thread stack overrun.".

* test.sql

	Test query list.

## Usage

Test data can be found in *Levenshtein*, queries taken from test.sql:

```SQL

SELECT word, lcs_similarity(word, 'Baylor/M') AS ratio
FROM en_us_dict
ORDER BY ratio DESC
LIMIT 100;

SELECT word, lcs_long_similarity(word, 'Baylor/M') AS ratio
FROM en_us_dict
ORDER BY ratio DESC
LIMIT 100;

SELECT word, similar_text_ratio(word, 'Baylor/M') AS ratio
FROM en_us_dict
ORDER BY ratio DESC
LIMIT 100;

```

## References
* http://php.net/manual/en/function.similar-text.php
* https://github.com/php/php-src/blob/master/ext/standard/string.c
* https://github.com/Preferencesoft/SimilarText
* [Longest common subsequence problem](https://en.wikipedia.org/wiki/Longest_common_subsequence_problem)
* [Longest common subsequence](http://wordaligned.org/articles/longest-common-subsequence)
* [Longest Common Subsequence | Introduction & LCS Length](http://www.techiedelight.com/longest-common-subsequence/)
* [Longest Common Subsequence | Space optimized version](http://www.techiedelight.com/longest-common-subsequence-lcs-space-optimized-version/)
* https://ideone.com/YUxTFY
* https://ideone.com/5eXVNC
* https://www.tools4noobs.com/online_tools/string_similarity/
* [An O(ND) Difference Algorithm and Its Variations](http://xmailserver.org/diff2.pdf)
* [An O(NP) Sequence Comparison Algorithm](https://publications.mpi-cbg.de/Wu_1990_6334.pdf)
* [Diff Strategies](https://neil.fraser.name/writing/diff/)
* [The implementations of "An O(NP) Sequence Comparison Algorithm"](https://github.com/cubicdaiya/onp)
* [Sørensen–Dice coefficient](https://en.wikipedia.org/wiki/S%C3%B8rensen%E2%80%93Dice_coefficient)
* [Algorithm Implementation/Strings/Dice's coefficient](https://en.wikibooks.org/wiki/Algorithm_Implementation/Strings/Dice%27s_coefficient)
* [How to Strike a Match](http://www.catalysoft.com/articles/StrikeAMatch.html)
* [A better similarity ranking algorithm for variable length strings](https://stackoverflow.com/questions/653157/a-better-similarity-ranking-algorithm-for-variable-length-strings)
