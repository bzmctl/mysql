/*第十一章 视图
 视图是从一个或多个表中导出的表，是一种逻辑意义上的（虚拟存在的）表。
 视图可以使用户操作方便，而且可以保障数据库系统的安全性。

11.1 什么时候使用视图
   在操作具体表之前，有时候只需要操作部分字段，而不是全部字段；为了
   提高复杂SQL语句的复用性和表的操作的安全性，MySQL数据库管理系统提
   供了视图特性。
 视图的特点：
 （1）视图是由基本表产生的表，视图的列可以来自不同的表，是表的抽象和逻辑
   意义上建立的新关系。
 （2）视图的建立和删除不影响基本表。
 （3）对视图的更新（添加，删除，更新）直接影响基本表。
 （4）当视图来自多个基本表时，不允许添加和删除数据。
11.2 创建视图
SQL语法：
CREATE [OR REPLACE][ALGORITHM=[UNDEFINED|MERGE|TEMPTABLE]]
VIEW viewname[columnlist]
AS SELECT statement
[WITH[CASCADED|LOCAL]CHECK OPTION]
11.2.1 在单表上创建视图
示例【11-1】在数据库company中，由员工表t_employee创建出隐藏字段salary的视图
v_selectemployee。
步骤一：创建数据库company并使用它。*/
CREATE DATABASE company;
USE company;
--步骤二：创建员工表
CREATE TABLE t_employee(
  id INT(4),
  name VARCHAR(20),
  gender VARCHAR(6),
  age INT(4),
  salary INT(6),
  deptno INT(4));
--步骤三：查看视图是否创建成功
DESC t_employee;
--步骤四：向表中插入数据
INSERT INTO t_employee(id,name,gender,age,salary,deptno)
  VALUES(1001,'Alicia Florric','Female',33,10000,1),
  (1002,'Kalinda Sharma','Female',31,9000,1),
  (1003,'Cray Agos','Male',27,8000,1),
  (1004,'Eli God','Male',44,20000,2),
  (1005,'Peter Florric','Male',34,30000,2),
  (1006,'Dina Lockhart','Female',43,50000,3),
  (1007,'Maia Rindell','Female',43,9000,3),
  (1008,'Will Gardner','Male',36,50000,3),
  (1009,'Jacquiline Florric','Female',57,9000,4),
  (1010,'Zach Florric','Female',17,5000,5),
  (1011,'Grace Florric','Female',14,4000,5);
--步骤五：检察数据是否插入成功
SELECT * FROM t_employee;
--步骤六：创建v_selectemployee的视图
CREATE VIEW v_selectemployee AS
  SELECT id,name,gender,age,deptno FROM t_employee;
--步骤七：查看视图结构
DESCRIBE v_selectemployee;
--步骤八：查询视图
SELECT * FROM v_selectemployee;
--11.2.3 在多表上创建视图
--示例【11-2】在数据库company中，由t_dept表和t_employee表创建一个名为
--   v_dept_employee的视图。
--步骤一：创建数据库company
CREATE DATABASE company;
--步骤二：选择数据库company
USE company;
--步骤三：创建部门表
CREATE TABLE t_dept(
  deptno INT(4),
  deptname VARCHAR(20),
  product VARCHAR(20),
  location VARCHAR(20));
--步骤四：检查表是否创建成功
DESCRIBE t_dept;
--步骤五：向表中插入数据
INSERT INT t_dept(deptno,name,product,location)
VALUES(1,'develop department','pivot_gaea','west_3'),
(2,'test department','sky start','east_4'),
(3,'operate department','cloud_4','south_4'),
(4,'maintain department','fly_4','north_5');
--步骤六：创建v_dept_employee的视图
CREATE ALGORITHM=MERGE VIEW
  v_dept_employee(name,dept,gender,age,loc)
  AS SELECT name,deptname,gender,age,location
  FROM t_employee e,t_dept d
  WHERE e.deptno=d.deptno
  WITH LOCAL CHECK OPTION;
