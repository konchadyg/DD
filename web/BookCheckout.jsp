<%-- 
    Document   : BookCheckout
    Created on : Mar 6, 2018, 6:50:41 PM
    Author     : konchady
--%>

<%@page import="java.sql.*"%>
<%@page import="libraryservlets.*"%>
<%@page import="utilities.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Book Checkout</title>
    </head>
    <body>
        <%! String[] booklist; 
            String lookup;
            DataBaseKit db;
            //HttpSession cart=null;
        %>
        <h4>Books Chosen to borrow:</h4>
        <form method="post" action="ValidateCheckout">
        <%
            HttpSession cart = request.getSession();
                booklist=request.getParameterValues("booksel");
                
                if (booklist==null)
                    booklist=(String[])cart.getAttribute("booklist");
                
                //application.setAttribute("booklist", booklist);
                if(booklist!=null)
                {
                     
                    cart.setAttribute("booklist", booklist);
                    db=new DataBaseKit();

                    for (int i = 0; i < booklist.length; i++) 
                    {
                        ResultSet rs = db.QueryResult("select title from book where isbn='"+booklist[i]+"'");
                        rs.next();
                        out.println ("<ul name=booklist>"+booklist[i]+"&#09;&#09;"+rs.getString(1)+"</ul>");
                    }
                }
            //db.CloseConnection();
        %>
        <br><br>
        <h4>Enter User Details: </h4>
        <p>Enter the Borrower ID: <input type="text" name="boid" id="boid"></p>
        
        <%
            if(cart.getAttribute("error")=="WRONG ID")
            //<div id="errormessage"></div>
            out.println("<p> WRONG ID. TRY AGAIN</P>");
            
            if(cart.getAttribute("error")=="Excess")
                out.println("<P> Borrower has exceeded borrowing limits </P>");
            

            cart.removeAttribute("error");
            %>
        <input type="submit" name="submit">
        </form>
        <hr/><footer>©Konchady Gaurav Shenoy, UT Dallas</footer>
    </body>
</html>
