/****************************�ھ���***************************/

/*9.1 ��ϵ���ݲ���

����UNION��
�ѿ�������CARTESIAN PRODUCT��
9.1.1 ����UNION��
���������ǰѾ�����ͬ�ֶ���Ŀ���ֶ����͵ı�ϲ���һ��
9.1.2 �ѿ�������CARTESIAN PRODUCT��
�ѿ���������û�������������ϵ���صĽ����*/

/*9.2 �����Ӳ�ѯ

��MySQL�п���ͨ�������﷨��ʵ�����Ӳ�ѯ��һ������FROM����ͨ������
���ֶ������WHERE�Ӿ���ͨ���߼����ʽ��ʵ��ƥ���������Ӷ�ʵ�ֱ����

�ӡ���һ����ANSI�����﷨��ʽ����FROM�Ӿ���ʹ��JOIN...ON�ؼ��֣�������

��д�ڹؼ���ON�Ӿ��С��Ƽ�ʹ��ANSI��ʽ�����ӡ�
SELECT field1,...,fieldn FROM tablename1 INNER JOIN tablename2 [INNER

JOIN tablenamen] ON CONDITION
MySQLȡ�������ƣ�
SELECT field1,...,fieldn [AS] otherfieldn
FROM tablename1 [AS] othertablename1,...,
tablenamen [AS] othertablenamen
��ƥ����������ӷ��������ࣺ
�����ӣ�
��ֵ���ӣ�
�������ӡ�*/
/*9.2.1 ������ ��������������*/
/*��ѯAlicia Florric ���ڰ༶��ѧ��*/
USE school;
CREATE TABLE t9_student(
stuid INT(10) DEFAULT NULL,
name VARCHAR(20) DEFAULT NULL,
gender VARCHAR(10) DEFAULT NULL,
age INT(4) DEFAULT NULL,
classno INT(11) DEFAULT NULL)DEFAULT CHARACTER SET UTF8 ENGINE=INNODB;
INSERT INTO t9_student(stuid,name,gender,age,classno)
VALUES(1001,'Alicia Florric','Female',33,1),
(1002,'Kalinda Sharma','Female',31,1),
(1003,'Cary Agos','Male',27,1),
(1004,'Diane Lockhart','Female',43,2),
(1005,'Eli Gold','Male',44,3),
(1006,'Peter Florric','Male',34,3),
(1007,'Will Gardner','Male',38,2),
(1008,'Jacquiline Florriok','Male',38,4),
(1009,'Zach Florriok','Male',14,4),
(1010,'Grace Florriok','Male',12,4);
SELECT * FROM t9_student;
SELECT ts.name,ts.classno FROM t9_student AS ts,t9_student AS ts1
WHERE ts.classno=ts1.classno AND ts1.name='Alicia Florric';
/*9.2.2 ��ֵ���� �����Ӳ�ѯ�еĵ�ֵ���ӣ�������ON�ؼ��ֺ��ƥ��������
ͨ�����ڹ�ϵ�������=����ʵ�ֵ�ֵ������*/
/*ʾ����ִ��SQL���INNER JOIN ... ON �������ݿ�school�У���ѯÿ��ѧ��

�ı�ţ��������Ա����䣬�༶�ţ��༶���ƣ��༶��ַ����������Ϣ��*/
USE school;
CREATE TABLE t9_class(
classno VARCHAR(11) DEFAULT NULL,
cname VARCHAR(20) DEFAULT NULL,
loc VARCHAR(40) DEFAULT NULL,
advisor VARCHAR(20) DEFAULT NULL)DEFAULT CHARACTER SET UTF8
ENGINE=INNODB;
INSERT INTO t9_class(classno,cname,loc,advisor) VALUES
(1,'class_1','loc_1','advisor_1'),
(2,'class_2','loc_2','advisor_2'),
(3,'class_3','loc_3','advisor_3'),
(4,'class_4','loc_4','advisor_4');
SELECT s.stuid,s.name,s.gender,s.age,s.classno,c.cname,c.loc,c.advisor
FROM t9_student s INNER JOIN t9_class c ON s.classno=c.classno;
/*ʾ���������ݿ�school�У���ѯÿ��ѧ���ı�ţ��������Ա����䣬�༶�ţ�
�༶���ƣ��༶��ַ�������Σ��ɼ��ܷ���Ϣ��*/
USE school;
CREATE TABLE t9_score(
stuid INT(11),
Chinese INT(4),
English INT(4),
Math INT(4),
Chemistry INT(4),
Physics INT(4));
INSERT INTO t9_score(stuid,Chinese,English,Math,Chemistry,Physics)
VALUES
(1001,90,89,92,83,80),
(1002,92,98,92,93,90),
(1003,79,78,82,83,89),
(1004,89,92,91,92,89),
(1005,92,95,91,96,97),
(1006,90,91,92,94,92),
(1007,91,90,83,88,93),
(1008,90,81,84,86,98),
(1009,91,84,85,86,93),
(1010,88,81,82,84,99);
SELECT s.stuid,s.name,s.gender,s.age,s.classno,c.cname,c.loc,c.advisor,
sc.Chinese+sc.English+sc.Math+sc.Chemistry+sc.Physics total
FROM t9_student s INNER JOIN t9_class c ON s.classno=c.classno
INNER JOIN t9_score sc ON s.stuid=sc.stuid;
/*9.2.3 ��������*/
/*�ڲ�ѯ�еĲ������Ӿ����ڹؼ���ON���ƥ�������г��˵��ڹ�ϵ�������ʵ

�ֲ��������⣬����ʹ�õĹ�ϵ���������>,>=,<,<=,!=�������*/
/*��ѯ��ѧ����Alicia Florric������ͬһ���༶��������ڡ�Alicia

Florric����ѧ����ţ��������Ա����䣬�༶�ţ�
�༶���ƣ��༶��ַ�������Σ��ɼ��ܷ���Ϣ*/
SELECT
s.stuid,s.name,s.gender,s.age,s.classno,c.cname,c.loc,c.advisor,
sc.Chinese+sc.English+sc.Math+sc.Chemistry+sc.Physics total
FROM t9_student s INNER JOIN t9_student s1 ON s.classno!=s1.classno
AND s.age>s1.age AND s1.name='Alicia Florric'
INNER JOIN t9_class c ON s.classno=c.classno
INNER JOIN t9_score sc ON s.stuid=sc.stuid;

