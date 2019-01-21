/*---------------------------------单表查询。-------------------------*/
/*8.1 基本数据记录查询*/
/*8.1.1 查询所有字段数据*/
/*1.列出表的所有字段*/
/*步骤一：创建和选择数据库*/
CREATE DATABASE IF NOT EXISTS school_8 DEFAULT CHARSET utf8;
USE school_8;
/*步骤二：创建表，并查看创建表的信息*/
CREATE TABLE t_student(
       id INT(11) PRIMARY KEY,
       NAME VARCHAR(20),
       age INT(3),
       gender VARCHAR(8))DEFAULT CHARACTER SET utf8;
DESCRIBE t_student;
/*步骤三：向表中插入数据，再使用SELECT语句查询表中数据*/
INSERT INTO t_student(id,NAME,age,gender) VALUES
(1001,'Rebecca',16,'Female'),
(1002,'Justin',17,'Male'),
(1003,'Jim',16,'Male');
SELECT id,NAME,age,gender FROM t_student;

/*2.“*”的使用*/
/*示例*/
SELECT * FROM t_student;/*好处显而易见，缺点不灵活，字段显示顺序固定，不可改变*/

/*8.1.2 查询指定字段*/
SELECT NAME,gender,age FROM t_student;/*如果所查询字段不在表中，mysql会出现错误提示*/

/*8.1.3 避免重复数据查询*/
/*SQL语法：SELECT DISTINCT FILED1,FILED2,...,FILEDN FROM TABLENAME;*/
SELECT DISTINCT age FROM t_student;
/*8.1.4 实现数学四则运算数据查询*/
USE school_8;
CREATE TABLE s_score(
       stuid INT(11),
       NAME VARCHAR(20),
       Chinese INT(4),
       English INT(4),
       Math INT(4),
       Chemistry INT(4),
       Physics INT(4))DEFAULT CHARACTER SET utf8;
DESCRIBE s_score;
INSERT INTO s_score(stuid,NAME,Chinese,English,Math,Chemistry,Physics)
VALUES(1001,'Jack Ma',87,94,99,89,91),
(1002,'Rebecca Zhang',76,78,89,80,90),
(1003,'Justin Zhou',92,98,99,93,80);
SELECT * FROM s_score;
SELECT NAME,Chinese+English+Math+Chemistry+Physics total FROM s_score;
/*8.1.5 设置显示格式数据查询*/
/*继续使用上面的school_8数据库以及其中s_score表*/
/*MySQL中提供CANCAT()来连接字符串，从而实现设置显示数据的格式，具体语句如下：*/
SELECT 
  CONCAT(
    NAME,
    '学生的总分是：',
    Chinese + English + Math + Chemistry + Physics
  ) 
FROM
  s_score ;

