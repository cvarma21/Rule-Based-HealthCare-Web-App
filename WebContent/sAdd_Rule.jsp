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
String filename = "/home/chaitanya/workspace/rulebase/WebContent/out.txt";
PrintWriter outputStream = null;
/*
try
{
 outputStream = new PrintWriter(new File (filename));
outputStream.write("Hi there file !");
outputStream.println();
outputStream.close();
}
catch(IOException e)
{
    System.err.println("error is: "+e.getMessage());
}

System.out.println("File Created!");
*/


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
		System.out.println("Rule  = "+statement2);
		statement2.executeUpdate();
		
		PreparedStatement statement3=con.prepareStatement("select count(*) from clause"+i);
		ResultSet rs3=statement3.executeQuery();

		rs3.next();
		
		String check=rs3.getString(1);
		System.out.println("Number of tuples in clause"+i+" = "+check);
		
		
		if(check.equals("0"))
		{
			System.out.println("Tupes = 0");
			
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
	//if(hello.equals("SHOW TABLES")==false)
{

//System.out.println("inot "+input);
if((input == null) || (output == null))
{
	response.sendRedirect("Add_Rule.jsp?io_flag=0");	
}


try{
	
		
		
		for(int i=0;i<output.length;i++)
		{
			if(i!= (output.length-1))
				outputstring+=output[i]+",";
			else
				outputstring+=output[i];
		}
		
		
		/*for(int i=0;i<input.length;i++)
			{
			
			if(i!=(input.length-1))
			inputstring+=input[i]+",";
			else
			inputstring+=input[i];
			}
		*/

		/*
		<select>
		  <option value="volvo">Volvo</option>
		  <option value="saab">Saab</option>
		  <option value="opel">Opel</option>
		  <option value="audi">Audi</option>
		</select>
		  
		
		
		*/
		
		
		Class.forName("com.mysql.jdbc.Driver");
		Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/tele","root","root");
		
		
		
		
		for(int i=0;i<output.length;i++)
		{
		outputtext+=output[i]+"<input type='text' name='"+output[i]+"'  id='"+output[i]+"'></input><input type='button' value='Formula' onclick='formula_open()'></input><br><br>";
			
		}
		
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
		
		PreparedStatement statement1=con.prepareStatement("select * from max_clauses");
		ResultSet rs1 = statement1.executeQuery();
		
		rs1.next();
		//String no = rs1.getString(1);
		int no = rs1.getInt(1);
		System.out.println("Max clauses= "+no);
		String table1="<table>";

		int colno;
		for(int i=1;i<=no;i++)
		{
			PreparedStatement statement2=con.prepareStatement("select * from clause"+i);
			ResultSet rs2=statement2.executeQuery();
			ResultSetMetaData rsmd = rs2.getMetaData();
			
			colno = rsmd.getColumnCount();
			System.out.println("Number of columns = "+colno);
			
			table1+="<table border='1'>";

			
			for(int j=1;j<=colno;j++)
			{
				String colname =rsmd.getColumnName(j);
				//System.out.println("Column Name = "+colname);
				//table1+="<td>"+"<th>"+colname+"</th>";	
				//table1+="<td>"+colname;	
				table1+="<th>"+colname+"</th>";	

				
				
			}
			
			table1+="<tr>";
			//rs2.next();
			
			while(rs2.next())
			{
				int flag=0;
				//table1+="<input id=\"myRadio\" type=\"radio \" </input>";
				for(int j=1;j<=colno;j++)
				{
					

					String colval = rs2.getString(j);
					String colname =rsmd.getColumnName(j);

					System.out.println("String = "+colval);
					
					if(j!=1 && flag==0 )
					{
						table1+="<input id=\"myRadio\" type= \"radio\" name=\"rule\"  value = "+rs2.getString(1)+" </input>"; 
						flag=1;
					}
					table1+="<td>"+colval;	
					//table1+="<td><input id=\"myRadio\" type=\"radio \" </input>"+colval;
				}
				
				table1+="<tr>";
			}
			
			table1+="<br>";
			//table1+="</table>";

			
			
			
			

		}
		table1+="</table>";
		inputtables+="<br>"+table1+"<br>";

		
		inputdrop+="</select>";
		
		inputtables+="</div>";
		outputtext+="</div>";
		
		inputstring=inputstring.substring(0,inputstring.length()-1);
		response.sendRedirect("Add_Rule.jsp?tables="+inputtables+"&inputdrop="+inputdrop+"&outputtext="+outputtext+"&inputstring="+inputstring+"&outputstring="+outputstring);
}
catch(Exception e)
{
	System.out.println("Exception to Add rule : " + e);	
	
}

}
%>
<body>


<%=inputtables %>
<%=inputdrop %>
<%=outputtext %>
<%=inputstring %>
</body>
</html>