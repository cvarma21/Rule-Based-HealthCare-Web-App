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
	response.sendRedirect("sAdd_Condition.jsp?input="+radiobutton+"&flag=0");
}
catch (Exception e)
{
	System.out.println("Left right values for variable : " + radiobutton + " processing");
	System.out.println("Exception occured : "+ e );	
	//System.out.println("/rulebase/sNewCondition.jsp?input="+radiobutton+"&flag=1");
	response.sendRedirect("/rulebase/sAdd_Condition.jsp?input="+radiobutton+"&flag=1");
}
%>
<body>

<%=datatype %>

</body>
</html>