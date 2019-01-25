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
修改一条数据，把stuid为1022的年龄修改为34，步骤如下：