/*8.2 条件数据记录查询*/
/*MySQL中，通过WHERE关键字对所查询的数据记录进行过滤，条件查询语法形式如下：
SELECT field1,field2,...,fieldn FROM tabname WHERE CONDITION;
----------CONDITION的查询条件种类：----------------------
查询条件	|	符号或关键字
----------------|--------------------------------------2
比较		|	=、>、>=、<、<=、!=、<>、!>、!<
指定范围	|	BETWEEN AND、NOT BETWEEN AND
指定集合	|	IN、NOT IN
匹配字符	|	LIKE、NOT LIKE
是否为空值	|	IS NULL、IS NOT NULL
多个查询条件	|	AND、OR	
-------------------------------------------------------	
*/
/*8.2.1 查询指定记录*/
USE school_8 ;
SELECT * FROM s_score WHERE NAME = 'Jack Ma' ;
SELECT * FROM s_score WHERE NAME = 'Shirley Xu' ; /*如果查询一条不存在
的记录 ，则查询结果为空*/
SELECT * FROM s_score WHERE Chinese>80;
/*8.2.2 带IN关键字的查询*/
/*在MySQL中提供了关键字IN，用来判断字段的数值是否在指定集合的条件查询*/
/*该关键字的语法形式：*/
SELECT field1,field2,...,fieldn FROM tablename WHERE  fieldm
IN(value1,value2,...,value3);
/*1.在集合中的数据记录查询*/
/*在数据库school_8,表s_score中继续插入7条数据*/
INSERT INTO s_score(stuid,NAME,Chinese,English,Math,Chemistry,Physics)
VALUES(1004,'Jessy Li',77,67,78,87,88),
(1005,'Lucy Wang',91,78,89,90,91),
(1006,'Lily Lv',90,88,92,93,94),
(1007,'Tom Cai',80,98,82,73,84),
(1008,'Emily Wang',89,99,78,89,91),
(1009,'Betty Ying',90,89,89,90,91),
(1010,'Jane Hu',89,98,75,94,89);
/*使用IN查询是否在指定集合中*/
SELECT NAME FROM s_score WHERE stuid IN(1001,1004,1009,1010);
/*2.不在集合中的数据记录查询*/
SELECT NAME FROM s_score WHERE stuid NOT IN(1001,1004,1009,1010);
/*3.关于集合查询的注意点*/
/*在具体使用关键字IN时，查询的集合中如果存在NULL，则不会影响查询结果，
如使用关键字NOT IN，查询的集合中如果存在NULL，则不会有任何的查询结果。
*/
SELECT NAME FROM s_score WHERE stuid IN(1001,1004,1009,NULL,1010);
SELECT NAME FROM s_score WHERE stuid NOT IN(1001,1004,1009,1010,NULL);
/*8.2.3 带BETWEEN AND关键字的查询*/
/*语法：SELECT field1,field2,...,fieldn FROM tablename WHERE fieldm
BETWEEN value1 AND value2;*/
/*BETWEEN minvalue AND maxvalue表示的是一个范围间的判断过程，这些关键
字操作符只针对数字类型。*/
/*1.符合范围的数据记录查询*/
/*示例:*/
/*步骤一：创建并选择数据库*/
CREATE DATABASE IF NOT EXISTS school_8;
USE school_8;
/*步骤二：创建表*/
CREATE TABLE IF NOT EXISTS s_score(
       stuid INT(11),
       NAME VARCHAR(30),
       Chinese INT(4),
       English INT(4),
       Math INT(4),
       Chemistry INT(4),
       Physics INT(4))DEFAULT CHARACTER SET utf8;
