<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@ page import = "java.io.*,java.util.*,java.sql.*"%>
       
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>
<body>


<%    String[] input=request.getParameterValues("input");



String inputtext="";
for(int i=0;i<input.length;i++)
{
inputtext+=input[i]+"<input type='text' name='"+input[i]+"'  id='"+input[i]+"'><br><br>";	
}



response.sendRedirect("Get_Dosage.jsp?inputtext="+inputtext);

%>




</body>
</html>