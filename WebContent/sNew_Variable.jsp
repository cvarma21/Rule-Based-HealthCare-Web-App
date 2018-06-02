<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
      <%@ page import = "java.io.*,java.util.*,java.sql.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>

<%

//inserting into the table 
//insert into Variables values('ht', 'ht' , 'patdetails', 'MR');

//create table patdetails(sno int not null auto_increment, ht int, wt int, sa int,primary key(sno));


String nametb=request.getParameter("nametb");
String colname=request.getParameter("colname");
String tabname=request.getParameter("tabname");
String rowtype=request.getParameter("rowtype");


Class.forName("com.mysql.jdbc.Driver");
Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/tele","root","1234");


PreparedStatement statement=con.prepareStatement("insert into Variables values ('"+nametb+"','"+colname+"','"+tabname+"','"+rowtype+"')");

System.out.println(statement);
try{statement.executeUpdate();
}
catch(Exception e)
{
System.out.println("hello");//close scriptlet within script tag alert("already exists!"); open scriptlet
response.sendRedirect("New_Variable.jsp?fail=yes");
}

response.sendRedirect("New_Variable.jsp?fail=no");


%>
<body>


</body>
</html>