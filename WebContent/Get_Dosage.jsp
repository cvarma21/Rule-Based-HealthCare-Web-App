<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    
        <%@ page import = "java.io.*,java.util.*,java.sql.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Get Dosage</title>
</head>
<body>
<%

String inputtext=request.getParameter("inputtext");
 Class.forName("com.mysql.jdbc.Driver");
 Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/tele","root","root");

PreparedStatement statement=con.prepareStatement("select * from parameters");

ResultSet result=statement.executeQuery();

String inputcheckboxes="";
String outputcheckboxes="";

while(result.next())
{
	String type=result.getString("type");
	if(type.equals("i"))
	{
		inputcheckboxes+="<input TYPE='checkbox'  name='input' VALUE="+result.getString("parameterName")+">"+result.getString("parameterName")+"</input><br>";
	}
	
}
 
%>
<form action="sGet_Dosage.jsp">
choose input parameters:<br><br>
<%= inputcheckboxes %>


<input type="submit" value="submit" >
<br><br>

</form>


<form action="Make_Clausev.jsp">

<% if (inputtext!=null){ %>
<%= inputtext %>
<%} %>


<input type="submit" value="MakeClause" ><br><br>

<a href="/rulebase/Home_page.jsp" class="btn btn-info" role="button">Home Page</a>
</form>







</body>
</html>