/*步骤三：查看数据库school中表s_score的信息*/
DESCRIBE s_score;
/*步骤四：向表s_score中插入数据*/
INSERT INTO
s_score(stuid,NAME,Chinese,English,Math,Chemistry,Physics)VALUES
(1001,'Jack Ma',87,94,99,89,91),
(1002,'Rebecca Zhang',76,78,89,80,90),
(1003,'Justin Zhou',92,98,99,93,80),
(1004,'Jessy Li',77,67,78,87,88),
(1005,'Lucy Wang',91,78,89,90,91),
(1006,'Lily Lv',90,88,92,93,94),
(1007,'Tom Cai',80,98,82,73,84),
(1008,'Emily Wang',89,99,78,89,91),
(1009,'Betty Ying',90,89,89,90,91),
(1010,'Jane Hu',89,98,75,94,89);
/*步骤五：使用BETWEEN AND查询字段Chinese在85和90之间的学生*/
SELECT NAME,Chinese FROM s_score WHERE Chinese BETWEEN 85 AND 90;/*注意：包括85和90*/
/*2.不符合范围的数据记录查询*/
SELECT NAME,Chinese FROM s_score WHERE Chinese NOT BETWEEN 85 AND 90;
/*8.2.4 带LIKE的模糊查询*/
/*语法：SELECT field1,field2,...,fieldn FROM tablename WHERE fieldm LIKE value;*/
/*
----------------------LIKE关键字支持的通配符-------------------
符号	功能描述
_	该通配符值能匹配单个字符
%	该通配符可以匹配任意长度的字符串，可以是0个字符，1个字符，甚至是多个字符
*/
/*1.带有“%”通配符的查询*/
USE school_8;
SELECT NAME FROM s_score WHERE NAME LIKE 'L%';
SELECT NAME FROM s_score WHERE NAME LIKE 'j%';
SELECT NAME FROM s_score WHERE NOT NAME LIKE 'j%';/*逻辑非运算符(NOT或!)*/
SELECT NAME FROM s_score WHERE NAME NOT LIKE 'j%';
/*2.带有“_”通配符的查询*/
SELECT NAME FROM s_score WHERE NAME LIKE '_A%';
SELECT NAME FROM s_score WHERE NOT NAME LIKE '_A%';
SELECT NAME FROM s_score WHERE NAME NOT LIKE '_A%';
/*3.使用LIKE关键字查询其他类型数据*/
SELECT NAME,English FROM s_score WHERE English LIKE '%9%';/*查询英语成绩中带9的全部学生*/
SELECT NAME FROM s_score WHERE English LIKE '%%';/*表示查询所有数据记录*/
/*8.2.5 带IS NULL空值查询*/
/*语法：SELECT field1,field2,...,fieldn FROM tablename WHERE fieldm IS NULL;
注意：在具体实现该应用时，一定要注意空值与空字符串，0的区别。*/
/*1.空值数据记录查询*/
INSERT INTO s_score(stuid,NAME) VALUES(1011,'Emma Qin'),(1012,'Charlie Yan');
SELECT NAME,Chinese FROM s_score WHERE Chinese IS NULL;
/*2.不是空值数据记录查询*/
SELECT NAME,Chinese FROM s_score WHERE Chinese IS NOT NULL;
/*8.2.6 带AND的多条件查询*/
/*语法：SELECT field1,field2,...,fieldn FROM tablename WHERE CONDITION1 AND CONDITION2 [...AND CONDITIONn];*/
USE school_8;
SELECT stuid,NAME FROM s_score WHERE stuid=1009 AND NAME='Betty Ying';
SELECT stuid,NAME,Chinese FROM s_score WHERE stuid<1008 AND NAME LIKE '%a%' AND Chinese<90;
/*8.2.7 带OR的多条件查询*/
/*语法：SELECT field1,field2,...,fieldn FROM tablename WHERE CONDITION1 OR CONDITION2 [...OR CONDITIONn];*/
SELECT stuid,NAME FROM s_score WHERE stuid=1009 OR NAME='Tom Cai';
SELECT stuid,NAME,Physics FROM s_score WHERE stuid BETWEEN 1001 AND 1008 OR NAME LIKE '%w%' OR Physics LIKE '%2%';
/*8.2.8 对查询结果排序*/
/*语法：SELECT field1,field2,...,fieldn FROM tablename ORDER BY fieldm
[ASC|DESC];*/
SELECT stuid,NAME,Chinese FROM s_score ORDER BY Chinese ASC;
SELECT stuid,NAME,Chinese FROM s_score ORDER BY Chinese DESC;
SELECT stuid,NAME,Chinese,English FROM s_score ORDER BY Chinese ASC,
English DESC;
/*8.3 统计函数和分组查询*/
/*8.3.1 MySQL支持的统计函数*/
/*MySQL中提供了5个统计函数实现统计功能，统计函数的查询语法形式如下：
SELECT function(field) FROM tablename WHERE CONDITION;*/
/*1.统计数据记录条数*/
/*COUNT()函数用来实现统计数据记录条数，可以用来确定表中记录的条数或指

定条件的记录的条数，可以通过两种方式来实现该统计函数。*/
/*
COUNT(*)使用方式：这种方式可以实现对表中记录进行统计，不管字段中是值是NULL值或非NULL值。
COUNT(field)使用方式：这种方式可以实现对指定字段的记录进行统计，在具体统计时会忽略NULL值。
*/
USE school_8;
SELECT COUNT(NAME) number FROM s_score;
SELECT COUNT(NAME) number FROM s_score WHERE Chinese>90;
/*2.统计计算平均值*/
/*统计函数AVG()首先用来实现统计计算特字段值之和，然后求得该字段的平均
值，该函数可以用来计算指定字段的平均值，与COUNT()统计函数相比，该统
计函数只有一种使用方式。
示例：*/
USE school_8;
SELECT AVG(Chinese) average FROM s_score;
/*计算特定条件下的平均值，
示例：*/
SELECT AVG(Chinese) average FROM s_score WHERE stuid<1008;
/*3.统计计算求和
统计函数SUM()用来计算指定字段值之和或符合特定条件的指定字段值之和，和
COUNT()函数相比，该统计函数也只有一种使用方式。
示例：*/
USE school_8;
SELECT SUM(Chinese) FROM s_score;
/*计算指定条件下的记录总和*/
SELECT SUM(Chinese) FROM s_score WHERE stuid<1008;
/*4.统计最大值和最小值*/
/*统计函数MAX()和MIN()用来实现统计数据计算求最大值和最小值，这些函数可

以用来计算指定字段中的最大值和最小值，或符合条件的指定字段中的最大值和

最值，与COUNT()函数相比，这些统计函数也只有一种使用方式。*/
/*示例：*/
SELECT MAX(Chinese) maxval,MIN(Chinese) minval FROM s_score;
SELECT MAX(Chinese) maxval,MIN(Chinese) minval FROM s_score WHERE
stuid BETWEEN 1003 AND 1007;
/*8.3.2 统计函数针对无数据记录的表*/
/*MySQL的统计函数，对于没有任何记录的表，COUNT()函数返回为0，其他所有函数返回NULL。*/
CREATE DATABASE IF NOT EXISTS school;
USE school;
CREATE TABLE IF NOT EXISTS s_teacher(
       tid INT(11),
       NAME VARCHAR(20),
       gender VARCHAR(8),
       age INT(4),
       SUBJECT VARCHAR(20),
       salary INT(6)
       )DEFAULT CHARACTER SET utf8;
