/****************************第九章***************************/

/*9.1 关系数据操作

并（UNION）
笛卡尔积（CARTESIAN PRODUCT）
9.1.1 并（UNION）
“并”就是把具有相同字段数目和字段类型的表合并到一起。
9.1.2 笛卡儿积（CARTESIAN PRODUCT）
笛卡儿积就是没有连接条件表关系返回的结果。*/

/*9.2 内连接查询

在MySQL中可以通过两种语法来实现连接查询：一种是在FROM语句后通过逗号
区分多个表，在WHERE子句中通过逻辑表达式来实现匹配条件，从而实现表的连

接。另一种是ANSI连接语法形式，在FROM子句中使用JOIN...ON关键字，而连接

条写在关键字ON子句中。推荐使用ANSI形式的连接。
SELECT field1,...,fieldn FROM tablename1 INNER JOIN tablename2 [INNER

JOIN tablenamen] ON CONDITION
MySQL取别名机制：
SELECT field1,...,fieldn [AS] otherfieldn
FROM tablename1 [AS] othertablename1,...,
tablenamen [AS] othertablenamen
按匹配情况内连接分如下三类：
自连接，
等值连接，
不等连接。*/
/*9.2.1 自连接 表与其自身连接*/
/*查询Alicia Florric 所在班级的学生*/
USE school;
CREATE TABLE t9_student(
stuid INT(10) DEFAULT NULL,
name VARCHAR(20) DEFAULT NULL,
gender VARCHAR(10) DEFAULT NULL,
age INT(4) DEFAULT NULL,
classno INT(11) DEFAULT NULL)DEFAULT CHARACTER SET UTF8 ENGINE=INNODB;
INSERT INTO t9_student(stuid,name,gender,age,classno)
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
SELECT * FROM t9_student;
SELECT ts.name,ts.classno FROM t9_student AS ts,t9_student AS ts1
WHERE ts.classno=ts1.classno AND ts1.name='Alicia Florric';
/*9.2.2 等值连接 内连接查询中的等值连接，就是在ON关键字后的匹配条件中
通过等于关系运算符（=）来实现等值条件。*/
/*示例，执行SQL语句INNER JOIN ... ON ，在数据库school中，查询每个学生

的编号，姓名，性别，年龄，班级号，班级名称，班级地址，班主任信息。*/
USE school;
CREATE TABLE t9_class(
classno VARCHAR(11) DEFAULT NULL,
cname VARCHAR(20) DEFAULT NULL,
loc VARCHAR(40) DEFAULT NULL,
advisor VARCHAR(20) DEFAULT NULL)DEFAULT CHARACTER SET UTF8
ENGINE=INNODB;
INSERT INTO t9_class(classno,cname,loc,advisor) VALUES
(1,'class_1','loc_1','advisor_1'),
(2,'class_2','loc_2','advisor_2'),
(3,'class_3','loc_3','advisor_3'),
(4,'class_4','loc_4','advisor_4');
SELECT s.stuid,s.name,s.gender,s.age,s.classno,c.cname,c.loc,c.advisor
FROM t9_student s INNER JOIN t9_class c ON s.classno=c.classno;
/*示例：在数据库school中，查询每个学生的编号，姓名，性别，年龄，班级号，
班级名称，班级地址，班主任，成绩总分信息。*/
USE school;
CREATE TABLE t9_score(
stuid INT(11),
Chinese INT(4),
English INT(4),
Math INT(4),
Chemistry INT(4),
Physics INT(4));
INSERT INTO t9_score(stuid,Chinese,English,Math,Chemistry,Physics)
VALUES
(1001,90,89,92,83,80),
(1002,92,98,92,93,90),
(1003,79,78,82,83,89),
(1004,89,92,91,92,89),
(1005,92,95,91,96,97),
(1006,90,91,92,94,92),
(1007,91,90,83,88,93),
(1008,90,81,84,86,98),
(1009,91,84,85,86,93),
(1010,88,81,82,84,99);
SELECT s.stuid,s.name,s.gender,s.age,s.classno,c.cname,c.loc,c.advisor,
sc.Chinese+sc.English+sc.Math+sc.Chemistry+sc.Physics total
FROM t9_student s INNER JOIN t9_class c ON s.classno=c.classno
INNER JOIN t9_score sc ON s.stuid=sc.stuid;
/*9.2.3 不等连接*/
/*内查询中的不等连接就是在关键字ON后的匹配条件中除了等于关系运算符来实

现不等条件外，可以使用的关系运算符包含>,>=,<,<=,!=等运算符*/
/*查询和学生“Alicia Florric”不在同一个班级且年龄大于“Alicia

Florric”的学生编号，姓名，性别，年龄，班级号，
班级名称，班级地址，班主任，成绩总分信息*/
SELECT
s.stuid,s.name,s.gender,s.age,s.classno,c.cname,c.loc,c.advisor,
sc.Chinese+sc.English+sc.Math+sc.Chemistry+sc.Physics total
FROM t9_student s INNER JOIN t9_student s1 ON s.classno!=s1.classno
AND s.age>s1.age AND s1.name='Alicia Florric'
INNER JOIN t9_class c ON s.classno=c.classno
INNER JOIN t9_score sc ON s.stuid=sc.stuid;

