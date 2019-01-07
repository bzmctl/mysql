/*----------第十五章 用户安全管理---------------*/
/*15.1 权限表
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
      1．首先确认服务器出于安全的状态，也就是没有人能够任意地连接MySQL数据库。 因为在重新设置MySQL的root密码的期间，MySQL数据库完全出于没有密码保护的 状态下，其他的用户也可以任意地登录和修改MySQL的信息。可以采用将MySQL对外的端口封闭，并且停止Apache以及所有的用户进程的方法实现服务器的准安全状态。最安全的状态是到服务器的Console上面操作，并且拔掉网线。
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
    15.3.1 MySQL的各种权限
    15.3.2 授权
    15.3.3 查看权限
    15.3.4 收回权限
  15.4 访问控制
    15.4.1 连接核实阶段
    15.4.2 请求核实阶段
  15.5 综合示例---综合管理用户权限
  15.6 经典习题与面试题
    1.经典习题
    2.面试题及解答
  15.7 本章小结*/
