/*------第十二章 存储过程和函数----------*/
  /*存储过程和函数是数据库中定义的一些SQL语句的集合，
然后直接调用这些存储过程和函数来执行已经定义好的SQL语句。
存储过程和函数可以避免开发人员重复地编写相同的SQL语句。
存储过程和函数是在MySQL服务器上存储和执行的，可以减少客户端和服务端的
数据传输。
本章内容：
  创建存储过程
  创建存储函数
  变量的使用
  定义条件和处理程序
  光标的使用
  流程控制的使用
  调用存储过程和函数
  查看存储过程和函数
  修改存储过程和函数
  删除存储过程和函数
学习目标：了解存储过程和函数的定义、作用；学会创建、使用、查看、修改、删
除存储过程和函数的方法。
12.1 创建存储过程和函数
12.1.1 创建存储过程
SQL语句：
CREATE PROCEDURE procedure_name([proc_param[,...]])
  [characteristic...] routine_body
procedure_name表示存储过程名字
proc_param表示存储过程参数
characteristic表示存储过程特性
routine_body表示存储过程的SQL语句代码，可以用BEGIN...AND来标志SQL语句的
开始和结束。
proc_param每个参数的语法形式：
[IN|OUT|INOUT] param_name type
每个参数由三部分组成，分别为输入输出类型，参数名和参数类型。IN表示输入类型，
OUT表示输出类型，INOUT表示输入输出类型；param_name表示参数名；type表示参数类型，
可以是MySQL软件支持的任何一种数据类型。
characteristic可有以下取值：
LANGUAGE SQL：说明routine_body部分是由SQL语句组成的，当前系统支持的语言
为SQL，SQL是LANGUAGE特性的唯一值。
[NOT]DETERMINISTIC：指明存储过程执行的结果是否确定。默认为NOT DETERMINISTIC。
{CONTAINS SQL|NO SQL|READS SQL DATA|MODIFIES SQL DATA}：指明子程序使用SQL
语句的限制。默认为CONTAINS SQL。
SQL SECURITY{DEFINER|INVOKER}:指明谁有权限执行。默认为DEFINER。
COMMENT'sting':注释信息，可以用来描述存储过程和函数。*/
/*示例【12-1】 执行SQL语句CREATE PROCEDURE，在数据库company中，
创建查询员工表t_employee中所有员工的薪水的存储过程。
步骤一：执行SQL语句CREATE DATABASE创建数据库company并选择该数据库。*/
CREATE DATABASE company;
USE company;
/*步骤二：执行SQL语句CREATE TABLE创建员工表t_employee。*/
CREATE TABLE t_employee(
  id INT(4),
  name VARCHAR(20),
  gender VARCHAR(6),
  age INT(4),
  salary INT(6),
  deptno INT(4));
/*步骤三：执行SQL语句INSERT INTO向表t_employee中插入数据。*/
INSERT INTO t_employee(id,name,gender,age,salary,deptno)
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
-- 步骤四：使用SQL语句SELECT检索数据是否插入成功。
SELECT * FROM t_employee;
-- 步骤五：执行SQL语句CREATE PROCEDURE，创建名为proc_employee的存储
--过程。
DELIMITER $$
CREATE PROCEDURE proc_employee()
COMMENT'查询员工薪水'
BEGIN
  SELECT salary
  FROM t_employee;