/*使用DESCRIBE语句查看s_teacher表信息*/       
DESCRIBE s_teacher;
/*利用COUNT()函数统计教师人数*/
SELECT COUNT(*) FROM s_teacher;
/*利用AVG()函数统计教师平均工资*/
SELECT AVG(salary) FROM s_teacher;
/*利用SUM()函数统计教师工资总和*/
SELECT SUM(salary) FROM s_teacher;
/*利用MIN()和MAX()函数统计教师最低和最高工资*/
SELECT MIN(salary),MAX(salary) FROM s_teacher;

/*8.3.3 简单分组查询*/
/*MySQL通过SQL语句GROUP BY来实现分组，分组语法如下：*/
/*SELECT function() FROM tablename WHERE CONDITION GROUP BY filed;*/
/*在上述语句中，参数field表示某个字段名，通过该字段对名称为tablename的表的数据记录进行分组。*/
/*示例：*/
USE school;
INSERT INTO s_teacher(tid,NAME,gender,age,SUBJECT,salary)
VALUES(2001,'Jon Snow','Male',22,'Physical Education',8000),
(2002,'Daenerys Targaryen','Female',22,'Music Education',7500),
(2003,'甲','Male',38,'History',9000),
(2004,'乙','Male',49,'Chinese',9000),
(2005,'丙','Female',20,'English',7000),
(2006,'丁','Male',22,'Math',7000),
(2007,'戊','Male',50,'Chemistry',8500),
(2008,'己','Male',22,'Math',7000),
(2009,'庚','Female',39,'Chinese',9000),
(2010,'辛','Male',36,'Physics',8000),
(2011,'壬','Male',26,'Physics',8000),
(2012,'癸','Male',20,'English',7000);
/*检查插入是否成功*/
SELECT * FROM s_teacher;
/*对所有数据按字段subject进行分组*/
SELECT * FROM s_teacher GROUP BY SUBJECT;
/*对所有数据按字段tid进行分组*/
SELECT * FROM s_teacher GROUP BY tid;/*无实际意义*/ /*在命今行下正确*/
/*实现统计功能分组查询*/
/*在MySQL中如果只实现简单的分组查询，是没有任何实际意义的，因为关键字

GROUP BY时，默认查询出每个分组中随机的一条记录，具有很大的不确定性，一

般都建议分组关键字与统计函数一起使用。
  如果想显示每个分组中的字段，可以通过函数GROUP_CONCAT()来实现，该函数
  可以实现每个分组中的指定字段，函数的具体形式如下：
SELECT GROUP_CONCAT(filed) FROM tablename WHERE CONTIDION GROUP BY
  field;
上述语句中会显示数组中的每个字段值。*/
USE school;
SELECT SUBJECT,GROUP_CONCAT(NAME) NAME FROM s_teacher GROUP BY SUBJECT;
/*8.3.5 实现多个字段分组查询
在MySQL中使用关键字GROUP BY时,其子句除了可以是一个字段外,还可以是多个
  字段,即可以按多个字段进行分组.多个分组数据查询语法形式如下:
SELECT GROUP_CONCAT(filed),function(field) FREOM tablename WHERE
  CONDITION GROUP BY filed1,filed2,...,filedn;
上述语句中,先按照字段field1进行分组,再对每组按field2分组,依次类推.
示例:
	执行SQL语句SELECT,在数据库school表s_teacher中,首先按照性别(字
  段gender)对所有教师进行分组,然后按照年龄(字段age)对每组进行分组,同时
  显示每组中的教师名(字段name)和个数,具体步骤如下:*/
