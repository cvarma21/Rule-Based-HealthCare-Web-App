
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
       <%@ page import = "java.io.*,java.util.*,java.sql.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Formula Calculator</title>
</head>
<body>

<%
// need to display varibles table 
// need to display formula table 
// need to display the text box to write the formula 
Class.forName("com.mysql.jdbc.Driver");
Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/tele","root","root");
String table="<table>";
PreparedStatement statement=con.prepareStatement("select * from Variables");

ResultSet result=statement.executeQuery();

	table+="<table border='1'><th>Variable Name</th><th>TableName</th><th>ColumnName</th><th>RowType</th>";
	while(result.next())
	{
	
	table+="<tr><td>"+result.getString(1)+"</td><td>"+result.getString(2)+"</td><td>"+result.getString(3)+"</td><td>"+result.getString(4)+"</td></tr>";	
	}
	table+="</table>";

	String table2="<table>";
	PreparedStatement statement2=con.prepareStatement("select * from formula");

	ResultSet result2=statement2.executeQuery();

		table2+="<table border='1'><th>ID</th><th>Formula</th>";
		while(result2.next())
		{
		
		table2+="<tr><td>"+result2.getString(1)+"</td><td>"+result2.getString(2)+"</td></tr>";
		}
		table2+="</table>";

%>

<form action="sNew_Formula.jsp">

Existing variables<br>
<%=table %><br>
Existing formulas <br>
<%=table2 %><br>
<label>MAKE NEW FORMULA OR CHOOSE AN ID FROM ABOVE:</label>
<input type="text" id="formulatb" name="formulatb" ></input>
<input type="submit" value="Add"  ></input>


</form>


</body>
</html>