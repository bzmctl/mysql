-------------第十六章 数据库备份与恢复---------------
本讲内容：
  数据备份
  数据恢复
  数据库迁移
  导出和导入文本
  
16.1 数据备份
16.1.1 使用mysqldump命令备份一个数据库
    基本语法：
    mysqldump -u username -p password dbname>BackupName.sql
BackupName.sql表示文件的名称，前面可加上绝对路径。
【示例16-1】使用root用户备份数据库test，具体步骤如下：
步骤一：选择数据库test
CREATE DATABASE test;
USE test;
步骤二：创建表test_1并向其中插入数据
CREATE TABLE test_1(
  id INT(10) NOT NULL,
  username VARCHAR(20) NOT NULL,
  PRIMARY KEY(id),
  UNIQUE KEY idx_id(id)
);
INSERT INTO test_1 VALUES(1,'Kate'),(2,'Emily');
CREATE TABLE test_2(
  id INT(10) NOT NULL,
  num INT(10) NOT NULL,
  PRIMARY KEY(id));
INSERT INTO test_2 VALUES(1,1000),(2,2000);
步骤三：执行以下命令，使用root用户备份test数据库。
  mysqldump -uroot -p test>e:\wt\workspace\backup\test.sql
步骤四：查看e:\wt\workspace\backup\目录下的test.sql文件
16.1.2 使用mysqldump命令备份一个数据库中的几张表
    基本语法：
    mysql -u username -p password dbname table1 table2
    ...>backupName.sql
【示例16-2】使用root备份test数据库下的test_1表。
步骤一：创建数据库及表在16-1中已完成，不再赘述。
步骤二：使用root用户备份test数据库下的test_1表。
  mysqldump -uroot -p test test_1>e:\wt\workspace\backup\test_1.sql
步骤三：查看e:\wt\workspace\backup\目录下的test_1.sql。
16.1.3 使用mysqldump命令备份多个数据库
    基本语法：
    mysqldump -u username -p password --databases
    [dbname,[dbname...]]>BackupName.sql
【示例16-3】使用root用户备份test数据库，school数据库，具体步骤：
步骤一：数据库test和school前面章节已创建，这里不再赘述。
步骤二：作用root备份test和school数据库。
mysqldump -uroot -p --databases test school>e:\wt\workspace\backup\two_database.sql
步骤三：查看目录e:\wt\workspace\backup\下的two_database.sql
    另外使用--all-databases参数可以备份系统中所有的数据库，语句如下：
    mysqldump -uusername -ppassword --all-databases>BackupName.sql
【示例16-4】使用root备份全部数据库，具体步骤如下：
步骤一：数据库及表延用之前内容。
步骤二：使用root用户备份全部数据库，命令如下：
mysqldump -uroot -p --all-databases>e:\wt\workspace\backup\all.sql
步骤三：查看e:\wt\workspace\backup\目录下的all.sql
16.1.4 直接复制整个数据目录
  对于MyISAM存储引擎的表，使用这种方式很方便，对InnoDB存储引擎的表不适
用，使用时最好相同版本的MySQL数据库，否则出现文件类型不匹配的情况。
16.2 数据恢复
16.2.1 使用MySQL命令恢复
    mysql命令的基本语法：
    mysql -uusername -p [dbname] < Backup.sql
    指定数据库名时，表示恢复该数据库下的表；不指定数据库名时，表示恢复特定的一个