--步骤七：检查视图结构
DESCRIBE v_dept_employee;
--步骤八：查询视图
SELECT * FROM v_dept_employee;
/*11.2.4 通过SQLyog创建视图
示例【11-3】与示例11-1一样，由数据库company的员工表
t_employee创建出隐藏salary字段的v_selectemployee视图。
11.3 查看视图
11.3.1 使用DESCRIBE|DESC语句查看视图基本信息
语法：
DESCRIBE|DESC viewname;
示例【11-4】查看数据库company中视图v_selectemployee的设计信息。
步骤一：创建数据库、表及插入数据在11-1中已完成，本例依然沿用，不再赘述。
步骤二：选择数据库company*/
USE company;
--步骤三：执行SQL语句DESCRIBE，查看名为v_selectemployee的视图的设计信息。
DESCRIBE v_selectemployee;
--步骤四：DESC是DESCRIBE的缩写，查看视图v_selectemployee的设计信息可改写
--为如下语句。
DESC v_selectemployee;
--11.3.2 使用SHOW TABLES语句查看视图基本信息
USE company;
SHOW TABLES;
/*11.3.3 使用SHOW TABLE STATUS语句查看视图基本信息
语法：
SHOW TABLE STATUS [FROM dbname] [LIKE 'pattern'];
示例【11-5】演示SHOW TABLE STATUS语句，用来查看名为v_selectemployee
视图的详细信息。
步骤一：创建数据库、表、视图及插入数据，由于此项工作前面已经完成，继续延用。
步骤二：选择数据库*/
USE company;
--步骤三：执行SQL语句，查看数据库company中视图和表的基本信息。
SHOW TABLE STATUS FROM company \G
--步骤四：查看v_selectemployee视图的信息
SHOW TABLE STATUS FROM company LIKE 'v_selectemployee' \G
--11.3.4 使用SHOW CREATE VIEW语句查看视图定义信息
--  如果要查看视图的定义信息，可以通过SHOW CREATE VIEW语句来实现，
--语法如下：
SHOW CREATE VIEW viewname;

--示例【11-6】演示SHOW CREATE VIEW语句，用来查看名为v_selectemployee
--视图的定义信息。
--步骤一：创建数据库、表及插入数据的部分工作已经在11-1，11-2中完成，此题
--延续使用。
--步骤二：选择数据库company
USE company;
--步骤三：执行SHOW CREATE VIEW语句，查看名为v_selectemployee视图的定义信息
SHOW CREATE VIEW v_selectemployee \G
--11.3.5 在views表中查看视图详细信息
--  在MySQL中，所有视图的定义都保存在数据库information_schema中的表views
--中，查询表views可以查看数据库中所有视图的详细信息，查询的语句如下：
SELECT * FROM information_schema.views WHERE table_name='viewname' \G
--示例【11-7】通过数据库information_schema中views表查看名为
--v_selectemployee视图的定义信息。
--步骤一：选择数据库information_schema
USE information_schema;
--步骤二：查询表views中名为v_selectemployee视图的详细信息。
SELECT * FROM views WHERE table_name='v_selectemployee' \G
/*11.3.6 使用SQLyog查看视图信息
示例【11-8】在客户端软件SQLyog中，不仅可以通过在“询问”语句中运行SQL
语句来查看视图，而且可以通过菜单栏操作来查看视图的各种信息。
步骤：
（1）创建数据库、表、视图，
（2）选中视图对象，
（3）选择菜单栏中的‘工具’|‘信息’，
（4）选择以HTML格式显示视图对象。
11.4 修改视图
  修改视图是指修改数据库中存在的视图，当基本表的某些字段发生变化时，可
以通过修改视图表与基本表保持一致。MySQL中通过CREATE OR REPLACE VIEW语
句和ALTER语句来修改视图。
11.4.1 使用CREATE OR REPLACE VIEW语句修改视图
SQL语法：
CREATE [OR REPLACE][ALGORITHM={UNDEFINED|MERGE|TEMPTABLE}]
VIEW viewname[columnlist]
AS SELECT_TATEMENT
[WITH [CASCADED|LOCAL]CHECK OPTION]
修改视图语句和创建视图语句是一样的，当视图不存在时创建视图，存在则修改
视图。
示例【11-9】11-1中的视图使用一段时间后，需要把编号的字段也隐藏掉。
步骤一：创建数据库、表、视图及插入数据在11-1，11-2中已经完成，继续延用。
步骤二：选择数据库company */
USE company;
--步骤三：重建视图v_selectemployee
CREATE OR REPLACE VIEW v_selectemployee
AS SELECT name,gender,age,deptno
FROM t_employee;
--步骤四：查看视图结构
DESCRIBE v_selectemployee;
--步骤五：查询视图
SELECT * FROM v_selectemployee;
/*11.4.2 使用ALTER语句修改视图
SQL语法：
ALTER [ALGORITHM={UNDEFINED|MERGE|TEMPTABLE}]
VIEW viewname[columnlist]
AS SELECT_TATEMENT
[WITH [CASCADED|LOCAL]CHECK OPTION]
--示例【11-11】演示ALTER VIEW语句用来修改视图
--步骤一：创建数据库、表、视图及插入数据在11-1，11-2中已经完成，继续延用。
--步骤二：选择数据库company */
USE company;
--步骤三：执行ALTER VIEW语句，修改v_selectemployee。
ALTER VIEW v_selectemployee AS
  SELECT name,gender,age FROM t_employee;