/*9.3 �����Ӳ�ѯ*/

/*��MySQL�������Ӳ�ѯ�᷵����������������һ������������ݡ�
�﷨��
SELECT field1,...,fieldn FROM tablename LEFT|RIGHT|FULL [OUTER] JOIN
tablename1 ON CONDITION*/
/*9.3.1 ��������*/
/*ʾ���������ݿ�school�У���ѯ����ѧ����ѧ�ţ��������༶��ţ��༶����
�༶��ַ����������Ϣ*/
INSERT INTO t9_student(stuid,name,gender,age,classno) VALUES
(1011,'Maia Rindell','Female',33,5);
SELECT s.stuid,s.name,s.classno,c.cname,c.loc,c.advisor
FROM t9_student s LEFT JOIN t9_class c ON s.classno=c.classno;
/*9.3.2 ��������*/
/*ʾ������ѯ���а༶������ѧ����Ϣ*/
INSERT INTO t9_class(classno,cname,loc,advisor)
VALUES(6,'class_6','loc_6','advisor_6');
SELECT s.stuid,s.name,s.gender,s.age,c.classno,c.cname,c.loc,c.advisor
FROM t9_student s RIGHT OUTER JOIN t9_class c ON s.classno=c.classno;

/*mysqlĬ�ϲ�֧��FULL JOIN����ʹ��UNION��ʵ��*/

