<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@ page import = "java.io.*,java.util.*,java.sql.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Add New Parameter</title>
</head>

<% 
String param_check;
param_check=request.getParameter("param_check");
%>

<script type="text/javascript">

function alertName()
{
	//if(param_check.equals(1)){
	var par = '<%= param_check%>';
	if (par == '1')
	{
		alert("Variable name exists; please provide a different name" );
		//alert(par);
	}	
	else if ((par == '2'))
	{	alert("New variable added successfully");}
} 
	


</script> 





<center> <b>Add New Parameter </b></center><br><br> 
<form action="sAdd_Parameter.jsp">

Parameter Name:
<input type="text" name="parameter_name"></input> <br>
(<i>NOTE</i>: Please check the names of the parameters below before defining new parameters)
<br><br>


Parameter Type:
<select name="type">
  <option value="i">INPUT</option>
  <option value="o">OUTPUT</option>
</select>
<br><br>

Datatype:
<select name="datatype">
  <option value="number">NUMBER</option>
  <option value="char">CHARACTER</option>
  <option value="date">DATE</option>
</select>
<br><br>

<input type="submit" value="ADD" name="action" onclick="alertName()"></input> <br><br>


<a href="/rulebase/Home_page.jsp" class="btn btn-info" role="button">Go to Home Page</a> 
<br><br><br>
<hr>

<%

String param = request.getParameter("param_check");


Class.forName("com.mysql.jdbc.Driver");
Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/tele","root","root");
PreparedStatement statement = con.prepareStatement("select * from parameters");
ResultSet result = statement.executeQuery();

String[] input =new String[1000];int ii=0;
String[] output=new String[1000];int oi=0;

while(result.next())
{
	if(result.getString("type").equals("i"))
	{
		input[ii++]=result.getString("parameterName");
	}
	else if(result.getString("type").equals("o"))
	{
		output[oi++]=result.getString("parameterName");
	}
	
	else{}
}

String inputString="";
String outputString="";
if(ii!=0)
{
	for(int i=0;i<ii;i++)
	{
		inputString+="<p>"+input[i]+"</p>";
	}
}

if(oi!=0)
{
	for(int i=0;i<oi;i++)
	{
		outputString+="<p>"+output[i]+"</p>";
	}
}


%>

<% 
if(ii!=0){ %>
<h5>INPUT PARAMETERS</h5>
<div><%= inputString %></div><hr>
<%} %>


<% if(oi!=0){ %>
<h5>OUTPUT PARAMETERS</h5>
<div><%= outputString %></div>
<%} %>



    <h5> DELETE PARAMETER SECTION</h5>
        <select name='item' value = 'Select Parameter to Delete'>
        <%   result = statement.executeQuery();

        while(result.next()){ %>
            <option selected><%= result.getString("parameterName")%></option>
        <% } %>
        </select>
<input type="submit" value="CHECK" name="action" ></input> <br><br>
<input type="submit" value="DEL" name="action" ></input> <br><br>

</form>

</body>
</html>