<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import = "java.io.*,java.util.*,java.sql.*, java.util.regex.*, java.util.regex.Matcher, java.util.regex.Pattern,javax.script.ScriptEngineManager ,javax.script.ScriptEngine, javax.script.ScriptException"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Make clause</title>
</head>

<%
/*
drop table if exists clause1v; 
create table clause1v 
select rule_id, anc.aL as aL1 , anc.aR as aR1, 
       plt.pL as pL1 ,plt.pR as pR1 , 
       state.stat as state_val1, 
       mp_dose,mtx_dose,nxt_date,o_state,no_of_clauses  
from imedixdb.clause1  
left outer join imedixdb.anc on (anc.id=clause1.anc1)  
left outer join imedixdb.plt on (plt.id=clause1.plt1)   
left outer join imedixdb.state on (state.id=clause1.i_state1); 
select * from imedixdb.clause1v ; 


drop table if exists clause1v; 
create table clause1v 
select rule_id, anc.ancL as ancL1 , anc.ancR as ancR1, 
       plt.pltL as pltL1 ,plt.pltR as pltR1 , 
       statei.stateival as stateival1, 
       mp_dose,mtx_dose,nxt_date,stateo,no_of_clauses  
from imedixdb.clause1  
left outer join imedixdb.anc on (anc.id=clause1.anc1)  
left outer join imedixdb.plt on (plt.id=clause1.plt1)   
left outer join imedixdb.state on (state.id=clause1.i_state1); 
select * from imedixdb.clause1v ; 

*/

Class.forName("com.mysql.jdbc.Driver");
Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/tele","root","root");

