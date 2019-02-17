/*****第二十章 论坛管理系统数据库设计******/
本讲内容：
	了解论坛管理系统的概述
	熟悉论坛管理系统的功能
	掌握如何设计论坛管理系统的表
	掌握如何设计论坛管理系统的索引
	掌握如何设计论坛管理系统的视图
	掌握如何设计论坛管理系统的触发器
20.1 系统概述
    BBS(Bulletin Board System)是一种以技术交流和会员互动为核心的论坛系统，在
论坛上用户可以维护自己的帖子，还可以对别人的帖子发表自己的评论，还可以按关键字
搜索相关帖子。
    论坛是一种交互性丰富且信息实时交互的电子信息服务系统。用户在BBS站点可以浏览信息，
发布信息，互动交流，信件往来等。类似日常生活的黑板报，论坛按不同主题分不同板块，板面
的设立依据是大多数用户的要求和喜好，用户可以阅读别人对某个主题的看法，也可以发表自己
的看法。目前BBS论坛的主要功能有以下几点：
  用户可以随时阅读他人发布的帖子。
  用户可在不同板块发布帖子供他人阅读，也可以编辑，删除自己发布的帖子。
  用户在登陆状态下可对其他用户发布的帖子进行回复。
  站长可以增加，编辑，删除板块。
  板主可以删除不符合板规的帖子。
20.2 系统功能
  （1）用户类型管理：用户分为站长，板主和普通用户三类，分别具有不同的权限。
  （2）用户管理：实现新增用户，查看用户和删除用户信息功能。
  （3）板块管理：站长可新增，修改和删除板块。
  （4）主帖管理：普通用户可发帖，编辑，删除自己的帖子，查看自己和别人发的帖子，
板主可删除不符合板规的帖子。
  （5）回帖管理：普通用户可查阅所有回帖，可回复其它用户发帖，板主可删除不符合板规的帖子。
20.3 数据库设计和实现
     数据库设计要确定设计哪些表，表中含有哪些字段，字段的数据类型及长度等。
20.3.1 设计表
  本系统所有表都放在bbsForm数据库下。
CREATE DATABASE bbsForm;
USE bbsForm;
       1.用户类型表userType
CREATE TABLE userType(
       userTypeId INT(8) NOT NULL AUTO_INCREMENT COMMENT '用户类型ID',
       userTypeName VARCHAR(20) NOT NULL COMMENT '用户类型名称',
       CONSTRAINT pk_id PRIMARY KEY(userTypeId)
);
       2.用户表user
CREATE TABLE user(
       userId INT(8) NOT NULL AUTO_INCREMENT COMMENT '用户ID',
       userName VARCHAR(20) NOT NULL COMMENT '用户名称',
       password VARCHAR(20) NOT NULL COMMENT '用户密码',
       email VARCHAR(20) NOT NULL COMMENT '用户邮箱',
       birthday DATETIME(6) NOT NULL COMMENT '用户生日',
       gender bit(1) NOT NULL COMMENT '用户性别',
       phone VARCHAR(15) NOT NULL COMMENT '用户手机',
       userTypeId INT(8) NOT NULL COMMENT '用户类型ID',
       registerTime DATETIME(6) NOT NULL COMMENT '用户注册时间',
       userPoint INT(8) NOT NULL COMMENT '用户积分',
       userClass INT(8) NOT NULL COMMENT '用户等级',
       userStatement VARCHAR(150) NOT NULL COMMENT '用户个人说明档',
       boardId INT(8) NOT NULL COMMENT '用户所在板面',
       CONSTRAINT pk_userId PRIMARY KEY(userId)
);
       3.板块表board
CREATE TABLE board(
       boardId INT(8) NOT NULL AUTO_INCREMENT COMMENT '板块ID',
       boardName VARCHAR(20) NOT NULL COMMENT '板块名称',
       masterUserId INT(8) NOT NULL COMMENT '板主用户ID',
       boardStatement VARCHAR(150) NOT NULL COMMENT '板块说明',
       onlineCount INT(8) NOT NULL COMMENT '板块在线人数',
       postCount INT(8) NOT NULL COMMENT '板块主帖数',
       daypostCount INT(8) NOT NULL COMMENT '板块当日主帖数',
       CONSTRAINT pk_boardId PRIMARY KEY(boardId)
);
       4.主帖表topic
