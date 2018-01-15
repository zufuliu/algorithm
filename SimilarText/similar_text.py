#!/usr/bin/env python3
#-*- coding: UTF-8 -*-

def php_similar_str(s1, s1_off, s1_len, s2, s2_off, s2_len):
	pos1 = 0
	pos2 = 0
	max_com_len = 0
	com_count= 0

	p = s1_off
	while p < s1_len:
		q = s2_off
		while q < s2_len:
			com_len = 0
			p1 = p
			q1 = q
			while p1 < s1_len and q1 < s2_len and s1[p1] == s2[q1]:
				com_len += 1
				p1 += 1
				q1 += 1

			if com_len > max_com_len:
				max_com_len = com_len
				pos1 = p
				pos2 = q
				com_count += 1

			q += 1
		p += 1

	return pos1, pos2, max_com_len, com_count

def php_similar_char(s1, s1_off, s1_len, s2, s2_off, s2_len):
	pos1, pos2, max_com_len, com_count = php_similar_str(s1, s1_off, s1_len, s2, s2_off, s2_len)
	sim = max_com_len
	if max_com_len:
		if pos1 and pos2 and com_count > 1:
			sim += php_similar_char(s1, s1_off, pos1, s2, s2_off, pos2)

		pos1 += max_com_len
		pos2 += max_com_len
		if pos1 < s1_len and pos2 < s2_len:
			sim += php_similar_char(s1, pos1, s1_len, s2, pos2, s2_len)

	return sim

def similar_text(s1, s2):
	s1_len = len(s1) if s1 else 0
	s2_len = len(s2) if s2 else 0
	sum_len = s1_len + s2_len
	max_len = max(s1_len, s2_len)

	# different from similar_text() in PHP
	if s1_len == 0 or s2_len == 0:
		if sum_len == 0:
			return max_len, 100
		return max_len, 0

	#s1 = s1.lower()
	#s2 = s2.lower()
	sim = php_similar_char(s1, 0, s1_len, s2, 0, s2_len)
	percent = sim * 200.0 / sum_len
	sim = max_len - sim
	return sim, percent


def php_similar_char2(s1, s1_len, s2, s2_len):
	sim = 0
	stack = [(0, s1_len, 0, s2_len)]
	while stack:
		s1_off, s1_len, s2_off, s2_len = stack.pop()
		pos1, pos2, max_com_len, com_count = php_similar_str(s1, s1_off, s1_len, s2, s2_off, s2_len)
		sim += max_com_len
		if max_com_len:
			if pos1 and pos2 and com_count > 1:
				stack.append((s1_off, pos1, s2_off, pos2))

			pos1 += max_com_len
			pos2 += max_com_len
			if pos1 < s1_len and pos2 < s2_len:
				stack.append((pos1, s1_len, pos2, s2_len))

	return sim

def similar_text2(s1, s2):
	s1_len = len(s1) if s1 else 0
	s2_len = len(s2) if s2 else 0
	sum_len = s1_len + s2_len
	max_len = max(s1_len, s2_len)

	# different from similar_text() in PHP
	if s1_len == 0 or s2_len == 0:
		if sum_len == 0:
			return max_len, 100
		return max_len, 0

	#s1 = s1.lower()
	#s2 = s2.lower()
	sim = php_similar_char2(s1, s1_len, s2, s2_len)
	percent = sim * 200.0 / sum_len
	sim = max_len - sim
	return sim, percent


def similar_text3(s1, s2):
	s1_len = len(s1) if s1 else 0
	s2_len = len(s2) if s2 else 0
	sum_len = s1_len + s2_len
	max_len = max(s1_len, s2_len)

	# different from similar_text() in PHP
	if s1_len == 0 or s2_len == 0:
		if sum_len == 0:
			return max_len, 100
		return max_len, 0

	#s1 = s1.lower()
	#s2 = s2.lower()
	#sim = php_similar_char2(s1, s1_len, s2, s2_len)
	sim = 0
	max_stack_size = (1 + min(s1_len, s2_len)//5) * 4;
	stack = [0] * max_stack_size
	#stack = [(0, s1_len, 0, s2_len)]
	stack[0] = 0
	stack[1] = s1_len
	stack[2] = 0
	stack[3] = s2_len
	stack_size = 4
	max_stack_size = stack_size
	while stack_size:
		#s1_off, s1_len, s2_off, s2_len = stack.pop()
		s1_off = stack[stack_size - 4]
		s1_len = stack[stack_size - 3]
		s2_off = stack[stack_size - 2]
		s2_len = stack[stack_size - 1]
		stack_size -= 4
		#pos1, pos2, max_com_len, com_count = php_similar_str(s1, s1_off, s1_len, s2, s2_off, s2_len)
		pos1, pos2, max_com_len, com_count = 0, 0, 0, 0
		p = s1_off
		while p < s1_len:
			q = s2_off
			while q < s2_len:
				com_len = 0
				p1 = p
				q1 = q
				while p1 < s1_len and q1 < s2_len and s1[p1] == s2[q1]:
					com_len += 1
					p1 += 1
					q1 += 1

				if com_len > max_com_len:
					max_com_len = com_len
					pos1 = p
					pos2 = q
					com_count += 1

				q += 1
			p += 1

		sim += max_com_len
		if max_com_len:
			if pos1 and pos2 and com_count > 1:
				#stack.append((s1_off, pos1, s2_off, pos2))
				stack[stack_size + 0] = s1_off
				stack[stack_size + 1] = pos1
				stack[stack_size + 2] = s2_off
				stack[stack_size + 3] = pos2
				stack_size += 4

			pos1 += max_com_len
			pos2 += max_com_len
			if pos1 < s1_len and pos2 < s2_len:
				#stack.append((pos1, s1_len, pos2, s2_len))
				stack[stack_size + 0] = pos1
				stack[stack_size + 1] = s1_len
				stack[stack_size + 2] = pos2
				stack[stack_size + 3] = s2_len
				stack_size += 4
			max_stack_size = max(stack_size, max_stack_size)

	print('stack_size:', max_stack_size//4, max_stack_size, len(stack)//4, len(stack))
	percent = sim * 200.0 / sum_len
	sim = max_len - sim
	return sim, percent


def _test():
	s1 = 'PHP IS GREAT'
	s2 = 'WITH MYSQL'
	print(similar_text(s1, s2))
	print(similar_text(s2, s1))
	print(similar_text('12345678901234567890', '12345678991234567890'))

def _test_stack_size():
	from itertools import repeat

	# without `com_count > 1` check
	# max stack size = ((min(s1_len, s2_len) + 1)//2)*4
	s1 = ''.join(repeat('AB', 128))
	s2 = ''.join(repeat('AC', 128))
	print(similar_text(s1, s2), similar_text2(s1, s2), similar_text3(s1, s2))

	# with `com_count > 1` check
	# max stack size = (1 + min(s1_len, s2_len)//5)*4
	s1 = ''.join(repeat('ABDEF', 51))
	s2 = ''.join(repeat('ACDEG', 51))
	print(similar_text(s1, s2), similar_text2(s1, s2), similar_text3(s1, s2))

if __name__ == '__main__':
	import sys
	if len(sys.argv) > 2:
		s1 = sys.argv[1]
		s2 = sys.argv[2]
		print("similar_text('{0}', '{1}')={2}, {3}".format(s1, s2, similar_text(s1, s2), similar_text3(s1, s2)))
	else:
		print("usage: {0} s1 s2".format(sys.argv[0]))
