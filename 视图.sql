第十一章 视图
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
步骤一：创建数据库company并使用它。
CREATE DATABASE company;
USE company;
步骤二：创建员工表
CREATE TABLE t_employee(
  id INT(4),
  name VARCHAR(20),
  gender VARCHAR(6),
  age INT(4),
  salary INT(6),
  deptno INT(4));
步骤三：查看视图是否创建成功
DESC t_employee;
步骤四：向表中插入数据
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
步骤五：检察数据是否插入成功
SELECT * FROM t_employee;
步骤六：创建v_selectemployee的视图
CREATE VIEW v_selectemployee AS
  SELECT id,name,gender,age,deptno FROM t_employee;
步骤七：查看视图结构
DESCRIBE v_selectemployee;
步骤八：查询视图
SELECT * FROM v_selectemployee;
11.2.3 在多表上创建视图
示例【11-2】在数据库company中，由t_dept表和t_employee表创建一个名为
   v_dept_employee的视图。
步骤一：创建数据库company
CREATE DATABASE company;
步骤二：选择数据库company
USE company;
步骤三：创建部门表
CREATE TABLE t_dept(
  deptno INT(4),
  deptname VARCHAR(20),
  product VARCHAR(20),
  location VARCHAR(20));
步骤四：检查表是否创建成功
DESCRIBE t_dept;
步骤五：向表中插入数据
INSERT INT t_dept(deptno,name,product,location)
VALUES(1,'develop department','pivot_gaea','west_3'),
(2,'test department','sky start','east_4'),
(3,'operate department','cloud_4','south_4'),
(4,'maintain department','fly_4','north_5');
步骤六：创建v_dept_employee的视图
CREATE ALGORITHM=MERGE VIEW
  v_dept_employee(name,dept,gender,age,loc)
  AS SELECT name,deptname,gender,age,location
  FROM t_employee e,t_dept d
  WHERE e.deptno=d.deptno
  WITH LOCAL CHECK OPTION;
步骤七：检查视图结构
DESCRIBE v_dept_employee;
步骤八：查询视图
SELECT * FROM v_dept_employee;
11.2.4 通过SQLyog创建视图
示例【11-3】与示例11-1一样，由数据库company的员工表
t_employee创建出隐藏salary字段的v_selectemployee视图。
11.3 查看视图
11.3.1 使用DESCRIBE|DESC语句查看视图基本信息
语法：
DESCRIBE|DESC viewname;
示例【11-4】查看数据库company中视图v_selectemployee的设计信息。
步骤一：创建数据库、表及插入数据在11-1中已完成，本例依然沿用，不再赘述。
步骤二：选择数据库company
USE company;
步骤三：执行SQL语句DESCRIBE，查看名为v_selectemployee的视图的设计信息。
DESCRIBE v_selectemployee;
步骤四：DESC是DESCRIBE的缩写，查看视图v_selectemployee的设计信息可改写
为如下语句。
DESC v_selectemployee;
11.3.2 使用SHOW TABLES语句查看视图基本信息
USE company;
SHOW TABLES;
11.3.3 使用SHOW TABLE STATUS语句查看视图基本信息
语法：
SHOW TABLE STATUS [FROM dbname] [LIKE 'pattern'];
示例【11-5】演示SHOW TABLE STATUS语句，用来查看名为v_selectemployee
视图的详细信息。
步骤一：创建数据库、表、视图及插入数据，由于此项工作前面已经完成，继续延用。
步骤二：选择数据库
USE company;
步骤三：执行SQL语句，查看数据库company中视图和表的基本信息。
SHOW TABLE STATUS FROM company \G
步骤四：查看v_selectemployee视图的信息
SHOW TABLE STATUS FROM company LIKE 'v_selectemployee' \G
11.3.4 使用SHOW CREATE VIEW语句查看视图定义信息
  如果要查看视图的定义信息，可以通过SHOW CREATE VIEW语句来实现，
语法如下：
SHOW CREATE VIEW viewname;

示例【11-6】演示SHOW CREATE VIEW语句，用来查看名为v_selectemployee
视图的定义信息。
步骤一：创建数据库、表及插入数据的部分工作已经在11-1，11-2中完成，此题
延续使用。
步骤二：选择数据库company
USE company;
步骤三：执行SHOW CREATE VIEW语句，查看名为v_selectemployee视图的定义信息
SHOW CREATE VIEW v_selectemployee \G
11.3.5 在views表中查看视图详细信息
  在MySQL中，所有视图的定义都保存在数据库information_schema中的表views
中，查询表views可以查看数据库中所有视图的详细信息，查询的语句如下：
SELECT * FROM information_schema.views WHERE table_name='viewname' \G
示例【11-7】通过数据库information_schema中views表查看名为
v_selectemployee视图的定义信息。
步骤一：选择数据库information_schema
USE information_schema;
步骤二：查询表views中名为v_selectemployee视图的详细信息。
SELECT * FROM views WHERE table_name='v_selectemployee' \G
11.3.6 使用SQLyog查看视图信息
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
步骤二：选择数据库company
USE company;
步骤三：重建视图v_selectemployee
CREATE OR REPLACE VIEW v_selectemployee
AS SELECT name,gender,age,deptno
FROM t_employee;
步骤四：查看视图结构
DESCRIBE v_selectemployee;
步骤五：查询视图
SELECT * FROM v_selectemployee;
11.4.2 使用ALTER语句修改视图
SQL语法：
ALTER [ALGORITHM={UNDEFINED|MERGE|TEMPTABLE}]
VIEW viewname[columnlist]
AS SELECT_TATEMENT
[WITH [CASCADED|LOCAL]CHECK OPTION]
示例【11-11】演示ALTER VIEW语句用来修改视图
步骤一：创建数据库、表、视图及插入数据在11-1，11-2中已经完成，继续延用。
步骤二：选择数据库company
USE company;
步骤三：执行ALTER VIEW语句，修改v_selectemployee。
ALTER VIEW v_selectemployee AS
  SELECT name,gender,age FROM t_employee;
步骤四：使用SELECT语句查询视图
SELECT * FROM v_selectemployee;
11.4.3 通过SQLyog修改视图
  选择视图对象，单击鼠标右键选择改变视图。
11.5 更新视图
