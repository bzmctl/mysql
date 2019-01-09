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
16.2.2 直接复制到数据库目录

16.3 数据库迁移
16.3.1 相同版本MySQL数据库之间的迁移
16.3.1 不同版本MySQL数据库之间的迁移
16.3.3 不同数据库之间的迁移

16.4 表的导出和导入
16.4.1 使用SELECT...INTO OUTFILE导出文本文件
16.4.2 使用mysqldump命令导出文本文件
16.4.3 使用MySQL命令导出文本文件
16.4.4 使用LOAD DATA INFILE方式导入文本文件
16.4.5 使用mysqlimport方式导入文本文件

16.5 综合示例---数据的备份与恢复

16.6 经典习题与面试题
1.经典习题
2.面试题及解答

16.7 本章小结
