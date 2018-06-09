
<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import = "java.io.*,java.util.*,java.sql.*"%>


<%
//code to create new table 
String type=request.getParameter("type");
String datatype=request.getParameter("datatype");
String param_name=request.getParameter("parameter_name");
String check = request.getParameter("item");
System.out.println("Check ="+check);

int flag=0;
int check_param_name_count = -1;
String redirect_page = "";
String param_check_value = "";
String action = request.getParameter("action");
System.out.println("ACTION ="+action);
ResultSet rs2, rs4, rs5;
//ResultSet rs3


if(action.equals("ADD"))
{
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
		redirect_page = "Add_Parameter.jsp";
		param_check_value = "1";

}
catch(Exception e)
{
		System.out.println("ans_check =" + e);
		//e.printStackTrace();
}
/////////////////////////////////////////


//////////////////////////////////////////

if (check_param_name_count < 1)
{
	System.out.println("Adding new variable = "+param_name);

	PreparedStatement statement=con.prepareStatement("insert into parameters values ('"+param_name+"','"+type+"','"+datatype+"')");

	try
	{	
		statement.executeUpdate();
		param_check_value = "2";
	}
	catch(Exception e)
	{
		System.out.println("Insert into parameters Exception = "+ e);//MySQLIntegrityConstraintViolationException
		//close scriptlet within script tag alert("already exists!"); open scriptlet
		redirect_page = "Add_Parameter.jsp";
		param_check_value = "1";

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
		try{
			statement2.executeUpdate();
			param_check_value = "2";	
		}
		catch(Exception e)
		{
			System.out.println("cannot create table with "+statement2+" "+e);
			param_check_value = "1";
		}

		for(int i=1;i<=total_clauses;i++)
		{
			PreparedStatement stmt=con.prepareStatement("ALTER TABLE clause"+i+" ADD "+param_name+i+" varchar(45)");
			try
			{
				stmt.executeUpdate();
				param_check_value = "2";
			}
			catch(Exception e)
			{
				System.out.println("Exception = "+e);
				param_check_value = "1";
			}
		}

		//response.sendRedirect("NewParameter.jsp");
		redirect_page = "Add_Parameter.jsp";

	}
	else
	{
		if(total_clauses>=1)
		{
			PreparedStatement stmt=con.prepareStatement("ALTER TABLE clause"+1+" ADD "+param_name+" varchar(45)");
			try
			{
				stmt.executeUpdate();
				param_check_value = "2";
			}
			catch(Exception e)
			{
				System.out.println("Exception = "+e);
				param_check_value = "1";
			}
			
		}

		//response.sendRedirect("NewParameter.jsp");
		redirect_page = "Add_Parameter.jsp";
	
	}
}
if (!redirect_page.equals("") )
{
	response.sendRedirect(redirect_page+"?param_check="+param_check_value);
}
}
else if(action.equals("DEL"))
{
	//we need to create a new table 
	Class.forName("com.mysql.jdbc.Driver");
	Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/tele","root","root");

	//////////////////////////////////////////
	//Before entering new parameter; check whether parameter name exist. If yes, please tell user to enter some other name
	PreparedStatement check_param_name = con.prepareStatement("select count(*) from parameters where parameterName = '"+check+"'");
	String ans_check="";
	try
	{
			ResultSet rs1 = check_param_name.executeQuery();
			//System.out.println("rs_max1 = " +rs1);
			while (rs1.next()) {
			check_param_name_count = rs1.getInt("count(*)"); }
			System.out.println("check_param_name_count = "+ check_param_name_count);
			//System.out.println("rs_max2 = " +rs1.getInt("count(*)")); }
			redirect_page = "Add_Parameter.jsp";
			param_check_value = "1";

	}
	catch(Exception e)
	{
			System.out.println("ans_check =" + e);
			//e.printStackTrace();
	}
	/////////////////////////////////////////


	//////////////////////////////////////////
	if (check_param_name_count ==1)
	{
		System.out.println("Deleting new variable = "+param_name);

		PreparedStatement statement1=con.prepareStatement("DELETE FROM parameters where parameterName ='"+check+"'");
		PreparedStatement statement2=con.prepareStatement("DROP TABLE "+check+"");
	

		
		try
		{	
			statement1.executeUpdate();
			statement2.executeUpdate();
			
			param_check_value = "2";
		}
		catch(Exception e)
		{
			System.out.println("Insert into parameters Exception = "+ e);//MySQLIntegrityConstraintViolationException
			//close scriptlet within script tag alert("already exists!"); open scriptlet
			redirect_page = "Add_Parameter.jsp";
			param_check_value = "1";

		}
		PreparedStatement statement_max=con.prepareStatement("select * from max_clauses");
		ResultSet rs_max=statement_max.executeQuery();

		int total_clauses=0;
		
		
		
		while(rs_max.next())
		{
			total_clauses=Integer.parseInt(rs_max.getString("no"));
		}

	}
	if (!redirect_page.equals("") )
	{
		response.sendRedirect(redirect_page+"?param_check="+param_check_value);
	}
}
else if(action.equals("CHECK"))
{
	Class.forName("com.mysql.jdbc.Driver");
	Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/tele","root","root");

	PreparedStatement statement4=con.prepareStatement("SELECT * from max_clauses");
	ResultSet rs3=null;
	try
	{
		rs3=statement4.executeQuery();
		
	}
	catch(Exception e)
	{
		e.printStackTrace();
	}
	
	if(rs3.next())
		System.out.println("Max clauses = "+rs3.getString(1));

	
	if(rs3.getString(1).equals("0"))
	{
		out.println("Number of rules existing = 0");
		
		
	}
	else
	{
	
		PreparedStatement statement5=con.prepareStatement("select * from parameters where type='o'");
		rs4=statement5.executeQuery();
		
		//if(rs4.next())
			//System.out.println("value = "+rs4.getString(1));
		
		int flg=0;
		
		while(rs4.next())
		{
			System.out.println("Output String = "+rs4.getString(1));
			if(rs4.getString(1).equals(check))
			{
				PreparedStatement statement6=con.prepareStatement("select count(*) from clause1 where "+check+" is not null");
				rs5=statement6.executeQuery();
				while(rs5.next())
				{
					//out.println("In rs2");
					out.println("Do you want to continue ? Number of rules existing =  "+rs5.getString(1));
					flg=1;
				}
				break;
			}

		}
	
		

		if(flg==0)
		{
			PreparedStatement statement3=con.prepareStatement("select count(*) from clause1 where "+check+"1 is not null");
			System.out.println("The statement is = "+"select count(*) from clause1 where "+check+"1 is not null");
			rs2=statement3.executeQuery();
			
			while(rs2.next())
			{
				//out.println("In rs2");
				out.println("Do you want to continue ? Number of rules existing =  "+rs2.getString(1));
			}
		}
	}
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

