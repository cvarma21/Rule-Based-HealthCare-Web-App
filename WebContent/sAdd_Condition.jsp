<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@ page import = "java.io.*,java.util.*,java.sql.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>New Condition</title>
</head>

<% 
String flag_status;
flag_status=request.getParameter("flag");
String radiobutton=request.getParameter("input");
//System.out.println(flag_status);

%>

<script type="text/javascript">
function alertName()
{
	//alert(par);
	var flag_par = '<%=flag_status%>';
	var radio_par = '<%=radiobutton%>';
	if (flag_par == '0')
	{
		alert("Condition inserted for "+radio_par);
	}	
	else if (flag_par == '1')
	{
		alert("Please enter left and right limit for "+radio_par);
	}	
} 
</script> 


<%

//String radiobutton=request.getParameter("input");
//System.out.println(radiobutton);

Class.forName("com.mysql.jdbc.Driver");
Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/tele","root","root");

PreparedStatement statement=con.prepareStatement("select * from parameters");

String datatype = "";
ResultSet result = null;
try{
	result = statement.executeQuery();
	
	while(result.next())
	{
		if((result.getString("parameterName")).equals(radiobutton))
			{
				datatype=result.getString("datatype");
			}
	}
}
catch(Exception e)
{
	System.out.println("select * from parameters not exceuted");	
}


//display that table 
//make condition selector 
PreparedStatement statement2=con.prepareStatement("select * from "+radiobutton);
int flagtable = 0;
String table = "";
ResultSet result2 = null;
try
{
	result2 = statement2.executeQuery();
	if(datatype.equals("number"))
	{
		while(result2.next())
		{
			flagtable=1;
			table+="<tr><td>"+result2.getString(1)+"</td><td>"+result2.getString(2)+"</td><td>"+result2.getString(3)+"</td></tr>";	
		}

		if(flagtable==1)
		{
			table="<br><br><table border='1'><th>id</th><th>left_limit</th><th>right_limit</th>"+table;
			table+="</table>";
		}
	}
	else
	{
		while(result2.next())
		{
			flagtable=1;
			table+="<tr><td>"+result2.getString(1)+"</td><td>"+result2.getString(2)+"</td></tr>";	
		}

		if(flagtable==1)
		{
			table="<br><br><table border='1'><th>id</th><th>value</th>"+table;
			table+="</table>";
		}	
	}
}
catch(Exception e)
{
	System.out.println("select * from "+radiobutton+" cannot be executed" );
	response.sendRedirect("/rulebase/Add_Condition.jsp?radio_button=0");
}

%>

<body onload="alertName()">
<form action="ssAdd_Condition.jsp">

<p><%=radiobutton %></p>
<p><%=datatype %></p>


<% 
if(datatype.equals("number"))
{%>
Make Condition: 
<input type="text" name="ll" id='ll' placeholder="leftlimit"></input>
<= <%=radiobutton %> <=
<input type="text" name="rl" id='rl' placeholder="rightlimit"></input>
<%}
else
{%>
Make Condition: 
<%=radiobutton %> = <input type="text" name="val" value="value" id='val'></input>
<% }%>

<div><%=table %></div>

<input type="hidden" value='<%=radiobutton%>' id="radiobutton" name="radiobutton" ></input>
<input type="hidden" value='<%=datatype%>' id="datatype" name="datatype" ></input>

<br>

<input type="submit" value="Add Condition"></input>
<br><br>

<a href="/rulebase/Home_page.jsp" class="btn btn-info" role="button">Home Page</a> 
</form>
</body>
</html>