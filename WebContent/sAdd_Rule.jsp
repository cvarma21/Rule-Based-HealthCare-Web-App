<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
     <%@ page import = "java.io.*,java.util.*,java.sql.*,  java.io.PrintWriter;"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>


<script>

function formula_open()
{
	alert("clicked");
	//window.open("Formula_Calculator.jsp");
	}

function deleted()
{
	
	alert("rule successfully deleted");
}
</script>


<%
/*
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


/*
Process ls=null;
BufferedReader input1=null;
String line=null;

    try {

           //ls= Runtime.getRuntime().exec("z3 example1.smt");
           
           ls= Runtime.getRuntime().exec("z3 out.smt");
           
           input1 = new BufferedReader(new InputStreamReader(ls.getInputStream()));

	        } catch (IOException e1) {
            e1.printStackTrace();  
            System.out.println("In try 1");
            		
            System.exit(1);
        }
        
       int flag1=0;
       try {
               while( (line=input1.readLine())!=null)
               {
                System.out.println(line);
                if(line.equals("sat"))
                	flag1=1;
                	
                //System.out.println("In printing stage");
               }

        } catch (IOException e1) {
            e1.printStackTrace();  
            System.out.println("In try 2");
            		
            System.exit(0);
        }         
		if(flag1==1)
			System.out.println("SAT");
            		else
            			System.out.println("UNSAT");
            		
            	
            		
outputStream.write("(define-fun range ((x Int) (lower Int) (upper Int)) Bool (and (< lower x) (< x upper)))");
outputStream.println();
outputStream.close();
5*/
            		
String filemat;
String inputstring="";
String outputstring="";
String inputdrop="<select id='inputdrop' name='inputdrop'>";
String outputtext="<div><br>";
String inputtables="<div>";

String[] input=request.getParameterValues("input");
String[] output=request.getParameterValues("output");

String rule = request.getParameter("rule");
System.out.println("Rule = "+rule);

String hello = request.getParameter("submit");

System.out.println("Hello = "+hello);



