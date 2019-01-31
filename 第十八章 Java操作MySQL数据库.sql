-----------------第十八章 Java操作MySQL数据库-------------------
本章内容：
  Java连接MySQL数据库
  Java操作MySQL数据库
  Java备份MySQL数据库
  Java恢复MySQL数据库
  完整的在线人力资源管理系统案例
8.1 Java连接MySQL数据库
18.1.1 JDBC简介（跨平台，可移植）
  全称Java DataBase Connectivity，它是一种可以执行SQL语句的Java API。
程序可以通过Java API连接到MySQL数据库，并使用SQL语句对数据进行增加，删除，
更改和查询操作。
18.1.2 下载JDBC驱动MySQL Connector/J
  https://dev.mysql.com/downloads/connector/j/
18.1.3 Windows下安装MySQL Connector/J驱动
18.1.4 Linux和Mac OS X下安装MySQL Connector/J驱动
18.1.5 Eclipse环境下安装MySQL Connector/J驱动
18.1.6 Java连接MySQL数据库
DriverManager类：用于管理JDBC驱动服务器，主要用于管理驱动程序和连接数据库，程序中
使用该类主要功能是获取Connection对象。
Connection接口：代表数据库连接对象，主要用于管理建立好的数据库连接，每个Connection
代表一个物理连接对话。要想访问数据库必须获得数据库连接。
Statement接口：用于执行SQL语句的接口。
PreparedStatement接口：预编译的Statement对象，是Statement的子接口，它允许数据库预编译SQL
语句，以后每次只改变SQL命令的参数，避免数据库每次编译SQL语句，因此性能更好。
Result接口：结果集对象，主要用于存储数据库返回的记录，该对象包含访问查询的方法，可以通过索引
或列名获得列数据。
【示例18-1】连接本地MySQLo数据库，默认端口3306，登陆账户root，密码123456，连接的数据库为
company，编码格式UTF-8。具体步骤：
步骤一：加载MySQL驱动
String DRIVER = "com.mysql.jdbc.Driver";
Class.forName(DRIVER);
步骤二：通过DriverManager获得数据库连接
String URL ="jdbc:mysql://localhost:3306/company?characterEncoding=utf-8";
String USER = "root";
String PASSWORD = "123456";
Connection conn = DriverManager.getConnection(URL,USER,PASSWORD);
18.2 Java操作MySQL数据库
    本节介绍Statement和PreparedStatement的用法。
18.2.1 使用Statement执行SQL语句———executeQuery()查询
    Statement接口是用于执行执行SQL语句的工具接口，有三种执行执行SQL语句的方法，即
executeQuery()，execute()，executeUpdate()。接下来详细介绍这些方法的使用。
【示例18-2】Statement使用executeQuery()方法执行SELECT语句，从本地数据库school_dml中
查询表student和表score的学号，姓名，性别，年龄，班级号，成绩总分，具体步骤如下：
步骤一：
    首先在MySQL数据库系统查询，具体SQL语句如下，
    SELECT st.stuid,st.name,st.gender,st.age,st.classno,sc.chinese+sc.math+sc.english total
    FROM student st,score sc WHERE st.stuid=sc.stuid;
