/******第十九章 网上课堂系统数据库设计******/
本讲内容：
	了解网上课堂系统的概述
	熟悉网上课堂系统的功能
	掌握如何设计网上课堂系统的表
	掌握如何设计网上课堂系统的索引
	掌握如何设计网上课堂系统的视图
	掌握如何设计网上课堂系统的触发器
19.1 系统概述
     互联网已经渗透到人们工作学习的方方面面，应用非常广泛，在此环境下，
每人都需要提高知识水平和工作效率，网上课堂系统数据库设计，管理员可以通过
该系统发布新闻信息和管理新闻信息。一个典型的网上系统至少包含课目管理、
课目信息显示和课目信息查询三种功能。
19.2 系统功能
     （1）用户管理：提供用户基本信息的增加、查询、修改以及删除的功能，拥有
用户信息的用户可以登陆系统进行课件的发布。
     （2）角色管理：角色可以分为三大类，系统管理员负责系统信息的管理和维护，
为系统初始化课程结构，赋予用户不同的角色权限；教师负责系统课程的管理、更新和
发布，并对学员的提问进行解答；学员可以查看、检索科目。
     （3）权限管理：系统权限分为课程类型的增加、查询、修改和删除权限，课件的
上传、浏览、查询、编辑和删除权限，评论的阅读、发表、修改和删除权限。
     （4）课程目录管理：系统管理员根据实际业务，为课程分门别类，有效组织课程
结构，对课程目录进行增加、查询、修改和删除操作。
     （5）课程管理：各相关部门的老师或负责人可针对本部门的业务需求发布不同类别
的课程，课程由多个课件构成，可以上传各种格式的视频、音频、文档课件，也可以删除
课件；老师和学员都可以浏览、检索课件。
     （6）系统公共信息：管理员可以发布与系统和维护相关的公告信息，也可以删除一些
恶意的评论，帮助网上课堂更好的运营。
19.3 数据库设计和实现
19.3.1 设计表
       本系统所有表都在webcourse数据库下。
       创建webcourse数据库。
CREATE DATABASE webcourse DEFAULT CHARACTER SET utf8;
       在该数据库下总共有九张表，分别是用户表user、管理员表admin、角色表role、
权限表authority、角色权限关系表role_authority、课程分类表courseCatalog、课程表
course、媒体类型表mediaType、评论表comment。
	--1.角色表role
	角色表中存储角色ID和角色名称，角色表中内容是固定的，由管理员初始化好，网络
系统中角色分为管理员，老师，普通用户。
CREATE TABLE role(
       roleId INT(8) UNIQUE NOT NULL AUTO_INCREMENT COMMENT '角色ID',
       roleName VARCHAR(20) COMMENT '角色名称',CONSTRAINT pk_id PRIMARY KEY(roleId)
);
INSERT INTO role VALUES(1,'管理员'),(2,'老师'),(3,'普通用户');
       --2.权限表authority
       权限表中存储权限ID和权限名称，权限表的内容由管理员初始化好。
CREATE TABLE authority(
       authorityId INT(8) UNIQUE NOT NULL AUTO_INCREMENT COMMENT '权限ID',
       authorityName VARCHAR(20) COMMENT '权限名称',
       CONSTRAINT pk_id PRIMARY KEY(authorityId)
);
INSERT INTO authority VALUES(1,'增加课程类型'),(2,'修改课程类型'),(3,'删除课程类型'),(4,'浏览课程类型'),
(5,'课件上传'),(6,'课件浏览'),(7,'课件查询'),(8,'课件删除'),(9,'课件编辑'),
(10,'阅读评论'),(11,'发表评论'),(12,'修改评论'),(13,'删除评论');
	--3.角色权限关系表role_authority
	role_authority表存储角色权限ID，角色ID和权限ID，表的内容是固定的，由管理员初始化好。
CREATE TABLE role_authority(
       raId INT(8) UNIQUE NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT '角色权限ID',
       roleId INT(8) NOT NULL COMMENT '角色ID',
       authorityId INT(8) NOT NULL
);
INSERT INTO role_authority VALUES(1,1,1),(2,1,2),(3,1,3),(4,1,4),(5,1,5),(6,1,6),
(7,1,7),(8,1,8),(9,1,9),(10,1,10),(11,1,11),(12,1,12),(13,1,13),
(14,2,4),(15,2,5),(16,2,6),(17,2,7),(18,2,10),(19,2,11),
(20,3,4),(21,3,6),(22,3,7),(23,3,10),(24,3,11);
	--4.用户表user
CREATE TABLE user(
       userId INT(8) KEY UNIQUE NOT NULL AUTO_INCREMENT,--KEY等价于PRIMARY KEY
       userName VARCHAR(20) NOT NULL,
       userPassword VARCHAR(20) NOT NULL,
       gender VARCHAR(8) NOT NULL,
       userEmail VARCHAR(20) NOT NULL,
       userPhoneNumber VARCHAR(15),
       roleId INT(8)DEFAULT 3
);
	--5.管理员表admin
