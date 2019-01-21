------------第十七章 日志管理------------
    本章内容
    了解和学习什么是MySQL日志
    掌握二进制日志的用法
    掌握错误日志的用法
    掌握查询通用日志的方法
    掌握慢查询日志的用法
    熟练掌握综合案例中日志的操作方法和技巧
17.1 MySQL软件所支持的日志
    二进制日志：记录所有更改数据的语句，可以用于数据复制。
    错误日志：记录MySQL服务的启动、运行或停止MySQL服务时出现的问题。
    查询日志：记录建立的客户端连接和执行的语句。
    慢查询日志：记录所有执行时间超过long_query_time的所有查询或不适用索引的查询。
17.2 操作二进制日志
17.2.1 启动二进制日志
SHOW VARIABLES LIKE 'log_bin%';
在my.ini中添加以下内容
log-bin="E:\\wt\\workspace\\mysql\\logs\\logs"
server-id=1
expire_logs_days=10
max_binlog_size=100M
my.cnf中添加如下内容：
log-bin=/var/lib/mysql/logs/binlog
server-id=1
expire_logs_days=10		--日志失效天数
max_binlog_size=100M
重启MySQL服务
再重新查看MySQL系统中的二进制日志开头
SHOW VARIABLES LIKE 'log_bin%';
17.2.2 查看二进制日志
【示例17-1】查看二进制日志文件个数及文件名，命令如下：
SHOW BINARY LOGS;
【示例17-2】使用mysqlbinlog查看二进制日志，具体步骤如下：
步骤一：
mysqlbinlog e:\\wt\\workspace\\mysql\\logs\\logs.000001
步骤二：
mysqlbinlog --no-defaults e:\\wt\\workspace\\mysql\\logs\\logs.000001
17.2.3 使用二进制日志恢复数据库
mysqlbinlog [option] filename|mysql -uuser -p;
option包括：
--start-datetime,
--stop-datetime,
--start-position,
--stop-position
【示例17-3】使用mysqlbinlog恢复MySQL数据库，命令如下：
mysqlbinlog e:\wt\workspace\mysql\logs\logs.000001|mysql -uroot -p

-- 以普通文本形式导出二进制日志
mysqlbinlog e:\wt\workspace\mysql\logs\logs.000001 > e:\wt\workspace\mysql\logs\fxlog\1.txt
【示例17-4】使用mysqlbinlog恢复MySQL数据库到指定时间以前的状态。
mysqlbinlog --stop-datetime="2019-01-17 22:36:00" /var/lib/mysql/logs/binlog.000002|mysql -uroot -p
17.2.4 暂停二进制日志
SET SQL_LOG_BIN = {0|1}		--0暂时记录|1恢复记录
SET SQL_LOG_BIN=0;
SET SQL_LOG_BIN=1;
17.2.5 删除二进制日志
  1.使用PURGE MASTER LOGS语句删除指定日志文件
  语法如下：
  PURGE {MASTER|BINARY} LOGS TO 'log_name'
  PURGE {MASTER|BINARY} LOGS BEFORE 'date'
【示例17-5】在MySQL数据库管理系统中，使用PURGE MASTER LOGS语句删除创建比binlog.000003早的日志，步骤如下：
步骤一：
SHOW BINARY LOGS;
步骤二：
PURGE MASTER LOGS TO "binlog.000003"
步骤三：
SHOW BINARY LOGS;
【示例17-6】在MySQL数据库管理系统中，使用PURGE MASTER LOGS语句删除指定日期之前的所有日志文件，具体步骤如下：
步骤一：
SHOW BINARY LOGS;
步骤二：
mysqlbinlog --no-defaults /var/lib/mysql/logs/binlog.000009
步骤三：
PURGE MASTER LOGS BEFORE '2019-01-18 0:11:14';
步骤四：
SHOW BINARY LOGS;
  2.使用RESET MASER语句删除所有二进制日志文件
  语法如下：
  RESET MASTER;
【示例17-7】在MySQL数据库管理系统中使用RESET MASTER语句删除所有日志文件，具体步骤如下：
步骤一：
SHOW BINARY LOGS;
步骤二：重启MySQL服务若干次或执行flush logs命令若干次，再执行
SHOW BINARY LOGS;
步骤三：
RESET MASTER;
17.3 操作错误日志
17.3.1 启动错误日志
  错误日志默认开启且无法关闭，默认存储在MySQL数据库的数据文件夹下，默认文件名为
