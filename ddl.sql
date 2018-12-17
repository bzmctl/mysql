/*注释样本。*/
/*创建数据库*/
CREATE DATABASE school;
/*选择数据库*/
USE school;
/*创建表*/
CREATE TABLE t_class(
	classno INT,
	classname VARCHAR(20),
	loc VARCHAR(40),
	stucount INT);
/*查看表结构，DESCRIBE可简写为DESC*/
DESCRIBE t_class;
/*查看表详细定义*/
SHOW CREATE TABLE t_class \G /*在sqlyog下执行错误，在命令行下正常执行！注意，结尾用;或\g或\G结尾，建议用\G*/
/*删除表*/
DROP TABLE t_class;

/*修改表*/
/*修改表名，使用RENAME*/
ALTER TABLE t_class RENAME TO tab_class;
DESC tab_class;
/*增加字段--在表的最后一个位置增加*/
ALTER TABLE tab_class ADD advisor VARCHAR(40);
DESC tab_class;
/*增加字段--在表的第一个位置增加*/
ALTER TABLE tab_class ADD advisor_first VARCHAR(40) FIRST;
/*增加字段--在表的指定字段之后增加*/
ALTER TABLE tab_class ADD advisor_after VARCHAR(20) AFTER classname;
/*删除字段--使用DROP*/
ALTER TABLE tab_class DROP advisor;
DESC tab_class;
/*修改字段--修改数据类型*/
ALTER TABLE tab_class MODIFY classno VARCHAR(20);
/*修改字段--修改字段的名字*/
ALTER TABLE tab_class CHANGE classno classid INT;
/*修改字段--同时修改字段的名字类型*/
ALTER TABLE tab_class CHANGE classid classno VARCHAR(20);
/*修改字段--修改字段的顺序*/
ALTER TABLE tab_class MODIFY classname VARCHAR(20) FIRST;
ALTER TABLE tab_class MODIFY classname VARCHAR(20) AFTER classno; 
/*表的约束*/
USE school;
CREATE TABLE t1(
cno INT(11) NOT NULL,/*非空约束*/
cname VARCHAR(20) DEFAULT 'class_3',/*设置默认值*/
loc VARCHAR(40),
stucount INT(11)
);
DESC t1;

/*设置表字段的唯一约束*/
CREATE TABLE t2(
cno INT(11),
cname VARCHAR(20) UNIQUE,
loc VARCHAR(40),
stucount INT(11)
);
DESC t2;
SHOW INDEX FROM school.t2;
ALTER TABLE school.t2 DROP INDEX cname;/*删除唯一约束*/
ALTER TABLE school.t2 ADD UNIQUE KEY(cname);/*添加唯一约束*/


/*设置表字段的主键*/
CREATE TABLE student(
sno INT PRIMARY KEY,/*单字段主键*/
sname VARCHAR(20),
sage INT,
sgender VARCHAR(3),
);

CREATE TABLE s1(
sno INT,
sname VARCHAR(20),
sage INT,
sgender VARCHAR(3),
CONSTRAINT pk_sno PRIMARY KEY(sno)/*给主键约束设置一个名字*/
);

/*多字段主键*/
CREATE TABLE s2(
sno INT AUTO_INCREMENT,/*自动增长*/
sname VARCHAR(20),
sage INT,
sgender VARCHAR(3),
CONSTRAINT pk_sno_sname PRIMARY KEY(sno,sname)
);
DESC s2;

ALTER TABLE t1 MODIFY cno INT PRIMARY KEY;/*为t1表添加主键约束*/
DESC t1;

/*设置表字段的外键约束*/
CREATE TABLE s3(
sno INT PRIMARY KEY,
sname VARCHAR(20),
sage INT,
sgender VARCHAR(3),
scno INT,
CONSTRAINT FK_scno FOREIGN KEY(scno) REFERENCES t1(cno)
);
ALTER TABLE t1 DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;/*修改表默认字符集*/
ALTER TABLE t1 CHANGE cname cname VARCHAR(20) NOT NULL CHARACTER SET utf8 COLLATE utf8_general_ci ;/*修改字段字符集*/

/*练习，创建一个学籍数据库和学生信息表*/
CREATE DATABASE	school_lx;
USE school_lx;
CREATE TABLE student(
id INT(4) PRIMARY KEY NOT NULL UNIQUE AUTO_INCREMENT COMMENT '编号',
num INT(10) NOT NULL UNIQUE COMMENT '学号',
NAME VARCHAR(20) NOT NULL COMMENT '姓名',
gender VARCHAR(3) NOT NULL COMMENT '性别',
birthday DATETIME COMMENT '生日',
address VARCHAR(50) COMMENT '家庭住址',
grade VARCHAR(4) NOT NULL COMMENT '年级',
class VARCHAR(10) NOT NULL COMMENT '班级'
);

ALTER TABLE student MODIFY NAME VARCHAR(25) NOT NULL;
DESC student;

ALTER TABLE student MODIFY address VARCHAR(50) AFTER grade;
DESC student;

ALTER TABLE student CHANGE num stuid INT(10) NOT NULL;/*字段的唯一约束并没有消失，而注释丢失了*/
DESC student;

ALTER TABLE student ADD nationality VARCHAR(10);
DESC student;

ALTER TABLE student RENAME studentTab;
DESC studentTab;

CREATE DATABASE shop;
USE shop;
CREATE TABLE car(
id INT(4) NOT NULL PRIMARY KEY AUTO_INCREMENT,
NAME VARCHAR(50) NOT NULL,
price DOUBLE(8,2) NOT NULL,
COUNT INT(4) NOT NULL,
sum_money DOUBLE(8,2) NOT NULL
);
DESC car;

/*将name字段数据改为varchar(30)且保留非空约束*/
ALTER TABLE car MODIFY NAME VARCHAR(30) NOT NULL;

/*将sum_money字段改到count字段之前*/
ALTER TABLE car MODIFY sum_money DOUBLE(8,2) NOT NULL AFTER price;

/*将字段sum_money改为total_money*/
ALTER TABLE car CHANGE sum_money total_money DOUBLE(8,2) NOT NULL;

/*添加expiredays字段，数据类型varchar(4)，表示是否过期*/

ALTER TABLE car ADD expiredays VARCHAR(4) COMMENT '是否过期';

/*删除count字段*/
ALTER TABLE car DROP COUNT;

/*将car表的存储引擎更改为MyISAM类型*/
ALTER TABLE car ENGINE=MYISAM;
SHOW TABLE STATUS FROM shop WHERE NAME='car';/*或者SHOW CREATE TABLE car;*/

/*将car改名为shoppingCar*/
ALTER TABLE car RENAME shoppingCar;
DESC shoppingcar;
