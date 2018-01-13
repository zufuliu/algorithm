#!/usr/bin/env python3
#-*- coding: UTF-8 -*-

def lcs_length(s1, s1_len, s2, s2_len):
	if s2_len > s1_len:
		s1, s2 = s2, s1
		s1_len, s2_len = s2_len, s1_len

	#s1 = s1.lower()
	#s2 = s2.lower()
	col = [0] * s2_len
	i = 0
	while i < s1_len:
		s1_ch = s1[i]
		prev2 = 0
		prev = 0
		j = 0
		while j < s2_len:
			old_diag = col[j]
			if s1_ch == s2[j]:
				last_diag = prev2 + 1
			else:
				last_diag = max(old_diag, prev)

			col[j] = last_diag
			prev2 = old_diag
			prev = last_diag
			j += 1
		i += 1

	return col[s2_len - 1]

def lcs_similarity(s1, s2):
	s1_len = len(s1) if s1 else 0
	s2_len = len(s2) if s2 else 0
	max_len = max(s1_len, s2_len)
	sum_len = s1_len + s2_len

	if s1_len == 0 or s2_len == 0:
		if sum_len == 0:
			return max_len, 100
		return max_len, 0

	sim = lcs_length(s1, s1_len, s2, s2_len)
	percent = 200.0 * sim / sum_len
	return max_len - sim, percent


def _test():
	print(lcs_similarity('12345678901234567890', '12345678991234567890'))
	print(lcs_similarity('PHP IS GREAT', 'WITH MYSQL'))
	print(lcs_similarity('WITH MYSQL', 'PHP IS GREAT'))
	print(lcs_similarity('XMJYAUZ', 'MZJAWXU'))
	print(lcs_similarity('12', '23'))

if __name__ == '__main__':
	import sys
	if len(sys.argv) > 2:
		s1 = sys.argv[1]
		s2 = sys.argv[2]
		print("lcs_similarity('{0}', '{1}')={2}".format(s1, s2, lcs_similarity(s1, s2)))
	else:
		print("usage: {0} s1 s2".format(sys.argv[0]))
