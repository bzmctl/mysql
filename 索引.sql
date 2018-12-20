/*----------第十章 索引------------*/
/*本章内容：
	索引的含义和特点
	索引的分类
	如何设计索引
	如何创建索引
	如何删除索引
*/
/*10.1 什么是索引
       索引是由数据库表中一列或多列组合而成，其作用是提高对表中数据的
查询速度。*/
/*10.1.1 索引的含义和特点
	 索引是创建在表上的，是对数据库表中一列或多列的值进行排序的一
种结构，所以可以提高查询速度。
	通过索引，不必读完记录的所有信息，而只是查询索引列，否则数据库
系统将读取每条记录的所有信息进行匹配。例如字典的音序表。使用索引可以很
大程度上提高数据的查询速度，有效地提高了数据库系统的性能。
	不同存储引擎定义了每个表的最大索引数和索引长度。所有存储引擎对
每个表至少支持16个索引，总索引长度至少为256字节，有些存储引擎支持更多
的索引数和更大的索引长度。索引有两种存储类型，包括B型树(BTREE)索引和哈
希(HASH)索引。InnoDB和MyISAM存储引擎支持BTREE索引，MEMOY存储引擎支持
HASH索引和BTREE索引，默认为前者。
	索引的优势和缺点：
		（1）提高检索数据的速度。对于有依赖关系子表与父表联合
查询时，可以提高查询速度；使用分组和排序子句进行数据查询时，同样可以节
省分组和排序的时间。
		（2）创建和维护索引需要时间，随数据量增加而增加；索引
占用物理空间，增加，删除和修改数据时，要动态地维护索引，因此数据维护速
度降低了。
		因此，选择使用索引时，要综合考虑索引的优点与缺点。

	注意：索引会降低数据的插入速度，数据量大时尤其明显，可
先删除索引，待数据插入完成后再添加索引。*/
/*10.1.2 索引的分类*/
/*
1.普通索引
2.唯一索引
3.全文索引
4.单列索引
5.多列索引
6.空间索引*/
/*10.1.3 索引的设计原则
为了使索引的使用效率更高，在创建索引时，必须考虑在哪些字段上创建索引以及
创建什么类型的索引。
	1.选择唯一性索引
	2.为经常需要排序，分组和联合操作的字段建立索引
	3.为常作为查询条件的字段建立索引
	4.限制索引的数目
	5.尽量使用数据量少的索引
	6.尽量使用前缀来索引
	7.删除不再使用和很少使用的索引*/
/*10.2 创建和查看索引*/
  /*创建索引是指在某个表的一个或多个列上建立一个索引，以便提高对表的访问

速。创建索引的方式有三种，分别是在创建表时创建，在已经存在的表中创建和

使ALTER TABLE语句来创建。*/

/*10.2.1 普通索引---创建表时直接创建*/
  /*所谓普通索引，就是在创建索引上不附加任何限制条件（唯一，非空等限制）
。该类型的索引可以创建在任何数据类型字段上。
  SQL语法：
  CREATE TABLE tablename(
    propname1 type1[CONSTRAINT1],
    ...
    propnamen typen[CONSTRAINTn],
    	      [UNIUQE]FULLTEXT|SPATIAL] INDEX|KEY 
              [indexname] (propname1[(length)][ASC|DESC]));
提示：参数length是可选参数，其指索引的长度，必须是字符串类型。在创建索
  引时，可以指定索引的长度，这是因为不同存储引擎定义了表的最大索引数和
  最大索引长度。*/

/*示例：10-1 在数据库school中，在表t10_class的字段classno上创建索引。
*/
/*步骤1：创建和使用数据库*/
CREATE DATABESE school;
USE school;
/*步骤2：创建表*/
CREATE TABLE t10_class(
  cno INT(4),
  cname VARCHAR(20),
  loc VARCHAR(40),
  INDEX index_cno(cno)
  );
/*步骤3：检查索引是否创建成功*/
SHOW CREATE TABLE t10_class \G
/*步骤4：检查表t10_class中的索引是否被使用*/
EXPLAIN SELECT * FROM t10_class WHERE cno=1\G