步骤二：
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import java.lang.System;
public class StatementQuery {
    public static void main(String[]args)throws Exception{

        //1.加载驱动
		Class.forName("com.mysql.jdbc.Driver");
        //2.使用DriverManager获取数据库连接
		String URL ="jdbc:mysql://localhost:3306/school_dml?characterEncoding=utf-8";
		String USER = "root";
		String PASSWORD = "Rot-123456";
		Connection conn = DriverManager.getConnection(URL,USER,PASSWORD);
        //3.使用Connection来建立一个Statement对象
		Statement stmt = conn.createStatement();
        //4.executeQuery执行Select语句，返回查询到的结果集
		ResultSet rs = stmt.executeQuery("SELECT st.stuid,st.name,st.gender,st.age,st.classno,sc.chinese+sc.math+sc.english total FROM student st,score sc WHERE st.stuid=sc.stuid");
		//使用next()将指针下移一行
		while(rs.next()){
			System.out.println(rs.getInt(1)+"\t"
			+rs.getString(2)+"\t\t"
			+rs.getString(3)+"\t"
			+rs.getInt(4)+"\t"
			+rs.getInt(5)+"\t"
			+rs.getInt(6));
		}
		if(rs != null)
			rs.close();
		if(stmt != null)
			stmt.close();
		if(conn != null)
			conn.close();
    }
}
18.2.2 使用Statement执行SQL语句———execute()查询
【示例18-3】Statement使用execute()方法执行SELECT语句，从本地数据库school_dml中
查询表student和表score的学号，姓名，性别，年龄，班级号，成绩总分，具体代码如下：
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import java.lang.System;
public class StatementExecute {
    public static void main(String[]args)throws Exception{

        //1.加载驱动
		Class.forName("com.mysql.jdbc.Driver");
        //2.使用DriverManager获取数据库连接
		String URL ="jdbc:mysql://localhost:3306/school_dml?characterEncoding=utf-8";
		String USER = "root";
		String PASSWORD = "Rot-123456";
		Connection conn = DriverManager.getConnection(URL,USER,PASSWORD);
        //3.使用Connection来建立一个Statement对象
		Statement stmt = conn.createStatement();
        //4.execute执行Select语句，返回查询到的结果集
		boolean hasResultSet = stmt.execute("SELECT st.stuid,st.name,st.gender,st.age,st.classno,sc.chinese+sc.math+sc.english total FROM student st,score sc WHERE st.stuid=sc.stuid");
		if(hasResultSet){
			ResultSet rs = stmt.getResultSet();
			//使用next()将指针下移一行
			while(rs.next()){
				System.out.println(rs.getInt(1)+"\t"
				+rs.getString(2)+"\t\t"
				+rs.getString(3)+"\t"
				+rs.getInt(4)+"\t"
				+rs.getInt(5)+"\t"
				+rs.getInt(6));
			}
			if(rs != null)
				rs.close();
			if(stmt != null)
				stmt.close();
			if(conn != null)
				conn.close();
		}
		
    }
}

18.2.3 使用Statement执行SQL语句———executeUpdate()插入数据
【示例18-4】Statement使用executeUpdate()方法执行INSERT语句，从本地数据库school_dml中
向表student中插入一条数据，步骤如下：
步骤一：使用SELECT语句查询表student。
SELECT * FROM student;
步骤二：向表t_student中插入一条数据，然后查询结果。
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import java.lang.System;
public class StatementExecuteInsert {
    public static void main(String[]args)throws Exception{

        //1.加载驱动
		Class.forName("com.mysql.jdbc.Driver");
        //2.使用DriverManager获取数据库连接
		String URL ="jdbc:mysql://localhost:3306/school_dml?characterEncoding=utf-8";
		String USER = "root";
		String PASSWORD = "Rot-123456";
		Connection conn = DriverManager.getConnection(URL,USER,PASSWORD);
        //3.使用Connection来建立一个Statement对象
		Statement stmt = conn.createStatement();
		stmt.executeUpdate("insert into student values(5,10005,\"Rebecca Rindell\",\"Female\",\"han\",23,3,\"pork\")");
		ResultSet rs = stmt.executeQuery("select * from student");
        //使用next()将指针下移一行
        while(rs.next()){
		System.out.println(rs.getInt(1)+"\t"
        	+rs.getInt(2)+"\t\t"
		+rs.getString(3)+"\t"
        	+rs.getString(4)+"\t"
        	+rs.getString(5)+"\t"
        	+rs.getInt(6)+"\t"
	        +rs.getInt(7)+"\t"
		+rs.getString(8));
        	}
        	if(rs != null)
			rs.close();
        	if(stmt != null)
        		stmt.close();
        	if(conn != null)
        		conn.close();
		
    }
}

18.2.4 使用Statement执行SQL语句———executeUpdate()修改数据
【示例18-5】使用Statement的executeUpdate()方法执行Update语句，从本地数据库school_dml表student中
修改一条数据，把stuid为10022的年龄修改为34，步骤如下：
步骤一：查询student，
SELECT * FROM student;
步骤二：编写程序
import java.lang.System;
import java.sql.DriverManager;
import java.sql.Connection;
import java.sql.Statement;
import java.sql.ResultSet;
public class StatementExecuteUpdate{
    public static void main(String[] args)throws Exception{
	Class.forName("com.mysql.jdbc.Driver");
	String URL ="jdbc:mysql://localhost:3306/school_dml?characterEncoding=utf-8";
	String USER ="root";
	String PASSWORD="Rot-123456";
	Connection conn = DriverManager.getConnection(URL,USER,PASSWORD);
	Statement stmt = conn.createStatement();
	stmt.executeUpdate("update student set age=34 where stuid=10022");
	ResultSet rs = stmt.executeQuery("select * from student");
	while(rs.next()){
	System.out.println(rs.getInt(1)+"\t"
		+rs.getInt(2)+"\t\t"
		+rs.getString(3)+"\t"
		+rs.getString(4)+"\t"
		+rs.getString(5)+"\t"
		+rs.getInt(6)+"\t"
		+rs.getInt(7)+"\t"
		+rs.getString(8));
	}
    if(rs != null)
		rs.close();
	if(stmt != null)
		stmt.close();
	if(conn != null)
		conn.close();
    }
}
步骤三：运行上述程序并显示结果
javac -encoding utf-8 StatementExecuteUpdate.java
java StatementExecuteUpdate

