# Levenshtein Distance

Levenshtein Distance in C and MySQL based on the following wiki articles:

 * [Wikipedia Levenshtein distance](https://en.wikipedia.org/wiki/Levenshtein_distance)
 * [Wikibooks Algorithm Implementation/Strings/Levenshtein distance](https://en.wikibooks.org/wiki/Algorithm_Implementation/Strings/Levenshtein_distance)

## File List

* levenshtein.c

	The C implementation (same as the one in above [Wikibooks page](https://en.wikibooks.org/wiki/Algorithm_Implementation/Strings/Levenshtein_distance#C)).

* levenshtein.sql, levenshtein\_long.sql

	The MySQL implementation.

* levenshtein\_case.sql, levenshtein\_long\_case.sql

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

```

## Notice

You may need to change `CHARSET utf32` to other appropriate types.