/*9.4 �����������Ӳ�ѯ*/

/*�����������Ӳ�ѯ�������Ӳ�ѯ�Ĺ����У�ͨ����ӹ����������Ʋ�ѯ�Ľ����
ʹ��ѯ�������׼ȷ��
*/
/*ʾ������ѯ���гɼ��ֳܷ���450�ֵ�ѧ���ı�ţ��������Ա����䣬�༶

�ţ��༶���ƣ��༶λ�ã������Σ��ɼ��ܷ֡�*/
USE school;
SELECT s.stuid,s.name,s.gender,s.age,s.classno,c.cname,c.loc,c.advisor,
sc.Chinese+sc.English+sc.Math+sc.Chemistry+sc.Physics total
FROM t9_student s INNER JOIN t9_class c ON s.classno=c.classno
INNER JOIN t9_score sc ON s.stuid=sc.stuid AND
sc.Chinese+sc.English+sc.Math+sc.Chemistry+sc.Physics>450;

SELECT s.stuid,s.name,s.gender,s.age,s.classno,c.cname,c.loc,c.advisor,
sc.Chinese+sc.English+sc.Math+sc.Chemistry+sc.Physics total
FROM t9_student s INNER JOIN t9_class c ON s.classno=c.classno
INNER JOIN t9_score sc ON s.stuid=sc.stuid ORDER BY
sc.Chinese+sc.English+sc.Math+sc.Chemistry+sc.Physics;

/*
9.5 �ϲ���ѯ���ݼ�¼*/

/*��MySQL��ͨ���ؼ���UNION��ʵ�ֲ�������������ͨ���佫���SELECT����

�����ϲ���һ������µĹ�ϵ���﷨���£�
SELECT field1,field2,...,fieldn FROM tablename1
UNION | UNION ALL
SELECT field1,field2,...,fieldn FROM tablename2
UNION | UNION ALL
SELECT field1,field2,...,fieldn FROM tablenamen
...
*/
/*9.5.1 ���йؼ���UNION�Ĳ�����*/
/*ʾ���������ݿ�company�У��ϲ�����������Ա�Ͳ��Բ�����Ա��Ϣ*/
CREATE DATABASE company DEFAULT CHARACTER SET UTF8;
USE company;
CREATE TABLE t_developer(
id INT(4),
name VARCHAR(20),
gender VARCHAR(6),
age INT(4),
salary INT(6),
deptno INT(4)
);
DESCRIBE t_developer;
INSERT INTO t_developer(id,name,gender,age,salary,deptno)
VALUES(1001,'Alicia Florric','Female',33,10000,1),
(1002,'Kalinda Sharma','Female',31,9000,1),
(1003,'Cary Agos','Male',27,8000,1),
(1004,'Eli Gold','Male',44,20000,1),
(1005,'Peter Florric','Male',34,30000,1);
CREATE TABLE t_tester(
id INT(4),
name VARCHAR(20),
gender VARCHAR(6),
age INT(4),
salary INT(6),
deptno INT(4)
);
DESCRIBE t_tester;
INSERT INTO t_tester(id,name,gender,age,salary,deptno)
VALUES(1006,'Diane Lockhart','Female',43,50000,2),
(1007,'Maia Rindell','Female',27,9000,2),
(1008,'Will Gardner','Male',36,9000,2),
(1009,'Jacquiline Florric','Female',57,7000,2),
(1010,'Zach Florric','Male',17,5000,2),
(1002,'Kalinda Sharma','Female',31,9000,1);
/*UNIONͬʱ��ȥ���ظ�����*/
SELECT * FROM t_developer UNION SELECT * FROM t_tester;
/*9.5.2 ���йؼ���UNION ALL�Ĳ�����*/
SELECT * FROM t_developer UNION ALL SELECT * FROM t_tester;
/*UNION ALL�����ظ����ݣ������ű���������ݺϲ���ʾ*/