18.2.5 使用Statement执行SQL语句———executeUpdate()删除数据
【示例18-6】使用Statement的executeUpdate()方法执行Update语句，从本地数据库school_dml表student中
删除一条数据，把stuid为10022的记录删除，步骤如下：
步骤一：使用SELECT语句查询student表。
SELECT * FROM student;
步骤二：编写程序
import java.lang.System;
import java.sql.DriverManager;
import java.sql.Connection;
import java.sql.Statement;
import java.sql.ResultSet;
public class StatementExecuteDelete{
    public static void main(String[] args)throws Exception{
	Class.forName("com.mysql.jdbc.Driver");
	String URL ="jdbc:mysql://localhost:3306/school_dml?characterEncoding=utf-8";
	String USER ="root";
	String PASSWORD="Rot-123456";
	Connection conn = DriverManager.getConnection(URL,USER,PASSWORD);
	Statement stmt = conn.createStatement();
	stmt.executeUpdate("DELETE FROM student WHERE stuid=10022");
	ResultSet rs = stmt.executeQuery("select * from student");
	while(rs.next()){
		System.out.println(rs.getInt(1)+"\t"
		+rs.getInt(2)+"\t\t"
		+rs.getString(3)+"\t"
		+rs.getString(4)+"\t"
		+rs.getString(5)+"\t"
		+rs.getInt(6)+"\t"
		+rs.getInt(7)+"\t"
		+rs.getString(8));
		}
    if(rs != null)
		rs.close();
    if(stmt != null)
		stmt.close();
    if(conn != null)
		conn.close();
    }
}
步骤三：编译运行程序
javac -encoding utf-8 StatementExecuteDelete.java
java StatementExecuteDelete

18.2.6 使用PreparedStatement执行SQL语句———executeQuery()查询
好处：效率比Statement高；防止SQL注入攻击。
PreparedStatement也有三种方法，即executeQuery()、execute()和executeUpdate()。
【示例18-7】使用PrepraredStatement的executeQuery()方法执行SELECT语句，从数据库
school_dml中student表和score表查询学号为10001的学生的学号、姓名、性别、年龄、班级号、
成绩总分，具体步骤如下：
步骤一：在MySQL数据库中执行查询语句：
SELECT st.stuid,st.name,st.gender,st.age,st.classno,sc.chinese+sc.math+sc.english total
FROM student st JOIN score sc ON st.stuid=sc.stuid AND st.stuid=10001;
步骤二：
import java.lang.System;
import java.sql.DriverManager;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
public class PreparedStatementExecuteQuery{
    public static void main(String[] args)throws Exception{
	Class.forName("com.mysql.jdbc.Driver");
	String URL ="jdbc:mysql://localhost:3306/school_dml?characterEncoding=utf-8";
	String USER ="root";
	String PASSWORD="Rot-123456";
	Connection conn = DriverManager.getConnection(URL,USER,PASSWORD);
	String strSql="SELECT st.stuid,st.name,st.gender,st.age,st.classno,sc.chinese+sc.math+sc.english total FROM student st JOIN score sc ON st.stuid=sc.stuid AND st.stuid=?";
	PreparedStatement pstmt = conn.prepareStatement(strSql);
	pstmt.setInt(1,10001);
	ResultSet rs = pstmt.executeQuery();
	while(rs.next()){
		System.out.println(rs.getInt(1)+"\t"
        +rs.getString(2)+"\t\t"
		+rs.getString(3)+"\t"
        +rs.getInt(4)+"\t"
        +rs.getInt(5)+"\t"
		+rs.getInt(6));
    }
    if(rs != null)
		rs.close();
    if(pstmt != null)
        pstmt.close();
    if(conn != null)
        conn.close();
    }
}
步骤三：编译运行上面程序，得到显示结果
javac -encoding utf-8 PreparedStatementExecuteQuery.java
java PreparedStatementExecuteQuery