CREATE TABLE topic(
       topicId INT(8) NOT NULL AUTO_INCREMENT COMMENT '主帖ID',
       topicTitle VARCHAR(255) NOT NULL COMMENT '主帖标题',
       topicContent VARCHAR(2048) NOT NULL COMMENT '主帖内容',
       postTime DATETIME(6) NOT NULL COMMENT '发帖时间',
       lastUpdateTime DATETIME(6) NOT NULL COMMENT '最后更新时间',
       userId INT(8) NOT NULL COMMENT '发帖用户ID',
       boardId INT(8) NOT NULL COMMENT '板块ID',
       CONSTRAINT pk_topicId PRIMARY KEY(topicId)
);
       5.回帖表reply
CREATE TABLE reply(
       replyId INT(8) NOT NULL AUTO_INCREMENT COMMENT '回帖ID',
       topicId INT(8) NOT NULL COMMENT '主帖ID',
       replyContent VARCHAR(1024) NOT NULL COMMENT '回帖内容',
       replyTime DATETIME(6) NOT NULL COMMENT '回帖时间',
       lastUpdateTime DATETIME(6) NOT NULL COMMENT '回帖最后更新时间',
       userId INT(8) NOT NULL COMMENT '发帖用户ID',
       CONSTRAINT pk_replyId PRIMARY KEY(replyId)
);
20.3.2 设计索引
       1.在topic表上建立索引
CREATE INDEX index_topic_title ON topic(topicTitle);
ALTER TABLE topic ADD INDEX index_post_time(postTime);
SHOW CREATE TABLE topic \G
       2.在board表上建立索引
CREATE INDEX index_board_name ON board(boardName);
SHOW CREATE TABLE board \G
       3.在reply表上建立索引
CREATE INDEX index_reply_content ON reply(replyContent);
CREATE INDEX index_reply_time ON reply(replyTime);
SHOW CREATE TABLE reply \G
20.3.3 设计视图
CREATE VIEW topic_user_board_view AS
       SELECT t.topicTitle,t.topicContent,u.userName,t.postTime,b.boardName
       FROM topic t,user u,board b
       WHERE t.userId=u.userId AND t.boardId=b.boardId;
SHOW CREATE VIEW topic_user_board_view \G
20.3.4 设计触发器
       1.设计INSERT触发器
DELIMITER $$
CREATE TRIGGER topic_count AFTER INSERT
ON topic FOR EACH ROW
   BEGIN
   UPDATE board SET postCount=postCount+1 WHERE boardId=NEW.boardId;
   UPDATE board SET dayPostCount=dayPostCount+1 WHERE boardId=NEW.boardId;
   END;
   $$
DELIMITER ;
       2.设计UPDATE触发器
DELIMITER $$
CREATE TRIGGER update_online_count AFTER UPDATE
ON USER FOR EACH ROW
   BEGIN
   UPDATE board SET onlineCount=onlineCount+1 WHERE boardId=NEW.boardId;
   UPDATE board SET onlineCount=onlineCount-1 WHERE boardId=OLD.boardId;
   END;
   $$
DELIMITER ;
       3.设计DELETE触发器
DELIMITER $$
CREATE TRIGGER delete_user_count AFTER DELETE
ON USER FOR EACH ROW
   BEGIN
   DELETE FROM topic WHERE userId=OLD.userId;
   DELETE FROM reply WHERE userId=OLD.userId;
   END;
   $$
DELIMITER ;
20.4 本章小结
     本章介绍了论坛数据库系统的设计方法，涉及了表和字段，索引，视图，
触发器等内容。特别是增加了设计方案图表，通过图表的设计，用户可以清晰
的看到各个表的设计字段之间的关系。通过学习，读者可对论坛系统数据库的
设计有一个清晰的思路。