/*9.6 �Ӳ�ѯ

�Ӳ�ѯ�ǽ�һ����ѯ���Ƕ������һ����ѯ����У��ڲ��ѯ���������
Ϊ����ѯ����ṩ��ѯ������*/
/*9.6.1 Ϊʲôʹ���Ӳ�ѯ
�����������ʱ����еѿ�������������������ʱ���������*/
/*9.6.2 ���Ƚ���������Ӳ�ѯ*/
/*�Ƚ����������=,!=,>,>=,<,<=��<>*/
/*�����ݿ�company�У���ѯн��ˮƽΪ�߼���Ա����ţ��������Ա������
���ʡ�*/
USE company;
CREATE TABLE t_employee(
id INT(4),
name VARCHAR(20),
gender VARCHAR(6),
age INT(4),
salary INT(6),
deptno INT(4)
);
DESCRIBE t_employee;
INSERT INTO t_employee(id,name,gender,age,salary,deptno)
VALUES
(1001,'Alicia Florric','Female',33,10000,1),
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
SELECT * FROM t_employee;
CREATE TABLE t_slevel(
id INT(4),
salary INT(6),
level INT(4),
description VARCHAR(20)
);
INSERT INTO t_slevel(id,salary,level,description)
VALUES(1,3000,1,'����'),
(2,7000,2,'�м�'),
(3,10000,3,'�߼�'),
(4,20000,4,'�ؼ�'),
(5,30000,5,'�߹�');
SELECT * FROM t_slevel;
SELECT * FROM t_employee
WHERE salary>=(SELECT salary FROM t_slevel WHERE level=3)
AND salary<(SELECT salary FROM t_slevel WHERE level=4);
/*��ѯ��Щ����û��33���Ա��*/
CREATE TABLE t_dept(
deptno INT(4),
deptname VARCHAR(20),
product VARCHAR(20),
location VARCHAR(20)
);
INSERT INTO t_dept(deptno,deptname,product,location)
VALUES
(1,'develop department','pivot_gaea','west_3'),
(2,'test department','sky_start','east_4'),
(3,'operate department','cloud_4','south_4'),
(4,'maintain department','fly_4','north_5');
SELECT * FROM t_dept WHERE deptno !=
(SELECT deptno FROM t_employee WHERE age=33);
/*9.6.3 ���ؼ���IN�Ĳ�ѯ*/
/*��ѯ���ݿ�company��Ա����t_employee�����ݼ�¼����Щ��¼���ֶ�deptno

������t_dept�г��ֹ�
*/
SELECT * FROM t_employee WHERE deptno IN
(SELECT deptno FROM t_dept);
/*��ѯ���ݿ�company��Ա����t_employee�����ݼ�¼����Щ��¼���ֶ�deptno
������t_dept��û�г��ֹ�
*/
SELECT * FROM t_employee WHERE deptno NOT IN
(SELECT deptno FROM t_dept);
/*9.6.4 ���ؼ���EXISTS���Ӳ�ѯ*/
/*EXISTS��ʾ���ڣ����Ӳ�ѯ�����д���0��ʱ��EXISTS�Ľ��ΪTRUE����ʱִ

������ѯ��������Ϊ��ʱ��EXISTS���Ϊfalse������ѯ��ִ��*/
/*ʾ������ѯ���ݿ�company�ı�t_dept�д���deptnoΪ4�Ĳ�����ִ�в�ѯ
t_employee���м�¼��Ϣ
*/
USE company;
SELECT * FROM t_employee
WHERE EXISTS(SELECT deptname FROM t_dept WHERE deptno=4);
/*ʾ������ѯ���ݿ�company�ı�t_dept�д���deptnoΪ4�Ĳ�����ִ�в�ѯ
t_employee�����������40�ļ�¼��Ϣ��
*/
SELECT * FROM t_employee WHERE age>40
AND EXISTS(SELECT deptname FROM t_dept WHERE deptno=4);
/*9.6.5 ���ؼ���ANY�Ĳ�ѯ*/
/*�ؼ���ANY��ʾ����������һ������ʹ�ùؼ���ANYʱ��ֻҪ�����ڲ��ѯ���
���ؽ���е��κ�һ�����Ϳ���ͨ������ִ������ѯ��*/
/*ʾ������ѯ���ݿ�school��t9_student����Щѧ�����Ի�ý�ѧ�𣬳ɼ���Ϣ

��t9_score���У���ѧ����Ϣ��t9_scholarship��*/
USE school;
CREATE TABLE t9_scholarship(
id INT(4),
score INT(4),
level INT(4),
description VARCHAR(20)
);
INSERT INTO t9_scholarship(id,score,level,description)
VALUES(1,430,3,'���Ƚ�ѧ��'),
(2,440,2,'���Ƚ�ѧ��'),
(3,450,1,'һ�Ƚ�ѧ��');
SELECT st.stuid,st.name,sc.Chinese+sc.English+sc.Math+sc.Chemistry+sc.Physics total
FROM t9_student st INNER JOIN t9_score sc
ON st.stuid=sc.stuid AND st.stuid
IN(
SELECT stuid FROM t9_score WHERE Chinese+English+Math+Chemistry+Physics>=ANY(SELECT score FROM t9_scholarship)
);
/*9.6.6 ���ؼ���ALL�Ĳ�ѯ*/
/*�ؼ���ALL��ʾ��������������ʹ��ALLʱ��ֻ�������ڲ��ѯ��䷵�ص�����
�������ִ�������䡣*/
/*ʾ������ѯ���ݿ�school��t9_student����Щѧ�����Ի��һ�Ƚ�ѧ�𣬳ɼ���Ϣ

��t9_score���У���ѧ����Ϣ��t9_scholarship��*/
SELECT st.stuid,st.name,sc.Chinese+sc.English+sc.Math+sc.Chemistry+sc.Physics total
FROM t9_student st INNER JOIN t9_score sc
ON st.stuid=sc.stuid AND st.stuid
IN(
SELECT stuid FROM t9_score WHERE Chinese+English+Math+Chemistry+Physics>=ALL(SELECT score FROM t9_scholarship)
);
/*9.7 �ۺ�ʾ��----��ѯѧ���ɼ�*/
/*ʹ�����ݿ�school�е�t_stu���t_sco�������Ӳ�ѯ��ʽ��ѯ����ѧ��ID�������Ϳ�����Ϣ*/
SELECT s.id,name,c_name,grade FROM t_stu s,t_sco c WHERE s.id=c.s_id;
/*����ÿ��ѧ�����ܳɼ�*/
SELECT s.id,name,SUM(grade) FROM t_stu s,t_sco c WHERE s.id=c.s_id GROUP BY s.id;
/*����ÿ��ѧ����ƽ���ɼ�*/
SELECT s.id,name,AVG(grade) FROM t_stu s,t_sco c WHERE s.id=c.s_id GROUP BY s.id;
/*��ѯ������ɼ�����85��ѧ������Ϣ*/
SELECT * FROM t_stu WHERE id IN(SELECT s_id FROM t_sco WHERE c_name='�����' AND grade<85);
/*��ѯ�μ����ĺͼ�������Ե�ѧ������Ϣ��*/
SELECT * FROM t_stu WHERE id=ANY
(SELECT s_id FROM t_sco WHERE s_id IN(SELECT s_id FROM t_sco WHERE c_name='����') AND c_name='�����');
/*��ѯ�����������ͬѧ��������Ժϵ�����Կ�Ŀ�ͳɼ�*/
SELECT name,department,c_name,grade FROM t_stu s,t_sco c
WHERE (s.name LIKE '��%' OR s.name LIKE '��%') AND s.id=c.s_id;
/*��ѯ������ͬѧ���������Ա����䣬Ժϵ�����Կ�Ŀ�ͳɼ���*/
SELECT NAME,sex,birthday,department,c_name,grade FROM t_stu s,t_sco c
WHERE s.address LIKE '���%' AND s.id=c.s_id;
/*9.8 ����ϰ����������*/
/*1.����ϰ��
	��company���ݿ��д������ű�t_dept_e��Ա����t_employee_e
*/
USE company;
CREATE TABLE t_dept_e(
id INT(4) NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT '����ID',
name VARCHAR(20) COMMENT '��������',
function VARCHAR(20) COMMENT '����ְ��',
description VARCHAR(20) COMMENT '��������');
CREATE TABLE t_employee_e(
id INT(4) NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT 'Ա��ID',
name VARCHAR(20) COMMENT 'Ա������',
gender VARCHAR(20) COMMENT '�Ա�',
age VARCHAR(20) COMMENT '����',
salary INT(6) COMMENT '����',
deptid INT(4) COMMENT '����ID');
/*(1)ʹ��LIMIT�ؼ�������ѯ������ߵ�Ա����Ϣ*/
INSERT INTO t_employee_e(id,name,gender,age,salary,deptid)
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
SELECT * FROM t_employee_e ORDER BY salary DESC LIMIT 1;
/*(2)��������Ա����Ů��Ա����ƽ������*/
SELECT gender,AVG(salary) FROM t_employee_e GROUP BY gender;
/*(3)��ѯ�������35���Ա�����������Ա�����Ͳ�������*/
INSERT INTO t_dept_e(id,name,function,description)
VALUES(1,'develop department','pivot_gaea','west_3'),
(2,'test department','sky_start','east_4'),
(3,'operate department','cloud_4','south_4'),
(4,'maintain department','fly_4','north_5'),
(5,'algorithm department','����㷨','center');
SELECT e.name,gender,age,d.name FROM t_employee_e e
INNER JOIN t_dept_e d ON e.age<35 AND e.deptid=d.id;
/*(4)�������ӵķ�ʽ��ѯt_dept_e���t_employee_e��*/
INSERT INTO t_employee_e(id,name,gender,age,salary,deptid)
VALUES(1012,'Jack Wang','Male',23,90000,6);
SELECT e.id,e.name,gender,age,salary,deptid,d.name,d.function,d.description
FROM t_dept_e d RIGHT JOIN t_employee_e e ON d.id=e.deptid;
/*(5)��ѯ��������ĸK��ͷ��Ա�����������Ա����䣬���ź͹����ص�*/
SELECT e.name,gender,age,d.name,description FROM t_employee_e e
INNER JOIN t_dept_e d ON e.deptid=d.id AND e.name REGEXP '^K';
/*(6)��ѯ����С��30���ߴ���40���Ա����Ϣ*/
SELECT * FROM t_employee_e WHERE age<30 OR age>40;
SELECT e.name,gender,age,`salary`,d.name,description FROM t_employee_e e
INNER JOIN t_dept_e d ON e.deptid=d.id AND (e.age<30 OR e.age>40) ORDER BY age;
/*�����������Ľ��������һ�£���ӵ��ɻ�����*/
/*2.�����⼰���
��1����WHERE �Ӿ��б���ʹ��Բ������
��2�������������ʲô�ã�*/
/*----9.9 ����С��---------*/
/*���´ӹ�ϵ���ݿ�����еĴ�ͳ����Ͷ�����Ӳ�ѯ������������ܡ�
ǰ�߽����˲����㣬�ѿ��������㣬���߽����������Ӻ������Ӳ�ѯ��
���������Ӱ��������ӣ���ֵ���ӣ�����ֵ���ӣ������Ӱ���������������ӣ�
ͬʱ�������˺ϲ���ѯ��¼����;�����Ӳ�ѯ��ϸ�����˴��Ƚ���������Ӳ�ѯ��
���ؼ���IN��EXISTS,ANY,ALL���Ӳ�ѯ��*/