18.2.7 使用PreparedStatement执行SQL语句———execute()查询
【示例18-8】使用PreparedStatement的execute()方法执行SELECT语句，从本地计算机
的MySQL数据库系统的school_dml数据库中学生表student和分数表score中查询学生的学号
为10001的学号、姓名、性别、年龄、班级号、成绩总分，具体步骤如下：
步骤一：编写程序PreparedStatementExecute.java
import java.lang.System;
import java.sql.DriverManager;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
public class PreparedStatementExecute{
    public static void main(String[] args)throws Exception{
	Class.forName("com.mysql.jdbc.Driver");
	String URL ="jdbc:mysql://localhost:3306/school_dml?characterEncoding=utf-8";
	String USER ="root";
	String PASSWORD="Rot-123456";
	Connection conn = DriverManager.getConnection(URL,USER,PASSWORD);
	String strSql="SELECT st.stuid,st.name,st.gender,st.age,st.classno,sc.chinese+sc.math+sc.english total FROM student st JOIN score sc ON st.stuid=sc.stuid AND st.stuid=?";
	PreparedStatement pstmt = conn.prepareStatement(strSql);
	pstmt.setInt(1,10001);
	boolean hasResultSet = pstmt.execute();
	if(hasResultSet){
	    ResultSet rs = pstmt.getResultSet();
	    while(rs.next()){
		System.out.println(rs.getInt(1)+"\t"
        +rs.getString(2)+"\t\t"
		+rs.getString(3)+"\t"
        +rs.getInt(4)+"\t"
        +rs.getInt(5)+"\t"
		+rs.getInt(6));
		}
		if(rs != null)
			rs.close();
	}
    if(pstmt != null)
        pstmt.close();
    if(conn != null)
        conn.close();
    }
}
步骤二：编译并运行程序
javac -encoding utf-8 PreparedStatementExecute.java
java PreparedStatementExecute

18.2.8 使用PreparedStatement执行SQL语句———executeUpdate()插入数据
【示例18-9】使用PreparedStatement的executeUpdate()方法执行INSERT语句，从本地
计算机MySQL数据库系统school_dml中的学生表student中插入一条数据，具体步骤如下：
步骤一：用SELECT语句查询student表，具体SQL语句如下，
SELECT * FROM student;
步骤二：编写程序
import java.lang.System;
import java.sql.DriverManager;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
public class PreparedStatementExecuteInsert{
    public static void main(String[] args)throws Exception{
	Class.forName("com.mysql.jdbc.Driver");
	String URL ="jdbc:mysql://localhost:3306/school_dml?characterEncoding=utf-8";
	String USER ="root";
	String PASSWORD="Rot-123456";
	Connection conn = DriverManager.getConnection(URL,USER,PASSWORD);
	String strSql="INSERT INTO student VALUES(?,?,?,?,?,?,?,?)";
	PreparedStatement pstmt = conn.prepareStatement(strSql);
	pstmt.setInt(1,3);
	pstmt.setInt(2,10003);
	pstmt.setString(3,"Jim");
	pstmt.setString(4,"Female");
	pstmt.setString(5,"zhuang");
	pstmt.setInt(6,30);
	pstmt.setInt(7,1);
	pstmt.setString(8,"beef");
	pstmt.executeUpdate();
	ResultSet rs = pstmt.executeQuery("select * from student");
	while(rs.next()){
	    System.out.println(rs.getInt(1)+"\t"
			       +rs.getInt(2)+"\t"
			       +rs.getString(3)+"\t\t"
			       +rs.getString(4)+"\t"
			       +rs.getString(5)+"\t"
			       +rs.getInt(6)+"\t"
			       +rs.getInt(7)+"\t"
			       +rs.getString(8));
	}
	    if(rs != null)
		rs.close();
	    if(pstmt != null)
		pstmt.close();
            if(conn != null)
		conn.close();
    }
}
步骤三：
javac -encoding utf-8 PreparedStatementExecuteInsert.java
java PreparedStatementExecuteInsert