/*9.3 外连接查询*/

/*在MySQL中外连接查询会返回所操作表中至少一个表的所有数据。
语法：
SELECT field1,...,fieldn FROM tablename LEFT|RIGHT|FULL [OUTER] JOIN
tablename1 ON CONDITION*/
/*9.3.1 左外连接*/
/*示例：在数据库school中，查询所有学生的学号，姓名，班级编号，班级名，
班级地址，班主任信息*/
INSERT INTO t9_student(stuid,name,gender,age,classno) VALUES
(1011,'Maia Rindell','Female',33,5);
SELECT s.stuid,s.name,s.classno,c.cname,c.loc,c.advisor
FROM t9_student s LEFT JOIN t9_class c ON s.classno=c.classno;
/*9.3.2 右外连接*/
/*示例：查询所有班级的所有学生信息*/
INSERT INTO t9_class(classno,cname,loc,advisor)
VALUES(6,'class_6','loc_6','advisor_6');
SELECT s.stuid,s.name,s.gender,s.age,c.classno,c.cname,c.loc,c.advisor
FROM t9_student s RIGHT OUTER JOIN t9_class c ON s.classno=c.classno;

/*mysql默认不支持FULL JOIN，可使用UNION来实现*/

/*9.4 复合条件连接查询*/

/*复合条件连接查询是在连接查询的过程中，通过添加过滤条件限制查询的结果，
使查询结果更加准确。
*/
/*示例：查询所有成绩总分超过450分的学生的编号，姓名，性别，年龄，班级

号，班级名称，班级位置，班主任，成绩总分。*/
USE school;
SELECT s.stuid,s.name,s.gender,s.age,s.classno,c.cname,c.loc,c.advisor,
sc.Chinese+sc.English+sc.Math+sc.Chemistry+sc.Physics total
FROM t9_student s INNER JOIN t9_class c ON s.classno=c.classno
INNER JOIN t9_score sc ON s.stuid=sc.stuid AND
sc.Chinese+sc.English+sc.Math+sc.Chemistry+sc.Physics>450;

SELECT s.stuid,s.name,s.gender,s.age,s.classno,c.cname,c.loc,c.advisor,
sc.Chinese+sc.English+sc.Math+sc.Chemistry+sc.Physics total
FROM t9_student s INNER JOIN t9_class c ON s.classno=c.classno
INNER JOIN t9_score sc ON s.stuid=sc.stuid ORDER BY
sc.Chinese+sc.English+sc.Math+sc.Chemistry+sc.Physics;

/*
9.5 合并查询数据记录*/