--步骤四：使用SELECT语句查询视图
SELECT * FROM v_selectemployee;
--11.4.3 通过SQLyog修改视图
--  选择视图对象，单击鼠标右键选择改变视图。
--11.5 更新视图
--   更新视图是指通过视图来插入（INSERT）、更新（UPDATE）和删除（DELETE）
--表中的数据。更新视图时，都是转换到基本表来更新。只能更新有权限范围内的数据。
--11.5.1 使用SQL语句更新视图
--示例【11-12】对由t_dept创建的视图v_selectdept进行更新。
--步骤一：创建数据库、表及插入数据在11-1，11-2中已经完成，继续延用。
--步骤二：选择数据库company。
USE company;
--步骤三：查询表t_dept。
SELECT * FROM t_dept;
--步骤四：创建视图v_selectdept。
CREATE VIEW v_selectdept(name,product,loc)
AS SELECT deptname,product,location
FROM t_dept WHERE deptno=1;
--步骤五：查询视图v_selectdept。
SELECT * FROM v_selectdept;
--步骤六：更新视图v_selectdept，新的记录name为hr_department,
--product为hr_system，loc为east_10。
UPDATE v_selectdept
SET name='hr_department',product='hr_system',loc='east_10';
--步骤七：查看视图v_selectdept的记录。
SELECT * FROM v_selectdept;
--步骤八：查看部门表t_dept中的记录。
SELECT * FROM t_dept;
--结论：对视图v_selectdept的更新实际上是对t_dept的更新。
--11.5.2 更新基本表后视图自动更新
--示例【11-13】在表t_dept中插入数据，查看由表t_dept创建的视图v_selectdept
--中数据是否发生改变。
--步骤一：创建数据库、表及插入数据在11-1，11-2中已经完成，继续延用。
--步骤二：选择数据库company。
USE company;
--步骤三：查询表t_dept。
SELECT * FROM t_dept;
--步骤四：创建视图v_selectdept。
CREATE VIEW v_selectdept(name,product,loc)
AS SELECT deptname,product,location FROM t_dept;
--步骤五：查询视图v_selectdept。
SELECT * FROM v_selectdept;
--步骤六：在部门表t_dept中插入一条数据
INSERT INTO t_dept(deptno,deptname,product,location)
VALUES(5,'hr_department','hr_sys','middle_2');
--步骤七：查询部门表t_dept。
SELECT * FROM t_dept;
--步骤八：查询视图v_selectdept。
SELECT * FROM v_selectdept;
--11.5.3 删除视图中的数据
--示例【11-14】删除由部门表t_dept创建出的视图v_selectdept中的记录数据。
--步骤一：创建数据库、表、视图及插入数据在11-1，11-2，11-13中已经完成，继续延用。
--步骤二：选择数据库company。
USE company;
--步骤三：查询表t_dept。
SELECT * FROM t_dept;
--步骤四：查询视图v_selectdept。
SELECT * FROM v_selectdept;
--步骤五：使用DELETE语句删除v_selectdept视图中的记录。
DELETE FROM v_selectdept WHERE name='hr_department';
--步骤六：查询视图v_selectdept;
SELECT * FROM v_selectdept;
--步骤七：查询表t_dept;
SELECT * FROM t_dept;
--11.5.4 不能更新的视图
--（1）视图中包含SUM(),COUNT(),MAX(),和MIN()等函数。
--示例【11-15】根据部门表创建包含COUNT()函数的视图。
CREATE OR REPLACE VIEW view_1(total)
  AS SELECT COUNT(deptname)
  FROM t_dept;
