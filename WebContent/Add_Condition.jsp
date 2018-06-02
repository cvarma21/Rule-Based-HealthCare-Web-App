<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@ page import = "java.io.*,java.util.*,java.sql.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Add Conditions</title>
</head>

<% 
String radio_check;
radio_check=request.getParameter("radio_button");
%>

<script type="text/javascript">
function alertName()
{
	//if(param_check.equals(1)){
	var par = '<%= radio_check%>';
	if (par == '0')
	{
		alert("Please select a parameter to add a new condition" );
		//alert(par);
	}	
} 
</script> 

<% 

Class.forName("com.mysql.jdbc.Driver");
Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/tele","root","root");

PreparedStatement statement=con.prepareStatement("select * from parameters where type='i'");


ResultSet result=statement.executeQuery();


String radiobuttons="";
int flag=0;
while(result.next())
{
	flag=1;
radiobuttons+="<input type='radio' name='input' value="+result.getString("parameterName")+">"+result.getString("parameterName")+"<br>";
}


%>

<body onload = "alertName()">

<form action="sAdd_Condition.jsp">


<% if(flag==1) {%>
choose input parameter:<br>
<div><%=radiobuttons %></div>
<%}%>

<input type="submit" value="Add Condition" name="action" ></input> <br><br> <br>

<a href="/rulebase/Home_page.jsp" class="btn btn-info" role="button">Home Page</a>
</form>

</body>
</html>