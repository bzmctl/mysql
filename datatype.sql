/*---------整数类型----------------------*/
USE school;
CREATE TABLE int_example(
	int_value INTEGER);

INSERT INTO int_example VALUES 
(0),
(-3),
(6.1),
(2147483647),
(-2147483648);

SELECT int_value FROM int_example;
INSERT INTO int_example VALUES
(2147483648);/*错误代码： 1264 Out of range value for column 'int_value' at row 1*/
UPDATE int_example SET int_value=-2147483648 WHERE int_value=-2147473648;

/*------------浮点和定点数类型---------------------------*/
CREATE TABLE fdd(
	a FLOAT(30,29),
	b DOUBLE(30,29),
	c DECIMAL(30,29)
);
INSERT INTO fdd VALUES(
0.00000000000000000000000000001,
0.00000000000000000000000000001,
0.00000000000000000000000000001
);
INSERT INTO fdd VALUES(
1.11111111111111111111111111111,
1.11111111111111111111111111111,
1.11111111111111111111111111111
);
SELECT a,b,c FROM fdd;

/*-------------------日期与时间类型-----------------------------*/
CREATE TABLE dt_example(
	e_date DATE,
	e_datetime DATETIME,
	e_timestamp TIMESTAMP,
	e_time TIME,
	e_year YEAR
);
INSERT INTO dt_example VALUES
(CURDATE(),NOW(),NOW(),TIME(NOW()),YEAR(NOW()));
SELECT * FROM dt_example;

/*--------------------字符串类型-----------------------*/
CREATE TABLE string_example(
	id TINYINT,
	num VARCHAR(100),
	content MEDIUMBLOB
)DEFAULT CHARACTER SET utf8;
INSERT INTO string_example VALUES
(2,'我的照片','C:\\Users\\wt\\Pictures\\Fri Oct 12 23-04-24.bmp');
SELECT id,num,content FROM string_example;
UPDATE string_example SET content=NULL WHERE id=1;

/*-------------枚举和集合类型---------------------*/
CREATE TABLE enum_set(
	gender ENUM('男','女'),
	hobby SET('看书','打球','跑步')
)DEFAULT CHARACTER SET utf8;
SHOW TABLES;
ALTER TABLE enum_set ADD id TINYINT NOT NULL PRIMARY KEY AUTO_INCREMENT FIRST;
ALTER TABLE enum_set ADD NAME VARCHAR(30) NOT NULL AFTER id;
INSERT INTO enum_set(NAME,gender,hobby) VALUES ('Tony','男','看书,跑步');
INSERT INTO enum_set(NAME,gender,hobby) VALUES ('Marry','女','打球,看书,跑步');
SELECT * FROM enum_set;
