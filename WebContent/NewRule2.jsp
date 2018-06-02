<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>New Rule</title>
</head>

<body>
<form>
Rule Name:<br>
<input type="text" name="rule_name"></input> 
<br><br>

Choose input parameters:<br>
  <input type="checkbox" name="anc" value="anc">anc<br>
  <input type="checkbox" name="plt" value="plt">plt<br>
<br><br><br>
Choose output parameters:<br>
  <input type="checkbox" name="mp6" value="mp6">6mp_dose<br>
  <input type="checkbox" name="mtx" value="mtx">mtx_dose<br>
  <input type="checkbox" name="nxt_date" value="nxt_date">nxt_date<br>
  <input type="checkbox" name="state" value="state">state<br>
  <br>
if : <br>


<p>
    <a href="javascript:void(0);" onclick="addElement();">Add</a>
    <a href="javascript:void(0);" onclick="removeElement();">Remove</a>
</p>
<table id="uTable" border="1" ></table>



<br>
<br>

Make clause c1: 
<select >
  <option value="a0">a0</option>
  <option value="b1">b1</option>
  <option value="c0">c0</option>
</select>
or 
Make clause c1:No. of predicates 
<select>
  <option value="a0">a0</option>
  <option value="b1">b1</option>
  <option value="c0">c0</option>
</select>
or
<select>
  <option value="a0">a0</option>
  <option value="b1">b1</option>
  <option value="c0">c0</option>
</select>


</form>
<script>
//Counter to maintain number of textboxes and give them unique id for later reference
var intTextBox = 0;

/**
* Function to add textbox element dynamically
* First we incrementing the counter and creating new div element with unique id
* Then adding new textbox element to this div and finally appending this div to main content.
*/
function addElement() {
    intTextBox++;
    var objNewDiv = document.createElement('tr');
    objNewDiv.setAttribute('id', 'tr_' + intTextBox);
    objNewDiv.innerHTML = 'Clause ' + intTextBox + '&nbsp; No. of predicates :  <input onblur="alerting(this)" type="text" id="tb_' + intTextBox + '" name="tb_' + intTextBox + '"/>';
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
        intTextBox--;
    } else {
        alert("No textbox to remove");
    }
}

function alerting(obj)
{
//alert(obj.value);
var trow=document.getElementById(obj.parentNode.id);
var newtb=document.createElement("p");
newtb.innerHTML="hello";

trow.appendChild(newtb);

	
	
	
	
	}
</script>

</body>
</html>