try
{
	PreparedStatement st=con.prepareStatement("select * from max_clauses");
	ResultSet rs1=st.executeQuery();
	int totalclauses=0;
	while(rs1.next())
	totalclauses=Integer.parseInt(rs1.getString("no"));
	
	String outputparameters="";
	
	for(int i=1;i<=totalclauses;i++)
	{
		//String querystring="";
		
		String querystring="drop table if exists clausev"+i;
	
		PreparedStatement sti=con.prepareStatement(querystring);
		sti.executeUpdate();
	
		//String querystring="drop table if exists clausev"+i+"; create table clausev"+i+" as (";


		querystring="create table clausev"+i+" as (";
		String from=" from clause"+i+" "; 
		String select="select rule_name,";
		
		PreparedStatement statement=con.prepareStatement("select * from parameters");
		ResultSet result=statement.executeQuery();
		System.out.println("Print 1 : ");
		
		while(result.next())
		{
			String type=result.getString("type");
			String datatype=result.getString("datatype");
			String name=result.getString("parameterName");
			if(type.equals("i"))
			{
				from+=" left outer join "+name+" on ("+name+".id=clause"+i+"."+name+i+")";
			}
			else
			{
				if(i==1)
				{
					select+=name+",";
					outputparameters+=name+",";
				}
			}
		
		}

		if(i==1)
		{
			select+="no_of_clauses,";
		}
		/*
		
		select rule_id, anc.ancL as ancL1 , anc.ancR as ancR1, 
		plt.pltL as pltL1 ,plt.pltR as pltR1 , 
		statei.stateival as stateival1, 
		mp_dose,mtx_dose,nxt_date,stateo,no_of_clauses  
		from imedixdb.clause1  
		
		*/
		
		PreparedStatement statement2=con.prepareStatement("select * from parameters");
		ResultSet result2=statement2.executeQuery();

		while(result2.next())
		{
			String type=result2.getString("type");
			String datatype=result2.getString("datatype");
			String name=result2.getString("parameterName");
			if(type.equals("i") && datatype.equals("number"))
			{
				select+=name+"."+name+"L  as "+name+"L"+i+","; 
				select+=name+"."+name+"R  as "+name+"R"+i+",";  
			}
			else if(type.equals("i"))
			{
				select+=name+"."+name+"val  as "+name+"val"+i+","; 
			}
			else{
			}
		}

		//remove last comma

		select=select.substring(0,select.length()-1);

		querystring+=" "+select+" "+from;

		querystring+=")";
		System.out.println("Print 2 : ");
		System.out.println("********"+querystring);

		PreparedStatement qstatement=con.prepareStatement(querystring);
		qstatement.executeUpdate();

	}//for loop complete


	outputparameters=outputparameters.substring(0,outputparameters.length()-1);
	
	String outputquery=" select "+outputparameters+" from ";

	for( int i=1;i<=totalclauses;i++)
	{
		if(i!=totalclauses)
			outputquery+="clausev"+i+" natural left outer join  ";
		else
			outputquery+="clausev"+i;
		
	}

	outputquery+=" where ( ";
	/*
	
	(no_of_clauses<1 or (aL1 is not NULL and aR1 is not null  and aL1<=300<=aR1)   
	                 or (pL1 is not null and pR1 is not null and pL1<=400<=pR1)   
	                 or (state_val1 is not null and  state_val1='Not_started') ) 
	
	*/
	
	for(int i=1;i<=totalclauses;i++)
	{
	
		String sth="";
	
		sth+="no_of_clauses<"+i;
	
		PreparedStatement ps=con.prepareStatement("select * from parameters");
		ResultSet rs=ps.executeQuery();
		while(rs.next())
		{
		
			String type=rs.getString("type");
			String datatype=rs.getString("datatype");
			String name=rs.getString("parameterName");
		
			if(type.equals("i"))
			{
				if(datatype.equals("number"))
				{
					sth+=" or( " +name+"L"+i+" is not null and "+name+"R"+i +" is not null and "+name+"L"+i+"<="+ request.getParameter(name)+"<="+name+"R"+i+")";
				}
				else
				{
					sth+=" or( " +name+"val"+i+" is not null and "+name+"val"+i+" = '"+ request.getParameter(name)+"')";
				}
				
			}
			
		}
		if(i==1)
			sth="("+sth+")";
		else
			sth=" and "+"("+sth+")";
	
	
		outputquery+=" "+sth;
	
	}
	
	
	outputquery+=")";
	
	System.out.println("MAIN QUERY "+outputquery );
	
	
	/*********************************/
	
  
    PreparedStatement  stmt = con.prepareStatement(outputquery);             
  
    ResultSet rs = stmt.executeQuery();
    ResultSetMetaData rsmd = rs.getMetaData();
  
	int numberOfColumns = rsmd.getColumnCount();
  
    for (int i = 1; i <= numberOfColumns; i++) 
    {
        if (i > 1) out.print(",  ");
    	String columnName = rsmd.getColumnName(i);
        out.print(columnName);
    }
    out.println("");
      
    //  String ansstring="";
  
    while (rs.next()) 
    {
        for (int i = 1; i <= numberOfColumns; i++) 
        {
          if (i > 1) out.print(",  ");
          String columnValue = rs.getString(i);
          
          
          System.out.println("columnValue= "+columnValue);
          if(columnValue!=null && columnValue.indexOf('[')>=0)
          {
        	  
        	  Pattern p1= Pattern.compile("\\[f\\d+\\]");
        	  Matcher m= p1.matcher(columnValue);
        	  String solve="";String found="";
        	  while(m.find())
        	  {
        		  found=m.group();
        		  System.out.println("found="+found);
        		
        		  PreparedStatement ps1=con.prepareStatement("select formula from formula where id='"+found+"'");
         		  ResultSet rs2=ps1.executeQuery();
         		  System.out.println("select formula from formula where id='"+found+"'");
	        		while(rs2.next())
	        		{
	        			solve=	rs2.getString(1);
	        		}
        		
        		      		
	        		Pattern p2=Pattern.compile("\\[\\w+\\]");
	        		Matcher m2=p2.matcher(solve);
	        		while(m2.find())
	        		{
	        			String found2=m2.group();
	        			String formula2= found2.substring(1,found2.indexOf(']'));
	            		formula2=formula2.trim();
	            		System.out.println("found="+found2);
	            		System.out.println("formula="+formula2);
	        			PreparedStatement psz=con.prepareStatement("select * from Variables where name='"+formula2+"'");
	       				ResultSet rsz=psz.executeQuery();
	        	   		
	        	   	   	System.out.println("select * from Variables where name='"+formula2+"'");
	        	   	   	String colname="";  
	        	   	   	String tabname="";
	        	   	   	String row="";
	        	   		
	        	   	   	while(rsz.next())
	        	   		{
	        	   			colname=rsz.getString(2);
	        	   			tabname=rsz.getString(3);
	        	   			row=rsz.getString(4);
	        	   		}
	        	   		
	
	        	   		if(row.equals("MR"))
	        	   		{
	        	   			PreparedStatement psz2=con.prepareStatement("select "+colname+" from "+tabname+" order by sno desc limit 1");
	        	   			
	        	   			//System.out.println("select "+colname+" from "+tabname+" order by sno desc limit 1");
	        	    		
	        	   			ResultSet rsz2=psz2.executeQuery();
	        	    		while(rsz2.next())
	        	    		{
	        	    			
	        	    		   solve=solve.replace(found2,rsz2.getString(1));
	        	    		   System.out.println("solve here = "+solve);
	        	    		}
	        	    		   
	        	   		}
	        	   		else if (row.equals("LNZ"))
	        	   		{
	        	   			
	        	   		   PreparedStatement psz2=con.prepareStatement("select "+colname+" from "+tabname+" where colname <> 0 order by sno desc limit 1 ");
	        			   ResultSet rsz2=psz2.executeQuery();
	        			   while(rsz2.next())
	        			   {
	        				   solve=solve.replace(found2,rsz2.getString(1));	
	        			   		System.out.println("solve here = "+solve);
	        			   }
	        	   		}
	        	   
        			}
        		        		  
        	  	}
        	    
        	  
	        	columnValue=columnValue.replace(found,solve);
	        	        	  
	        	ScriptEngineManager mgr = new ScriptEngineManager();
	        	ScriptEngine engine = mgr.getEngineByName("JavaScript");
	        	    
	        	columnValue=(engine.eval(columnValue)).toString();
	        	  
	        	    
	        	System.out.println("d===="+engine.eval(columnValue));
	        	//System.out.println("columnValue here is "+columnValue);
        	  
          }

         out.print(columnValue);
        }
       out.println("");  
     }
%>
    <br><br><a href="/rulebase/Home_page.jsp" class="btn btn-info" role="button">Home Page</a>
<%
		 /*    
		 
		 int l= ansstring.length();
		     String copy=ansstring;
		     String replaced= copy.replace("f", "");
		     
		      int nooff=l-replaced.length();
		      
		      out.println(nooff);
		      
		      while(nooff>0)
		      {
		    	  int i1=ansstring.indexOf('f',0);
		    	
		           
		    	  
		      }
		   */   
      
}  
catch(Exception e)
{
	System.out.println("You have catch the exception e : " + e);	
}
      
%>




<body>

</body>
</html>