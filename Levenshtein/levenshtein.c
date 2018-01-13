/**
 * https://github.com/zufuliu/algorithm.git
 * https://en.wikipedia.org/wiki/Levenshtein_distance
 * https://en.wikibooks.org/wiki/Algorithm_Implementation/Strings/Levenshtein_distance
 */

#include <string.h>

#include <stdio.h>
#include <float.h>

/*
 MinGW-w64 GCC
 gcc -D__USE_MINGW_ANSI_STDIO -Wall -Wextra levenshtein.c
*/

static inline size_t max(size_t a, size_t b) {
	return a < b ? b : a;
}

static inline size_t min(size_t a, size_t b) {
	return a < b ? a : b;
}

static inline size_t min3(size_t a, size_t b, size_t c) {
	return min(min(a, b), c);
}

size_t levenshtein(const char *s1, const char *s2) {
	const size_t s1_len = (size_t)strlen(s1);
	const size_t s2_len = (size_t)strlen(s2);
	size_t last_diag, old_diag;
	size_t column[s1_len + 1];
	size_t x, y;

	if (s1_len == 0 || s2_len == 0) {
		return max(s1_len, s2_len);
	}
	for (y = 1; y <= s1_len; y++) {
		column[y] = y;
	}

	for (x = 1; x <= s2_len; x++) {
		char s2_x_1 = s2[x - 1];
		column[0] = x;
		for (y = 1, last_diag = x - 1; y <= s1_len; y++) {
			last_diag += (s1[y - 1] == s2_x_1) ? 0 : 1;
			old_diag = column[y];
			column[y] = min3(old_diag + 1, column[y - 1] + 1, last_diag);
			last_diag = old_diag;
		}
	}

	x = column[s1_len];
	y = max(s1_len, s2_len);
	double ratio = x / (double)y;
	ratio = 100 * (1 - ratio);
	printf("s1_len=%zu, s2_len=%zu, dist=%zu, ratio=%.*g\n", s1_len, s2_len, x, DBL_DECIMAL_DIG, ratio);
	return x;
}

int main(int argc, char* argv[]) {
	if (argc > 2) {
		levenshtein(argv[1], argv[2]);
	} else {
		printf(
			"Calculate Levenshtein distance of two strings\n"
			"Usage: %s s1 s2\n"
		, argv[0]);
	}
	return 0;
}