/*在MySQL中通过关键字UNION来实现并操作，即可以通过其将多个SELECT语句的

查结果合并到一起组成新的关系。语法如下：
SELECT field1,field2,...,fieldn FROM tablename1
UNION | UNION ALL
SELECT field1,field2,...,fieldn FROM tablename2
UNION | UNION ALL
SELECT field1,field2,...,fieldn FROM tablenamen
...
*/
/*9.5.1 带有关键字UNION的并操作*/
/*示例：在数据库company中，合并开发部门人员和测试部门人员信息*/
CREATE DATABASE company DEFAULT CHARACTER SET UTF8;
USE company;
CREATE TABLE t_developer(
id INT(4),
name VARCHAR(20),
gender VARCHAR(6),
age INT(4),
salary INT(6),
deptno INT(4)
);
DESCRIBE t_developer;
INSERT INTO t_developer(id,name,gender,age,salary,deptno)
VALUES(1001,'Alicia Florric','Female',33,10000,1),
(1002,'Kalinda Sharma','Female',31,9000,1),
(1003,'Cary Agos','Male',27,8000,1),
(1004,'Eli Gold','Male',44,20000,1),
(1005,'Peter Florric','Male',34,30000,1);
CREATE TABLE t_tester(
id INT(4),
name VARCHAR(20),
gender VARCHAR(6),
age INT(4),
salary INT(6),
deptno INT(4)
);
DESCRIBE t_tester;
INSERT INTO t_tester(id,name,gender,age,salary,deptno)
VALUES(1006,'Diane Lockhart','Female',43,50000,2),
(1007,'Maia Rindell','Female',27,9000,2),
(1008,'Will Gardner','Male',36,9000,2),
(1009,'Jacquiline Florric','Female',57,7000,2),
(1010,'Zach Florric','Male',17,5000,2),
(1002,'Kalinda Sharma','Female',31,9000,1);
/*UNION同时会去除重复数据*/
SELECT * FROM t_developer UNION SELECT * FROM t_tester;
/*9.5.2 带有关键字UNION ALL的并操作*/
SELECT * FROM t_developer UNION ALL SELECT * FROM t_tester;
/*UNION ALL保留重复数据，将两张表的所有数据合并显示*/