END;
$$
DELIMITER ;
/*12.1.2 创建存储函数
  MySQL中创建函数通过SQL语句CREATE FUNCTION来实现，其语法形式：
CREATE FUNCTION func_name([func_param[,...]])
 [characteristic...] routine_body
参数func_name表示要创建的函数的名字；
参数func_param表示函数的参数；
参数characteristic表示函数特性，取值与存储中取值相同。
参数routine_body表示SQL语句的代码，可以用BEGIN...END来表示SQL语句
的开始和结束。
函数名不能重名，推荐使用func_xxx形式的命名规则。
func_param每个参数的语法形式如下：
param_name type
每个参数由两部分组成，分别为参数名和参数类型。param_name表示参数名；
type表示参数类型，可以是MySQL软件支持的任何一种数据类型。
示例【12-2】执行SQL语句CREATE FUNCTION，在数据库company中，
创建名为func_employee的函数用来查询员工表中某个员工的薪水。*/
-- 步骤一：创建数据库，表及数据插入工作在示例12-1中已经完成，本示例继续延用。
-- 步骤二：选择数据库company。
USE company;
-- 步骤三：执行SQL语句CREATE FUNCTION，创建名为func_employee的函数。
DELIMITER $$
CREATE FUNCTION func_employee(id INT(4))
  RETURNS INT(6)
COMMENT'查询某个员工的薪水'
BEGIN
  RETURN(SELECT salary
  FROM t_employee
  WHERE t_employee.id=id);
END;
$$
DELIMITER ;
/*11.1.3 变量的使用
    在存储过程和函数中，可以定义和使用变量。用户可以使用关键字DECLARE来定义变量，
然后可以为变量赋值。这些变量的作用范围在BEGIN...END程序段中。
1.定义变量
MySQL中定义变量的基本语法：
DECLARE var_name[,...] type [DEFAULT value]
DECLARE用来声明变量；
var_name为变量名称，可以同时定义多个变量；
type用来指明变量类型；
DEFAULT value子句将变量默认值设置为value，没有使用DEFAULT子句时，默认为NULL。
示例【12-3】定义变量test_sql，数据类型为INT型，默认值为20。代码如下：
*/
DECLARE test_sql INT DEFAULT 20;
2.为变量赋值
  MySQL中可以关键字SET为变量赋值，SET语句的基本语法如下：
SET var_name=expr[,var_name=expr]...
关键字SET用来为变量赋值；
var_name是变量的名称；
参数expr是赋值表达式。
一个SET语句可以同时为多个变量赋值，各个变量的赋值语句之间用逗号隔开。
示例【12-4】为变量test_sql赋值为30.
SET test_sql=30;
  MySQL中还可以使用SELECT...INTO语句为变量赋值，其基本语法如下：
SELECT col_name[,...]INTO var_name[,...]
  FROM table_name WHERE condition;
参数col_name表示查询字段的名称；
参数var_name是变量的名称；
参数table_name指表的名称；
参数condition指查询条件。
示例【12-5】下面从表t_employee中查询id为3的记录，将记录的id值赋给变量
test_sql。
SELECT id INTO test_sql FROM t_employee WHERE id=3;
12.1.4 定义条件和处理程序
  定义条件和程序是事先定义程序执行过程中可能遇到问题，并且可以在处理程序中
定义解决这些问题的办法。这种方式可以提前预测可能出现的问题，并提出解决办法。
这样可以增强程序处理问题的能力，避免程序异常终止。MySQL中都是通过关键字
DECLARE来定义条件和处理程序。
1.定义条件
语法如下：
DECLARE condition_name CONDITION FOR condition_value;
condition_value:
SQLSTATE[VALUE]sqlstate_value|mysql_error_code
condition_name表示条件名称；
condition_value表示条件类型；
参数sqltate_value和参数mysql_error_code都可以表示MySQL的错误。
示例【12-6】下面定义“ERROR 1146(42S02)”这个错误，名称为can_not_find，
可以用两种不同的方法来定义，代码如下：
-- 方法一：使用sqlstate_value
DECLARE can_not_find CONDITION FOR '42S02';
-- 方法二：使用mysql_error_code
DECLARE can_not_find CONDITION FOR 1146;
2.定义处理程序
  MySQL中使用DECLARE关键字处理程序，基本语法如下：
