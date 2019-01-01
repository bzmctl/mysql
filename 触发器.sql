/*----------第十三章 触发器------------*/
  触发器是MySQL数据库对象之一，是由事件（INSERT、UPDATE、DELETE）来触发某个操作。
当数据库系统执行这些事件时，就会激活触发器执行相应的操作。
  本章内容包括
    触发器的含义和作用
    如何创建触发器
    如何查看触发器
    如何删除触发器
13.1 什么时候使用触发器
  当表更改时自动作一些处理操作。
13.2 创建触发器
  触发器是特殊的存储过程。
  按照激活触发器执行的语句数目，可以将触发器分为“一个执行语句的触发器”
和“多个执行语句的触发器”。
13.2.1 创建有一条执行语句的触发器
  MySQL语法：
CREATE trigger trigger_name BEFORE/AFTER trigger_EVENT
  ON TABLE_NAME FOR EACH ROW trigger_STMT
【示例13-1】数据库company中有两个表对象，部门表t_dept和日志表t_logger,
创建触发器实现向部门表中插入记录时，就会在插入之前向t_logger表中插入当
前时间。
-- 步骤一：创建数据库company并选择数据库。
CREATE DATABASE company;
USE company;
-- 步骤二：创建部门表t_dept。
CREATE TABLE t_dept(
deptno int(4),
deptname varchar(20),
product varchar(20),
location varchar(20));
-- 步骤三：查看部门表t_dept信息。
DESC t_dept;
-- 步骤四：创建日志表t_logger。
CREATE TABLE t_logger(
lid int(11),
tablename varchar(20),
ltime datetime);
-- 步骤五：查看查看日志表t_logger信息。
DESC t_logger;
-- 步骤六：创建触发器tri_loggertime。
DELIMITER $$
CREATE TRIGGER tri_loggertime BEFORE INSERT ON t_dept
FOR EACH ROW
INSERT INTO t_logger(lid,tablename,ltime)
VALUES(NULL,'t_dept',now());
$$
DELIMITER ;
-- 步骤七：向表t_dept中插入数据。
INSERT INTO t_dept(deptno,deptname,product,location)
VALUES(1,'develop_department','cloud_sky','west_3');
-- 步骤八：检验触发器是否执行。
SELECT * FROM t_dept;
SELECT * FROM t_logger;
13.2.2 创建包含多条语句的触发器
CREATE TRIGGER trigger_name BEFORE/AFTER trigger_EVENT
  ON TABLE_NAME FOR EACH ROW
  BEGIN
  trigger_STMT
  END
【示例13-2】数据库company中有两个表对象，部门表t_dept和日志表t_logger,
创建触发器实现向部门表中插入记录时，就会在插入之后向t_logger表中插入当
前时间。
-- 步骤一：查看数据库company中表t_dept和表t_logger的信息。
DESC t_dept;
DESC t_logger;
-- 步骤二：创建触发器tri_loggertime2。
DELIMITER $$
CREATE TRIGGER tri_loggertime2 AFTER INSERT ON t_dept
FOR EACH ROW
BEGIN
  INSERT INTO t_logger(lid,tablename,ltime)values(null,'t_dept',now());
  INSERT INTO t_logger(lid,tablename,ltime)values(null,'t_dept',now());
END$$
DELIMITER ;
-- 步骤三：检验触发器tri_loggertime2。
INSERT INTO t_dept(deptno,deptname,product,location)
VALUES(2,'test_department','sky','east_4');
SELECT * FROM t_logger;
13.2.3 使用SQLyog创建触发器
13.3 查看触发器
13.3.1 通过SHOW TRIGGERS语句查看触发器。
  SHOW TRIGGERS \G
