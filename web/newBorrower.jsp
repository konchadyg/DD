<%-- 
    Document   : newBorrower
    Created on : Mar 7, 2018, 4:03:26 AM
    Author     : konchady
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
        <script type="text/javascript">
            function validateForm() 
            {
                var ssn = document.getElementById("ssn").value;
                var fname = document.getElementById("fname").value;
                var lname = document.getElementById("lname").value;
                var addr1 = document.getElementById("addr1").value;
                var city = document.getElementById("city").value;
                var telephone = document.getElementById("telephone").value;
                //var zipcode = document.getElementById("zipcode").value;
                
                var valid=1;
                var letters = /^[A-Za-z\s]+$/;
                var addr = /^[0-9a-zA-Z\s]+$/;
                //var zip = /^[0-9]+$/;
                
                //if(ssn.length==9 && fname.match(letters) && lname.match(letters) && addr1.match(addr) && telephone && zipcode.match(zip))
                if(ssn.length==9 && fname.match(letters) && lname.match(letters) && city.match(letters) && addr1.match(addr) && telephone.length==10)
                    valid = 0
                
                //alert(ssn);
                if (valid == 0) 
                {
                    alert("Click OK to create a new borrower.");
                    return true;
                }
                else 
                {
                    alert("Invalid Data");
                    return false;
                }
            }
        </script>
    </head>
    <body>
        <h1><CENTER>New Borrower Registration</CENTER></h1>
        <br>
        <br>
        <%!
            
        %>
        
        <%
          HttpSession cart=request.getSession();
          
                      try{
                cart.removeAttribute("checkinflag");
            }catch (IllegalStateException sx)
            {
                
            }
          
          try{
              
              boolean newuseradded=(boolean)cart.getAttribute("newuseradded");
          
          if(newuseradded)
          {
              out.println("<h3><font color='green'> Congratulations! New Borrower Added!</font></h3><br>");
              %>
              <table  border="1">
                  <tr>
                      <th>Card ID</th>
                      <th>SSN</th>
                      <th>Full Name</th>
                      <th>Address </th>
                      <th>Phone Number</th>
                  </tr>
              <%
                  out.print("<tr>");
                  out.print("<td>"+cart.getAttribute("newcard_id")+"</td>");
                  out.print("<td>XXX-XX-"+cart.getAttribute("ssn")+"</td>");
                  out.print("<td>"+cart.getAttribute("fullname")+"</td>");
                  out.print("<td>"+cart.getAttribute("baddress")+"</td>");
                  out.print("<td>"+cart.getAttribute("phonenumber")+"</td>");
                  out.print("</tr>");
              %>
              </table><hr>
        <%
            cart.removeAttribute("newuseradded");
            cart.removeAttribute("newcard_id");
            cart.removeAttribute("ssn");
            cart.removeAttribute("fullname");
            cart.removeAttribute("baddress");
            cart.removeAttribute("phonenumber");
            
          }
        }catch(NullPointerException nx)
          {
              
          }
              
        %>
        <form name="registration" method="POST" action="ProcessNewBorrower" onsubmit="return validateForm()">
            <h5>***ALL FIELDS ARE MANDATORY***</h5><br>
            <label for="ssn">SSN:&nbsp;</label><input type="text" name="ssn" id="ssn" maxlength="9" onkeypress='return event.charCode >= 48 && event.charCode <= 57' ><br>
            <br>
            <%
               String ssnexist=null;
               ssnexist=(String)cart.getAttribute("error");
               if(ssnexist!=null)
               {
                   out.println("<div><p id=\"errormessage\" ><b><font color='red'>SSN Exists</font></b></p></div>");
                   cart.removeAttribute("error");
               }
            %>
            <h5>Name:</h5>
            <label>First Name:&nbsp;</label><input name="fname" id="fname" type="text" maxlength="50" ><br>
            <!--<p>Middle Initial:&nbsp;<input name="mi" id="mi" type="text" maxlength="1"></p><br>-->
            <p>Last Name:&nbsp;<input name="lname" id="lname" type="text" maxlength="50"></p><br>
            <br>
            <h5>Address & Contact:</h5><br>
            <p>Address Line:&nbsp;<input name="addr1" id="addr1" type="text" maxlength="50"></p><br>
            <p>City:&nbsp;<input name="city" type="text" id="city" maxlength="20"></p><br>
            <p>State:&nbsp;<select name="state" id="state">
                <option value="AL">Alabama</option>
                <option value="AK">Alaska</option>
                <option value="AZ">Arizona</option>
                <option value="AR">Arkansas</option>
                <option value="CA">California</option>
                <option value="CO">Colorado</option>
                <option value="CT">Connecticut</option>
                <option value="DE">Delaware</option>
                <option value="DC">District of Columbia</option>
                <option value="FL">Florida</option>
                <option value="GA">Georgia</option>
                <option value="HI">Hawaii</option>
                <option value="ID">Idaho</option>
                <option value="IL">Illinois</option>
                <option value="IN">Indiana</option>
                <option value="IA">Iowa</option>
                <option value="KS">Kansas</option>
                <option value="KY">Kentucky</option>
                <option value="LA">Louisiana</option>
                <option value="ME">Maine</option>
                <option value="MD">Maryland</option>
                <option value="MA">Massachusetts</option>
                <option value="MI">Michigan</option>
                <option value="MN">Minnesota</option>
                <option value="MS">Mississippi</option>
                <option value="MO">Missouri</option>
                <option value="MT">Montana</option>
                <option value="NE">Nebraska</option>
                <option value="NV">Nevada</option>
                <option value="NH">New Hampshire</option>
                <option value="NJ">New Jersey</option>
                <option value="NM">New Mexico</option>
                <option value="NY">New York</option>
                <option value="NC">North Carolina</option>
                <option value="ND">North Dakota</option>
                <option value="OH">Ohio</option>
                <option value="OK">Oklahoma</option>
                <option value="OR">Oregon</option>
                <option value="PA">Pennsylvania</option>
                <option value="RI">Rhode Island</option>
                <option value="SC">South Carolina</option>
                <option value="SD">South Dakota</option>
                <option value="TN">Tennessee</option>
                <option value="TX">Texas</option>
                <option value="UT">Utah</option>
                <option value="VT">Vermont</option>
                <option value="VA">Virginia</option>
                <option value="WA">Washington</option>
                <option value="WV">West Virginia</option>
                <option value="WI">Wisconsin</option>
                <option value="WY">Wyoming</option>
            </select></p><br>
            <!--<p>Zipcode:&nbsp;<input id="zipcode" name="zipcode" type="text" onkeypress='return event.charCode >= 48 && event.charCode <= 57' value = "" pattern="\d{5}" maxlength="5"></p><br>-->
            <p>Telephone:&nbsp;<input name="telephone" id="telephone" type="tel" maxlength="10" onkeypress='return event.charCode >= 48 && event.charCode <= 57'></p><br>
            
            <br><br>
            <input type="submit" name="submit">
            <input type="reset">
        </form>
            <hr/><footer>©Konchady Gaurav Shenoy, UT Dallas</footer>
    </body>
</html>
