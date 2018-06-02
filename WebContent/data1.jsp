<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import = "java.io.*,java.util.*,java.sql.*"%>
<%@ page import = "javax.servlet.http.*,javax.servlet.*,java.sql.Connection,java.sql.DriverManager,java.sql.PreparedStatement,java.sql.ResultSet"%>

<%

Class.forName("com.mysql.jdbc.Driver");
Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/tele","root","root");

PreparedStatement statement=con.prepareStatement("select * from Persons");

ResultSet result=statement.executeQuery();


String one="";

while(result.next())
{
one=result.getString(2);
}




%>

<html>
   <head>
      <title>Title</title>
   </head>
   
   <body>
    <p><%=one %></p>
 
   </body>
</html>