数据库。而备份文件中有创建数据库的语句。
【示例16-5】root用户用mysql命令将16-1中备份的e:\wt\workspace\backup\test.sql文件中
的备份导入到数据库中，命令如下：
mysql -uroot -p test<e:\wt\workspace\backup\test.sql
【示例16-6】下面使用root用户恢复所有数据库，命令如下：
mysql -uroot -p <e:\wt\workspace\backup\all.sql
如果已经登陆到数据库，还可以使用source命令导入SQL文件，具体语法如下：
use testDb;
source filename;
16.2.2 直接复制到数据库目录
16.3 数据库迁移
16.3.1 相同版本MySQL数据库之间的迁移
【示例16-7】使用root用户，从一个名为host1的机器中备份所有数据库，然后，将这些数据库迁移
到名为host2的机器上，命令如下：
mysqldump -h host1 -uroot -p[password] --all-databases|mysql -h host2 -uroot -p[password]
16.3.1 不同版本MySQL数据库之间的迁移
16.3.3 不同数据库之间的迁移
http://www.ccidnet.com/product/techzt/qianyi/
16.4 表的导出和导入
16.4.1 使用SELECT...INTO OUTFILE导出文本文件
【示例16-8】使用SELECT...INTO OUTFILE将test数据库中的test_1表中的记录导出到文本文件，步骤如下：
1.
USE test;
SELECT * FROM test_1;
2.
SELECT * FROM test_1 INTO OUTFILE "e:\\wt\\workspace\\backup\\test1.txt";
3.查看mysql导出目录权限限制
SHOW GLOBAL VARIABLES LIKE '%secure%';
4.设置MySQL的secure_file_priv的值
在my.ini文件中添加下列语句
secure_file_priv=
5.重启mysql，查看secure_file_priv的值
net stop mysql
net start mysql
SHOW GLOBAL VARIABLES LIKE '%secure%';
6.
SELECT * FROM test_1 INTO OUTFILE "e:\\wt\\workspace\\backup\\test1.txt";
7.
查看test1.txt文件
16.4.2 使用mysqldump命令导出文本文件
【示例16-9】使用mysqldump将test数据库中的test_1表导出到文本文件，步骤如下：
1.USE test;
SELCT * FROM test_1;
2.
mysqldump -uroot -p -T e:\wt\workspace\backup\ test test_1
3.
查看test_1.sql文件
4.
查看test_1.txt文件
【示例16-10】使用MySQLdump将company数据库中的t_developer表导出到文本文件中，使用
FIELDS选项，要求字段之间用逗号“,”间隔，所有字符类型数据用双引号括起来，步骤如下：
1.
SELECT * FROM t_developer;
2.
mysqldump -uroot -p -T e:\wt\workspace\backup\ company t_developer --fields-terminated-by=, --fields-optionally-enclosed-by=\"
3.
查看t_developer.sql文件
4.
查看t_developer.txt文件
16.4.3 使用MySQL命令导出文本文件
使用MYSQL导出数据文本文件语句的基本格式如下：
mysql -uroot -p -exexute="SELECT语句" dbname>filename.txt
【示例16-11】使用MySQL语句，导出company数据库中t_developer表中记录到文本文件，步骤如下：
1.
mysql -uroot -p --execute="SELECT * FROM t_developer;" company>e:\wt\workspace\backup\t_developer_1.txt
2.查看t_developer_1.txt文件
【示例16-12】使用MySQL语句，导出company数据库中t_developer表中记录到文本文件，使用--veritcal参数。
1.
mysql -uroot -p --vertical --execute="SELECT * FROM t_developer;" company>e:\wt\workspace\backup\t_developer_1.tx
2.查看t_developer_1.txt文件
【示例16-13】导出company数据库中t_developer表中的记录到html文件，步骤如下：
1.
mysql -uroot -p --html --execute="SELECT * FROM t_developer;" company>e:\wt\workspace\backup\t_developer_2.html
2.
在浏览器中打开t_developer_2.html
【示例16-14】导出company数据库中t_developer表中的记录到xml文件，步骤如下：
1.
mysql -uroot -p --xml --execute="SELECT * FROM t_developer;" company>e:\wt\workspace\backup\t_developer_3.xml
2.
在浏览器中打开t_developer_3.xml
16.4.4 使用LOAD DATA INFILE方式导入文本文件
【示例16-15】使用LOAD DATA命令将e:\wt\workspace\backup\t_developer0.txt
文件中的数据导入到company数据库中的t_developer表，具体步骤如下：
1.
SELECT * FROM company.t_developer INTO OUTFILE 'e:\\wt\\workspace\\backup\\t_developer0.txt';
2.
查看t_developer0.txt中的内容
3.
DELETE FROM company.t_developer;
SELECT * FROM t_developer;
4.
LOAD DATA INFILE 'e:\\wt\\workspace\\backup\\t_developer0.txt' INTO TABLE company.t_developer;
5.
SELECT * FROM t_developer;
【示例16-16】使用LOAD DATA命令将e:\wt\workspace\backup\t_developer1.txt
文件中的数据导入到company数据库中的t_developer表，使用FIELDS选项，要求字段之间用逗号“,”间隔，
所有字符类型数据用双引号括起来具体步骤如下：
1.
USE company;
2.
SELECT * FROM t_developer;
3.
SELECT * FROM company.t_developer
INTO OUTFILE 'e:\\wt\\workspace\\backup\\t_developer1.txt'
FIELDS
TERMINATED BY ','
ENCLOSED BY '\"';
4.
查看t_developer1.txt中的内容
5.
DELETE FROM company.t_developer;
6.
LOAD DATA INFILE 'e:\\wt\\workspace\\backup\\t_developer1.txt'
INTO TABLE company.t_developer
FIELDS
TERMINATED BY ','
ENCLOSED BY '\"';
7.
SELECT * FROM company.t_developer;
16.4.5 使用mysqlimport方式导入文本文件
【示例16-17】】使用myimport命令将e:\wt\workspace\backup\t_developer.txt
文件中的数据导入到company数据库中的t_developer表，使用FIELDS选项，要求字段之间用逗号“,”间隔，
所有字符类型数据用双引号括起来具体步骤如下：
1.查看t_develop.txt中的内容
2.DELETE FROM company.t_developer;
3.
mysqlimport -uroot -p company e:\wt\workspace\backup\t_developer.txt --fields-terminated-by=, --fields-optionally-enclosed-by=\"
4.
SELECT * FROM company.t_developer;
16.5 综合示例---数据的备份与恢复
-- 按操作完成对数据库school的备份和恢复
步骤一：使用MySQLdump将t_student表备份到e:\wt\workspace\backup\t_student.sql中；
创建数据库school，表t_class和表t_student并向其中插入数据，由于前面已创建，继续延用。
mysqldump -uroot -p school t_student>e:\wt\workspace\backup\t_student.sql
步骤二：使用MySQL命令将t_student中的数据恢复到t_student表。为验证其正确性，先删除，恢复后再查看。
DROP TABLE t_student;
SELECT * FROM t_student;
source e:\\wt\\workspace\\backup\\t_student.sql
SELECT * FROM t_student;
步骤三：使用SELECT...INTO OUTFILE语句导出t_class表中的记录，导出到e:\\wt\\workspace\\backup\\t_class.txt
SELECT * FROM t_class INTO OUTFILE "e:\\wt\\workspace\\backup\\t_class.txt";
步骤四：
DELETE FROM t_class;
SELECT * FROM t_class;
LOAD DATA INFILE 'e:\\wt\\workspace\\backup\\t_class.txt' INTO TABLE t_class;
SELECT * FROM t_class;
步骤五：使用MySQL命令将t_student表的记录导出到e:\wt\workspace\backup\t_student.html中
mysql -uroot -p --html --execute="SELECT * FROM t_student;" school>e:\wt\workspace\backup\t_student.html
16.6 经典习题与面试题
1.经典习题
(1)
mysqldump -uroot -p --all-databases>e:\wt\workspace\backup\all.sql
DROP DATABASE school_lx;
DROP DATABASE school_dml;
DROP DATABASE school_8;
mysql -uroot -p <e:\wt\workspace\backup\all.sql
(2)
mysqldump -uroot -p school t_class t_student >e:\wt\workspace\backup\t_class_student.sql
USE school;
DROP TABLE t_class;
DROP TABLE t_student;
mysql -uroot -p school<e:\wt\workspace\backup\t_class_student.sql
(3)
USE school;
SELECT * FROM t_class INTO OUTFILE "E:\\wt\\workspace\\backup\\t_class.txt";
DELETE FROM t_class;
SELECT * FROM t_class;
(4)
USE school;
LOAD DATA INFILE "E:\\wt\\workspace\\backup\\t_class.txt" INTO TABLE t_class;
SELECT * FROM t_class;
(5)
mysql -uroot -p --xml --execute="SELECT * FROM t_class;" school>e:\wt\workspace\backup\t_class.xml
2.面试题及解答
(1)mysqldump备份的文件只能在MySQL中使用吗？
    可对其内容修改以实现不同数据库之间的迁移。
(2)如何选择备份数据库的方法？
    根据数据库表存储引擎的不同，备份表的方法也不一样。对于MyISAM类型的表，可直接复制MySQL文件，
mysqldump最安全，即适用MyISAM类型的表，也适合InnoDB类型的表。
(3)使用mysqldump备份整个数据库成功，把表和库都删除后，使用备份文件却不能恢复数据库？
    mysqldump备份命令是否加了--databases选项或--all-databases，否则备份文件不包括创建
数据库信息。
16.7 本章小结
    本章介绍了备份数据库、恢复数据库、数据库迁移、导出表和导入表的内容。
备份数据库量本章的重点。在实际应用中，通常使用mysqldump命令备份数据库，
作用MySQL命令恢复数据库。数据库迁移、导出导入表是本章的难点。需多练习。下一章讲MySQL
日志的作用和使用。
