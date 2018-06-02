
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import = "java.io.*,java.util.*,java.sql.*"%>


<%
//code to create new table 
String type=request.getParameter("type");
String datatype=request.getParameter("datatype");
String param_name=request.getParameter("parameter_name");

int flag=0;
int check_param_name_count = -1;
String redirect_page = "";
//we need to create a new table 
Class.forName("com.mysql.jdbc.Driver");
Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/tele","root","root");

//////////////////////////////////////////
//Before entering new parameter; check whether parameter name exist. If yes, please tell user to enter some other name
PreparedStatement check_param_name = con.prepareStatement("select count(*) from parameters where parameterName = '"+param_name+"'");
String ans_check="";
try
{
		ResultSet rs1 = check_param_name.executeQuery();
		//System.out.println("rs_max1 = " +rs1);
		while (rs1.next()) {
		check_param_name_count = rs1.getInt("count(*)"); }
		System.out.println("check_param_name_count = "+ check_param_name_count);
		//System.out.println("rs_max2 = " +rs1.getInt("count(*)")); }

}
catch(Exception e)
{
		System.out.println("ans_check =" + e);
		//e.printStackTrace();
}
/////////////////////////////////////////


//////////////////////////////////////////

PreparedStatement statement=con.prepareStatement("insert into parameters values ('"+param_name+"','"+type+"','"+datatype+"')");

try
{	
	statement.executeUpdate();
}
catch(Exception e)
{
	System.out.println("Insert into parameters Exception = "+ e);//MySQLIntegrityConstraintViolationException
	//close scriptlet within script tag alert("already exists!"); open scriptlet
	redirect_page = "NewParameter.jsp";

}

PreparedStatement statement_max=con.prepareStatement("select * from max_clauses");
ResultSet rs_max=statement_max.executeQuery();

int total_clauses=0;
while(rs_max.next())
{
	total_clauses=Integer.parseInt(rs_max.getString("no"));
}

if(type.equals("i"))
{

	PreparedStatement statement2;


	if(datatype.equals("number"))
	{
		statement2=con.prepareStatement("create table "+param_name+"(id varchar(45),"+param_name+"L int(32),"+param_name+"R int(32),primary key(id))");

	}
	else
	{
		statement2=con.prepareStatement("create table "+param_name+"(id varchar(45),"+param_name+"val varchar(45),primary key(id))");
	}
	try{statement2.executeUpdate();}
	catch(Exception e)
	{
		System.out.println("cannot create table with "+statement2+" "+e);
	}

	for(int i=1;i<=total_clauses;i++)
	{
		PreparedStatement stmt=con.prepareStatement("ALTER TABLE clause"+i+" ADD "+param_name+i+" varchar(45)");
		try
		{
			stmt.executeUpdate();
		}
		catch(Exception e)
		{
			System.out.println("Exception = "+e);
		}
	}


	//response.sendRedirect("NewParameter.jsp");
	redirect_page = "NewParameter.jsp";

}
else
{
	if(total_clauses>=1)
	{
		PreparedStatement stmt=con.prepareStatement("ALTER TABLE clause"+1+" ADD "+param_name+" varchar(45)");
		stmt.executeUpdate();
	}

	//response.sendRedirect("NewParameter.jsp");
	redirect_page = "NewParameter.jsp";
	
}

if (!redirect_page.equals("") )
{
	response.sendRedirect(redirect_page);
}

%>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>



<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>sNewParameter</title>
</head>



<body>


<p><%=type %></p>
<p><%=datatype %></p>
<p><%=param_name %></p>

</body>
</html>