SELECT * FROM view_1;
--（2）视图中包含UNION、UNION ALL、DISTINCT、GROUP BY和HAVING等关键字。
--示例【11-16】根据部门表创建包含关键字GROUP BY的视图。
CREATE VIEW view_2(deptno)
  AS SELECT deptno
    FROM t_dept GROUP BY deptno;
SELECT * FROM view_2;
--（3）常量视图。
--示例【11-17】创建带有常量的视图。
CREATE VIEW view_3 AS SELECT 'Rebecca' AS name;
select * from view_3;
--（4）视图中的SELECT中包含子查询。
--示例【11-18】创建包含子查询的视图。
CREATE VIEW view_4(name)
  AS SELECT(SELECT deptname FROM t_dept WHERE deptno=1);
SELECT * FROM view_4;
--（5）由不可更新的视图导出的视图。
--示例【11-19】创建由不可更新的视图导出的视图。
CREATE VIEW view_5 AS SELECT * FROM view_4;
SELECT * FROM view_5;
--（6）创建视图时，ALGORITHM为TEMPTABLE类型。
--示例【11-20】创建ALGORITHM为TEMPTABLE的视图
CREATE ALGORITHM=TEMPTABLE VIEW view_6
  AS SELECT * FROM t_dept;
SELECT * FROM view_6;
--（7）视图对应的表存在没有默认值的列，而且该列没有包含在视图里。
--（8）WITH[CASCADED|LOCAL]CHECK OPTION也将决定视图能否更新。
/*提示：视图虽可更新但有很多限制。
  一般将视图作为查询数据的虚拟表，而不通过视图更新数据，
  因为，如果没有考虑全面在视图中更新数据的限制，
  可能会出现更新数据失败。*/
--11.6 删除视图
--  删除视图是删除数据库中已经存在的视图。删除视图只会删除视图的定义，
--不会删除数据。在MySQL中，使用DROP VIEW语句来删除数据，但用户必须
--具有DROP权限。
--11.6.1 删除视图的语法形式
--DROP VIEW viewname1[,...,viewnamen] --viewname表示要删除视图的名称
--示例【11-21】使用DROP VIEW删除视图对象v_selectdept。
--（1）创建数据库、表、视图及插入数据在11-1、11-2、11-13中已完成，继续延用。
--（2）选择数据库。
	USE company;
--（3）查询视图v_selectdept。
	SELECT * FROM v_selectdept;
--（4）删除视图v_selectdept;
	DROP VIEW v_selectdept;
--（5）再次查询视图v_selectdept。
	SELECT * FROM v_selectdept;
--（6）一次删除多个视图。
	SELECT * FROM view_1;
	SELECT * FROM view_2;
	DROP VIEW view_1,view_2;
/*
11.6.2 通过SQLyog删除视图
  打开要删除的视图所在的数据库对象，打开视图对象，鼠标右键选中要删除的视图对象，
单击删除视图。
*/

-- 11.7 综合示例---视图应用
  根据数据库school中的t11_student,t11_score,t11_scholarship
三张表及其中数据，创建可获得奖学金的视图v_student_scholarship
和可获得所有奖学金的视图v_student_scholarship_best。
--步骤一：创建三张表并插入数据。
CREATE TABLE t11_student(
  studentId INT(4) NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT '学生ID',
  studentName VARCHAR(20) COMMENT '姓名',
  gender VARCHAR(6) COMMENT '性别',
  age INT(4) COMMENT '年龄',
  classId INT(4) COMMENT '班级号');
