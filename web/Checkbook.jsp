<%-- 
    Document   : Checkbook
    Created on : Mar 5, 2018, 1:23:58 AM
    Author     : konchady
--%>

<%@page import="java.sql.*"%>
<%@page import="utilities.DataBaseKit"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Book Search | Library Orion</title>
        
        <script>
        </script>
            
    </head>
    <body>
        <CENTER><h1><U>Book Search</U></h1></CENTER>
        
        <form method=POST action="BookSearchResult.jsp">
            <p>Enter Search Term (ISBN/Title/Author Name):<input id="searchme" name="searchme" type="text" /></p>
            <br>
            <input type="SUBMIT" value="Submit" />
        </form>
        <%! boolean firsttime=true; 
            int clicks=0;
            
                DataBaseKit db;
                ResultSet rs=null;
                
        %>
        <%
            HttpSession cart = request.getSession();
            
            if(cart.getAttribute("success")=="COMPLETED")
            {
                out.println("<p><font color='green'>Check-out Successful</font></p>");
                cart.removeAttribute("success");
            }
            
            String val=(String)application.getAttribute("searchme");
            if(firsttime)
            {
                //application.setAttribute("query",application.getAttribute("searchme"));
                firsttime=false;
                //out.print("<p>");
            }
            if(!firsttime){
                
                String searchterm = (String)request.getAttribute("searchme");
                
                try{
                    db = new DataBaseKit();
                    rs = db.QueryResult("select * from Authors LIMIT 10;");

                }catch (Exception e)
                {
                    out.println("Error "+e.getMessage());
                }
                
                /*
                out.println("<p>You Searched for: "+searchterm+"</p>");
                out.println("<table>");
                out.println("<tr> <th>Author ID</th> <th>Author Name</th> </tr>");
                while(rs.next())
                    out.println("<tr><td>"+rs.getInt(1)+"</td><td>"+rs.getString(2)+"</td></tr>");
                out.println("</table>");
                
                firsttime=false;
                */
            }
            //out.println("<h3>Hello</h3>");
         %>
            
        <!--<P> Value of firsttime: <%=firsttime %> <br> Clicks: <%=++clicks %></P>-->
        <%
            //firsttime=firsttime?false:true;
            
                
            
            
            db.CloseConnection();
        %>
        <hr/><footer>©Konchady Gaurav Shenoy, UT Dallas</footer>
    </body>
</html>
