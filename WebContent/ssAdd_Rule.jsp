<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    
     <%@ page import = "java.io.*,java.util.*,java.sql.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>ssAdd_Rule</title>
</head>
<body>

<% 
System.out.println(request.getParameter("outputstring"));
String hello = request.getParameter("submit");

System.out.println("Hello = "+hello);

String rule = request.getParameter("rule");
System.out.println("Rule = "+rule);



String[] outputvalues=(request.getParameter("outputstring")).split(",");

String[] parameter_names=new String[1000];int pi=0;
Class.forName("com.mysql.jdbc.Driver");
Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/tele","root","root");

PreparedStatement statement=con.prepareStatement("select * from max_clauses");
PreparedStatement statementforp=con.prepareStatement("select * from parameters order by type");
ResultSet resultforp=statementforp.executeQuery();


ResultSet result=statement.executeQuery();
String clause1="";


int no=0;

while(result.next())
{
no=Integer.parseInt(result.getString("no"));
}
while(resultforp.next())
{
	
	if((resultforp.getString("type")).equals("o") && no==0)
	{
		clause1+=resultforp.getString("parameterName")+" varchar(45),";
	}
	
	else if((resultforp.getString("type")).equals("i"))   
	{
		parameter_names[pi++]=resultforp.getString("parameterName");
	}
	
	
}

int no_of_clauses=Integer.parseInt(request.getParameter("intTextBox"));
if(no_of_clauses>no)
{
	
	while(no_of_clauses!=no)
	{
		
		no++;
		
		String createStatement="create table clause"+no+"(rule_name varchar(45),";
		for(int i=0;i<pi;i++)
		{
			createStatement+=parameter_names[i]+no+" varchar(45),";	
		}
		if(no==1)
		{
			createStatement+=clause1;
			createStatement+="no_of_clauses int(32) , primary key(rule_name))";
		}
		else
		{
			createStatement+="primary key(rule_name))";
		}
		
///'mtx_dose varchar(45)nxt_date varchar(45)stateo varchar(45)null varchar(45),no_of' at line 1

		
PreparedStatement statementforcreate=con.prepareStatement(createStatement);
System.out.println(createStatement);
statementforcreate.executeUpdate();
	}
	
}



PreparedStatement statementforupdate=con.prepareStatement("update max_clauses set no="+no);
statementforupdate.executeUpdate();


//insert query insert into clause1  (rule_name,anc1,plt1,null) values ('R2','anc_0','plt_0','null',)
//insert query insert into clause2  (rule_name,plt2) values ('R2','plt_0')

int suc=1;
for(int i=1;i<=no_of_clauses;i++)
{
     //if i =1 total clause; 
	
	String[] select=request.getParameterValues("select"+i);
	String insert="insert into clause"+i+"  (rule_name,";
	System.out.println("here insert is "+insert);
	for(int k=0;k<select.length;k++)
	{
		int in=select[k].indexOf("_");
		String col=select[k].substring(0,in)+i;
		insert+=col+",";
		
	}
	if(i==1)
	{
		for(int x=0;x<outputvalues.length;x++)
		{
			insert+=outputvalues[x]+",";
		}
		
		insert+="no_of_clauses,";
	}
	//to remove last comma
	insert=insert.substring(0,insert.length()-1);
	insert+=") values ('"+request.getParameter("rule_name")+"',";
	for(int j=0;j<select.length;j++)
	{
		if(j!=(select.length-1))
		insert+="'"+select[j]+"',";
		else if(i!=1 && j==select.length-1)
		insert+="'"+select[j]+"')";
	else{
		
		insert+="'"+select[j]+"',";
		
	}
	}
	
	if(i==1)
	{
	
	
	for(int b=0;b<outputvalues.length;b++)
	{
		
        insert+="'"+request.getParameter(outputvalues[b])+"',";

			
	}	
	
	insert+=no_of_clauses+")";
	
	}
	
	PreparedStatement insquery=con.prepareStatement(insert);
	System.out.println("final insert query :"+insert);
	
	try{insquery.executeUpdate();}
	catch(Exception e)
	{
		suc=0;
		System.out.println("Exception "+e);
	}
    	
	
	
		
}



if(suc==1){
%><a href="Add_Rule.jsp">Success ! Go to Add rule page</a>
<%}else {%>
<a href="Add_Rule.jsp">Fail! Try again</a>
<%} %>



</body>
</html>