INSERT INTO t11_student(studentId,studentName,gender,age,classId)
VALUES(1001,'Alicia Florric','Female',33,1),
(1002,'Kalinda Sharma','Female',31,1),
(1003,'Cary Agos','Male',27,1),
(1004,'Diane Lockhart','Female',43,2),
(1005,'Eli Gold','Male',44,3),
(1006,'Peter Florric','Male',34,3),
(1007,'Will Gardner','Male',38,2),
(1008,'Jacquiline Florriok','Male',38,4),
(1009,'Zach Florriok','Male',14,4),
(1010,'Grace Florriok','Male',12,4);
CREATE TABLE t11_score(
  stuId INT(4) COMMENT '学生ID',
  Chinese INT(4) COMMENT '语文成绩',
  English INT(4) COMMENT '英语成绩',
  Maths INT(4) COMMENT '数学成绩',
  Chemistry INT(4) COMMENT '化学成绩',
  Physics INT(4) COMMENT '物理成绩');
INSERT INTO t11_score(stuId,Chinese,English,Maths,Chemistry,Physics)
VALUES(1001,90,89,92,83,80),
(1002,92,98,92,93,90),
(1003,79,78,82,83,89),
(1004,89,92,91,92,89),
(1005,92,95,91,96,97),
(1006,90,91,92,94,92),
(1007,91,90,83,88,93),
(1008,90,81,84,86,98),
(1009,91,84,85,86,93),
(1010,88,81,82,84,99);
CREATE TABLE t11_scholarship(
  id INT(4) COMMENT '编号',
  score INT(4) COMMENT '总分',
  level INT(4) COMMENT '奖学金等级',
  description VARCHAR(20) COMMENT '奖学金描述信息');
INSERT INTO t11_scholarship(id,score,level,description)
VALUES(1,430,3,'三等奖学金'),
(2,440,2,'二等奖学金'),
(3,450,1,'一等奖学金');
-- 步骤二：创建可获得奖学金的学生视图v_student_scholarship。
CREATE VIEW v_student_scholarship(id,name,total) AS
SELECT stu.studentId,stu.studentName,
sco.Chinese+sco.English+sco.Maths+sco.Chemistry+sco.Physics
FROM t11_student stu,t11_score sco WHERE stu.studentId=sco.stuId
AND sco.stuId IN
(SELECT stuId FROM t11_score WHERE Chinese+English+Maths+Chemistry+Physics>=ANY
(SELECT score FROM t11_scholarship));
SELECT * FROM v_student_scholarship;
-- 步骤三：创建可获得所有奖学金的学生视图v_student_scholarship_best。
CREATE VIEW v_student_scholarship_best(id,name,total) AS
SELECT stu.studentId,stu.studentName,
sco.Chinese+sco.English+sco.Maths+sco.Chemistry+sco.Physics
FROM t11_student stu,t11_score sco WHERE stu.studentId=sco.stuId
AND sco.stuId IN
(SELECT stuId FROM t11_score WHERE Chinese+English+Maths+Chemistry+Physics>=ALL
(SELECT score FROM t11_scholarship));
SELECT * FROM v_student_scholarship_best;
-- 删除id为1001的学生信息，再查询可获得奖学金的视图。
DELETE FROM t11_student WHERE studentId=1002;
SELECT * FROM v_student_scholarship;
SELECT * FROM v_student_scholarship_best;

-- 11.8 经典习题与面试题
/*
1.经典习题
（1）如何在一个表上创建视图？
	CREATE [OR REPLACE] [ALGORITHM={UNDIFINED|MERGE|TEMPTABLE}]
 	VIEW viewname[columnlist]
	AS SELECT STATEMENT
	[WITH[CASCADED|LOCAL]CHECK OPTION]
（2）如何在多个表上创建视图？
（3）如何更改视图？
	创建视图语句或ALTER语句
（4）如何查看视图的详细信息？
	SHOW TABLE STATUS|information_schema中views表
（5）如何更新视图的内容？
	INSERT,UPDATE,DELETE
（6）如何理解视图和基本表之间的关系？
	区别和联系
2.面试题及解答
（1）MySQL与基本表之间的区别和联系？
（2）为什么有些视图更新不了？
11.9 本章小结
  本章介绍了MySQL数据库视图的含义和作用，并讲解了视图的创建，修改和删除的方法。
创建和修改是重点。
  创建和修改视图后需查看视图结构，以验证是否正确。
  更新视图是本章难点。
*/
