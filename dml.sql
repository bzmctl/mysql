CREATE DATABASE school_dml;
USE school_dml;
CREATE TABLE t_c(
	`cno` INT NOT NULL PRIMARY KEY,
	`cname` VARCHAR(20) NOT NULL,
	`loc` VARCHAR(50) NOT NULL,
	`advisor` VARCHAR(20) NOT NULL
	)DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ENGINE=INNODB;
	DROP TABLE t_c;

ALTER TABLE t_c DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
/*改变字段字符集与非空约束不能同时进行，分两次改变。*/
ALTER TABLE t_c CHANGE cname cname VARCHAR(20) CHARACTER SET utf8 COLLATE utf8_general_ci;
/*-------------------------插入数据记录-----------------------------------------*/
/*插入数据的完整语法*/
INSERT INTO t_c(cno,cname,loc,advisor) VALUES(1,'科教一班','一教3楼','杰克');
SELECT * FROM t_c;/*等同于SELECT cno,cname,loc,advisor FROM t_c;*/

/*当插入数据表的部分字段时，表的字段名不可省略且必须与字段值一一对应*/
CREATE TABLE t2_c(
	cno INT PRIMARY KEY AUTO_INCREMENT,
	cname VARCHAR(20) NOT NULL,
	loc VARCHAR(50) NOT NULL,
	stucount INT
	);
INSERT INTO t2_c(cname,loc) VALUES('高一8班','西教学楼4楼');
SELECT * FROM t2_c;

/*插入多条完整数据记录*/
INSERT INTO tname VALUES
('value11',...,'value1n'),
...,
('valuen1',...,'valuenn');
/*插入多条部分数据记录*//*字段需与值一一对应*/
INSERT INTO tname(file1,file2,...,filen) VALUES
('value11','value12',...,'value1n'),
...,
('valuen1','valuen2',...,'valuenn');

/*插入查询结果*/
INSERT INTO tablename(file1,file2,...,filen)
SELECT (file21,file22,...,file2n) FROM tablename2 WHERE ...
CREATE TABLE t3(
cno INT,
cname VARCHAR(20),
address VARCHAR(50),
COUNT INT
);
INSERT INTO t3 VALUES
(1,'高一8班','西教学楼4楼',80),
(2,'高二3班','东1教',90),
(3,'高三3班','北一教',100);

INSERT INTO t2_c SELECT * FROM t3;

/*-------------------更新数据记录----------------------------------------------*/
/*语法*/
UPDATE tablename SET field1=value1,field2=value2,field3=value3 WHERE CONDITION;
/*示例*/
/*更新特定字段的值*/
UPDATE t2_c SET loc='东2教',stucount=92 WHERE cno=2;
/*更新所有数据记录*/
UPDATE t2_c SET loc='更新所有符合条件的记录' WHERE cno<5;
/*-------------------删除数据记录----------------------------------------------*/
/*语法*/
DELETE FROM tablename WHERE CONDITION;
/*删除特定数据记录*/
DELETE FROM t2_c WHERE cname='高二3班';
/*删除符合条件的所有记录*/
DELETE FROM t2_c WHERE cno<4;

/*---------------------综合示例-------------*/
USE school_dml;
CREATE TABLE student(
id INT(4) NOT NULL UNIQUE AUTO_INCREMENT COMMENT '编号',
stuid INT(10) NOT NULL COMMENT '学号',
NAME VARCHAR(20) NOT NULL COMMENT '姓名',
gender VARCHAR(10) NOT NULL COMMENT '性别',
nationality VARCHAR(10) NOT NULL COMMENT '民族',
age INT(4) COMMENT '年龄',
classno INT(11) NOT NULL COMMENT '班级号',
diet VARCHAR(40) COMMENT '饮食',
CONSTRAINT p_id PRIMARY KEY(id)
);
INSERT INTO student(id,stuid,NAME,gender,nationality,age,classno,diet) VALUES
(1,10001,'Jack Ma','Male','Han',8,3,'mutton'),
(2,10002,'Justin Zhou','Male','Han',8,1,'pork'),
(3,10022,'Rebecca Li','Female','hui',9,2,'beef'),
(4,10010,'Emily Wang','Female','Han',8,2,'pork'),
(5,10030,'Jim Yan','Male','Han',7,4,'pork');
/*将Emily Wang 民族改为蒙古族(Mongolian),并将班级号改成2*/
UPDATE student SET nationality='Mongolian',classno=2 WHERE NAME='Emily Wang';
/*将民族为Han的饮食都改成猪肉*/
UPDATE student SET diet='pork' WHERE nationality='Han';
/*将民族为蒙古的饮食改为羊肉*/
UPDATE student SET diet='mutton' WHERE nationality='Mongolian';
/*删除年龄小于8岁的学生*/
DELETE FROM student WHERE age<8;

/*--------------------经典习题与面试题-----------------------------------*/
/*在shop数据库创建一个购物车表cart*/
USE shop;
CREATE TABLE cart(
id INT(4) NOT NULL AUTO_INCREMENT PRIMARY KEY COMMENT '商品ID',
NAME VARCHAR(50) NOT NULL COMMENT '商品名称',
price DOUBLE(8,2) NOT NULL COMMENT '商品价格',
COUNT INT(4) NOT NULL COMMENT '商品数量',
sum_money DOUBLE(8,2) NOT NULL COMMENT '商品总价'
)DEFAULT CHARACTER SET utf8 ENGINE=INNODB;
DROP TABLE cart;
/*1.将name字段的数据改为varchar(30)，且保留非空约束*/
ALTER TABLE cart MODIFY NAME VARCHAR(30) NOT NULL COMMENT '商品名称';
/*2.将sum_money字段该到count之前*/
ALTER TABLE cart MODIFY sum_money DOUBLE(8,2) NOT NULL COMMENT '商品总价' AFTER price;
/*3.将sum_money字段改为total_money*/
ALTER TABLE cart CHANGE sum_money total_money DOUBLE(8,2) NOT NULL COMMENT '商品总价';
/*4.在表中添加expiredays字段，数据类型为varchar(4)，表示是否过期*/
ALTER TABLE cart ADD expiredays VARCHAR(4) NOT NULL COMMENT '过期时间';
/*5.删除count字段*/
ALTER TABLE cart DROP COUNT;
/*6.将cart的存储引擎改为MyISAM*/
ALTER TABLE cart ENGINE=MYISAM;
/*7.将cart表名改为shoppingcart_2*/
ALTER TABLE cart RENAME shoppingcart_2;
DESC cart;
/***/
/**again**/