hostname.err，如需修改可在my.ini或my.cnf中添加
log_error=[path/[filename]]
17.3.2 查看错误日志
【示例17-8】查看MySQL错误日志
SHOW VARIABLES LIKE 'log_err%';
17.3.3 删除错误日志
MySQL错误日志以文本形式存储在文件系统中，可直接删除，需重启MySQL
mysqladmin -uroot -p flush-logs
或者在客户端登陆MySQL执行flush-logs
17.4 通用查询日志
17.4.1 启用通用查询日志
MySQL默认关闭通用查询日志，开启
方法一：在my.cnf中加入：
general_log=ON
general_log_file=[path[filename]] --如果不指定参数，此选项可省略
方法二：命令方式,临时生效
SET GLOBAL general_log=on;
SET GLOBAL general_log_file='path/filename'
17.4.2 查看通用查询日志
【示例17-9】查看MySQL通用查询日志，具体步骤如下：
步骤一：
SET GLOBAL general_log=on;
步骤二：
SHOW VARIABLES LIKE 'general_log%';
步骤三：
使用emacs查看通用日志文件
17.4.3 停止通用查询日志
【示例17-10】修改my.cnf，从而实现停用通用查询日志
步骤一：
删除my.cnf中general_log=ON重启MySQL服务
步骤二：
SHOW VARIABLES LIKE 'general_log%';
【示例17-11】使用SET语句停止MySQL通用查询日志功能，具体步骤如下：
步骤一：
SET GLOBAL general_log=off
步骤二：重启MySQL服务，
SHOW VARIABLES LIKE 'general_log%';
17.4.4 删除通用查询日志
1.手工删除通用日志查询
rm -rf /var/lib/mysql/localhost.log
mysqladmin -uroot -p flush-logs重新生成查询日志文件
2.使用mysqladmin命令直接删除通用查询日志
mysqladmin -uroot -p flush-logs
17.5 慢查询日志
17.5.1 启动慢查询日志
1.修改配置文件开启慢查询日志
在my.cnf中添加：
long_query_time=n
slow_query_log=ON
slow_query_log_file=[path[filename]]
【示例17-12】修改配置文件来启动MySQL慢查询日志功能，具体步骤如下：
步骤一：
SHOW VARIABLES LIKE '%slow%';
SHOW VARIABLES LIKE '%long_query_time%';
步骤二：
在my.cnf中添加
long_query_time=2
slow_query_log=ON
步骤三：
重启MySQL服务
SHOW VARIABLES LIKE '%slow%';
SHOW VARIABLES LIKE '%long_query_time%';
步骤四：
ls -l /var/lib/mysql/localhost-slow.log
2.使用SET语句开启慢查询日志，临时生效
步骤一：
SHOW VARIABLES LIKE '%slow%';
SHOW VARIABLES LIKE '%long_query_time%';
步骤二：
set global slow_query_log=ON;
set global long_query_time=2;
set session long_query_time=2;
步骤三：
SHOW VARIABLES LIKE '%slow%';
SHOW VARIABLES LIKE '%long_query_time%';
步骤四：
ls -l /var/lib/mysql/localhost-slow.log
17.5.2 查看和分析慢查询日志
【示例17-14】查看MySQL慢查询日志的内容，具体步骤如下：
步骤一：查询慢日志所在目录
show variables like '%slow_query_log_file%';
步骤二：
show variables like '%long_query_time%';
步骤三：
SELECT BENCHMARK(6000000,ENCODE('hello','goodbye'));
步骤四：
emacs /var/lib/mysql/localhost-slow.log
17.5.3 停止慢查询日志
【示例17-15】修改my.cnf文件停止MySQL慢查询日志功能
步骤一：
修改slow_query_log=OFF，或删除此项
步骤二：重启MySQL服务，执行如下语句：
SHOW VARIABLES LIKE '%slow%';
SHOW VARIABLES LIKE '%long_query_time%';
【示例17-16】使用SET语句停止MySQL慢查询日志功能，具体步骤如下：
步骤一：SET GLOBAL slow_query_log=off
步骤二：重启MySQL服务，执行如下语句：
SHOW VARIABLES LIKE '%slow%';
SHOW VARIABLES LIKE '%long_query_time%';
17.5.4 删除慢查询日志
1.手工删除慢查询日志
SHOW VARIABLES LIKE 'slow_query_log%';
rm -rf /var/lib/mysql/localhost-slow.log
mysqladmin -uroot -p flush-logs
2.使用mysqladmin命令直接删除慢查询日志
mysqladmin -uroot -p flush-logs
17.6 综合示例---MySQL日志的综合管理
步骤一：启动二进制日志，并用将二进制日志文件名设置为mybinlog.000001
my.cnf中添加如下内容：
log-bin=/var/lib/mysql/data/mylog/mybinlog
server-id=1
expire_logs_days=10		--日志失效天数
max_binlog_size=100M
步骤二：将二进制文件存储路径改为/var/lib/mysql/data/mylog/
步骤三：检查flush-logs对二进制日志的影响
  每刷新一次mybinlog.0000xx增加一个
