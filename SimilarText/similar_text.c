#include <string.h>

#include <stdio.h>
#include <float.h>

/*
 MinGW-w64 GCC
 gcc -D__USE_MINGW_ANSI_STDIO -Wall -Wextra similar_text.c
*/

static void php_similar_str(const char *txt1, size_t len1, const char *txt2, size_t len2, size_t *pos1, size_t *pos2, size_t *max, size_t *count) {
	const char *p, *q;
	const char *end1 = txt1 + len1;
	const char *end2 = txt2 + len2;
	size_t l;

	*max = 0;
	*count = 0;
	for (p = txt1; p < end1; p++) {
		for (q = txt2; q < end2; q++) {
			for (l = 0; (p + l < end1) && (q + l < end2) && (p[l] == q[l]); l++);
			if (l > *max) {
				*max = l;
				*pos1 = p - txt1;
				*pos2 = q - txt2;
				*count += 1;
			}
		}
	}
}

static size_t php_similar_char(const char *txt1, size_t len1, const char *txt2, size_t len2) {
	size_t sum;
	size_t pos1 = 0, pos2 = 0, max, count;

	php_similar_str(txt1, len1, txt2, len2, &pos1, &pos2, &max, &count);
	if ((sum = max) != 0) {
		if (pos1 && pos2 && count > 1) {
			sum += php_similar_char(txt1, pos1,
									txt2, pos2);
		}
		if ((pos1 + max < len1) && (pos2 + max < len2)) {
			sum += php_similar_char(txt1 + pos1 + max, len1 - pos1 - max,
									txt2 + pos2 + max, len2 - pos2 - max);
		}
	}

	return sum;
}

size_t similar_text(const char *txt1, const char *txt2, size_t *distance, double *percent) {
	size_t len1 = txt1 ? strlen(txt1) : 0;
	size_t len2 = txt2 ? strlen(txt2) : 0;
	size_t sum_len = len1 + len2;
	size_t sim;

	/* different from similar_text() in PHP */
	if (len1 == 0 || len2 == 0) {
		*distance = sum_len;
		if (sum_len == 0) {
			*percent = 100;
		} else {
			*percent = 0;
		}
		return 0;
	}

	sim = php_similar_char(txt1, len1, txt2, len2);
	*percent = sim * 200.0 / sum_len;
	*distance = sum_len - 2*sim;
	return sim;
}


int main(int argc, char* argv[]) {
	if (argc > 2) {
		const char *txt1 = argv[1];
		const char *txt2 = argv[2];
		size_t distance;
		double percent;
		size_t sim = similar_text(txt1, txt2, &distance, &percent);
		printf("similar_text('%s', '%s')=%zu, %zu, %.*g\n", txt1, txt2, sim, distance, DBL_DECIMAL_DIG, percent);
	} else {
		printf("usage: %s txt1 txt2\n", argv[0]);
	}
	return 0;
}
