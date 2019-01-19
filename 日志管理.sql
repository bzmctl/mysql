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
17.4.2 查看通用查询日志
17.4.3 停止通用查询日志
17.4.4 删除通用查询日志
