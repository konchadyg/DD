<%-- 
    Document   : FinesProcess
    Created on : Mar 11, 2018, 3:13:46 PM
    Author     : konchady
--%>

<%@page import="java.sql.ResultSet"%>
<%@page import="java.util.Date"%>
<%@page import="utilities.DataBaseKit"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Fines Management</title>
        <script type="text/javascript">
            function Validate()
            {
                var radio = document.getElementById('fineradio');
                
                
                for (var i=0;i<radio.length;i++)
                {
                    if (radio[i].checked)
                    {
                        //alert('Not Fine Selected!');
                        return true;
                    }
                    else
                    {
                        alert('No Fine Selected!');
                        return false;
                    }
                }
                
                
            }
            </script>
    </head>
    <body>
        <%! //HttpSession cart;
                %>
        <h1><center>Fines Processing</center></h1>
        
        <form method="GET" action="FineGeneration" >
            <label>Refresh Fines:&nbsp;</label>
            <input type="submit" value="REFRESH DATA"/>
        </form>
        <hr/>
        <%
            HttpSession cart=request.getSession();
            DataBaseKit db=null;
            
            //try
            {
                    //boolean flag=(boolean)cart.getAttribute("FineDataReady");
            
            //if(!session.isNew())
            if((cart.getAttribute("paymentdone"))==null ||(cart.getAttribute("payid"))==null )
            {
                
            }
            else
            {
                String payid=(String)cart.getAttribute("payid");
                
                //db=new DataBaseKit();
                
                out.println("<h5><font color='green'>Borrower Account "+payid+" payment completed successfully</font></h5>\n");
                cart.removeAttribute("payid");
                
            }
            
            
            if( (cart.getAttribute("FineDataReady"))==null )
            {
                out.println("<p><i>Click Refresh to Generate the Fine Table</i></p>");
            }
            else
            {
                db=new DataBaseKit();
                
                String query ="select l.card_num,b.bname,group_concat(f.loan_id),sum(fine_amt) "
                        + "from book_loans l, fines f, borrower b "
                        + "where l.loan_id=f.loan_id and l.card_num=b.card_id "
                        + "and f.paid=false "
                        + "and l.date_in is null "
                        + " group by l.card_num";
                
                String returnedquery ="select l.card_num,b.bname,group_concat(f.loan_id),sum(fine_amt) "
                        + " from book_loans l, fines f, borrower b "
                        + " where l.loan_id=f.loan_id and l.card_num=b.card_id "
                        + " and f.paid=false "
                        + " and l.date_in is not null "
                        + " group by l.card_num";
                
                //String payablequery ="";
                
                out.println("<p><b><font color='ORANGE'>Fines Generated ["+new Date()+"]</font></b></P>");
                
                
                
                %>
                
                <table border="1">
                    <tr>
                        <th>*</th>
                        <th>Card Number</th>
                        <th>Borrower Name</th>
                        <th>Loan ID</th>
                        <th>Fine For Non-Returned Books (in US$)</th>
                    </tr>
                    
                
                <%
                ResultSet rs = db.QueryResult(query);
                
                while(rs.next())
                {
                    out.print("<tr>");
                    out.print("<td><input type=radio id='finereview' name='finereview' value="+rs.getString(1)+" disabled></td>");
                    out.println("<td>"+rs.getString(1)+"</td>");
                    out.println("<td>"+rs.getString(2)+"</td>");
                    out.println("<td>"+rs.getString(3)+"</td>");
                    out.println("<td>"+rs.getString(4)+"</td>");
                    out.println("</tr>");
                }
                //session.invalidate();
                %>
                </table >
                <BR>
                <BR>
                <form method="post" action="PayFine" onsubmit="return Validate()">
                <h4> Payable Fines: </h4>
                <table border="1">
                    <tr>
                        <th>*</th>
                        <th>Card Number</th>
                        <th>Borrower Name</th>
                        <th>Loan ID</th>
                        <th>Fine For Non-Returned Books (in US$)</th>
                    </tr>
                    <%
                        int count=0;
                        rs = db.QueryResult(returnedquery);
                        while(rs.next())
                        {
                            count++;
                    out.print("<tr>");
                    out.print("<td><input type='radio' id='fineradio' name=\"fineradio\" value="+rs.getString(1)+" ></td>");
                    out.println("<td>"+rs.getString(1)+"</td>");
                    out.println("<td>"+rs.getString(2)+"</td>");
                    out.println("<td>"+rs.getString(3)+"</td>");
                    out.println("<td>"+rs.getString(4)+"</td>");
                    out.println("</tr>");                            
                        }
                    
                    if(count>0){
                    %>
                <tr><td><input type="submit" value="Pay Fine"></td></tr>
                </table>
                </form>
                
                <% }
                else
{
%>
    <tr><td><input type="submit" value="Pay Fine" disabled=""></td></tr>
                </table>
                </form>
<%
}
            }
            }//catch(NullPointerException nx)
            {
            //    response.sendRedirect("index.html");
            }
            
            
        %>  
        <hr/><footer>©Konchady Gaurav Shenoy, UT Dallas</footer>
    </body>
</html>