18.2.9 使用PreparedStatement执行SQL语句———executeUpdate()修改数据
【示例18-10】使用PreparedStatement的executeUpdate()方法执行Update语句，从本地数据库school_dml表student中
修改一条数据，把stuid为10002的年龄修改为34，步骤如下：
步骤一：查询student，
SELECT * FROM student;
步骤二：编写程序
import java.lang.System;
import java.sql.DriverManager;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
public class PreparedStatementExecuteUpdate{
    public static void main(String[] args)throws Exception{
	Class.forName("com.mysql.jdbc.Driver");
	String URL ="jdbc:mysql://localhost:3306/school_dml?characterEncoding=utf-8";
	String USER ="root";
	String PASSWORD="Rot-123456";
	Connection conn = DriverManager.getConnection(URL,USER,PASSWORD);
	String strSql="UPDATE student SET age=? WHERE stuid=?";
	PreparedStatement pstmt = conn.prepareStatement(strSql);
	pstmt.setInt(1,34);
	pstmt.setInt(2,10002);
	pstmt.executeUpdate();
	ResultSet rs = pstmt.executeQuery("select * from student");
	while(rs.next()){
	    System.out.println(rs.getInt(1)+"\t"
			       +rs.getInt(2)+"\t"
			       +rs.getString(3)+"\t\t"
			       +rs.getString(4)+"\t"
			       +rs.getString(5)+"\t"
			       +rs.getInt(6)+"\t"
			       +rs.getInt(7)+"\t"
			       +rs.getString(8));
	}
	    if(rs != null)
		rs.close();
	    if(pstmt != null)
		pstmt.close();
            if(conn != null)
		conn.close();
    }
}
步骤三：编译并运行程序
javac -encoding utf-8 PreparedStatementExecuteUpdate.java
java PreparedStatementExecuteUpdate

18.2.10 使用PreparedStatement执行SQL语句———executeUpdate()删除数据
【示例18-10】使用PreparedStatement的executeUpdate()方法执行Update语句，从本地数据库school_dml表student中
删除一条数据，把stuid为10002的学生删除，步骤如下：
步骤一：查询student，
SELECT * FROM student;
步骤二：编写程序
import java.lang.System;
import java.sql.DriverManager;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
public class PreparedStatementExecuteDelete{
    public static void main(String[] args)throws Exception{
	Class.forName("com.mysql.jdbc.Driver");
	String URL ="jdbc:mysql://localhost:3306/school_dml?characterEncoding=utf-8";
	String USER ="root";
	String PASSWORD="Rot-123456";
	Connection conn = DriverManager.getConnection(URL,USER,PASSWORD);
	String strSql="DELETE FROM student WHERE stuid=?";
	PreparedStatement pstmt = conn.prepareStatement(strSql);
	pstmt.setInt(1,10002);
	pstmt.executeUpdate();
	ResultSet rs = pstmt.executeQuery("select * from student");
	while(rs.next()){
	    System.out.println(rs.getInt(1)+"\t"
			       +rs.getInt(2)+"\t"
			       +rs.getString(3)+"\t\t"
			       +rs.getString(4)+"\t"
			       +rs.getString(5)+"\t"
			       +rs.getInt(6)+"\t"
			       +rs.getInt(7)+"\t"
			       +rs.getString(8));
	}
	    if(rs != null)
		rs.close();
	    if(pstmt != null)
		pstmt.close();
            if(conn != null)
		conn.close();
    }
}
步骤三：编译并运行程序
javac -encoding utf-8 PreparedStatementExecuteDelete.java
java PreparedStatementExecuteDelete

18.3 Java备份和恢复MySQL数据库
  MySQL备份语句为：
  mysqldump -u username -p dbname table1 table2 ... >BackupName.sql
  Java语言中的Runtime类的exec()方法可以执行外部命令。调用exec()方法的代码如下：
  Runtime rt = Runtime.getRuntime();
  rt.exec("命令语句");
