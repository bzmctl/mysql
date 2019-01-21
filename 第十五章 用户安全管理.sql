/*----------第十五章 用户安全管理---------------*/
/*
15.1 权限表
15.1.1 user表
use mysql;
desc user;
1.用户列
  其中Host和user为主键
2.权限列
3.安全列
4.资源控制列
15.1.2 db表
desc mysql.db;
15.1.3 table_priv表和columns_priv表
desc tables_priv;
desc columns_priv;
15.1.4 procs_priv表
desc procs_priv;
15.2 账户管理
15.2.1 登陆和退出MySQL服务器
mysql -h hostname|hostIP -P port -u username -p DatabaseName -e "SQL语句"
【示例一】使用root用户登陆到本机的数据库。
mysql -h localhost -uroot -p
mysql -h 127.0.0.1 -uroot -p
【示例二】使用root用户登陆到本机的mysql数据库，并查询func的表结构。
mysql -h localhost -uroot -p mysql -e "desc func";
15.2.2 新建普通用户
1.用CREATE USER语句新建普通用户
CREATE USER user[IDENTIFIED BY [PASSWORD] 'password']
,...,[user[IDENTIFIED BY [PASSWORD] 'password']]
【示例三】使用CREATE语句创建名为Justin的用户，密码为123456主机名为localhost。
CREATE USER 'Justin'@'localhost' IDENTIFIED BY '123456';
2.用GRANT语句新建普通用户
GRANT priv_type ON database.table TO user[IDENTIFIED BY [PASSWORD] 'password']
,...,[user[IDENTIFIED BY [PASSWORD] 'password']]
【示例五】使用GRANT语句创建名为Justin的用户，密码为123456主机名为localhost,该用户对所有数据库有查询权限。
GRANT SELECT ON *.* TO 'Justin'@'localhost' IDENTIFIED BY '123456';
3.用INSERT语句新建普通用户
使用时注意将没有默认值的列加上，语句执行完需执行FLUSH PRIVILEGES;需具有RELOAD权限。
15.2.3 删除普通用户
1.用DROP语句来删除普通用户
DROP USER user[,uer]...
【示例六】删除用户名为Justin主机名为localhost的用户。
DROP USER 'Justin'@'localhost';
2.用DELETE语句删除普遍用户
DELETE FROM mysql.user WHERE host='hostname' AND user='username';
【示例七】删除Emily用户，主机名localhost
DELETE FROM mysql.user WHERE host='localhost' AND user='Emily';
FLUSH PRIVILEGES;
15.2.4 root用户修改自己密码
1.使用mysqladmin命令修改
mysqladmin -u username -p password "new_password";
【示例八】修改root密码为hello1234
mysqladmin -u root -p password "hello1234";
2.修改mysql数据库下的user表
UPDATE mysql.user SET password=PASSWORD('new_password') WHERE host='hostname' and user='username';
【示例九】修改root密码为123456
UPDATE mysql.user SET authentication_string=PASSWORD('123456') WHERE host='localhost' and user='root';
flush privileges;
3.使用SET语句修改
SET PASSWORD='new_password';
【示例十】使用SET修改用户密码
SET PASSWORD='xxxxxxxx';
15.2.5 root用户修改普通用户密码
1.使用SET命令修改
SET PASSWORD FOR 'username'@'hostname'=PASSWORD('new_password');
【示例十一】修改Justin的密码为123456
SET PASSWORD FOR 'Justin'@'localhost'='123456';
2.修改mysql的user表
同修改root密码的语法一样
【示例十二】
UPDATE mysql.user SET authentication_string=PASSWORD('123456') WHERE host='localhost' and user='Justin';
3.使用GRANT语句修改
GRANT priv_type ON database.table TO user[IDENTIFIED BY [PASSWORD] 'password'];
【示例十三】
GRANT SELECT ON *.* TO 'Justin'@'localhost' IDENTIFIED BY 'hello1234';
15.2.6 普通用户修改密码
修改自己密码
SET PASSWORD='new_password';
15.2.7 root用户密码丢失的解决办法
1.Windows系统下
步骤1：以管理员身份打开DOS窗口并停止MySQL服务
NET STOP mysql
步骤2：进入MySQL安装目录下的bin目录
步骤3：以安全模式打开MySQL
mysqld --defaults-file="D:\Program Files\mysql-5.7.23-winx64\my.ini" --skip-grant-tables
步骤4：
重新打开一个DOS窗口，用以下命令登陆MySQL
mysql -uroot
步骤5：使用update语句更新root用户密码
UPDATE mysql.user SET authentication_string=PASSWORD('new_password') WHERE user='root';
步骤六：刷新操作
FLUSH PRIVILEGES;
步骤七：查看windows所有进程
tasklist
步骤八：使用tskill 关闭mysql进程
tskill mysqld/pid
步骤九：重新启动mysql
NET START mysql
步骤十：使用新密码登陆
mysql -uroot -p
2.Linux系统下
1．首先确认服务器出于安全的状态，也就是没有人能够任意地连接MySQL
数据库。 因为在重新设置MySQL的root密码的期间，MySQL数据库完全出于没有
密码保护的状态下，其他的用户也可以任意地登录和修改MySQL的信息。
可以采用将MySQL对外的端口封闭，并且停止Apache以及所有的用户进程的方法
实现服务器的准安全状态。
最安全的状态是到服务器的Console上面操作，并且拔掉网线。
2．修改MySQL的登录设置：
# vi /etc/my.cnf
在[mysqld]的段中加上一句：skip-grant-tables 保存并且退出vi。
3．重新启动mysqld
# /etc/init.d/mysqld restart  ( service mysqld restart )
4．登录并修改MySQL的root密码
mysql> USE mysql ;
mysql> UPDATE user SET Password = password ( 'new-password' ) WHERE User = 'root' ;
mysql> flush privileges ;
mysql> quit
5．将MySQL的登录设置修改回来
# vi /etc/my.cnf
将刚才在[mysqld]的段中加上的skip-grant-tables删除
保存并且退出vi。
6．重新启动mysqld
# /etc/init.d/mysqld restart   ( service mysqld restart )
7．恢复服务器的正常工作状态
将步骤一中的操作逆向操作。恢复服务器的工作状态。
3.Mac下
step1:
关闭mysql服务：  苹果->系统偏好设置->最下边点mysql 在弹出页面中 关闭mysql服务（点击stop mysql server）
step2:
进入终端输入：cd /usr/local/mysql/bin/
回车后 登录管理员权限 sudo su
回车后输入以下命令来禁止mysql验证功能 ./mysqld_safe --skip-grant-tables &
回车后mysql会自动重启（偏好设置中mysql的状态会变成running）
step3:
输入命令 ./mysql
回车后，输入命令 FLUSH PRIVILEGES;
回车后，输入命令 SET PASSWORD FOR 'root'@'localhost' = PASSWORD('你的新密码');
15.3 权限管理
权限管理主要是对登陆到MySQL的用户进行权限验证。所有用户的权限都
存储在MySQL的权限表中，不合理的权限规划会给系统带来安全隐患。数据
库管理员要对所有用户的权限进行合理的规划管理。MySQL的权限系统主要
功能是证实连接到一台给定主机的用户，并且赋予该用户在数据库上的SELECT，
INSERT，UPDATE，和DELETE权限。
15.3.1 MySQL的各种权限
  权限信息存储在MySQL数据库的user、db、host、tables_priv、columns_priv和procs_priv表中。
在MySQL启动时，服务器将这些数据库表中的信息的内容读入内存。
15.3.2 授权
  授权就是为某个用户赋予某些权限。合理的授权可保证数据库的安
全，不合理的授权会给数据库带来安全隐患。
授予的权限可分为多个层级：
1.全局层级
 适用于一个给定服务器的所有目标。
	GRANT ALL ON *.*和REVOKE ALL ON *.*
2.数据库层级
适用于一个给定数据库的所有目标。
   GRANT ALL ON db_name和REVOKE ALL ON db_name.*
3.表层级
适用于一个给定表的所有列。
   GRANT ALL ON db_name.tablename和REVOKE ALL ON db_name.tablename
4.列层级
列权限适用于一个给定表中的单一列。这些权限存储在
mysql.columns_priv表中。当使用REVOKE时，必须指定和被授予相同的列。
5.子程序层级
  CREATE ROUTINE、ALTER ROUTINE、EXECUTE和GRANT权限适用
于已存储的子程序。这些权限可以被授予为全局层级和数据库层级。
而且，除了CREATE ROUTINE外，这些权限可以被授予子程序层级，
并存储在mysql.procs_priv表中。
GRANT语法：
GRANT priv_type[(column_list)] ON database.table
TO user[IDENTIFIDE BY[PASSWORD] 'password']
[,user[IDENTIFIDE BY[PASSWORD] 'password']]
...
[WITH with_option[with_option]...]
priv_type:表示权限类型；
column_list:表示权限作用在哪些列上；
user:由用户名和主机名构成，形式'username'@'hostname'；
IDENTIFIDE:用来设置新密码；
password:为新密码；
WITH：后面带有一个或多个with_option参数。这个参数有五个选
项，分别为：
GRANT OPTION:被授予的用户可以将这些权限授予别的用户。
MAX_QUERIES_PER_HOUR count:设置每小时允许执行count次查询。
MAX_UPDATES_PER_HOUR count:设置每小时允许执行count次更新。
MAX_CONNECTIONS_PER_HOUR count:设置每小时可以建立count个连接。
MAX_USER_CONNECTIONS count:设置单个用户同时可以具有count个连接。
【示例15-16】下面作用GRANT创建一个新用户‘Rebecca’。该用户对所有数据
库有SELECT和UPDATE权限。密码为‘123456’，且加上WITH GRANT OPTION字句。
步骤一：创建执行语句。
GRANT SELECT,UPDATE ON *.* TO 'Rebecca'@'localhost'
IDENTIFIED BY '123456' WITH GRANT OPTION;
步骤二：查询user表，查看Rebecca的信息。
SELECT
host,user,authentication_string,select_priv,update_priv,grant_priv
FROM mysql.user WHERE user='Rebecca' \G
15.3.3 查看权限
方法一：使用SELECT * FROM mysql.user;必须具有user表的SELECT权限。
方法二：SHOW GRANTS FOR 'username'@'hostname';
【示例15-17】查看root用户权限。
SHOW GRANTS FOR 'root'@'localhost';
【示例15-18】查看Rebecca用户权限。
SHOW GRANTS FOR 'Rebecca'@'localhost';
【示例15-19】查看Rebecca用户的SELECT和INSERT权限。
SELECT select_priv,insert_priv FROM mysql.user
WHERE user='Rebecca' AND host='localhost';
15.3.4 收回权限
  收回权限就是取消已经赋予用户的某些权限。收回用户不必要的权限可以在一
定程度上保证系统的安全性。
  语法形式：
REVOKE priv_type[(cloumn_list)]...
ON database.table
FROM user[,user]...
收回全部权限语法形式：
REVOKE ALL PRIVILEGES,GRANT OPTION FROM user[,user]...
【示例15-20】收回Rebecca用户的UPDATE权限。
REVOKE UPDATE ON *.* FROM 'Rebecca'@'localhost';
SELECT host,user,authentication_string,update_priv FROM mysql.user
WHERE user='Rebecca' AND host='localhost';
【示例15-20】收回Rebecca用户的所有权限。
REVOKE ALL PRIVILEGES,GRANT OPTION FROM 'Rebecca'@'localhost';
SELECT host,user,authentication_string,select_priv,update_priv,grant_priv FROM mysql.user
WHERE user='Rebecca' AND host='localhost';
15.4 访问控制
15.4.1 连接核实阶段
  当用户试图连接MySQL服务器时，服务器基于用户的身份以及用户是否能提供
正确的密码验证身份来确定接受或拒绝连接。
15.4.2 请求核实阶段
  一旦建立了连接，服务器就进入了访问控制的阶段2，也就是请求核实阶段。
对此连接上进来的每个请求，服务器检查该请求执行什么操作，是否有足够的权
限来执行它，这正是授权表中权限列发挥作用的地方。这些权限可以来自user、
db、table_priv、column_priv表。
15.5 综合示例---综合管理用户权限
步骤1：使用root用户登陆mysql
mysql -uroot -p
步骤2：选择数据库
USE mysql;
步骤3：创建新用户newRebecca，key为123456，允许其从本地访问MySQl，并拥有对数据
库school中t_student表的SELECT和UPDATE权限,同时允许每小时建立30次连接。
GRANT SELECT,UPDATE(gender,studentId,studentName,age) ON school.t_student TO 'newRebecca'@'localhost'
IDENTIFIED BY '123456' WITH MAX_CONNECTIONS_PER_HOUR 30;
步骤4：分别从user表查看新账户信息，从tables_priv和columns_priv表中查看权限信
息。
SELECT host,user,select_priv,update_priv FROM mysql.user
WHERE host='localhost' AND user='newRebecca';
SELECT host,db,user,table_name,table_priv,column_priv
FROM tables_priv WHERE user='newRebecca';
SELECT host,db,user,table_name,column_name,column_priv
FROM columns_priv WHERE user='newRebecca';
步骤5：查看newRebecca的权限信息。
SHOW GRANTS FOR 'newRebecca'@'locahost' \G
步骤6：使用newRebecca用户登陆MySQL
mysql -unewRebecca -p123456
步骤7：查看t_student表中的数据
SELECT * FROM school.t_student;
步骤8：向表t_student中插入一条记录
INSERT INTO t_student VALUES(2,'Betty','Female',21,1,489);
步骤9：使用REVOKE收回newRebecca账户权限，再用SHOW GRANTS语句查看权限。
REVOKE SELECT,UPDATE(gender,studentId,studentName,age)	ON
school.t_student
FROM 'newRebecca'@'localhost';
SHOW GRANTS FOR 'newRebecca'@'localhost' \G
步骤10：删除newRebecca账户信息。
DROP USER 'newRebecca'@'localhost';
SELECT host,user,select_priv,update_priv FROM user WHERE user='newRebecca';
15.6 经典习题与面试题
1.经典习题
(1)
GRANT SELECT,INSERT ON company.t_employee TO 'newAccount'@'localhost'
IDENTIFIED BY '123456';
GRANT UPDATE(deptname) ON company.t_dept TO 'newAccount'@'localhost';
(2)
SET PASSWORD FOR 'newAccount'@'localhost'='654321';
(3)
FLUSH PRIVILEGES;
(4)
SHOW GRANTS FOR 'newAccount'@'localhost' \G
(5)
REVOKE ALL PRIVILEGES,GRANT OPTION FROM 'newAccount'@'localhost';
(6)
DROP USER 'newAccount'@'localhost';
2.面试题及解答
（1）MySQLadmin能不能修改普通用户的密码
	不能，普通用户不具备SUPER权限
（2）删除一个账户后，为何该账户还可以登陆到MySQL数据库
	注意查看user表中是否有User字段值为空串的记录存在，若存在删除之。
（3）新建MySQL用户不能在其他机器上登陆MySQL数据库系统
	修改该账户的host字段值为%，并授权允许其远程访问
（4）应该使用哪种方式创建用户
	为了系统的安全性，推荐使用CREATE USER语句和GRANT。
15.7本章小结
  本章讲解了MySQL数据库的权限表、账户管理、权限管理的内容。其中
账户管理和权限管理是重点。特别是密码管理、授权和收回是重中之重，因为它
们涉及MySQL数据库安全。
  取回root用户密码和授权是难点。
  本章讲解了在Window、Linux、Mac系统下root密码丢失的解决办法。
需反复练习并掌握。
下一章讲解数据库备份和恢复