/*选择数据库*/
USE school;
/*按照gender进行分组,具体SQL语句如下:*/
SELECT gender FROM s_teacher GROUP BY gender;
/*按照gender,age进行分组*/
SELECT gender,age FROM s_teacher GROUP BY gender,age;
/*按照gender,age进行分组,同时显示每组中教师名和个数:*/
SELECT gender,age,GROUP_CONCAT(NAME) NAME,COUNT(NAME) FROM s_teacher
  GROUP BY gender,age;
/*执行结果进行解析:首先按照字段gender分为两组,然后针对每组再按照字段
  age进行分组,GROUP_CANCAT()和COUNT()显示每组中教师的名字和个数.*/
/*实现HAVING子句限定分组查询
	在MySQL中如果想实现对分组进行条件查询,决不能通过关键字WHERE来实现,
因为该关键字主要用来实现条件限制数据记录.为了解决上述问题MySQL专门提供了关键字
HAVING来实现条件限制分组数据记录.
语法:
SELECT function(filed) 
FROM tablename 
WHERE CONDITION 
GROUP BY filed1,filed2,...,filedn 
HAVING CONDITION;
在上述语句中,通过关键字HAVING来指定分组后的条件。
示例:
执行SQL语句SELECT,在数据库school的教师表s_teacher中,首先按照年龄对所有教师进行
分组,然后显示平均工资高于8000的组,具体步骤如下:
*/
USE school;
SELECT age FROM s_teacher GROUP BY age;
SELECT age,AVG(salary) average,GROUP_CONCAT(name) name,COUNT(name) number
FROM s_teacher GROUP BY age ORDER BY average ASC;
SELECT age,AVG(salary) average,GROUP_CONCAT(name) name,COUNT(name) number
FROM s_teacher GROUP BY age HAVING AVG(salary)>8000 ORDER BY average ASC ;

