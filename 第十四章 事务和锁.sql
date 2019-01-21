--------------------第 14 章 事务和锁----------------
  /*当多个用户访问同一个数据时，一个用户在更改数据的同时可能另一个用户也
在更改同一份数据，为保证数据从一个一致性状态到另一个一致性状态，这时有
必要引入事务的概念。*/
-- 本章节内容
/*事务的概述
  事务的控制语句
  事务的隔离级别
  InnoDB锁机制*/
14.1 事务概述
  事务的四个特性。
（1）原子性(Atomicity)：事务中的所有操作视为一个原子单元，即对事务所有
进行的数据的修改操作只能是完全提交或者完全回滚。
（2）一致性（Consistency）：事务在完成时，必须从一种一致性状态变更为另
一种一致性状态，所有的变更都必须应用于事务的修改，以确保数据的完整性。
（3）隔离性（Isolation）：一个事务中的操作语句所作的修改必须与其它事务
所做的修改相隔离。在进行事务查看数据时数据所处的状态要么是被另一并发事
务修改之前的状态，要么是被另一并发事务修改之后的状态，即当前事务不会查
由另一个并发事务正在修改的数据。这种特性通过锁机制实现。
（4）持久性（Durability）：事务完成之后，所做的修改对数据的影响是持久
的，即使系统重启或者出现系统故障，数据仍可恢复。
1.REDO日志
  事务执行时需要将执行的事务日志写入日志文件里，对应的文件为REDO日志。
2.UNDO日志
  与REDO日志相反，UNDO日志主要用于事务异常时的数据的回滚，具体内容就是
复制事务前的数据库内容到UNDO缓冲区，然后在合适的时间将内容刷新到磁盘。
14.2 MySQL事务控制语句
【示例14-1】本示例实现的功能为更新表中的一条记录，为保证数据从一个一致
性状态到另一个一致性状态，因此使用事务完成更新过程，如更新失败或者其它
原因可以使用回滚。此示例使用MySQL默认隔离级别为REPEATABLE-READ。
-- 步骤一：查看MySQL隔离级别
SHOW VARIABLES LIKE 'tx_isolation';
-- 步骤二：创建数据库并选择该数据库
CREATE DATABASE test;
USE test;
-- 步骤三：创建表test_1，并插入数据
CREATE TABLE test_1(
  id INT,
  username VARCHAR(20)
)ENGINE=InnoDB;
INSERT INTO test_1
VALUES(1,'Rebecca'),
(2,'Jack'),
(3,'Emily'),
(4,'Water');
-- 步骤四：查询表test_1;
SELECT * FROM test_1;
-- 步骤五：开户一个事务，更新表test_1的记录，再提交事务，最后查询表test_1
BEGIN;
UPDATE test_1 SET username='Selina' WHERE id=1;
COMMIT;
SELECT * FROM test_1;
-- 步骤六：开户一个事务，更新表test_1的记录，查询记录再回滚事务，最后
-- 查询表记录是否已经更改。
BEGIN;
UPDATE test_1 SET username='LiMing' WHERE id=1;
SELECT * FROM test_1;
ROLLBACK;
SELECT * FROM test_1;
14.3 事务的隔离级别
  SQL标准定义了4种隔离级别，指定了事务中哪些数据改变其他事务可见，哪些
数据改变其它事务不可见。低级别的隔离级别可以支持更高的并发处理，同时占
用系统资源更少。
  InnoDB系统级事务隔离级别可以使用以下语句设置。
  -- 未提交读
  SET GLOBAL TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
  -- 提交读
  SET GLOBAL TRANSACTION ISOLATION LEVEL READ COMMITTED;
  -- 可重复读
  SET GLOBAL TRANSACTION ISOLATION LEVEL REPEATABLE READ;
  -- 可串行化
  SET GLOBAL TRANSACTION ISOLATION LEVEL SERIALIZABLE;
  查看系统事务隔离级别可用以下语句：
  SELECT @@global.tx_isolation;
14.3.1 READ UNCOMMITTED（读取未提交内容）
  在该隔离级别，所有事务都可以看到其他未提交事务的执行结果。读取未提交
的数据被称为脏读（Dirty-Read）。
  MySQL的隔离级别为READ UNCOMMITTED，首先开户A和B两事务，在B事务更新但
未提交之前，A事务读取到了更新后的数据；但由于B事务回滚，A事务出现了脏读的现象。
14.3.2 READ COMMITTED（读取提交内容）
  这是大多数系统默认的隔离级别，但并不是MySQL默认的隔离级别，其满足了
隔离的简单定义：一个事务从开始到提交前所做的任何改变都是不可兼得，事务
只能看见已经提交事务所做的改变。这种隔离级别也支持所谓的不可重复读
（Nonrepeatable Read），因为同一事务的其它示例在该示例处理期间可能会
有新的数据提交导致数据改变，所以同一查询可能返回不同结果。
  MySQL的隔离级别为READ COMMITTED，首先开启A和B两事务，在B事务更新并提
交后，A事务读取到了更新后的数据，此时处于同一A事务查询出现了不同的查询
结果，即不可重复读。
14.3.3 REPEATABLE READ（重复读）
  这是MySQL默认的事务隔离级别，能确保同一事务的多个实例在并发读取数据
  时，会看到同样的数据行，理论上会导致另一个问题：幻读（Phontom Read）。
