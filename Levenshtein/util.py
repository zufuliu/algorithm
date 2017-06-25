#-*- coding: UTF-8 -*-
import sys
import os.path

def get_in_out_path(path, out_path, new_ext='.sql'):
	if len(sys.argv) > 1:
		path = sys.argv[1]
		if len(sys.argv) > 2:
			out_path = sys.argv[2]
		else:
			out_path, name = os.path.split(path)
			name, ext = os.path.splitext(name)
			out_path = os.path.join(out_path, name + new_ext)
	return path, out_path

# https://dev.mysql.com/doc/refman/5.7/en/string-literals.html
# Table 9.1 Special Character Escape Sequences

_mysql_escape_map = {
	'\0': r'\0',
	'\'': r'\'',
	'\"': r'\"',
	'\b': r'\b',
	'\n': r'\n',
	'\r': r'\r',
	'\t': r'\t',
	'\x1A': r'\Z'
}

def sql_escape(query, escape_map=_mysql_escape_map):
	if not query:
		return query
	if not any(ch in query for ch in escape_map.keys()):
		return query

	result = []
	for ch in query:
		if ch in escape_map:
			result.append(escape_map[ch])
		else:
			result.append(ch)

	query = ''.join(result)
	return query
