#include <string.h>

#include <stdio.h>
#include <float.h>

/*
 MinGW-w64 GCC
 gcc -D__USE_MINGW_ANSI_STDIO -Wall -Wextra lcs.c
*/

size_t lcs_similarity(const char *s1, const char *s2, double *percent) {
	size_t s1_len = s1 ? strlen(s1) : 0;
	size_t s2_len = s2 ? strlen(s2) : 0;
	size_t length;

	if (s1_len == 0 || s2_len == 0) {
		if (s1_len + s2_len == 0) {
			*percent = 100;
		} else {
			*percent = 0;
		}
		return 0;
	}

	if (s2_len > s1_len) {
		const char *t = s2;
		s2 = s1;
		s1 = t;
		length = s2_len;
		s2_len = s1_len;
		s1_len = length;
	}

	size_t column[s2_len];
	memset(column, 0, sizeof(column));

	for (size_t i = 0; i < s1_len; i++) {
		char s1_ch = s1[i];
		size_t prev2 = 0,  prev1 = 0;
		for (size_t j = 0; j < s2_len; j++) {
			size_t old_diag = column[j], last_diag;
			if (s1_ch == s2[j]) {
				last_diag = prev2 + 1;
			} else {
				last_diag = (old_diag > prev1)? old_diag : prev1;
			}

			column[j] = last_diag;
			prev2 = old_diag;
			prev1 = last_diag;
		}
	}

	length = column[s2_len - 1];
	*percent = length * 200.0 / (s1_len + s2_len);
	length = s1_len - length;
	return length;
}

int main(int argc, char* argv[]) {
	if (argc > 2) {
		const char *s1 = argv[1];
		const char *s2 = argv[2];
		double percent;
		size_t dist = lcs_similarity(s1, s2, &percent);
		printf("lcs_similarity('%s', '%s')=%zu, %.*g\n", s1, s2, dist, DBL_DECIMAL_DIG, percent);
	} else {
		printf("usage: %s s1 s2\n", argv[0]);
	}
	return 0;
}
