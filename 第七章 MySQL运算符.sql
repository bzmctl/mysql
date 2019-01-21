------------------第七章 MySQL运算符-------------------
USE school;
/*------------算术运算符---------------------*/
CREATE TABLE t_student(
	id INT(11) NOT NULL PRIMARY KEY,
	NAME VARCHAR(20) NOT NULL,
	age INT(4),
	gender VARCHAR(8)
);
CREATE TABLE t_score(
	stuid INT(11),
	Chinese INT(4),
	English INT(4),
	Math INT(4),
	Chemistry INT(4),
	Physics INT(4),
CONSTRAINT fk_stuid FOREIGN KEY(stuid) REFERENCES t_student(id)
);
INSERT INTO t_student(id,NAME,age,gender) VALUES
(1,'Rebecca',16,'Female'),
(2,'Justin',17,'Male'),
(3,'Jim',16,'Male');
SELECT * FROM t_student;
INSERT INTO t_score(stuid,Chinese,English,Math,Chemistry,Physics) VALUES
(1,87,94,99,89,91),
(2,76,78,89,88,98),
(3,92,98,99,93,88);
SELECT * FROM t_score;

SELECT stu.name,
sco.Chinese,sco.English,sco.Math,sco.Chemistry,sco.Physics,
sco.Chinese+sco.English+sco.Math+sco.Chemistry+sco.Physics total
FROM t_student stu,t_score sco
WHERE stu.id=sco.stuid;

/*验证mysql中(除法/)和(取模%)操作*/
SELECT 8/0 除法操作,9 DIV 0 除法操作,4%0 求模操作,7 MOD 0 求模操作;

/*--------------------比较运算符---------------------*/
/*常用的比较运算符*/

/*执行=和<=>比较运算符的SQL语句的SELECT*/
SELECT 
3=3 数值比较,
'sky'='heaven' 字符串比较,
3*4=2*6 表达式比较,
1<=>1 数值比较,
'dragon'='dragon' 字符串比较,
2+7<=>6+3 表达式比较;

/*=和<=>比较运算符在比较字符串是否相等时，
依据字符串的ASCII码来进行判断，前者不能操作NULL(空值)，后者可以*/
SELECT NULL<=>NULL '<=>操作符效果',NULL=NULL '=操作符效果';

/*!=和<>用来比较数值，字符串，表达式是否不相等，它们都不能操作NULL(空值)*/
SELECT 2<>2 数值比较,'hello'<>'hi' 字符串比较,2+3<>0+5 表达式比较,
	6!=6 数值比较,'year'!='year' 字符串比较,7+8!=2+9 表达式比较;
SELECT NULL!=NULL 'NULL的！=效果',NULL<>NULL 'NULL的<>效果';

/*>,>=,<,<=的数值，字符串，表达式的比较*/
SELECT 1>=1 数值比较,'abcde'<'abecd' 字符串比较,1+3<=3+5 表达式比较,
1>2 数值比较,'eof'<='zoo' 字符串比较,3+5>=8+1 表达式比较;

/*----------特殊功能的比较运算符-----------------------*/
/*实现特殊功能的比较运算符包含
实现判断是否存在于指定范围的BETWEEN AND(值必须大于等于m且小于n才返回1)
实现判断是否为空的IS NULL
实现判断是否不为空的IS NOT NULL
判断是否存在指定集合的IN
实现通配符的LIKE
和实现正则表达式匹配的REGEXP
*/
SELECT 8 IS NULL,NULL IS NULL;
SELECT 8 IS NOT NULL,NULL IS NOT NULL;
SELECT 'songofice&fire' LIKE 'ice%',
	'songofice&fire' LIKE '%ice%',
	'songofice&fire' LIKE '%eci%';
SELECT 27 BETWEEN 18 AND 30,9 BETWEEN 5 AND 10;
SELECT 4 IN (3,4,5), 'a' IN ('a','b','c','d'),10 IN (7,8,9);
/*-------------------REGEXP运算符-------------------*/
/*mysql支持的模式字符
^ 匹配字符串开始部分
$ 匹配字符串结尾部分
. 匹配字符串任意一个字符
[字符集合] 匹配字符集合中的任意一个字符
[^字符集合] 匹配字符集合外的任意一个字符
str1|str2|str3 匹配字符str1,str2,str3中任意一个字符串
* 匹配字符包含0到多个
+ 匹配字符包含1个
字符串{n} 字符串出现n次
字符串{m,n} 字符串至少m次，最多n次
*/
SELECT 'onelittlefinger' REGEXP '^o',
	'onelittlefinger' REGEXP '^one';
SELECT 'goodnight' REGEXP 't$','goodnight' REGEXP 'night$';
SELECT 'goodnight' REGEXP '^g......ht$';
SELECT 'goodnight' REGEXP '[abc]' 字符中字符,
       'goodnight' REGEXP '[abcd]' 字符中字符,
       'goodnight' REGEXP '[^abc]' 字符外字符,
       'goodnight' REGEXP '[a-zA-Z]' 字符中的区间,
       'goodnight' REGEXP '[^a-zA-Z0-9]' 字符外区间;
