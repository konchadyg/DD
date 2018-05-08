<%-- 
    Document   : CheckinBook
    Created on : Mar 11, 2018, 6:20:53 AM
    Author     : konchady
--%>

<%@page import="utilities.DataBaseKit"%>
<%@page import="utilities.datework"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.sql.ResultSet"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Check-in Book</title>
        <script type="text/javascript">
            function validatesearch()
            {
               var searchterm=document.getElementById("searchloan").value;
               if(!searchterm.match(/\S/))
               {
                   alert("Enter a seach term!");
                   return false;
               }
            }
            
            function checkboxcheck()
            {
                var x = document.getElementsByName('loanbook');
                var okay=false;
                for(var i=0,l=x.length;i<l;i++)
                {
                    if(x[i].checked)
                    {
                        okay=true;
                        break;
                    }
                }
                
                if(!okay)
                {
                    alert ("Please select atleast 1 book");
                    return false
                }
            }
                    
        </script>
        <%! int loanresults=0;
        %>
    </head>
    <body>
        <h1><center>Check-in Book</center></h1>
        <%
            HttpSession cart=request.getSession();
            
            try{
                cart.removeAttribute("checkinflag");
            }catch (IllegalStateException sx)
            {
                
            }
        %>
        <form method=POST action="ListLoanedBooks" onsubmit="return validatesearch()">
            <table>
                <tr>
                    <td>Enter Search Term (ISBN/Borrower-ID/Borrower's Name):<input id="searchloan" name="searchloan" type="text" /></td>
                    <td><input type="SUBMIT" value="Submit" /></td>
                </tr>
            </table>
        </form>
        <hr>
        <%
            
            try{
                loanresults= (int) cart.getAttribute("loanresults");
                
                if(loanresults==1)
                {
                    ResultSet rs = (ResultSet)cart.getAttribute("result");
                    
        %>
        <h3><font color='green'> Results Found:</font></h3>
        <form method=POST action="ListLoanedBooks" onsubmit="return checkboxcheck()">
            <table border='1'>
                <tr>
                    <th>
                        *
                    </th>
                    <th>
                        Loan-ID
                    </th>
                    <th>
                        ISBN
                    </th>
                    <th>
                        Card-ID
                    </th>
                    <th>
                        Borrower Name
                    </th>
                    <th>
                        Date Out
                    </th>
                    <th>
                        Due Date
                    </th>
                </tr>
            <%
                while(rs.next())
                {
            %>
            <tr>
                <td><input type="checkbox" name='loanbook' value='<%=rs.getString(1)%>'></td>
                <td><%=rs.getString(1)%></td>
                <td><%=rs.getString(2)%></td>
                <td><%=rs.getString(3)%></td>
                <td><%=rs.getString(4)%></td>
                <td><%=rs.getString(5)%></td>
                <%
                    Date duedate=(Date)rs.getDate(6);
                    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-mm-dd");

                    if (!sdf.parse(duedate.toString()).after(sdf.parse(datework.getCurrentStringDate())))
                    {


                %>
                <td><font color='red'><b> <%=rs.getString(6)%> </b></font></td>
                <%
                    }
                    else
                    {

                %>
                <td><%=rs.getString(6)%></td>
            </tr>
            <%
                    }
                }
                rs.beforeFirst();
                cart.setAttribute("loanresults", rs);
                cart.setAttribute("checkinflag",true);

            %>
            <tr border='0'><td border='0'><input type="submit" value="Submit"></td><tr>
            </table>
        </form>
        
        <%
                    loanresults=0;
                    cart.setAttribute("loanresults",loanresults);
                    //out.println("<h3>Gotcha</h3>");
                }
                else if (loanresults==2)
                {
                    out.println("<p><font color='red'><b>NO RESULTS FOUND</b></font></p>");
                    loanresults=0;
                    cart.setAttribute("loanresults",loanresults);
                }
                else if (loanresults==3)
                {
                    String[] checkinbooklist= (String [])cart.getAttribute("checkinlist");
%>
<p><h4><font color="green"><b>Check-in Successful</b></font></h4></p>
    <table border="1">
    <tr>
        <th>ISBN</th>
        <th>Title</th>
        <th>Status</th>
    </tr>
    
    <% 
        DataBaseKit db=new DataBaseKit();
                    for (int i=0;i<checkinbooklist.length;i++)
                    {
                    String listquery="select isbn,title,available from book where isbn in (select book_id from book_loans where loan_id='"+ 
                    checkinbooklist[i]+"')";

                    ResultSet rs=db.QueryResult(listquery);

                    while(rs.next())
                        {
                            out.println("<tr><td>");
                            out.print(rs.getString(1));
                            out.print("</td><td>");
                            out.print(rs.getString(2));
                            out.print("</td><td>");
                            if(rs.getBoolean(3)==true)out.print("Checked In");
                            else out.print("Not Checked In");
                            //out.print(rs.getBoolean(3));
                            out.print("</td></tr>");
                        }

                    }
                    
                    cart.removeAttribute("loanresults");
                    %>
    </table>
                    <%
                }
                else 
                {
                    cart.removeAttribute("loanresults");
                    //cart.removeAttribute("loanresults");
                }
            
            }catch (NullPointerException nx)
            {
                
            }
            

            
        %>

            
        
        <hr/><footer>©Konchady Gaurav Shenoy, UT Dallas</footer>
    </body>
</html>