-- REPEATABLE READ(可重读)(会出现问题--幻读）
SET GLOBAL TRANSACTION ISOLATION LEVEL REPEATABLE READ;/*设置完成需要重新登陆mysql*/
/**事务A*/                              /**事务B*/
SELECT @@tx_isolation;                  SELECT @@tx_isolation;
BEGIN;                                  BEGIN;
SELECT * FROM test_1;                   SELECT * FROM test_1;
                                        INSERT INTO test_1 VALUES(5,'Jack');
                                        COMMIT;
SELECT * FROM test_1;                   SELECT * FROM test_1;

UPDATE test_1 SET username='Jack'
 WHERE id=5;
SELECT * FROM test_1;                   SELECT * FROM test_1;
14.3.4 SERIALIZABLE（可串行化）
  这是最高的隔离级别，通过强制事务排序，是指不可能相互冲突，从而解决幻
 读问题，简而言之，是在每个读的数据行上加上共享锁实现。在这个级别，可
 能会导致大量的超时现象和锁竞争，一般不推荐使用。
USE test;
CREATE TABLE test_2(
  id int,
  num int);
SET GLOBAL TRANSACTION ISOLATION LEVEL SERIALIZABLE;/*设置完成需要重新登陆mysql*/
/**事务A*/                              /**事务B*/
SELECT @@tx_isolation;                  SELECT @@tx_isolation;
BEGIN;                                  BEGIN;
SELECT * FROM test_2;                   SELECT * FROM test_2;
commit;                                 UPDATE test_2 SET num=2000 WHERE id=1;
SELECT * FROM test_2;                   SELECT * FROM test_2;
                                        commit;
SELECT * FROM test_2;                   SELECT * FROM test_2;					
14.4 InnoDB锁机制
  为了解决数据库并发控制问题，如在同一时刻，客户对于同一表做更新或者查
 询操作，为保证数据的一致性，需要对并发操作进行控制，因此产生了锁。同
 时为实现MySQL的各个隔离级别，锁机制为其提供了保证。
14.4.1 锁的类型
1.共享锁
  共享锁的代号是S，是Share的缩写，粒度为行或元组。一个事务获得了共享锁
 之后，可以对锁定范围内的数据执行读操作。
2.排它锁
  排它锁的代号是X，是eXclusive的缩写，粒度也为行或元组。一个事务获得了
 排它锁之后，可以对锁定范围内的数据执行写操作。
   如果两个事务A和B，如果事务A获得了一个元组的共享锁，事务B还可以立即
 获得这个元组的共享锁，但不能立即获得这个元组的排它锁，必须等到事务A释
 放共享锁之后。
   如果事务A获得了一个元组的排它锁，事务B不能立即获得这个元组的共享锁，
 也不能获得这个元组的排它锁，必须等到事务A释放排它锁之后。
3.意向锁
  意向锁是一种表锁，锁定的粒度是整张表，分意向共享锁（IS）和意向排它锁
 （IX）两类，表示一个事务有意对数据上共享锁或排它锁。“有意”表示事务
 想执行操作但还没有真正执行。锁和锁之间要么相容要么互斥。
   锁a与锁b相容是指：操作同一组数据时，如果事务t1获得了锁a，另一个事务
 t2还可以获取锁b。
   锁a与锁b互斥是指：操作同一组数据时，如果事务t1获得了锁a，另一个事务
 t2在t1释放锁a之前无法获取锁b。
   共享锁、排它锁、意向共享锁、意向排它锁相互之间的兼容与互斥关系：
   /*总结如下：
   排它锁与所有锁都不相容；
   共享锁与共享锁和意向共享锁相容；
   意向排它锁与意向锁相容；
   意向共享锁与除排它锁之外的所有锁相容。*/
   为了尽可能提高数据库的并发量，每次锁定的数据范围越小越好，但越小的
 锁耗费的系统资源越多，系统性能越低。为了在高并发和系统性能两方面进行
 平衡，这样就产生了“锁的粒度（Lock granularity）”的概念。
14.4.2 锁的粒度
  锁的粒度主要分为表锁或行锁。
  表锁管理锁的开销最小，同时的并发量也是最小的锁机制。
  行锁可支持最大的并发。
  以下为MySQL中一些语句执行时锁的情况：
  SELECT ... LOCK IN SHARE MODE	--此操作会加上一个共享锁
  SELECT ... FOR UPDATE		--此操作会加上一个共享锁
  INSERT、UPDATE、DELETE	--会话事务会对DML语句操作的数据上加一
  --个排它锁。
  查看MySQL中InnoDB存储引擎的状态。
14.5 本章小结
  本章介绍了事务的基本概念，事务具备的四种特性，再介绍了事务控制语句，
 通过事务控制语句可以控制事务的开启、提交、或者进行事务回滚等操作。事
 务的隔离级别介绍了数据库事务在各种级别下的表现，因为隔离级别不同会导
 致脏读、不可重复读或者幻读等问题，最后介绍了InnoDB锁机制，锁机制是事
 务实现不同的隔离级别所必须的。