SELECT 'goodnight' REGEXP 'b*t','goodnight' REGEXP 'b+t';
SELECT 'fivelittleducks' REGEXP 'five' 单个字符串,
       'fivelittleducks' REGEXP 'five|four|six' 多个字符串,
       'fivelittleducks' REGEXP 'six|four|seven' 多个字符串;
SELECT 'fivelittleducks' REGEXP 't{3}' 匹配3个t,
       'fivelittleducks' REGEXP 'v{2}' 匹配2个v,
       'fivelittleducks' REGEXP 'v{1,5}' 匹配至少1个至多5个,
       'fivelittleducks' REGEXP 'du{1,2}' 匹配至少1个，至多2个,
       'fivelittleducks' REGEXP 'duk{1,2}' 至少1个至多2个;
/*-----------------逻辑运算符----------------------------*/
SELECT 5 AND 6,0 AND 7,0 AND NULL,3 AND NULL, 9 && 2,0 && 12, 0 && NULL, 14 && NULL;
SELECT 5 OR 6, 0 OR 7, 0 OR 0, 3 OR NULL, 9 || 2, 0 || 12, 0 || NULL, 14 || NULL;
SELECT NOT 0,NOT 5,NOT NULL,!3,!0,!NULL;
SELECT 5 XOR 6, 0 XOR 0, NULL XOR NULL, 0 XOR 7, 0 XOR NULL, 3 XOR NULL;
/*--------------------位运算符----------------------*/
SELECT 3&6,BIN(3&6) 二进制数,3&6&7,BIN(3&6&7) 二进制数;
SELECT 3|6,BIN(3|6) 二进制数,3|6|7,BIN(3|6|7) 二进制数;
SELECT ~6,BIN(~6) 二进制数;
SELECT 6^7,BIN(6^7) 二进制数;
SELECT BIN(7) 二进制数,7<<4,BIN(7<<4) 二进制数,7>>2,BIN(7>>2) 二进制数;
/*-----------------运算符的优先级----------------*/
/*
1	！
2	~
3	^
4	*,/,DIV,%,MOD
5	+,-
6	>>,<<
7	&
8	|
9	=,<=>,<,<=,>,>=,!=,<>,IN,IS NULL,LIKE,REGEXP
10	BETWEEN AND,CASE,WHEN,THEN,ELSE
11	NOT
12	&&,AND
13	||,OR,XOR
14	:=
从上到下，优先级依次降低*/
/*-----综合示例，运算符的使用------------*/
CREATE TABLE TEST(
       NUM INT(4),
       INFO VARCHAR(100));
INSERT INTO TEST VALUES(50,'WHERE THERE IS A WILL,THERE IS A WAY.');
/*从test表中取出num，并对其进行+,-,*,/,%运算*/
SELECT num,num+10,num-12,num*2,num DIV 5,num%3 FROM test;
/*将num值与其它数据比较*/
SELECT num,num=20,num<>45,num>35,num>=30,num<10,num<=40,num<=>60 FROM test;
/*判断num是否落在指定区间，并且判断num是否在指定集合中*/
SELECT num,num BETWEEN 34 AND 49,num IN(2,4,50,65,78) FROM test;
/*判断test表info字段是否为空，用LIKE判断是否以“Yo”这两个字母开头，
用REGEXP来判断是否第一个字母是x，最后一个字母是e。*/
SELECT info,info IS NULL,info LIKE 'wh%',info REGEXP '^x',info REGEXP '.$' FROM test;
/*与，或，非和异或运算*/
SELECT 4&&0,5&&NULL,0&&NULL,4||0,5||NULL,0 OR NULL;
SELECT !3,!0,NOT NULL,4 XOR 0,2 XOR NULL,0 XOR NULL;
/*位运算*/
SELECT 8&12,8|12,~13;
SELECT 12<<3,155>>2;

/*练习与面试题*/
SELECT (13-4)*2,9+20/2,19 DIV 3,23%3;
SELECT 54>24,32>=25,34<=43,12<=12,NULL<=>NULL,NULL<=>2,4<=>4;
SELECT 7&&9,-4||NULL,NULL XOR 0,0 XOR1,!4;
SELECT 15&19,15|8,12^20,~12;
/*
（1）比较运算符的结果只能是0和1吗？
	是，逻辑运算结果也是0和1。
（2）哪种运算符的优先级最高?
	!最高,赋值运算符:=最低，通常情况使用括号来设定运算符优先级，使运算层次更清晰。
（3）十进制的数也可以直接使用位运算符吗？
	在进行位运算时，数据库系统会先将所有操作数转换为二进制数，然后将这些二进制数进行位运算，
再讲运算结果转换为十进制数。所以，位运算的操作数必须是十进制。十进制与二进制数之间的互换是数据库
系统实现的。因此，位运算的操作数必须是十进制数，否则计算的结果就会是错误的。
在使用位运算时，如果操作数是非十进制数时，要通过CONV()函数将操作数转换为十进制数。然后才能进行
相应的位运算。
*/
