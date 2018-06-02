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
String datatype=request.getParameter("datatype");
String radiobutton=request.getParameter("radiobutton");

//System.out.println(datatype +" "+ radiobutton );

Class.forName("com.mysql.jdbc.Driver");
Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/tele","root","root");
String action = request.getParameter("action");
System.out.println("Action in SS = "+action);
if(action.equals("Add Condition"))
{
PreparedStatement statement = con.prepareStatement("select * from "+radiobutton);

try 
{
	ResultSet result = statement.executeQuery();
	PreparedStatement statement2;
	int count=0;

	while(result.next())
	{
		count++;
	}
	
	//System.out.println("String = "+result.getString(1));

	if(datatype.equals("number"))
	{
		int ll=Integer.parseInt(request.getParameter("ll"));
		int rl=Integer.parseInt(request.getParameter("rl"));
		statement2=con.prepareStatement("insert into "+radiobutton+" values('"+radiobutton+"_"+count+"',"+ll+","+rl+")");
	}
	else
	{
		String val=request.getParameter("val");
		statement2=con.prepareStatement("insert into "+radiobutton+" values('"+radiobutton+"_"+count+"','"+val+"')");
	}

	System.out.println("the statement2 is "+statement2);
	
	statement2.executeUpdate();
	//response.sendRedirect("sAdd_Condition.jsp?input="+radiobutton+"&flag=0");
	response.sendRedirect("sAdd_Condition.jsp?input=feg&action=Add+Condition");
}
catch (Exception e)
{
	System.out.println("Left right values for variable : " + radiobutton + " processing");
	System.out.println("Exception occured : "+ e );	
	//System.out.println("/rulebase/sNewCondition.jsp?input="+radiobutton+"&flag=1");
	//response.sendRedirect("/rulebase/sAdd_Condition.jsp?input="+radiobutton+"&flag=1");
}
}
else if(action.equals("Delete Condition"))
{
	System.out.println("Delete Condition starting");
	System.out.println("Radiobutton = "+radiobutton);
	String vals=request.getParameter("val");
	System.out.println("Val = "+vals);
	PreparedStatement statement2;

	if(datatype.equals("number"))
	{
		try{
			statement2=con.prepareStatement("delete from "+radiobutton+" where id = '"+vals+"'");
			statement2.executeUpdate();

		}
		catch(Exception e)
		{
			System.out.println("Error in sql");
			e.printStackTrace();
		}
	}
	else
	{
		String val=request.getParameter("val");
		//statement2=con.prepareStatement("insert into "+radiobutton+" values('"+radiobutton+"_"+count+"','"+val+"')");
	}

	//System.out.println("the statement2 is "+statement2);
	
	//response.sendRedirect("sAdd_Condition.jsp?input="+radiobutton+"&flag=0");
	response.sendRedirect("sAdd_Condition.jsp?input=feg&action=Delete+Condition");
}
%>
<body>

<%=datatype %>

</body>
</html>