DECLARE handler_type HANDLER FOR condition_value[,...] proc_statement;
handler_type:
CONTINUE|EXIT|UNDO
condition_value:
SQLSTATE[VALUE]sqlstate_value|condition_name|SQLWARNING|NOT FOUND|SQLEXCEPTION|mysql_error_code
参数handler_type指明错误的处理方式，该参数有三种取值。MySQL中暂不支持UNDO。
参数condition_value表示错误类型，可以有以下取值：
SQLSTATE[VALUE]sqlstate_value包含5个字符的字符串错误值。
condition_name表示DECLARE CONDITION定义的错误条件名称。
SQLWARNING匹配所有以01开头的SQLSTATE错误代码。
NOT FOUND匹配所有以02开头的SQLSTATE错误代码。
SQLEXCEPTION匹配所有没有被SQLWARNING和NOT FOUND捕获的SQLSTATE错误代码。
mysql_error_code匹配数值类型错误代码。
参数proc_statement为程序语句段，表示在遇到定义的错误时，需要执行的存储过程或函数。
示例【12-7】下面是定义处理程序的几种方式。
-- 方法一：捕获sqlstate_value
DECLARE CONTINUE HANDLER FOR SQLSTATE '42S02' SET @info='NOT FOUND';
-- 方法二：使用mysql_error_code
DECLARE CONTINUE HANDLER FOR 1146 SET @info='NOT FOUND';
-- 方法三：先定义条件然后使用
DECLARE not_found CONDITION FOR 1146;
DECLARE CONTINUE HANDLER FOR not_found SET @info='NOT FOUND';
-- 方法四：使用SQLWARNING
DECLARE EXIT HANDLER FOR SQLWARNING SET @info='ERROR';
-- 方法五：使用NOT FOUND
DECLARE EXIT HANDLER FOR NOT FOUND SET @info='NOT FOUND';
-- 方法六：使用SQLEXCEPTION
DECLARE EXIT HANDLER FOR SQLEXCEPTION SET @info='ERROR';
12.1.5 光标的使用
  查询语句可能查询出多条记录，在存储过程和函数中使用光标来逐条读取查询的几种记录。
光标的使用包括声明光标，打开光标，使用光标和关闭光标。光标必须声明在处理程序之前，
并且声明在变量和条件之后。
  1.声明光标
  MySQL中使用DECLARE关键字来声明光标，其基本语法为
DECLARE cursor_name CURSOR
  FOR select_statement;
参数cursor_name表示光标名称，
参数select_statement表示SELECT语句的内容。
示例【12-8】下面声明一个名为cur_employee的光标。
DECLARE cur_employee CURSOR
  FOR SELECT name,age FROM t_employee;
上面示例中，光标的名称为cur_employee;
SELECT语句部分是从表t_employee中查询出的字段name和age的值。
  2.打开光标
  MySQL中使用关键字OPEN来打开光标，其基本语法为：
OPEN cursor_name;
示例【12-9】下面打开一个名为cur_employee的光标。
OPEN cur_employee;
  3.使用光标
  MySQL中使用关键字FETCH来使用光标，其基本语法为：
FETCH cursor_name
  INTO var_name[,...var_name];
var_name表示将光标中的SELECT语句查询出来存入到该参数中。var_name
必须在声明光标之前就定义好。
示例【12-10】下面打开一个名为cur_employee的光标，将查询出来的数据存入
emp_name和emp_age中。emp_name和emp_age必须在前面已经定义。
FETCH cur_employee INTO emp_name,emp_age;
  4.关闭光标
  MySQL中使用CLOSE关闭光标
CLOSE cursor_name;
  参数cursor_name表示光标的名称。
【示例12-11】下面关闭一个名为cur_employee的光标。
CLOSE cur_employee;
  上面的示例中，关闭了名为cur_employee的光标后，就不能使用FETCH来使用光标了。
提示：如果存储过程或函数执行了SELECT语句，并且SELECT语句会查询出多条记录，这种
情况最好使用光标来读取记录，光标必须在处理程序之前和在条件之后声明，而且光标使用
完之后一定要关闭。