步骤四：查看二进制文件
mysqlbinlog /var/lib/mysql/logs/binlog.000001
步骤五：使用二进制恢复数据
mysqlbinlog /var/lib/mysql/logs/binlog.000003|mysql -uroot -p
步骤六：删除二进制日志
reset master;
步骤七：使用SET语句暂停和重启二进制日志
set sql_log_bin=0;
set sql_log_bin=1;
步骤八：设置启动和查看错误日志信息
show variables like 'log_err%'
步骤九：设置错误日志文件为/var/lib/mysql/data/mylog/myerrorlog.err
在my.cnf中添加：
log-error=/var/lib/mysql/data/mylog/myerrorlog.err
步骤十：查看MySQL的通用日志信息
set global general_log=ON;
SHOW VARIABLES LIKE 'general_log%';
步骤十一：设置启动查看慢查询日志
set global slow_query_log=ON;
set global long_query_time=2;
set session long_query_time=2;
17.7 经典习题与面试题
1.经典习题
（1）练习启动和设置二进制、查看二进制日志、暂停二进制日志功能的操作。
SHOW VARIABLES LIKE 'log_bin%';
my.cnf中添加如下内容：
log-bin=/var/lib/mysql/logs/binlog
server-id=1
expire_logs_days=10		--日志失效天数
max_binlog_size=100M
mysqlbinlog e:\\wt\\workspace\\mysql\\logs\\logs.000001
SET SQL_LOG_BIN=0;
SET SQL_LOG_BIN=1;
（2）练习使用二进制日志恢复数据。
mysqlbinlog e:\wt\workspace\mysql\logs\logs.000001|mysql -uroot -p
（3）练习使用三种方法删除二进制日志。
  PURGE {MASTER|BINARY} LOGS TO 'log_name'
  PURGE {MASTER|BINARY} LOGS BEFORE 'date'
  RESET MASTER;
（4）练习设置错误日志的存储路径、查看、删除错误日志。
hostname.err，如需修改可在my.ini或my.cnf中添加
log_error=[path/[filename]]
MySQL错误日志以文本形式存储在文件系统中，可直接删除，需重启MySQL
mysqladmin -uroot -p flush-logs
或者在客户端登陆MySQL执行flush-logs
（5）练习启动和设置通用查询日志、查看通用查询日志。
在my.cnf中添加：
general_log=ON
general_log_file=[path[filename]] --如果不指定参数，此选项可省略
直接用emacs打开查看
（6）练习启动和设置慢查询日志，查看慢查询日志。
在my.cnf中添加
long_query_time=2
slow_query_log=ON
直接用emacs打开查看
（7）练习删除通用查询日志和慢查询日志。
mysqladmin -uroot -p flush-logs
此方法直接覆盖原文件，注意提前备份。
2.面试题与解答
（1）平时应该开启什么日志？
    慢查询日志用于记录sql语句的执行效率，通用查询日志用于记录进行了哪些查询，
二进制日志用于记录数据库的改变，错误日志默认开启。可根据实际需要开启相应的日志
功能。
（2）如何使用二进制日志？
    二进制不仅可以记录查询还可以用来还原数据库。在备份数据库后可以开启二进制日志，
当数据库发生故障时，先使用备份进行恢复，再用二进制日志进行恢复备份后的数据库。
17.8 本章小结
   本章介绍了日志的含义、作用和优缺点，介绍了二进制日志、错误日志、通用查询日志和慢查询日志
的内容。
重点是，二进制日志，通用查询日志和错误日志，
二进制是难点。查询方法需要特殊命令，而且，二进制还可以还原数据库。
下一章介绍java操作MySQL数据库相关知识。