/*9.6 子查询

子查询是将一个查询语句嵌套在另一个查询语句中，内层查询结果，可以
为外层查询语句提供查询条件。*/
/*9.6.1 为什么使用子查询
进行联表操作时会进行笛卡尔积操作，数据量大时会出现问题*/
/*9.6.2 带比较运算符的子查询*/
/*比较运算符包括=,!=,>,>=,<,<=和<>*/
/*在数据库company中，查询薪资水平为高级的员工编号，姓名，性别，年龄和
工资。*/
USE company;
CREATE TABLE t_employee(
id INT(4),
name VARCHAR(20),
gender VARCHAR(6),
age INT(4),
salary INT(6),
deptno INT(4)
);
DESCRIBE t_employee;
INSERT INTO t_employee(id,name,gender,age,salary,deptno)
VALUES
(1001,'Alicia Florric','Female',33,10000,1),
(1002,'Kalinda Shama','Female',31,9000,1),
(1003,'Cary Agos','Male',27,8000,1),
(1004,'Eli Gold','Male',44,20000,2),
(1005,'Peter Florric','Female',34,30000,2),
(1006,'Diane Lockhart','Female',43,50000,3),
(1007,'Maia Rindell','Female',43,9000,3),
(1008,'Will Gardner','Male',36,50000,3),
(1009,'Jacquiline Florric','Female',57,9000,4),
(1010,'Zach Florric','Female',17,5000,5),
(1011,'Grace Florric','Female',14,4000,5);
SELECT * FROM t_employee;
CREATE TABLE t_slevel(
id INT(4),
salary INT(6),
level INT(4),
description VARCHAR(20)
);
INSERT INTO t_slevel(id,salary,level,description)
VALUES(1,3000,1,'初级'),
(2,7000,2,'中级'),
(3,10000,3,'高级'),
(4,20000,4,'特级'),
(5,30000,5,'高管');
SELECT * FROM t_slevel;
SELECT * FROM t_employee
WHERE salary>=(SELECT salary FROM t_slevel WHERE level=3)
AND salary<(SELECT salary FROM t_slevel WHERE level=4);
/*查询哪些部门没有33岁的员工*/
CREATE TABLE t_dept(
deptno INT(4),
deptname VARCHAR(20),
product VARCHAR(20),
location VARCHAR(20)
);
INSERT INTO t_dept(deptno,deptname,product,location)
VALUES
(1,'develop department','pivot_gaea','west_3'),
(2,'test department','sky_start','east_4'),
(3,'operate department','cloud_4','south_4'),
(4,'maintain department','fly_4','north_5');
SELECT * FROM t_dept WHERE deptno !=
(SELECT deptno FROM t_employee WHERE age=33);
/*9.6.3 带关键字IN的查询*/
/*查询数据库company中员工表t_employee的数据记录，这些记录的字段deptno

必须在t_dept中出现过
*/
SELECT * FROM t_employee WHERE deptno IN
(SELECT deptno FROM t_dept);
/*查询数据库company中员工表t_employee的数据记录，这些记录的字段deptno
必须在t_dept中没有出现过
*/
SELECT * FROM t_employee WHERE deptno NOT IN
(SELECT deptno FROM t_dept);
/*9.6.4 带关键字EXISTS的子查询*/
/*EXISTS表示存在，当子查询返回行大于0行时，EXISTS的结果为TRUE，此时执

行外层查询，返回行为空时，EXISTS结果为false，外层查询不执行*/
/*示例：查询数据库company的表t_dept中存在deptno为4的部门则执行查询
t_employee表中记录信息
*/
USE company;
SELECT * FROM t_employee
WHERE EXISTS(SELECT deptname FROM t_dept WHERE deptno=4);
/*示例：查询数据库company的表t_dept中存在deptno为4的部门则执行查询
t_employee表中年龄大于40的记录信息。
*/
SELECT * FROM t_employee WHERE age>40
AND EXISTS(SELECT deptname FROM t_dept WHERE deptno=4);
/*9.6.5 带关键字ANY的查询*/
/*关键字ANY表示满足其中任一条件。使用关键字ANY时，只要满足内层查询语句
返回结果中的任何一个，就可以通过条件执行外层查询。*/
/*示例：查询数据库school表t9_student中哪些学生可以获得奖学金，成绩信息

在t9_score表中，奖学金信息在t9_scholarship中*/
USE school;
CREATE TABLE t9_scholarship(
id INT(4),
score INT(4),
level INT(4),
description VARCHAR(20)
);
INSERT INTO t9_scholarship(id,score,level,description)
VALUES(1,430,3,'三等奖学金'),
(2,440,2,'二等奖学金'),
(3,450,1,'一等奖学金');
SELECT st.stuid,st.name,sc.Chinese+sc.English+sc.Math+sc.Chemistry+sc.Physics total
FROM t9_student st INNER JOIN t9_score sc
ON st.stuid=sc.stuid AND st.stuid
IN(
SELECT stuid FROM t9_score WHERE Chinese+English+Math+Chemistry+Physics>=ANY(SELECT score FROM t9_scholarship)
);
/*9.6.6 带关键字ALL的查询*/
/*关键字ALL表示满足所有条件。使用ALL时，只有满足内层查询语句返回的所有
结果，才执行外层语句。*/
/*示例：查询数据库school表t9_student中哪些学生可以获得一等奖学金，成绩信息

在t9_score表中，奖学金信息在t9_scholarship中*/
SELECT st.stuid,st.name,sc.Chinese+sc.English+sc.Math+sc.Chemistry+sc.Physics total
FROM t9_student st INNER JOIN t9_score sc
ON st.stuid=sc.stuid AND st.stuid
IN(
SELECT stuid FROM t9_score WHERE Chinese+English+Math+Chemistry+Physics>=ALL(SELECT score FROM t9_scholarship)
);
/*9.7 综合示例----查询学生成绩*/
/*使用数据库school中的t_stu表和t_sco表，用连接查询方式查询所有学生ID，姓名和考试信息*/
SELECT s.id,name,c_name,grade FROM t_stu s,t_sco c WHERE s.id=c.s_id;
/*计算每个学生的总成绩*/
SELECT s.id,name,SUM(grade) FROM t_stu s,t_sco c WHERE s.id=c.s_id GROUP BY s.id;
/*计算每个学生的平均成绩*/
SELECT s.id,name,AVG(grade) FROM t_stu s,t_sco c WHERE s.id=c.s_id GROUP BY s.id;
/*查询计算机成绩低于85的学生的信息*/
SELECT * FROM t_stu WHERE id IN(SELECT s_id FROM t_sco WHERE c_name='计算机' AND grade<85);
/*查询参加中文和计算机考试的学生的信息。*/
SELECT * FROM t_stu WHERE id=ANY
(SELECT s_id FROM t_sco WHERE s_id IN(SELECT s_id FROM t_sco WHERE c_name='中文') AND c_name='计算机');
/*查询姓吴和姓王的同学的姓名，院系，考试科目和成绩*/
SELECT name,department,c_name,grade FROM t_stu s,t_sco c
WHERE (s.name LIKE '王%' OR s.name LIKE '吴%') AND s.id=c.s_id;
/*查询是天津的同学的姓名，性别，年龄，院系，考试科目和成绩。*/
SELECT NAME,sex,birthday,department,c_name,grade FROM t_stu s,t_sco c
WHERE s.address LIKE '天津%' AND s.id=c.s_id;
/*9.8 经典习题与面试题*/
/*1.经典习题
	在company数据库中创建部门表t_dept_e和员工表t_employee_e
*/
USE company;
CREATE TABLE t_dept_e(
id INT(4) NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT '部门ID',
name VARCHAR(20) COMMENT '部门名称',
function VARCHAR(20) COMMENT '部门职能',
description VARCHAR(20) COMMENT '部门描述');
CREATE TABLE t_employee_e(
id INT(4) NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT '员工ID',
name VARCHAR(20) COMMENT '员工姓名',
gender VARCHAR(20) COMMENT '性别',
age VARCHAR(20) COMMENT '年龄',
salary INT(6) COMMENT '工资',
deptid INT(4) COMMENT '部门ID');
/*(1)使用LIMIT关键字来查询工资最高的员工信息*/
INSERT INTO t_employee_e(id,name,gender,age,salary,deptid)
VALUES(1001,'Alicia Florric','Female',33,10000,1),
(1002,'Kalinda Shama','Female',31,9000,1),
(1003,'Cary Agos','Male',27,8000,1),
(1004,'Eli Gold','Male',44,20000,2),
(1005,'Peter Florric','Female',34,30000,2),
(1006,'Diane Lockhart','Female',43,50000,3),
(1007,'Maia Rindell','Female',43,9000,3),
(1008,'Will Gardner','Male',36,50000,3),
(1009,'Jacquiline Florric','Female',57,9000,4),
(1010,'Zach Florric','Female',17,5000,5),
(1011,'Grace Florric','Female',14,4000,5);
SELECT * FROM t_employee_e ORDER BY salary DESC LIMIT 1;
/*(2)计算男性员工和女性员工的平均工资*/
SELECT gender,AVG(salary) FROM t_employee_e GROUP BY gender;
/*(3)查询年龄低于35岁的员工的姓名，性别，年龄和部门名称*/
INSERT INTO t_dept_e(id,name,function,description)
VALUES(1,'develop department','pivot_gaea','west_3'),
(2,'test department','sky_start','east_4'),
(3,'operate department','cloud_4','south_4'),
(4,'maintain department','fly_4','north_5'),
(5,'algorithm department','设计算法','center');
SELECT e.name,gender,age,d.name FROM t_employee_e e
INNER JOIN t_dept_e d ON e.age<35 AND e.deptid=d.id;
/*(4)用右连接的方式查询t_dept_e表和t_employee_e表*/
INSERT INTO t_employee_e(id,name,gender,age,salary,deptid)
VALUES(1012,'Jack Wang','Male',23,90000,6);
SELECT e.id,e.name,gender,age,salary,deptid,d.name,d.function,d.description
FROM t_dept_e d RIGHT JOIN t_employee_e e ON d.id=e.deptid;
/*(5)查询名字以字母K开头的员工的姓名，性别，年龄，部门和工作地点*/
SELECT e.name,gender,age,d.name,description FROM t_employee_e e
INNER JOIN t_dept_e d ON e.deptid=d.id AND e.name REGEXP '^K';
/*(6)查询年龄小于30或者大于40岁的员工信息*/
SELECT * FROM t_employee_e WHERE age<30 OR age>40;
SELECT e.name,gender,age,`salary`,d.name,description FROM t_employee_e e
INNER JOIN t_dept_e d ON e.deptid=d.id AND (e.age<30 OR e.age>40) ORDER BY age;
/*上面两条语句的结果条数不一致，添加到疑惑中了*/
/*2.面试题及解答
（1）在WHERE 子句中必须使用圆括号吗？
（2）给表起别名有什么用？*/
/*----9.9 本章小结---------*/
/*本章从关系数据库操作中的传统运算和多表连接查询操作两方面介绍。
前者介绍了并计算，笛卡尔积运算，后者介绍了内连接和外连接查询，
其中内连接包括自连接，等值连接，不等值连接，外连接包括左外和右外连接，
同时还介绍了合并查询记录操作;对于子查询详细介绍了带比较运算符的子查询，
带关键字IN，EXISTS,ANY,ALL的子查询。*/
