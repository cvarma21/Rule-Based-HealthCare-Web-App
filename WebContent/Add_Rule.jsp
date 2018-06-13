<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    <%@ page import = "java.io.*,java.util.*,java.sql.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Add Rule</title>
</head>

<% 
String io_flag=request.getParameter("io_flag");
%>

<script>
function alertName()
{
	//if(param_check.equals(1)){
	var par = '<%= io_flag%>';
	if (par == '0')
	{
		alert("Please select the input and output \"both\" variables for adding rule" );
		//alert(par);
	}	

}


function formula_open()
{
	alert("clicked");
	window.open("Formula_Calculator.jsp");
	}


</script>

<%

String tables=request.getParameter("tables");
String inputdrop=request.getParameter("inputdrop");
String outputtext=request.getParameter("outputtext");
String inputstring=request.getParameter("inputstring");
String outputstring=request.getParameter("outputstring");

//System.out.println(tables + inputdrop + outputtext + inputstring + outputstring );

Class.forName("com.mysql.jdbc.Driver");
Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/tele","root","root");

PreparedStatement statement=con.prepareStatement("select * from parameters");

ResultSet result=statement.executeQuery();

String inputcheckboxes="";
String outputcheckboxes="";

while(result.next())
{
	String type=result.getString("type");
	if(type.equals("i"))
	{
		inputcheckboxes+="<input TYPE='checkbox'  name='input' VALUE="+result.getString("parameterName")+">"+result.getString("parameterName")+"</input><br>";
	}
	else
	{
		outputcheckboxes+="<input TYPE='checkbox' name='output' VALUE="+result.getString("parameterName")+">"+result.getString("parameterName")+"</input><br>";	
	}
}

%>


<body onload = "alertName()">



<form action="sAdd_Rule.jsp">

<h4>Choose input parameters:</h4> 
<%=inputcheckboxes %>
<br> <hr>

<h4>Choose output parameters:</h4> 
<%=outputcheckboxes %>
<br><hr>

<a href="/rulebase/Home_page.jsp" class="btn btn-info" role="button">Home Page</a>
<br> <hr>

<input type="submit" name="submit" value="Show tables"></input>
<br>

<%

	String table = tables;
	if (table != null)
	{
		%><%=tables %><% 
	}	

%>


<!-- %=tables %-->

<input type="submit" name="submit"  action = "hello" value="DEL RULE"></input>

<br><hr>


</form>

<br>
<br>

<form action="ssAdd_Rule.jsp">

<input type="hidden" value="<%=inputstring %>" id="inputstring" name="inputstring"></input>
<input type="hidden" value="<%=outputstring %>" id="outputstring" name="outputstring"></input>



Rule Name:<br>
<input type="text" name="rule_name"></input> <br><br>
if : <br>


<p>
    <a href="javascript:void(0);" onclick="addElement();">Add</a>
    <a href="javascript:void(0);" onclick="removeElement();">Remove</a>
</p>
<table id="uTable" border="1" ></table>


<br>
then: 

<%=outputtext %>

<input type='hidden' id='clausepred' name='clausepred'></input>
<input type='hidden' id='intTextBox' name='intTextBox'></input>

<input type='button' value='Formula' onclick='formula_open()'></input>


<br>
<input type="submit" name="submit" onclick="getclauses();"  value="ADD RULE"></input>



</form>
<script>
//Counter to maintain number of textboxes and give them unique id for later reference
var intTextBox = 0;
var clause_pred=[];


/**
* Function to add textbox element dynamically
* First we incrementing the counter and creating new div element with unique id
* Then adding new textbox element to this div and finally appending this div to main content.
*/

function getclauses()
{
	
	var clausepred=clause_pred.toString();
	clausepred=clausepred.substring(1);
    document.getElementById("clausepred").value=clausepred;
    
    document.getElementById("intTextBox").value=intTextBox;
	}
function addElement() {
    intTextBox++;
    var objNewDiv = document.createElement('tr');
    objNewDiv.setAttribute('id', 'tr_' + intTextBox);
    objNewDiv.innerHTML = 'Clause ' + intTextBox + '&nbsp; No. of predicates :  <input style="width:50px;"  onblur="alerting(this)" type="text" id="tb_' + intTextBox + '" name="tb_' + intTextBox + '"/>';
   

    if(intTextBox!=1)
    	{
    var lab=document.createElement('label');
     lab.setAttribute('id','l_'+intTextBox);
    lab.innerHTML='and';
    document.getElementById('uTable').appendChild(lab);
    	}
    document.getElementById('uTable').appendChild(objNewDiv);
   
}

/**
* Function to remove textbox element dynamically
* check if counter is more than zero then remove the div element with the counter id and reduce the counter
* if counter is zero then show alert as no existing textboxes are there
*/
function removeElement() {
    if(0 < intTextBox) {
        document.getElementById('uTable').removeChild(document.getElementById('tr_' + intTextBox));
     if(intTextBox!=1)
    	 {
    	 document.getElementById('uTable').removeChild(document.getElementById('l_' + intTextBox)); 
    	 }
        intTextBox--;
    } else {
        alert("No textbox to remove");
    }
}

function alerting(obj)
{
//alert(obj.value);


var inputstring=document.getElementById("inputstring").value;

var istrings=inputstring.split(",");




var trow=document.getElementById(obj.parentNode.id);
var trow_name=document.getElementById(obj.parentNode.id).id;
var n=parseInt(obj.value);


var n2 = trow_name.lastIndexOf('_');
var result = parseInt(trow_name.substring(n2 + 1));
if( typeof clause_pred[result] != 'undefined' )
	{
	var till=clause_pred[result];
	for(var i=0;i<till;i++)
		{
		    if(i!=0)
		{trow.removeChild(document.getElementById('l_'+i+"_"+result));}	
		trow.removeChild(document.getElementById('p_'+i+"_"+result));
		}
	}
clause_pred[result]=n;



for(var i=0;i<n;i++)
	{
var newtb=document.createElement("select");
newtb.setAttribute('name',"select"+(result));

for(var i2=0;i2<istrings.length;i2++)
	{
var op=document.createElement("option");
op.setAttribute('value',istrings[i2]);
op.innerHTML=istrings[i2];
newtb.appendChild(op);
	}
newtb.setAttribute('id','p_'+i+"_"+result);
//newtb.innerHTML=result;
if(i!=0){
var lab=document.createElement("label");
lab.setAttribute('id','l_'+i+"_"+result);
lab.innerHTML='or';
trow.appendChild(lab);
}

trow.appendChild(newtb);
}

}

function formula_open()
{
	alert("clicbbked");
	window.open("Formula_Calculator.jsp");
	}
</script>

</body>
</html>