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
String col="";
String my="", my1="";
//int j;

System.out.println("Output String = "+request.getParameter("outputstring"));
String[] outputvalues=(request.getParameter("outputstring")).split(",");

for( int j=0;j<outputvalues.length;j++)
	System.out.println("Output String value = "+outputvalues[j]);

String rn=request.getParameter("rule_name");
String outp="";

ResultSet rs1, rs2, rs3, rs4;
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
PreparedStatement statement1=con.prepareStatement("select parameterName from parameters where type='o'");
rs1=statement1.executeQuery();

String stat="select * from clause1 where ";
//while(rs1.next())
	//System.out.println("Output parameters are = "+rs1.getString("parameterName"));

//PreparedStatement statement1=con.prepareStatement("select * from clause"+i+" where "+col+" is not NULL");
//for(int x=0;x<outputvalues.length;x++)
//{
//PreparedStatement statement2=con.prepareStatement("select * from clause1");
//rs1=statement1.executeQuery();

//while(rs1.next())

//stat+=outputvalue[x]+"='"+
//}
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
		System.out.println("Select = "+select[k]);
		int in=select[k].indexOf("_");
		 col=select[k].substring(0,in)+i;
		System.out.println("col = "+col);

		insert+=col+",";
		//break;
	}
	
	PreparedStatement statement111=con.prepareStatement("select * from clause"+i+" where "+col+" is not NULL");
	System.out.println("The query is = "+"select * from clause"+i+" where "+col+" is not NULL");
	ResultSet result1 = statement111.executeQuery();
	//System.out.println("ResultName  = "+rn);
	
	
	System.out.println("insert now is = "+insert);
	
	if(i==1)
	{
		int flag=0;

		for(int x=0;x<outputvalues.length;x++)
		{
			if(flag==1)
				stat=stat+"and ";
			insert+=outputvalues[x]+",";
			outp=outputvalues[x];
			my=request.getParameter(outp);
			System.out.println("Outp= "+outp);
			System.out.println("Output Value = "+my);
			stat+=outp+"='"+my+"' ";
			flag=1;

		}
		
		System.out.println("Stat = "+stat);
		String temp;
		while(rs1.next())
		{
			flag=0;
			temp=rs1.getString("parameterName");
			//System.out.println("Temp = "+temp);
			for(int x=0;x<outputvalues.length;x++)
			{
				if(temp.equals(outputvalues[x]))
				{
					flag=1;
					break;
				}
			}
			
			if(flag==0)
				stat=stat+"and "+temp+" is null ";
			
			
		}
		
		System.out.println("temp = "+stat);
		
		PreparedStatement statement2=con.prepareStatement(stat);
		rs2=statement2.executeQuery();
		
		PreparedStatement statement3=con.prepareStatement("select count(*) from clause1");
		rs3=statement3.executeQuery();
		
		rs3.next();
			
		String cou = rs3.getString(1);
		System.out.println("Count = "+cou);
		
		if(rs2.next()==false && rs3.next()!=false && cou.equals("0")==false)
		{
			System.out.println("Result set in java is empty");
			// If empty then we need to check for the consistency of the rule
			
			for( i=1;i<=no_of_clauses;i++)
			{
			     //if i =1 total clause; 
			    
				
				select=request.getParameterValues("select"+i);
				
				for(int k=0;k<select.length;k++)
				{
					System.out.println("Select to be inserted = "+select[k]);
					int in=select[k].indexOf("_");
					 col=select[k].substring(0,in)+i;
					System.out.println("col = "+col);
					rs2.first();
					
					PreparedStatement statement4=con.prepareStatement("select "+col+ " from clause"+i);
					System.out.println("select "+col+ " from clause"+i);
					rs4=statement4.executeQuery();
					
					while(rs3.next())
					{
						String go=rs3.getString(col);
						if(go.equals(select[k]))
						{
							out.println("Error");
							
						}
					}

				
					//break;
				}
				
			}
		}
		else
		{
			System.out.println("Result set is not empty");
			String rnn="";
			System.out.println("Insert check = "+insert);
			
			insert+="no_of_clauses ";
			
			insert=insert.substring(0,insert.length()-1);
			insert+=") values ('"+request.getParameter("rule_name")+"',";
			
			System.out.println("Insert check = "+insert);
			
			for(int j=0;j<select.length;j++)
			{
				if(j!=(select.length-1))
				{
				insert+="'"+select[j]+"',";
				rnn=rnn+select[j];
				}
				else if(i!=1 && j==select.length-1)
				{
				insert+="'"+select[j]+"')";
				rnn=rnn+select[j];
				}
			else{
				
				insert+="'"+select[j]+"',";
				rnn=rnn+select[j];
			}
			}
			System.out.println("Rnn = "+rnn);
			System.out.println("Insert here is = "+insert);
			
			System.out.println("Let us check the results of resultset - ");

			System.out.println("Value required to be inserted  ="+my);
			
			while(result1.next())
			{
				i=1;
				System.out.println("result1.getString(col) = "+result1.getString(col));
				my1=result1.getString(outp);
				
				System.out.println("Rule value existing in table = = "+my1);
				
				if(my1==null)
					continue;


				if(result1.getString(col).equals(rnn))
				{
					
					if(my1.equals(my)==false && my1!=null && my!=null )
					{
						out.println("Conflict for action = "+ result1.getString(col)+"!");
						out.println("Rule value existing in table = "+my1);
						out.println("but value required to be inserted = "+my);
						suc=0;
						break;
					}
				}
			
			}
			
			if(suc==0)
			{
				System.out.println("Continuing due to error");
				continue;
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
		//System.out.println("Outp= "+outp);
		//my=request.getParameter(outp);
		//System.out.println("Output Value = "+my);
		insert+="no_of_clauses,";
	}
	//to remove last comma
	
    	
	
	
		
}



if(suc==1){
%><a href="Add_Rule.jsp">Success ! Go to Add rule page</a>
<%}else {%>
<a href="Add_Rule.jsp">Fail! Try again</a>
<%} %>



</body>
</html>