【示例18-12】在Windows、Linux、Mac三种操作系统下分别使用Java备份数据库。
public class ExecuteMysqldumpComand{
    public static void main(String[] args){
	//windows
	//	String command = "cmd /c"+"mysqldump -uroot -pRot-123456 --databases myBill>E:\\wt\\workspace\\mysql\\backup\\myBill.sql";
	//linux
	//String command = "/bin/sh"+"-c"+"/usr/bin/mysqldump -uroot -pRot-123456 --databases mybill>/var/backup/mybill.sql";
	String command = "sh /root/jdbc/mysqldump.sh";
	//mac  未测试
	//String command = "/usr/local/mysql/mysqldump -uroot -pRot-123456 --databases mybill>/var/backup/mybill.sql";
	executeCommand(command);
    }
    private static void executeCommand(String command){
	try{
	    Runtime.getRuntime().exec(command);
	}
	catch (Exception e){
	    e.printStackTrace();
	}

    }
}
【示例18-13】在Windows、Linux、Mac三种操作系统下分别使用Java恢复数据库。
public class ExecuteMysqldumpComand2{
    public static void main(String[] args){
	//windows
	//String command = "cmd /c"+"mysql -uroot -pRot-123456 myBill<E:\\wt\\workspace\\mysql\\backup\\myBill.sql";
	//linux
	//String command = "/bin/sh"+"-c"+"/usr/bin/mysql -uroot -pRot-123456 mybill</var/backup/mybill.sql";
	String command = "sh /root/jdbc/mysqldump2.sh";
	//mac  未测试
	//String command = "/usr/local/mysql/mysql -uroot -pRot-123456 mybill</var/backup/mybill.sql";
	executeCommand(command);
    }
    private static void executeCommand(String command){
	try{
	    Runtime.getRuntime().exec(command);
	}
	catch (Exception e){
	    e.printStackTrace();
	}

    }
}

18.4 综合示例———人力资源管理系统
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
public class DBUtils{
    public static final String DRIVER = "com.mysql.jdbc.Driver";
    public static final String URL = "jdbc:mysql://localhost:3306/hrmsdb?characterEncoding=utf-8";
    public static final String USER = "root";
    public static final String PASSWORD = "Rot-123456";
    private static Connection conn = null;
    public static Connection getConnection()throws Exception{
	Class.forName(DRIVER);
	conn = DriverManager.getConnection(URL,USER,PASSWORD);
	return conn;
    }
    public static void closeConnection()throws Exception{
	if(conn != null && conn.isClosed()){
	    conn.close();
	    conn = null;
	}
    }
    public int executeUpdate(String sql)throws Exception{
	getConnection();
	Statement st = conn.createStatement();
	int r = st.executeUpdate(sql);
	closeConnection();
	return r;
    }
    public static int executeUpdate(String sql,Object...obj)throws Exception{
	getConnection();
	PreparedStatement pst = conn.prepareStatement(sql);
	if(obj != null && obj.length > 0)
	    for(int i = 0; i < obj.length; i++)
		pst.setObject(i+1,obj[i]);
	int r = pst.executeUpdate();
	closeConnection();
	return r;
    }
    public static ResultSet executeQuery(String sql,Object...obj)throws Exception{
	getConnection();
	PreparedStatement pst = conn.prepareStatement(sql);
	if(obj != null && obj.length > 0)
	    for(int i = 0; i < obj.length; i++)
		pst.setObject(i+1,obj[i]);
	ResultSet rs = pst.executeQuery();
	return rs;
    }
    public static boolean queryLogin(String name,String password)throws Exception{
	//String sql = "select name from t_user where name=? and password=?";
	//ResultSet rs = executeQuery(sql,name,password);
	String sql = "select name from t_user where name=?";
	ResultSet rs = executeQuery(sql,name);
	if(rs.next())
	    return true;
	else
	    return false;
    }
}

