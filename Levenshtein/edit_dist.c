/**
 * https://github.com/zufuliu/algorithm.git
 * https://en.wikipedia.org/wiki/Levenshtein_distance
 * https://en.wikibooks.org/wiki/Algorithm_Implementation/Strings/Levenshtein_distance
 */

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <stdint.h>

static inline uint32_t max(uint32_t a, uint32_t b) {
	return a < b ? b : a;
}

static inline uint32_t min(uint32_t a, uint32_t b) {
	return a < b ? a : b;
}

static inline uint32_t min3(uint32_t a, uint32_t b, uint32_t c) {
	return min(min(a, b), c);
}

uint32_t levenshtein(const char *s1, const char *s2) {
	const uint32_t s1_len = (uint32_t)strlen(s1);
	const uint32_t s2_len = (uint32_t)strlen(s2);
	uint32_t last_diag, old_diag;
	uint32_t column[s1_len + 1];
	uint32_t x, y;

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
	printf("s1_len=%u, s2_len=%u, dist=%u, ratio=%f\n", s1_len, s2_len, x, ratio);
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
