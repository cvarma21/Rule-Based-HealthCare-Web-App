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
String hel="";

String option  = request.getParameter("rule");
System.out.println("Option = "+option);

String op="";
int i=0;
char c;



Class.forName("com.mysql.jdbc.Driver");
Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/tele","root","root");
String action = request.getParameter("action");
System.out.println("Action in SS = "+action);
if(action.equals("Add Condition"))
{
	
System.out.println("In add condition");
PreparedStatement statement = con.prepareStatement("select * from "+radiobutton);

try 
{
	ResultSet result = statement.executeQuery();
	PreparedStatement statement2;
	int count=0;
	int dig, num=0, fi=0;
	char ch, ch1;
	
	while(result.next())
	{
		i=0;
		//count++;
		//hel=result.getString(1);
		//System.out.println(result.getString(1));
		hel=result.getString(1);
		
		while(i<hel.length())
		{
			ch=hel.charAt(i);
			if(ch=='_')
			{
				i++;
				while(i<hel.length())
				{
					
					System.out.println("Index = "+i);
					ch1=hel.charAt(i);
					dig=(int)(ch1);
					dig=dig-48;
					num=(num*10)+dig;
					i++;
				}
				
				
				
			}
			
			i++;
			
		}
		
		if(num>fi)
			fi=num;
		
		num=0;
	}
	
	System.out.println("fi= "+fi);
	
	
	
	
	System.out.println("Num = "+num);
	num++;
	
	fi++;
	//System.out.println("Hello ===="+hel);
	
	//System.out.println("String = "+result.getString(1));

	if(datatype.equals("number"))
	{
		int ll=Integer.parseInt(request.getParameter("ll"));
		int rl=Integer.parseInt(request.getParameter("rl"));
		statement2=con.prepareStatement("insert into "+radiobutton+" values('"+radiobutton+"_"+fi+"',"+ll+","+rl+")");
	}
	else
	{
		String val=request.getParameter("val");
		statement2=con.prepareStatement("insert into "+radiobutton+" values('"+radiobutton+"_"+fi+"','"+val+"')");
	}

	System.out.println("the statement2 is "+statement2);
	
	statement2.executeUpdate();
	//response.sendRedirect("sAdd_Condition.jsp?input="+radiobutton+"&flag=0");
	//response.sendRedirect("sAdd_Condition.jsp?input=feg&action=Add+Condition");
	
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
	while(i!=option.length())
	{
		c=option.charAt(i);
		if(c!='+')
			op+=c;
		else
			break;
		
		i++;

	}

	System.out.println("OP = "+op);
	System.out.println("Delete Condition starting");
	System.out.println("Radiobutton = "+radiobutton);
	String vals=request.getParameter("val");
	System.out.println("Val = "+vals);
	PreparedStatement statement2;

	if(datatype.equals("number"))
	{
		try{
			statement2=con.prepareStatement("delete from "+radiobutton+" where id = '"+op+"'");
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
	//response.sendRedirect("sAdd_Condition.jsp?input=feg&action=Delete+Condition");
}
%>
<body>

<%=datatype %>

</body>
</html>