import java.util.Scanner;
import java.sql.ResultSet;
import java.sql.SQLException;
public class Hrms{
    public static Scanner sc = new Scanner(System.in);
    public static void mainInterface(){
	while(true){
	    System.out.println("欢迎使用人力资源管理系统");
	    System.out.println("1.查看员工信息");
	    System.out.println("2.添加员工信息");
	    System.out.println("3.修改员工信息");
	    System.out.println("4.删除员工信息");
	    System.out.println("0.退出系统");
	    System.out.println("请选择：");
	    int num = sc.nextInt();
	    switch(num){
	    case 1:
		query();
		break;
	    case 2:
		add();
		break;
	    case 3:
		update();
		break;
	    case 4:
		del();
		break;
	    case 0:
		System.out.println("谢谢使用！");
		System.exit(0);
	    default:
		System.out.println("没这个选项，请重新输入！");
	    }
	}

    }
    private static void query(){
	System.out.println("查询员工信息：(a:全部，b:单个),请选择：");
	String num = sc.next();
	String sql = null;
	try{
	    switch(num){
	    case "a":
		sql = "select * from t_employee";
		ResultSet rsa = DBUtils.executeQuery(sql);
		System.out.println("编号\t姓名\t性别\t年龄");
		while(rsa.next()){
		    int id = rsa.getInt(1);
		    String name = rsa.getString(2);
		    String gender = rsa.getString(3);
		    int age = rsa.getInt(4);
		    System.out.println(id+"\t"+name+"\t"+gender+"\t"+age);
		}
		break;
	    case "b":
		System.out.println("请输入要查询员工的id：");
		int idnum = sc.nextInt();
		sql = "select * from t_employee where id=?";
		ResultSet rsb = DBUtils.executeQuery(sql,idnum);
		System.out.println("编号\t姓名\t性别\t年龄");
		while(rsb.next()){
		    int id = rsb.getInt(1);
		    String name = rsb.getString(2);
		    String gender = rsb.getString(3);
		    int age = rsb.getInt(4);
		    System.out.println(id+"\t"+name+"\t"+gender+"\t"+age);
		}
		break;
	    default:
		System.out.println("无此选项，请重新输入！");
		break;
	    }
	}catch(SQLException e){
	    System.out.println("db error"+e.getMessage());
	    e.printStackTrace();
	}catch(Exception e){
	    System.out.println("other error"+e.getMessage());
	    e.printStackTrace();
	}finally{
	    try{
		DBUtils.closeConnection();
	    }catch(Exception e){
		System.out.println(e.getMessage());
	    }
	}
    }
    private static void add(){
	System.out.println("\t新增员工");
	System.out.println("姓名：");
	String name = sc.next();
	System.out.println("性别：");
	String gender = sc.next();
	System.out.println("年龄：");
	int age = sc.nextInt();
	String sql = "INSERT INTO t_employee(name,gender,age) VALUES(?,?,?)";
	try{
	    DBUtils.executeUpdate(sql,name,gender,age);
	    System.out.println("新增成功！");
	}catch(Exception e){
	    System.out.println("error："+e.getMessage());
	}finally{
	    try{
		DBUtils.closeConnection();
	    }catch(Exception e){
		e.printStackTrace();
	    }
	}
    }
    private static void update(){
	String sql1 = "select * from t_employee where id=?";
	String sql2 = "update t_employee set name=? where id=?";
	String sql3 = "update t_employee set gender=? where id=?";
	String sql4 = "update t_employee set age=? where id=?";
	System.out.println("请输入要修改的员工的id：");
	int idnum = sc.nextInt();
	try{
	    ResultSet rs = DBUtils.executeQuery(sql1,idnum);
	    System.out.println("编号\t姓名\t性别\t年龄");
	    while(rs.next()){
		int id = rs.getInt(1);
		String name = rs.getString(2);
		String gender = rs.getString(3);
		int age = rs.getInt(4);
		System.out.println(id+"\t"+name+"\t"+gender+"\t"+age);
	    }
	    System.out.println("你确认要修改此人信息吗？y/n:");
	    String yorn = sc.next();
	    if("y".equals(yorn)){
		System.out.println("修改选项：a、姓名，b、性别，c、年龄：");
		String abc = sc.next();
		if("a".equals(abc)){
		    System.out.println("请输入姓名：");
		    String iname = sc.next();
		    DBUtils.executeUpdate(sql2,iname,idnum);
		}else if("b".equals(abc)){
		    System.out.println("请输入性别：");
		    String igender = sc.next();
		    DBUtils.executeUpdate(sql3,igender,idnum);
		}else if("c".equals(abc)){
		    System.out.println("请输入年龄：");
		    String iage = sc.next();
		    DBUtils.executeUpdate(sql4,iage,idnum);
		}else{
		    System.out.println("输入错误！");
		}
		System.out.println("修改成功！");
	    }else
		System.out.println("取消修改！");
	}catch(Exception e){
	    System.out.println(e.getMessage());
	}finally{
	    try{
		DBUtils.closeConnection();
	    }catch(Exception e){
		e.printStackTrace();
	    }
	}
    }
    private static void del(){
	String sql1 = "select * from t_employee where id=?";
	String sql2 = "delete from t_employee where id=?";
	System.out.println("请输入要删除的员工的id：");
	int idnum = sc.nextInt();
	ResultSet rs = null;
	try{
	    rs = DBUtils.executeQuery(sql1,idnum);
	    System.out.println("编号\t姓名\t性别\t年龄");
	    while(rs.next()){
		int id = rs.getInt(1);
		String name = rs.getString(2);
		String gender = rs.getString(3);
		int age = rs.getInt(4);
		System.out.println(id+"\t"+name+"\t"+gender+"\t"+age);
	    }
	    System.out.println("你确认要删除此人信息吗？y/n:");
	    String yorn = sc.next();
	    if("y".equals(yorn)){
		DBUtils.executeUpdate(sql2,idnum);
		System.out.println("删除成功！");
	    }else
		System.out.println("取消删除！");
	}catch(Exception e){
	    System.out.println(e.getMessage());
	}finally{
	    try{
		DBUtils.closeConnection();
	    }catch(Exception e){
		e.printStackTrace();
	    }
	}
    }
}

