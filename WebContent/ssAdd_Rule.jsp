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

String filename = "/home/chaitanya/workspace/rulebase/WebContent/out.txt";
PrintWriter outputStream = null;

try
{
 outputStream = new PrintWriter(new File (filename));
//outputStream.write("Hi there file !");
outputStream.println();
//outputStream.close();
}
catch(IOException e)
{
    System.err.println("error is: "+e.getMessage());
}

System.out.println("File Created!");



System.out.println(request.getParameter("outputstring"));

outputStream.write("(define-fun range ((x Int) (lower Int) (upper Int)) Bool (and (< lower x) (< x upper)))");
outputStream.println();
//outputStream.close();
/*
String hello = request.getParameter("hello");

System.out.println("Hello = "+hello);

String rule = request.getParameter("rule");
System.out.println("Rule = "+rule);

if(hello.equals("DEL RULE"))
{
	
	Class.forName("com.mysql.jdbc.Driver");
	Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/tele","root","root");
	PreparedStatement statement1=con.prepareStatement("select * from max_clauses");
	

	ResultSet rs1 = statement1.executeQuery();
	
	rs1.next();
	//String no = rs1.getString(1);
	int no = rs1.getInt(1);
	System.out.println("Max clauses= "+no);
}

*/

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
	System.out.println("And here insert is = "+insert);
	
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
    	
	
	PreparedStatement statement2=con.prepareStatement("select * from max_clauses");
	

	ResultSet rs2 = statement2.executeQuery();
	
	rs2.next();
	//String no = rs1.getString(1);
	int no1 = rs2.getInt(1);
	System.out.println("Max clauses= "+no1);
	
	for( int k=1;k<=no1;k++)
	{
		PreparedStatement statement3=con.prepareStatement("select *  FROM clause"+k);
		ResultSet rs3=statement3.executeQuery();
		
		while(rs3.next())
		{
			int no2=rs3.getInt("rule_name");
			//System.out.println("no = "+no2);
			
			for(int l=0;l<select.length;l++)
			{
				int in=select[l].indexOf("_");
				String col=select[l].substring(0,in)+i;
				System.out.println("Col = "+col);
				
				outputStream.write("(declare-fun "+col+" () Int)");
				outputStream.println();
			
			}
			
			outputStream.close();
			
			
			
			
		}
	}
		
}



if(suc==1){
%><a href="Add_Rule.jsp">Success ! Go to Add rule page</a>
<%}else {%>
<a href="Add_Rule.jsp">Fail! Try again</a>
<%} %>



</body>
</html>