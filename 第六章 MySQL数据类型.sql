-----------第六章 MySQL数据类型--------------------
6.1 整数类型
------------------------
整数类型	字节数
TINYINT		1
SMALLINT	2
MEDIUMINT	3
INT		4
INTEGER		4
BIGINT		8
------------------------
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

6.2 浮点数类型和定点数类型
-------------------------------
类型			字节数
FLOAT			4
DOUBLE			8
DECIMAL(M,D)或DEC(M,D)	M+2
-------------------------------
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

6.3 日期与时间类型
-------------------------------
类型			字节数
YEAR			1
DATE			4
TIME			3
DATETIME		8
TIMESTAMP		4
-------------------------------
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

6.4 字符串类型
6.4.1 CHAR类型和VARCHAR类型
CHAR类型为固定长度
VARCHAR类型为可变长度
CREATE TABLE string_example(
	id TINYINT,
	num VARCHAR(100),
	content MEDIUMBLOB
)DEFAULT CHARACTER SET utf8;
INSERT INTO string_example VALUES
(2,'我的照片','C:\\Users\\wt\\Pictures\\Fri Oct 12 23-04-24.bmp');
SELECT id,num,content FROM string_example;
UPDATE string_example SET content=NULL WHERE id=1;
6.4.2 TEXT类型
包括以下类型：
-------------------------------------------------------
类型		允许长度		存储空间
TINYTEXT	0~255字节		值的长度+2个字节
TEXT		0~65535字节		值的长度+2个字节
MEDIUMTEXT	0~16777215字节		值的长度+3个字节
LONGTEXT	0~4294967295字节	值的长度+4个字节
-------------------------------------------------------
6.4.3 ENUM类型
在创建表时，ENUM类型的取值范围就以列表的形式指定了，其基本形式如下：
属性名	ENUM('值1','值2',...,'值n')
ENUM只能取列表中的一个元素，其取值列表中最多有65535个值。
如果ENUM类型加上了NOT NULL属性，其默认值为第一个元素；如果不加上NOT NULL属性，
ENUM将允许插入NULL，而且NULL为默认值。
6.4.4 SET类型
在创建表时，SET类型的取值范围就以列表的形式指定了，其基本形式如下：
属性名	SET('值1','值2',...,'值n')
这些值末尾的空格会被自动删除，SET的值可以是列表中的一个或多个元素组合。取多个元素时，
值之间用逗号隔开。SET类型的值最多由64个元素构成的组合。
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
6.5 二进制类型
类型		取值范围
BINARY(M)	字节数为M，允许长度为0~M的定长二进制字符串
VARBINARY(M)	允许长度为0~M的变长二进制字符串，字节数为值得长度加1
BIT(M)		M为二进制数据，M最大值为64
TINYBLOB	可变二进制数据，最多为255个字节
BLOB		可变二进制数据，最多（2^16-1）个字节
MEDIUMBLOB	可变二进制数据，最多（2^24-1）个字节
LONGBLOB	可变二进制数据，最多（2^32-1）个字节
6.5.1 BINARY和VARBINARY类型
基本形式：
	字符串类型(M)
6.5.2 BIT类型
基本形式：
	BIT(M)
6.5.3 BLOB类型
6.6 如何选择数据类型
1.整数类型和浮点数类型
2.浮点数类型和定点数类型
3.CHAR类型VARCHAR类型
4.时间和日期类型
5.ENUM和SET类型
6.TEXT类型和BLOB类型
6.7 经典习题与面试题
1.经典习题
（1）MySQL中小数如何表示，不同表示方法有什么不同？
  浮点数和定点数，浮点数存储的是近似值，定点数存储的是字符串，
浮点数又包括单精度浮点数和双精度浮点数；单精度占4个字节，双精度占
8个字节，双精度的精度高于单精度。
（2）BLOB和TEXT分别适合于存储什么类型的数据？
BLOB存储数据量大的二进制类型数据，TEXT存储特殊字符类型数据。它们又都可分为
TINYBLOB,BLOB,MEDIUMBLOB,LONGBLOB和和、TINYTEXT,TEXT,MEDIUMTEXT,
LONGTEXT，允许存储的长度都不相同。
（3）说明ENUM和SET类型的区别以及在什么情况下适用？
  EMUM有65535个成员，SET有64个成员，两者的取值只能在成员列表中选取。当只取一个
元素来表示字段时用ENUM，当要取多个元素表示字段时用SET。
（4）浮点数和定点数的区别是什么？
  对浮点数和定点数，当插入值的精度高于实际定义的精度时，系统会自动进行四舍五入处理，
其目的是为了使该值的精度达到要求。浮点数四舍五入时不会报警，定点数会出现警告。
  在未指定精度时，浮点数和定点数有其默认的精度。FLOAT型和DOUBLE型默认会保存实际精度。
这个精度与操作系统和硬件的精度有关。DECIMAL型默认整数位为10，小数为0，即默认为整数。
（5）DATETIME类型和TIMESTAMP类型的相同点和不同点是什么？
  都可表示时间与日期，DATETIME表示时间范围较大，若时间范围比较大，选择DATETIME类型比较合适；
TIMESTAMP类型的时间是根据时区来显示的，如果需要显示时间与时区对应该选择TIMESTAMP。
（6）如果一个字段中包含文字和图片，应该选择哪种数据类型进行存储？
	TEXT和BLOB。
（7）举例说明哪种情况下适用ENUM类型？哪种情况下使用SET类型？
	人的性别适合用ENUM，人的爱好适合用SET。
2.面试题及解答
（1）MySQL中什么类型能够存储路径？
  CHAR,VARCHAR和TEXT和字符类型都可以存储路径。注意"\"字符会被过滤。解决办法用
"/"或"\\"代替"\"。这样，MySQL就不会自动过滤路径的分隔字符，可以完整地表达路径。
（2）MySQL中如何使用布尔类型？
  BOOL和BOOLEAN类型造价于TINYINT(1)。
6.8 本章小结
  本章介绍了MySQL数据库中常见的数据类型：
  整数类型，小数类型，字符类型，时间日期类型，二进制类型。
选择数据库类型是难点，需要重点掌握。下一章将介绍MySQL运算符。