import java.util.Scanner;
public class Login{
    private static Scanner sc = new Scanner(System.in);
    public static void register()throws Exception{
	System.out.println("****欢迎注册人力资源管理系统****");
	String sql = "insert into t_user(name,password) values(?,?)";
	while(true){
	    System.out.println("请输入用户名：");
	    String iname = sc.next();
	    System.out.println("请设置密码：");
	    String ipassword = sc.next();
	    boolean b = DBUtils.queryLogin(iname,ipassword);
	    if(b){
		System.out.println("该用户已经存在，请重新输入：");
	    }else{
		DBUtils.executeUpdate(sql,iname,ipassword);
		System.out.println("注册成功！欢迎登陆！是否立即登陆?y/n");
		String yorn = sc.next();
		if("y".equals(yorn)){
		    login();
		}
		break;
	    }
	}
    }
    public static void login()throws Exception{
	int count = 0;
	System.out.println("****欢迎登陆人力资源管理系统****");
	while(true){
	    System.out.println("请输入用户名：");
	    String iname = sc.next();
	    System.out.println("请输入密码：");
	    String ipassword = sc.next();
	    boolean b = DBUtils.queryLogin(iname,ipassword);
	    if(b){
		Hrms.mainInterface();
	    }else{
		count++;
		System.out.println("账号密码不匹配，请重新输入！");
	    }
	    if(count>2){
		System.out.println("您已经连续三次输入错误，已退出！");
		break;
	    }
	}
    }
    public static void updatePassword()throws Exception{
	System.out.println("****请登陆后修改密码****");
	int count = 0;
	while(true){
	    System.out.println("请输入用户名：");
	    String iname = sc.next();
	    System.out.println("请输入密码：");
	    String ipassword = sc.next();
	    boolean b = DBUtils.queryLogin(iname,ipassword);
	    if(b){
		System.out.println("-----修改密码-----");
		System.out.println("请输入新的密码");
		String newPassword = sc.next();
		String sql = "update t_user set password=? where name=?";
		DBUtils.executeUpdate(sql,newPassword,iname);
		System.out.println("修改成功，请重新登陆！");
		login();
	    }else{
		count++;
		System.out.println("账号密码不匹配，请重新输入！");
	    }
	    if(count>2){
		System.out.println("您已经连续三次输入错误，已退出！");
		break;
	    }
	}
    }
}

import java.util.Scanner;
public class MainLogin{
    public static void main(String[] args)throws Exception{
	Scanner sc = new Scanner(System.in);
	while(true){
	    System.out.println("*****欢迎登陆人力资源管理系统*****");
	    System.out.println("*1.注册|2.登陆|3.修改密码|0.退出*");
	    System.out.println("请选择：");
	    int num = sc.nextInt();
	    if(num == 0){
		System.out.println("\n Thanks For Your Use!");
		break;
	    }else{
		switch(num){
		case 1:
		    Login.register();
		    break;
		case 2:
		    Login.login();
		    break;
		case 3:
		    Login.updatePassword();
		    break;
		default:
		    System.out.println("输入错误，请重新输入！");
		}
	    }
	}
	sc.close();
    }
}

18.5 本章总结
    本章介绍了Java访问MySQL数据库的方法。Java连接和操作MySQL数据库是本章重点。
连接部分详细介绍了如何通过JDBC连接MySQL数据库。在Java操作MySQL数据库分别介绍了
Statement和PreparedStatement两个方面，它们在Java中执行SELECT,INSER,UPDATE,DELETE
语句的方法。Java备份和恢复MySQL数据库是本章难点，因为Java需要调用外部命令。
最后通过一个综合示例，介绍了Java连接和操作MySQL数据库的方法。下一章介绍网上课堂系统设计
方案。
