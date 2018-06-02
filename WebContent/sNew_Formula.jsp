<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
      <%@ page import = "java.io.*,java.util.*,java.sql.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>



<body>
<%


System.out.println("hello");
String nametb=request.getParameter("formulatb");


Class.forName("com.mysql.jdbc.Driver");
Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/tele","root","root");

PreparedStatement statement=con.prepareStatement("select count(*) from formula");

ResultSet result=statement.executeQuery();

int rows=0;
while(result.next())
rows=Integer.parseInt(result.getString(1));


System.out.println(rows);


PreparedStatement statement2=con.prepareStatement("insert into formula values ('[f"+(rows+1)+"]','"+request.getParameter("formulatb")+"')");

System.out.println(statement2);
try{statement2.executeUpdate();
}
catch(Exception e)
{
System.out.println("hello");//close scriptlet within script tag alert("already exists!"); open scriptlet
response.sendRedirect("Formula_Calculator.jsp");
}

response.sendRedirect("Formula_Calculator.jsp");

%>


</body>
</html>