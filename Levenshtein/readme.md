# Levenshtein Distance

Levenshtein Distance in C and MySQL based on the following wiki articles:

 * [Wikipedia Levenshtein distance](https://en.wikipedia.org/wiki/Levenshtein_distance)
 * [Wikibooks Algorithm Implementation/Strings/Levenshtein distance](https://en.wikibooks.org/wiki/Algorithm_Implementation/Strings/Levenshtein_distance)

## File List

* edit\_dist.c

	The C implementation (same as the one in above [Wikibooks page](https://en.wikibooks.org/wiki/Algorithm_Implementation/Strings/Levenshtein_distance#C)).

* edit\_distance.sql

	The MySQL implementation.

* edit\_distance\_case.sql

	Case sensitive implementation in MySQL.

* aktagon/levenshtein.sql

	The MySQL implementation from (also listed in above [Wikibooks page](https://en.wikibooks.org/wiki/Algorithm_Implementation/Strings/Levenshtein_distance#MySQL))

	[Levenshtein distance for MySQL](https://snippets.aktagon.com/snippets/610-levenshtein-distance-for-mysql)

	under Creative Commons Attribution 3.0 License.

* test.sql

	Test query list.

* en\_us\_dict.py, ce\_dict.py, util.py

	Python scripts to parse and build test data import SQL query.

## Used Test Data

Those test data can be download online and use provided Python script to process.

* en\_US.dic

	[English Dictionaries Project (AOO+Mozilla+others)](https://github.com/marcoagpinto/aoo-mozilla-en-dict/)

* cedict\_ts.u8

	[CC-CEDICT](http://www.mdbg.net/chindict/chindict.php?page=cedict)

## Usage

Queries taken from test.sql:

```SQL

SELECT edit_distance_case('Hello','hello'), edit_distance_case_ratio('Hello','hello'),
	edit_distance('Hello','hello'), edit_distance_ratio('Hello','hello'),
	levenshtein('Hello','hello'), levenshtein_ratio('Hello','hello');

SELECT word, edit_distance_case_ratio(word, 'Baylor/M') AS ratio
FROM en_us_dict
ORDER BY ratio DESC
LIMIT 100;

SELECT word, edit_distance_ratio(word, 'Baylor/M') AS ratio
FROM en_us_dict
ORDER BY ratio DESC
LIMIT 100;

SELECT word, levenshtein_ratio(word, 'Baylor/M') AS ratio
FROM en_us_dict
ORDER BY ratio DESC
LIMIT 100;

```