if(hello.equals("DEL RULE") && hello.equals("null")==false)
{
	
	Class.forName("com.mysql.jdbc.Driver");
	Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/tele","root","root");
	PreparedStatement statement1=con.prepareStatement("select * from max_clauses");
	

	ResultSet rs1 = statement1.executeQuery();
	
	rs1.next();
	//String no = rs1.getString(1);
	int no = rs1.getInt(1);
	System.out.println("Max clauses= "+no);
	
	for(int i=1;i<=no;i++)
	{
		PreparedStatement statement2=con.prepareStatement("delete  FROM clause"+i+" WHERE rule_name="+rule);
		statement2.executeUpdate();
		
		PreparedStatement statement3=con.prepareStatement("select count(*) from clause"+i);
		ResultSet rs3=statement3.executeQuery();

		rs3.next();
		
		String check=rs3.getString(1);
		System.out.println("Number of tuples in clause"+i+" = "+check);
		
		
		if(check.equals("0"))
		{
			System.out.println("Tuples = 0");
			
			PreparedStatement statement4=con.prepareStatement("drop table clause"+i);
			statement4.executeUpdate();
			System.out.println("Table dropped");
			
			int no1=no-1;
			PreparedStatement statement5=con.prepareStatement("update max_clauses set no="+no1);
			statement5.executeUpdate();
			
			System.out.println("New numbe rof max_clauses = "+no1);
			

		}
		

		
		


	}
	response.sendRedirect("Add_Rule.jsp?io_flag=0");	
	
	

}
else 
{

//System.out.println("inot "+input);
if((input == null) || (output == null))
{
	response.sendRedirect("Add_Rule.jsp?io_flag=0");	
	
}

System.out.println("In show tables");

Class.forName("com.mysql.jdbc.Driver");
Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/tele","root","root");
PreparedStatement statement1 = con.prepareStatement("create table mytable ( rule_name varchar(20), primary key (rule_name))");
statement1.execute();
PreparedStatement statement2=con.prepareStatement("select * from max_clauses");


ResultSet rs2 = statement2.executeQuery();

rs2.next();
//String no = rs1.getString(1);
int no = rs2.getInt(1);
System.out.println("Max clauses= "+no);
int flag1=0;
for(int i=1;i<=no;i++)
{
	System.out.println("Current clause is = "+i);
	PreparedStatement statement3=con.prepareStatement("select * from clause"+i);
	ResultSet rs3 = statement3.executeQuery();
	
	ResultSetMetaData rsmd = rs3.getMetaData();
	
	int colno = rsmd.getColumnCount();
	
	for(int j=1;j<=colno;j++)
	{
		String colname =rsmd.getColumnName(j);
		if(colname.equals("rule_name")==false)
		{
		PreparedStatement statement4=con.prepareStatement("alter table mytable add column "+colname+" varchar(20)");
		statement4.execute();
		}
		
	}
	if(flag1==0)
	{
		PreparedStatement statement0=con.prepareStatement("select * from clause1");
		ResultSet rs0=statement0.executeQuery();
		
		while(rs0.next())
		{
			System.out.println("insert into mytable (rule_name) values ('"+rs0.getString(1)+"');");
			PreparedStatement statement00=con.prepareStatement("insert into mytable (rule_name) values ('"+rs0.getString(1)+"');");
			statement00.executeUpdate();
		}
		flag1=1;
	}
	
	// Now all the tables have been generated
	
	PreparedStatement statement5=con.prepareStatement("select * from clause1");
	ResultSet rs5=statement5.executeQuery();
	
	while(rs5.next())
	{
			String rul=rs5.getString("rule_name");
			System.out.println("Current rule  = "+ rul);
			
			 rsmd = rs3.getMetaData();
			
			 colno = rsmd.getColumnCount();
			
			for( int j=2;j<=colno;j++)
			{
				String colname = rsmd.getColumnName(j);
				System.out.println("Colname = "+colname);
				
				PreparedStatement statement6=con.prepareStatement("select "+colname+" from clause"+i+" where rule_name='"+rul+"'");
	
				ResultSet rs6=statement6.executeQuery();
				String check="";
				if(rs6.next())
				 check=rs6.getString(1);
				System.out.println("Check = "+check);
				
				
				if(check!=null)
				{
					//System.out.println("insert into mytable (rule_name, "+colname+") values ("+rul+","+check+");");
					//PreparedStatement statement7=con.prepareStatement("insert into mytable (rule_name, "+colname+") values ('"+rul+"','"+check+"');");
					PreparedStatement statement7=con.prepareStatement("update mytable set "+colname+" = '"+check+"' where rule_name = '"+rul+"';");
					System.out.println("update mytable set "+colname+" = '"+check+"' where rule_name = '"+rul+"';");
					statement7.execute();
					

				}

			}
			
	}
	
	
	

}
String table1="";


try{
	
		
		
		for(int i=0;i<output.length;i++)
		{
			if(i!= (output.length-1))
				outputstring+=output[i]+",";
			else
				outputstring+=output[i];
		}
		
		
		//ok
		
		
		
		
		
		
		for(int i=0;i<output.length;i++)
		{
		outputtext+=output[i]+"<input type='text' name='"+output[i]+"'  id='"+output[i]+"'></input><input type='button' value='Formula' onclick='formula_open()'></input><br><br>";
			
		}
		//ok
		
		for(int i=0;i<input.length;i++)
		{
			String table="<table>";
			PreparedStatement statement=con.prepareStatement("select * from "+input[i]);
			
			ResultSet result=statement.executeQuery();
			ResultSetMetaData rsmd = result.getMetaData();
			int columnsNumber = rsmd.getColumnCount();
			if(columnsNumber==3)
			{
				table+="<table border='1'><th>id</th><th>left_limit</th><th>right_limit</th>";
				while(result.next())
				{
					inputstring+=result.getString(1)+",";
					inputdrop+="<option value="+result.getString(1)+">"+result.getString(1)+"</option>";
					table+="<tr><td>"+result.getString(1)+"</td><td>"+result.getString(2)+"</td><td>"+result.getString(3)+"</td></tr>";	
				}
				table+="</table>";
			}
			else
			{
				table+="<table border='1'><th>id</th><th>value</th>";
				while(result.next())
				{
					inputstring+=result.getString(1)+",";
					inputdrop+="<option value="+result.getString(1)+">"+result.getString(1)+"</option>";
					table+="<tr><td>"+result.getString(1)+"</td><td>"+result.getString(2)+"</td></tr>";	
				}
				table+="</table>";
			}
		
			inputtables+="<br>"+table;
		
		
		}
		
		PreparedStatement statement11=con.prepareStatement("select * from mytable  order by rule_name+0 asc;");
		ResultSet rs1 = statement11.executeQuery();
		
		ResultSetMetaData rsmd = rs1.getMetaData();
		
		int colno = rsmd.getColumnCount();
		System.out.println("Number of columns = "+colno);
		
		table1+="<table border='1'>";

		
		for(int j=1;j<=colno;j++)
		{
			String colname =rsmd.getColumnName(j);
			System.out.println("Column Name = "+colname);
			//table1+="<td>"+"<th>"+colname+"</th>";	
			//table1+="<td>"+colname;	
			table1+="<th>"+colname+"</th>";	

			
			
		}
		
		table1+="<tr>";
		
		while(rs1.next())
		{
			int flag=0;
			for(int j=1;j<=colno;j++)
			{
				

				String colval = rs1.getString(j);
				String colname =rsmd.getColumnName(j);

				
				if(j!=1 && flag==0 )
				{
					table1+="<input id=\"myRadio\" type= \"radio\" name=\"rule\"  value = "+rs1.getString(1)+" </input>"; 
					flag=1;
				}
				table1+="<td>"+colval;	
				//table1+="<td><input id=\"myRadio\" type=\"radio \" </input>"+colval;
			}
			
			table1+="<tr>";
		}
		
		table1+="<br>";
	

		PreparedStatement statement111=con.prepareStatement("drop table mytable;");
		statement111.executeUpdate();
			
			
			

}
catch(Exception e)
{
	System.out.println("Exception to Add rule : " + e);	
	
}

		
		table1+="</table>";
		inputtables+="<br>"+table1+"<br>";

		
		inputdrop+="</select>";
		
		inputtables+="</div>";
		outputtext+="</div>";
		
		System.out.println("inputstring = "+inputstring);
		inputstring=inputstring.substring(0,inputstring.length()-1);
		
		
		response.sendRedirect("Add_Rule.jsp?tables="+inputtables+"&inputdrop="+inputdrop+"&outputtext="+outputtext+"&inputstring="+inputstring+"&outputstring="+outputstring);
	


}
%>
<body>


<%=inputtables %>
<%=inputdrop %>
<%=outputtext %>
<%=inputstring %>
</body>
</html>