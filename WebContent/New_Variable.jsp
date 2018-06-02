<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Insert title here</title>
</head>

<%

if((request.getParameter("fail"))== null)
{%>

<%
}
else if((request.getParameter("fail")).equals("yes"))
{%>
<script>alert("Failed to Add");</script>
<% }
else{%>
<script>alert("Successfully Added");</script>

<%} %>




<body>
<form action="sNew_Variable.jsp">

<label>Name:</label><input id="nametb" name="nametb" type="text"></input>

<br>
<label>Column Name:</label><input id="colname" name="colname"   type="text"></input>
<br>
<label>Table Name:</label><input id="tabname"  name="tabname"          type="text"></input>
<br>
<label>Row to select on fetching multiple rows:</label>
<select id="rowtype"   name="rowtype">
  <option value="MR">Most Recent</option>
  <option value="LNZ">Last Non-Zero</option>
</select>

<br>
<input type="submit" value="Add variable" ></input>



</form>
</body>
</html>