/*8.4 用LIMIT限制数据记录查询数量*/
/*通过条件数据查询，虽然可以查询到符合用户需求的数据记录，但是有时所查

询到的数量记太多，对于这么多数据记录，如果全部显示不符合实际需求，这时

可以通过MySQL提供的关键字LIMIT来限制查询结果的数据。具体语法如下：
SELECT filed1,filed2,...,filedn 
FROM tablename
WHERE CONDITION LIMIT OFFSET_START,ROW_COUNT;
其中参数OFFSET_START表示数据记录的起始偏移量,参数ROW_COUNT表示显示的行
数。
根据是否指定起始位置，关于限制查询结果数量语句可以分为如下两类：
不指定初始位置方式
指定初始位置方式
*/
/*
8.4.1 不指定初始位置
具体语法形式：
	LIMIT rowcount;
1.显示记录数小于查询结果
*/
USE school;
SELECT * FROM s_teacher WHERE salary>8000;
SELECT * FROM s_teacher WHERE salary>8000 LIMIT 2;
/*2.显示记录数大于查询结果*/
SELECT * FROM s_teacher WHERE salary>8000 LIMIT 6;
/*8.4.2 指定初始位置*/
USE school;
SELECT * FROM s_teacher WHERE age>22 order by salary;
SELECT * FROM s_teacher WHERE age>22 order by salary LIMIT 0,3;
SELECT * FROM s_teacher WHERE age>22 order by salary LIMIT 3,3;
/*8.5 使用正则表达式查询*/
/*8.5.1查询以特定字符或字符串开头的记录*/
/*在school.s_teacher中查询以R和Rob开头的记录*/
USE school;
SELECT * FROM s_teacher WHERE name REGEXP '^R';
SELECT * FROM s_teacher WHERE name REGEXP '^Rob';
/*8.5.2 在school.s_teacher中查询以特定字符或字符串结尾的记录*/
SELECT * FROM s_teacher WHERE name REGEXP 'k$';
SELECT * FROM s_teacher WHERE name REGEXP 'en$';
/*8.5.3 用符号“.”来替代字符串中的任意一个字符*/
SELECT * FROM s_teacher WHERE name REGEXP 'n.w';
SELECT * FROM s_teacher WHERE name REGEXP 'S..w';
/*8.5.4 使用“*”和“+”来匹配多个字符*/
SELECT * FROM s_teacher WHERE name REGEXP 'k*n';
SELECT * FROM s_teacher WHERE name REGEXP 'k+n';
/*8.5.5 匹配指定字符串*/
SELECT * FROM s_teacher WHERE name REGEXP 'Xu';
/*8.5.6 匹配指定字符串中的任意一个*/
INSERT INTO s_teacher(tid,name,gender,age,subject,salary)
values(2013,'Jack123','Male',23,'Physicas',10000),
values(2014,'123123','Male',23,'Physicas',9800);
SELECT * FROM s_teacher WHERE name REGEXP '[abc]';
/*8.5.7 匹配指定字符外的字符*/
SELECT * FROM s_teacher WHERE name REGEXP '[^a-z A-Z]';/*注意空格*/
/*8.5.8 使用{n}或{n,m}来指定字符串连续出现的次数*/
INSERT INTO s_teacher(tid,name,gender,age,subject,salary)
VALUES(2015,'wtt','Male',30,'Math',10000),
(2016,'wttt','Male',30,'Math',10000),
(2017,'wtttttt','Male',30,'Math',10000);
SELECT * FROM s_teacher WHERE name REGEXP 't{1}';
SELECT * FROM s_teacher WHERE name REGEXP 't{1,3}';
SELECT * FROM s_teacher WHERE name REGEXP 't{2,3}';

