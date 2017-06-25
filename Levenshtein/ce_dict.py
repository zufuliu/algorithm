#/usr/bin/python3
#-*- coding: UTF-8 -*-
from util import *

create_table_stmt = """
DROP TABLE IF EXISTS `ce_dict`;
CREATE TABLE `ce_dict` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`chinese` VARCHAR(150) NOT NULL,
	`english` VARCHAR(500) NOT NULL,
	PRIMARY KEY (`id`)
)
COMMENT='cedict_ts.u8 from http://www.mdbg.net/chindict/chindict.php?page=cedict'
COLLATE='utf8_general_ci'
ENGINE=InnoDB;

"""

def parse_cedict_line(line):
	items = [item.strip() for item in line.split('/')]
	items = [item for item in items if item]
	chinese = items[0]
	english = '\n'.join(items[1:])
	return chinese, english

def build_stmt():
	path, out_path = get_in_out_path('cedict_ts.u8', 'ce_dict.sql')
	if not os.path.isfile(path):
		print('file not exists: ', path)
		return

	word_list = []
	step_size = 5000
	total_count = 0
	max_zh_len = 0;
	max_en_len = 0

	def save_query(fp):
		query = ",\n\t".join("('%s', '%s')" % (word[0], word[1]) for word in word_list)
		fp.write("INSERT INTO `ce_dict`(`chinese`, `english`) VALUES \n\t")
		fp.write(query)
		fp.write(";\n")

	with open(out_path, 'w', encoding='utf-8', newline='\n') as fp:
		fp.write(create_table_stmt)

		word_count = 0
		for line in open(path, encoding='utf-8', newline='\n').readlines():
			line = line.strip()
			if not line or line[0] == '#':
				continue

			chinese, english = parse_cedict_line(line)
			max_zh_len = max(max_zh_len, len(chinese))
			max_en_len = max(max_en_len, len(english))
			chinese = sql_escape(chinese)
			english = sql_escape(english)
			word_list.append((chinese, english))
			word_count += 1
			if word_count == step_size:
				total_count += word_count
				save_query(fp)
				word_count = 0
				word_list = []

		if word_list :
			total_count += len(word_list)
			save_query(fp)

	print('total word count:', total_count)
	print('max chinese word length:', max_zh_len)
	print('max english word length:', max_en_len)

if __name__ == '__main__':
	build_stmt()