/*10.2.2 普通索引---在已经存在的表上创建*/
/*语法形式：
CREATE [UNIQUE|FULLTEXT|SPATIAL] INDEX indexname 
ON tablename (propname [(length)] [ASC|DESC]);
*/
/*示例10-2 在数据库school的表t10_class的cno字段上创建索引*/
/*步骤：1 创建数据库并选择数据库*/
CREATE DATABASE school
USE school;
/*步骤：2 创建表t10_class*/
CREATE TABLE t10_class(
  cno INT(4),
  cname VARCHAR(20),
  loc VARCHAR(40));
/*步骤：3 创建索引*/
CREATE INDEX index_cno ON t10_class(cno);
/*步骤：4 检查索引是否创建成功*/
SHOW CREATE TABLE t10_class \G

/*10.2.3 普通索引---通过ALTER TABLE语句创建*/
/*语法形式：
ALTER TABLE tablename 
ADD INDEX|KEY indexname (propname [(length)] [ASC|DESC]);*/
/*示例 10-3 使用SQL语句ALTER TABLE在数据库school中的表t10_class
的字段cno上的创建普通索引。*/
/*步骤：1 创建数据库school并使用数据库*/
CREATE DATABASE school;
USE school;
/*步骤：2 创建表t10_class*/
CREATE TABLE t10_class(
  cno INT(4),
  cname VARCHAR(20),
  loc VARCHAR(40));
/*步骤：3 通过ALTER TABLE语句在t10_class的cno字段上创建普通索引*/
ALTER TABLE t10_class ADD KEY index_cno (cno);
/*步骤：4 查看索引是否创建成功*/
SHOW CREATE TABLE t10_class \G

/*10.2.4 唯一索引---创建表时直接创建*/
/*
  唯一索引，就是在创建索引时，限制索引的值必须是唯一的。
通过该类型的索引可以更快的查询某条记录。在MySQL中，根据创建索引的方式，
可以分为自动索引和手动索引两种。
  自动索引，是指在数据库表里设置完整型约束，该表会被系统自动创建。
  手动索引，是指手动在表上创建索引。当表中的某个字段设置为主键或唯一完
整型约束时，系统会自动创建关联该字段的唯一索引。
语法形式：
CREATE TABLE tablename(
  propname1 type1 [CONSTRAINT1],
  ...
  propnamen typen [CONSTRAINTn],
  UNIQUE INDEX|KEY [indexname] (propname1 [(length)] [ASC|DESC])
);
*/
/*示例 10-4 执行SQL语句UNIQUE INDEX，在数据库school中，在班级表
t10_class的字段cno上创建唯一索引。*/
/*步骤一：创建数据库school和选择数据库school*/
CREATE DATABASE school;
USE school;
/*步骤二：创建表t10_class及在cno字段上添加唯一索引*/
CREATE TABLE t10_class(
  cno INT(4),
  cname VARCHAR(20),
  loc VARCHAR(40),
  UNIQUE INDEX index_cno(cno));
/*步骤三：检查索引是否创建成功*/
SHOW CREATE TABLE t10_class \G
/*10.2.5 唯一索引---在已经存在的表中创建*/
/*SQL语句：
CREATE UNIQUE INDEX indexname
 ON tablename (propname1 [(length)][ASC|DESC]);
*/
/*示例10-5 执行SQL语句CREATE UNIQUE INDEX，在数据库school的班级表
t10_class中创建关联字段cno的唯一索引。*/
/*步骤一：创建数据库school，并选择数据库school*/
CREATE DATABASE school;
USE school;
/*步骤二：创建表t10_class*/
CREATE TABLE t10_class(
  cno INT(4),
  cname VARCHAR(20),
  loc VARCHAR(40));
/*步骤三：执行SQL语句CREATE UNIQUE INDEX，在表t10_class中创建关联
字段cno的唯一索引对象index_cno*/
CREATE UNIQUE INDEX index_cno ON t10_class(cno);
/*步骤四：检查t10_class中索引是否创建成功*/
SHOW CREATE TABLE t10_class \G
/*10.2.6 唯一索引---通过ALTER TABLE语句创建*/
/*SQL语法：
ALTER TABLE tablename
 ADD UNIQUE INDEX|KEY indexname (propname1[(length)] [ASC|DESC]);*/