/* 8.6 -------------综合示例---查询学生成绩---------------*/
/*(1)创建学生表*/
CREATE TABLE t_stu(
id INT(10) NOT NULL UNIQUE PRIMARY KEY COMMENT '学号',
name VARCHAR(20) NOT NULL COMMENT '姓名',
sex VARCHAR(4) COMMENT '性别',
birthday YEAR COMMENT '出生年份',
department VARCHAR(30) COMMENT '院系',
address VARCHAR(50) COMMENT '家庭住址')DEFAULT CHARACTER SET UTF8 ENGINE=INNODB;
SHOW CREATE TABLE t_stu \G/*查看表详细定义*/
/*创建分数表*/
CREATE TABLE t_sco(
id INT(10) NOT NULL UNIQUE PRIMARY KEY COMMENT '编号',
s_id INT(10) NOT NULL COMMENT '学号',
c_name VARCHAR(20) COMMENT '课程名',
grade INT(10) COMMENT '分数')DEFAULT CHARACTER SET UTF8 ENGINE=INNODB;
SHOW CREATE TABLE t_sco \G/*\G后面不需要再加分号*/
/*(2)插入数据*/
INSERT INTO t_stu(id,name,sex,birthday,department,address)
VALUES(101,'吴楠','女',1999,'计算机系','山西省太原市'),
(102,'王水心','女',1998,'英语系','香港九龙'),
(103,'陈梨','女',1999,'计算机系','北京昌平区'),
(104,'段小宽','男',1996,'计算机系','天津市静海区'),
(105,'张小苗','女',1996,'英语系','湖北省武汉市'),
(106,'周婷婷','女',1997,'中文系','上海市静安区');
INSERT INTO t_sco(id,s_id,c_name,grade)
VALUES(1,101,'计算机',98),
(2,101,'中文',80),
(3,102,'计算机',88),
(4,102,'英语',96),
(5,103,'计算机',98),
(6,103,'英语',91),
(7,104,'计算机',84),
(8,104,'英语',87),
(9,105,'计算机',78),
(10,105,'英语',99),
(11,106,'计算机',79),
(12,106,'中文',99);
/*(3)查询表s_stu所有记录*/
SELECT * FROM t_stu;
/*(4)查询表s_stu第4条到第6条记录*/
SELECT * FROM t_stu LIMIT 3,3;
/*(5)从t_stu查询所有学生学号,姓名和院系的信息*/
SELECT id,name,department FROM t_stu;
/*(6)从表t_stu中查询计算机系和中文系学生的信息*/
SELECT * FROM t_stu WHERE department IN ('计算机系','中文系');
/*(7)从表t_stu中查询年龄为18~22岁的学生信息*/
SELECT id,name,sex,2018-birthday age,department,address FROM t_stu WHERE 2018-birthday BETWEEN 18 AND 22;
/*(8)从表t_stu中查询每个院系有多少人*/
SELECT department,COUNT(id) number FROM t_stu GROUP BY department;
/*(9)从表t_sco中查询每个科目的最高分*/
SELECT c_name,MAX(grade) score FROM t_sco GROUP BY c_name;

/*8.7 -------------经典习题与面试题---------------*/
/*
对8.3节s_teacher表进行如下查询。
  (1)计算s_teacher表所有教师的出生年份，并显示结果中的字段别名为birth_year。*/
SELECT name,2018-age birth_day FROM s_teacher;
/*(2)用函数MIN()查询工资最低的教师的信息。*/
SELECT * FROM s_teacher WHERE salary IN (SELECT MIN(salary) FROM s_teacher);
/*(3)计算男教师和女教师的平均工资*/
SELECT gender,AVG(salary) FROM s_teacher GROUP BY gender;
/*(4)查询年龄大于30岁且小于50岁的教师的信息*/
SELECT * FROM s_teacher WHERE age BETWEEN 30 AND 50;
/*(5)用函数GROUP_CONCAT()对所有教师按学科进行多字段分组查询*/
SELECT subject,GROUP_CONCAT(name) FROM s_teacher GROUP BY subject;
/*(6)练习正则表达式的使用*/
SELECT * FROM s_teacher WHERE name REGEXP '^w';
SELECT * FROM s_teacher WHERE name REGEXP '^w.t$';
SELECT * FROM s_teacher WHERE name REGEXP '^wt+t$';
SELECT * FROM s_teacher WHERE name REGEXP '^wt+t$';
SELECT * FROM s_teacher WHERE name REGEXP 'ar{1,3}';