CREATE TABLE admin(
       adminId INT(8) NOT NULL AUTO_INCREMENT,
       adminName VARCHAR(20) NOT NULL,
       adminPassword VARCHAR(20) NOT NULL,
       userId INT(8) NOT NULL,
       CONSTRAINT pk_id PRIMARY KEY(adminId)
);
	--6.课程分类表courseCatalog
CREATE TABLE courseCatalog(
       cCatalog INT(8) PRIMARY KEY NOT NULL AUTO_INCREMENT,
       cCatalogName VARCHAR(20) NOT NULL,
       parentId INT(8) NOT NULL,
       description VARCHAR(50) NOT NULL
);
	--7.课程表course
CREATE TABLE `course` (
  `courseId` int(8) NOT NULL AUTO_INCREMENT COMMENT '课程ID，自增1',
  `courseName` varchar(20) NOT NULL COMMENT '课程名称',
  `courseCatalogId` int(8) NOT NULL COMMENT '课程所属分类',
  `description` varchar(50) NOT NULL COMMENT '课程分类描述',
  `mediaTypeId` int(8) NOT NULL COMMENT '媒体类型ID',
  `uploadDate` datetime(6) NOT NULL COMMENT '课程上传时间',
  `userId` int(8) NOT NULL COMMENT '上传用户ID',
  KEY `courseId` (`courseId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
--8.媒体类型表mediaType
CREATE TABLE `mediatype` (
  `mediaId` int(8) NOT NULL AUTO_INCREMENT COMMENT '媒体类型，自增1',
  `mediaName` varchar(20) NOT NULL COMMENT '媒体名称',
  `icon` varchar(50) NOT NULL COMMENT '图标',
  `isMultipary` bit(1) NOT NULL COMMENT '是否二进制内容',
  `mimeType` varchar(256) NOT NULL COMMENT 'MIME类型',
  `maxLength` int(4) NOT NULL COMMENT '最大允许文件长度',
  PRIMARY KEY (`mediaId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='媒体类型表'  ;
	--9.评论表comment
CREATE TABLE `comment` (
  `commentId` int(8) NOT NULL COMMENT '评论ID，自增1',
  `commentContent` varchar(100) NOT NULL COMMENT '评论内容',
  `userId` int(8) NOT NULL COMMENT '评论者ID',
  `courseId` int(8) NOT NULL COMMENT '被评论课程ID',
  `uploadDate` datetime(6) NOT NULL COMMENT '发表评论时间',
  `editDate` datetime(6) NOT NULL COMMENT '修改评论时间',
  `deleteDate` datetime(6) NOT NULL COMMENT '删除评论时间(逻辑删除)',
  `logicDeleteBit` bit(1) NOT NULL COMMENT '逻辑删除位',
  PRIMARY KEY (`commentId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='评论表';
19.3.2 设计索引
       1.在course表上建立索引
CREATE INDEX index_course_name ON course(courseName);
ALTER TABLE course ADD INDEX index_upload_date(uploadDate);
      检验表course中索引是否创建成功
SHOW CREATE TABLE course \G
EXPLAIN SELECT * FROM course WHERE courseName='Java' \G
EXPLAIN SELECT * FROM course WHERE uploadDate='2019-02-16 12:50:30' \G
	2.在courseCatalog表上建立索引
CREATE INDEX index_course_catalog_name ON courseCatalog(cCatalogName);
SHOW CREATE TABLE courseCatalog \G
EXPLAIN SELECT * FROM courseCatalog WHERE cCatalogName='计算机' \G
19.3.3 设计视图
       为了查询方便，可以建立一个视图role_authroty_view，它显示角色编号，角色名称，
权限编号，权限名称，这样就可以直观地看出每个角色具有哪些权限。
CREATE VIEW role_authority_view AS
	SELECT role_authority.`roleId`,role.`roleName`,authority.`authorityName`
	FROM role_authority,role,authority
	WHERE role_authority.`roleId`=role.`roleId` AND role_authority.`authorityId`=authority.`authorityId`;
查看视图详细信息
SHOW CREATE VIEW role_authority_view \G
19.3.4 设计触发器
       由于comment表中的courseId与course表中courseId有关联，根据此设计相应触发器。
       1.设计UPDATE触发器
DELIMITER $$
USE `webcourse`$$

DROP TRIGGER /*!50032 IF EXISTS */ `update_courseId`$$

CREATE
    /*!50017 DEFINER = 'root'@'%' */
    TRIGGER `update_courseId` AFTER UPDATE ON `course`
    FOR EACH ROW BEGIN
	UPDATE `webcourse`.comment SET courseId=new.courseId;
    END;
$$
DELIMITER ;
       2.设计DELETE触发器
DELIMITER $$

CREATE
    /*[DEFINER = { user | CURRENT_USER }]*/
    TRIGGER `webcourse`.`delete_comment` AFTER DELETE
    ON `webcourse`.`course`
    FOR EACH ROW BEGIN
	DELETE FROM `webcourse`.`comment` WHERE courseId=old.courseId;
    END$$
DELIMITER ;
19.4 本章小结
     本章介绍了网上课堂系统数据库设计方法，重点是MySQL数据库的设计部分，在数据库
设计方面，不仅设计了表和字段，还设计了索引，视图和触发器。通过学习对MySQL数据库设计
有一个基本的认识。
