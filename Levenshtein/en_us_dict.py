#/usr/bin/python3
#-*- coding: UTF-8 -*-
from util import *

create_table_stmt = """
DROP TABLE IF EXISTS `en_us_dict`;
CREATE TABLE `en_us_dict` (
	`id` INT(11) NOT NULL AUTO_INCREMENT,
	`word` VARCHAR(50) NOT NULL,
	PRIMARY KEY (`id`)
)
COMMENT='en_US.dic from https://github.com/marcoagpinto/aoo-mozilla-en-dict/'
COLLATE='utf8_general_ci'
ENGINE=InnoDB;

"""

def build_stmt():
	path, out_path = get_in_out_path('en_US.dic', 'en_us_dict.sql')
	if not os.path.isfile(path):
		print('file not exists: ', path)
		return

	word_list = []
	step_size = 5000
	total_count = 0
	max_len = 0;

	def save_query(fp):
		query = ",\n\t".join("('%s')" % word for word in word_list)
		fp.write("INSERT INTO `en_us_dict`(`word`) VALUES \n\t")
		fp.write(query)
		fp.write(";\n")

	with open(out_path, 'w', encoding='utf-8', newline='\n') as fp:
		fp.write(create_table_stmt);

		word_count = 0
		for line in open(path, encoding='utf-8', newline='\n').readlines():
			line = line.strip();
			if not line:
				continue

			max_len = max(max_len, len(line))
			line = sql_escape(line)
			word_list.append(line)
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
	print('max word length:', max_len)

if __name__ == '__main__':
	build_stmt()