/*示例10-6 执行SQL语句ALTER TABLE，在数据库school的班级表t10_class中创
建关联字段cno的唯一索引。*/
/*步骤一：创建数据库school，使用数据库school*/
CREATE DATABASE school;
USE school;
/*步骤二：创建表t10_class*/
CREATE TABLE t10_class(
  cno INT(4),
  cname VARCHAR(20),
  loc VARCHAR(40));
/*步骤三：执行SQL语句ALTER TABLE，在表t10_class中创建关联字段cno的唯一
索对象index_cno。*/
ALTER TABLE t10_class ADD UNIQUE INDEX index_cno(cno);
/*步骤四：检查表t10_class中索引是否创建成功*/
SHOW CREATE TABLE t10_class \G
/*10.2.7 全文索引---创建表时直接创建*/
/*全文索引主要关联在数据类型为CHAR、VARCHAR、和TEXT的字段上，以便能够
更加快速地查询数据量较大的字符串类型的字段。
  MySQL全文索引只能在存储引擎为MyISAM的数据表上创建全文索引。默认情况
下，全文索引的搜索执行方式不区分大小写，如果全文索引所关联的字段为二进
制数据类型，则区分大小写的搜索方式执行。
  MySQL创建全文索引的SQL语法：
CREATE TABLE tablename(
  propname1 type1[CONSTRAINT1],
  ...
  propnamen typen[CONSTRAINTn],
FULLTEXT INDEX|KEY [indexname](propname1[(length)][ASC|DESC]);*/
/*示例10-7 执行SQL语句FULLTEXT INDEX，在数据库school中的班级表
t10_class的字段loc上创建全文索引。*/
/*步骤一：创建数据库school并使用school*/
CREATE DATABASE school;
USE school;
/*步骤二：执行SQL语句FULLTEXT INDEX，在创建表t10_class时，在字段loc上创建
全文索引*/
CREATE TABLE t10_class(
  cno INT(4),
  cname VARCHAR(20),
  loc VARCHAR(40),
  FULLTEXT INDEX index_loc(loc))ENGINE=MYISAM;
/*步骤三：检查t10_class中全文索引是否创建成功*/
SHOW CREATE TABLE t10_class \G
/*步骤四：验证表t10_class中的索引是否被使用*/
INSERT INTO t10_class VALUES(1,'c1','beijing');
EXPLAIN SELECT * FROM t10_class WHERE loc='beijing' \G
/*10.2.8 全文索引---在已经存在的表上创建*/
/*SQL语法
CREATE FULLTEXT INDEX indexname
 ON tablename (propname1[(length)][ASC|DESC]);*/
/*示例10-8执行SQL语句的INDEX，在数据库school中已经创建好的班级表
t10_class上创建关联字段loc的全文索引。 */
/*步骤一：创建及使用数据库school*/
CREATE DATABASE school;
USE school;
/*步骤二：创建表t10_class*/
CREATE TABLE t10_class(
  cno INT(4),
  cname VARCHAR(20),
  loc VARCHAR(40));
/*步骤三：执行SQL语句CREATE FULLTEXT INDEX，在表t10_class中创建关联
字段loc的全文索引对象index_loc*/
CREATE FULLTEXT INDEX ON t10_class index_loc(loc);
/*步骤三：检查t10_class中全文索引是否创建成功*/
SHOW CREATE TABLE t10_class \G
/*10.2.9 全文索引---通过ALTER TABLE语句创建*/
/*SQL语法：
ALTER TABLE tablename
  ADD FULLTEXT INDEX|KEY indexname(propname1[(length)][ASC|DESC]);*/
/*示例10-9 执行SQL语句ALTER TABLE，在数据库school中已经存在的班级表
t10_class上创建关联字段loc的全文索引。*/
/*步骤一：创建数据库school及使用数据库school*/
CREATE DATABASE school;
USE school;
/*步骤二：创建表t10_class*/
CREATE TABLE t10_class(
  cno INT(4),
  cname VARCHAR(20),
  loc VARCHAR(40));
/*步骤三：使用ALTER TABLE语句在表t10_class中创建loc字段的全文索引*/
ALTER TABLE t10_class ADD FULLTEXT INDEX index_loc(loc);
/*步骤四：使用SHOW CREATE TABLE查看创建表信息。*/
SHOW CREATE TABLE t10_class \G