13.3.2 通过看系统表triggers实现查看触发器。
【示例13-4】查看数据库information_schema中触发器对象。
-- 步骤一：选择数据库information_schema。
-- 步骤二：查看表系统表triggers的所有记录。
SELECT * FROM TRIGGERS \G
-- 步骤三：查看指定名称的触发器对象信息。
SELECT * FROM TRIGGERS WHERE TRIGGER_NAME='tri_loggertime2' \G
13.4 删除触发器
13.4.1 通过DROP TRIGGER语句删除触发器
语法：DROP TRIGGER trigger_name;
【示例13-5】执行SQL语句DROP TRIGGER删除数据库company中触发器对象
tri_loggertime2。
-- 步骤一：选择数据库company
USE company;
-- 步骤二：查看所有触发器
SHOW TRIGGERS \G
-- 步骤三：删除名为tri_loggertime2的触发器
DROP TRIGGER tri_loggertime2;
-- 步骤四：查看所有触发器
SHOW TRIGGERS \G
13.4.2 通过工具删除触发器
13.5 综合示例---创建并使用触发器
在数据库school中有三张表，分别为班级表t_class，学生表t_student，成绩表
t_score。每向学生表中插入一条记录，与之相对应的班级人数加一，每删除学生表
中一条记录，则与之相对应的班级人数减一。成绩表中每更新一条记录都会影响学生
表中学生总分值。
以下为三张表的结构：
下面开始操作流程：
-- 步骤一：创建并使用数据库
CREATE DATABASE school;
USE school;
-- 步骤二：创建班级表并向其中插入数据
CREATE TABLE t_class(
classId int(4) NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT '班级编号',
className VARCHAR(20) COMMENT '班级名称',
location VARCHAR(40) COMMENT '班级位置',
advisor VARCHAR(20) COMMENT '班主任',
studentCount int(4) COMMENT '班级人数');
INSERT INTO t_class VALUES
(1,'class_1','loc_1','advisor_1',0),
(2,'class_2','loc_2','advisor_2',0),
(3,'class_3','loc_3','advisor_3',0);
-- 步骤三：创建学生表t_student和分数表t_score
CREATE TABLE t_student(
  studentId INT(4) NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT '学生ID',
  studentName VARCHAR(20) COMMENT '学生姓名',
  gender VARCHAR(6) COMMENT '性别',
  age INT(4) COMMENT '年龄',
  classId INT(4) COMMENT '班级号',
  totalScore INT(4) DEFAULT 0 COMMENT '学生总分'
);
CREATE TABLE t_score(
  studentId INT(4) NOT NULL,
  Chinese INT(4) DEFAULT 0,
  English INT(4) DEFAULT 0,
  Maths INT(4) DEFAULT 0
);
-- 步骤四：由于学生表中数据会影响班级表的数据,我们先创建触发器,
--体现表之间的这种关联。
DELIMITER $$
CREATE TRIGGER tri_update_studentCount BEFORE INSERT
  ON t_student FOR EACH ROW BEGIN
  UPDATE t_class SET studentCount=studentCount+1 WHERE classId=NEW.classId;
  END;
$$
DELIMITER ;
-- 步骤五：向学生表中插入数据，查看t_class表中数据的变化
INSERT INTO t_student(studentId,studentName,gender,age,classId,totalScore)
VALUES(1,'Rebecca Li','F',18,1,0),
(2,'Emily Lin','F',17,2,0),
(3,'Justin Zhou','M',18,3,0);
SELECT * FROM t_class;
-- 使用SELECT语句查询t_student和t_class
-- 步骤六：由于对成绩表的更新会影响学生表中成绩总分，我们先创建触发器体现这种关联。
DELIMITER $$
CREATE TRIGGER tri_update_score_i AFTER INSERT ON t_score FOR EACH ROW BEGIN
  UPDATE t_student SET totalScore = NEW.Chinese+NEW.English+NEW.Maths
  WHERE studentId=NEW.studentId;
  END;
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER tri_update_score_u AFTER UPDATE ON t_score FOR EACH ROW BEGIN
  UPDATE t_student SET totalScore = NEW.Chinese+NEW.English+NEW.Maths
  WHERE studentId=NEW.studentId;
  END;
$$
DELIMITER ;
-- 步骤七：向表t_score中插入一组数据，再用查询t_score表和t_student表。
INSERT INTO t_score VALUES(1,79,80,90);
SELECT * FROM t_score;
SELECT * FROM t_student;
13.6 经典习题与面试题
1.经典习题
（1）创建INSERT事件的触发器。
（2）创建UPDATE事件的触发器。
（3）创建DELETE事件的触发器。
-- 创建综合示例中当删除学生时的触发器，由于删除学生时表班级表和分数表都发生变化，
--我们创建一个触发器体现这种关联。
DELIMITER $$
CREATE TRIGGER tri_update_del_class_score AFTER DELETE ON t_student FOR
EACH ROW BEGIN
  UPDATE t_class SET studentCount=studentCount-1 WHERE classId=OLD.classId;
  DELETE FROM t_score WHERE studentId=OLD.studentId;
END;
$$
DELIMITER ;
（4）查看触发器。
（5）删除触发器。
2.面试题及解答
（1）使用触发器时，应注意哪些问题？
对于相同的表，相同的事件只能创建一个触发器。
（2）是否将不需要的触发器删除掉？
应删掉，否则影响数据的完整性。
（3）关于DELIMITER改变MySQL默认分割符的问题？
当创建多条语句的触发器时，会用到BEGIN...END的形式。每个执行语句都以分号结束。但这样会
出现问题，因为系统默认以分号作为结束符，遇到分号整个整个程序就结束了。要解决这个问题，
就需要使用DELIMITER语句改变程序的结束符号。如：DELIMITER &&。要变回分号执行DELIMITER ;
即可。
13.7 本章小结
  本章介绍了MySQL数据库对象触发器的定义和作用以及创建、查看、使用、删除触发器内容。
创建触发器是本章的重点。创建触发器后一定要查看触发器的结构。使用触发器时，触发器执行顺序为
BEFORE触发器、表操作（INSERT、UPDATE、DELETE）和AFTER触发器。创建触发器是本章难点，要结合
实际需要来设计触发器。下一章介绍事务和锁的内容。
