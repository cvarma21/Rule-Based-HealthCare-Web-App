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

int suc=1;					 int cnt=0;

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
    	
	
	//PreparedStatement statement111=con.prepareStatement("select * from parameters where type = 'i'");
	PreparedStatement statement111=con.prepareStatement("select * from parameters ");
	ResultSet rs111=statement111.executeQuery();
	
	while(rs111.next())
	{
		String para = rs111.getString("parameterName");
		System.out.println("Parameter = "+para);
		
		outputStream.write("(declare-fun "+para+" () Int)");
		outputStream.println();
		
	}
	
	//Now we have added the delarations for the input variables in the out.txt, to do the same for the putput parameters
	
	PreparedStatement statement2=con.prepareStatement("select * from max_clauses");
	

	ResultSet rs2 = statement2.executeQuery();
	
	rs2.next();
	//String no = rs1.getString(1);
	int no1 = rs2.getInt(1);
	System.out.println("Max clauses= "+no1);
	/*
	for( int k=1;k<=no1;k++)
	{
		PreparedStatement statement3=con.prepareStatement("select *  FROM clause"+k+" order by rule_name + 0 ASC");
		
		ResultSet rs3=statement3.executeQuery();
		String col="";
		while(rs3.next())
		{
			int no2=rs3.getInt("rule_name");
			System.out.println("No = "+no2);
			
			
			for(int l=0;l<select.length;l++)
			{
				int in=select[l].indexOf("_");
				 col=select[l].substring(0,in);
				System.out.println("Col = "+col);
				
				//outputStream.write("(declare-fun "+col+" () Int)");
				//outputStream.println();
			
			}
			outputStream.write("(declare-fun "+col+" () Int)");
			outputStream.println();
			//Now try to add to the input clauses here
			
			
			
			
			
			
		}
		outputStream.close();
		
	}
	*/
	
	PreparedStatement statement3=con.prepareStatement("select *  FROM clause1 order by rule_name + 0 ASC");
	
	ResultSet rs3=statement3.executeQuery();
	String col="";
	while(rs3.next())
	{
		int no2=rs3.getInt("rule_name");
		System.out.println("Current rule No = "+no2);
		
		
		for(int l=0;l<select.length;l++)
		{
			int in=select[l].indexOf("_");
			 col=select[l].substring(0,in);
			System.out.println("Col = "+col);
			
			//outputStream.write("(declare-fun "+col+" () Int)");
			//outputStream.println();
		
		}
		String temp="";
		outputStream.write("(define-fun rule"+no2+"_applies () Bool (and " );
		temp+="(define-fun rule"+no2+"_applies () Bool (and ";
		
		
		PreparedStatement statement4=con.prepareStatement("select * from clause1 where rule_name='"+no2+"'");
		System.out.println("The query is = select * from clause1 where rule_name='"+no2+"'");
		
		ResultSet rs4=statement4.executeQuery();
		rs4.next();// This contains the results of the query of the rule which is currenlty being produced
		
		ResultSetMetaData rsmd = rs3.getMetaData();
		
		int colno = rsmd.getColumnCount();
		System.out.println("Number of columns = "+colno);
		
		
		
		for(int j=1;j<=colno;j++)
		{
			String colname =rsmd.getColumnName(j);
			System.out.println("Column Name = "+colname);
			
			String inp = rs4.getString(colname);
			System.out.println("inp = "+inp);
			boolean numeric  = true;
			
			
	       if(inp!=null)
	       {
	    	   try
		        {
		            Double num = Double.parseDouble(inp);
		            
		        } 
		        catch (NumberFormatException e)
		        {
		            numeric = false;
		        }
	       }
	        
			/*
	        if(numeric)
	            System.out.println(inp + " is a number");
	        else
	            System.out.println(inp + " is not a number");
			*/
			
			if(inp!=null && numeric==false)
			{	
				//This means that the rule has atleast 1 predicate and now we need to check for the rest of the predicates
				int flag=0;
				for(int k=j+1;k<=colno;k++)
				{
					String colname1 =rsmd.getColumnName(k);
					System.out.println("Column Name in the loop = "+colname1);
					
					String inpt = rs4.getString(colname1);
					System.out.println("inpt in the loop = "+inpt);
					
					
					 boolean numeric1  = true;
					 cnt=0;
					
					
				       if(inpt!=null)
				       {
				    	   try
					        {
					            Double num = Double.parseDouble(inpt);
					            
					        } 
					        catch (NumberFormatException e)
					        {
					            numeric1 = false;
					        }
				       }
				        
					if(inpt!=null && numeric1==false)
					{
						System.out.println("There is a value which is not null and it is equal to = "+inpt);
						cnt++;
						flag=1;
						break;
						
					}
						
				}
				if(flag==0)
					System.out.println("There is only 1");
				else
					System.out.println("There is more than 1");
				
				//This means that the string inp is the input variable and we need to access it
				String inp1 = inp.substring(0, inp.length()-2);
				System.out.println("Inp1 = "+inp1);
				
				PreparedStatement statement5=con.prepareStatement("select * from "+inp1+" where id = '"+inp+"'");
				ResultSet rs5=statement5.executeQuery();//This contains the result of the query which contains the limits
				
				rs5.next();
				
				String inp1l = inp1+"L";
				String inp1r = inp1+"R";
				
				System.out.println("inp1l = "+inp1l);
				System.out.println("inp1r = "+inp1r);
				
				
				int ll = rs5.getInt(inp1l);
				int rr = rs5.getInt(inp1r);
				
				System.out.println("Left limit = "+ll);
				System.out.println("Right limit = "+rr);
				
				//Before writing here we need to check if the rule exists in different clauses or not
				
				if(flag==0)// This means there is only 1 
				{
					outputStream.write("(range "+inp1+" "+ll+" "+rr+" )");
					temp+="(range "+inp1+" "+ll+" "+rr+" )";
					cnt--;
				}
				else // This means that there is more than 1
				{
					outputStream.write("(or (range "+inp1+" "+ll+" "+rr+" )");
					temp+="(or (range "+inp1+" "+ll+" "+rr+" )";
					cnt--;
				}
				/*
				for(int m=2;m<=no1;m++)
				{
					System.out.println("Currently in clause = "+m);
					PreparedStatement statement6=con.prepareStatement("select * from clause"+m+" where rule_name = '"+no2+"'");
					ResultSet rs6=statement6.executeQuery();
					
					rs6.next();
					

					ResultSetMetaData rsmd1 = rs6.getMetaData();
					
					colno = rsmd1.getColumnCount();
					System.out.println("Number of columns = "+colno);
					
					for(int n=1;n<=colno;n++)
					{
						colname =rsmd1.getColumnName(n);
						System.out.println("Column Name = "+colname);
						rs6.next();
						String inpx = rs6.getString(colname);
						System.out.println("inp = "+inpx);
						numeric  = true;
						
						
				       if(inpx!=null)
				       {
				    	   try
					        {
					            Double num = Double.parseDouble(inp);
					            
					        } 
					        catch (NumberFormatException e)
					        {
					            numeric = false;
					        }
				       }
				        
						/*
				        if(numeric)
				            System.out.println(inp + " is a number");
				        else
				            System.out.println(inp + " is not a number");
						
						
						if(inpx!=null && numeric==false)
						{	
							//This means that the rule has atleast 1 predicate and now we need to check for the rest of the predicates
							 flag=0;
							for(int o=n+1;o<=colno;n++)
							{
								String colname1 =rsmd.getColumnName(o);
								System.out.println("Column Name in the loop = "+colname1);
								
								String inpt = rs4.getString(colname1);
								System.out.println("inpt in the loop = "+inpt);
								
								
								 boolean numeric1  = true;
								 cnt=0;
								
								
							       if(inpt!=null)
							       {
							    	   try
								        {
								            Double num = Double.parseDouble(inpt);
								            
								        } 
								        catch (NumberFormatException e)
								        {
								            numeric1 = false;
								        }
							       }
							        
								if(inpt!=null && numeric1==false)
								{
									System.out.println("There is a value which is not null and it is equal to = "+inpt);
									cnt++;
									flag=1;
									break;
									
								}
									
							}
						}
					}
					

				}
				*/
				int lb = 0, rb = 0, diff=0;
				for(int l=0;l<temp.length();l++)
				{
					char ch = temp.charAt(l);
					if(ch=='(')
							lb++;
					else if(ch==')')
						rb++;
					
					
				}
				
				if(lb>rb)
					 diff=lb-rb;
				System.out.println("cnt= "+cnt);
				if(cnt==-1)
				{
					while(diff>0)
					{
						outputStream.write(")");
						diff--;

					}
					
				}
				
								//outputStream.println();
			}
			
			//outputStream.println();

	
		
		}
		outputStream.println();


	}
	outputStream.close();

}

if(suc==1){
			%><a href="Add_Rule.jsp">Success ! Go to Add rule page</a>
			<%}else {%>
			<a href="Add_Rule.jsp">Fail! Try again</a>
			<%} %>


</body>
</html>