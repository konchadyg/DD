<%-- 
    Document   : BookSearchResult
    Created on : Mar 6, 2018, 3:24:13 PM
    Author     : konchady
--%>

<%@page import="java.sql.*"%>
<%@page import="utilities.DataBaseKit"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Book Result</title>
        
        <script>
            function checkboxcheck()
            {
                var x = document.getElementsByName('booksel');
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
    </head>
    <body>
        
        <%!
            String searchTerm="";
            DataBaseKit db;
            ResultSet rs=null;
        %>
        <%
            searchTerm=(String) request.getParameter("searchme");
            //searchTerm=searchTerm.trim();
            if(searchTerm!=null && !searchTerm.equals("") )
            {
                out.println("<a href=\"Checkbook.jsp\">Return</a>");
                out.println("<p> You searched for: <B><I>"+searchTerm+"</B></I></p>");
                
                out.println("<h3><u>Search Results</h3></u>");
                
                try{
                    db=new DataBaseKit();
                    String stlc = searchTerm.trim().toLowerCase();
                    String query="select b.isbn isbn, b.title title,GROUP_CONCAT(a.name) authors,b.available "
                                +"from book b, authors a, book_authors c "
                                +"where b.isbn=c.isbn and a.`Author_id`=c.author_id "
                                +"and (lower(b.isbn)like '%"+stlc+"%' OR lower(a.name) like '%"+stlc+"%' OR "
                                +"lower(b.title) like '%"+stlc+"%') "
                                +"group by b.isbn;";
                    //out.println(query);
                    rs = db.QueryResult(query);
                    
                    if(rs==null || !rs.next())
                    {
                        out.println("<h3><font color=\"red\">No Results</font></h3>");
                    }
                    else 
                    {
                        out.println("<h3 id='top'>Results</h3>");
                        //rs.beforeFirst(); //Rewind
                        
                        
                        %>
                        <form name="booklist" method=POST action="BookCheckout.jsp" onsubmit="return checkboxcheck()">
                            <input type="SUBMIT" value="Select books and Submit" /><br><br>
                            <table border="1">
                                <tr>
                                    <th>Sno</th><th>ISBN</th><th>Title</th><th>Authors</th><th>Available?</th><th>*</th>
                                </tr>                            
                            <%
                            int ser=0;    
                            do{

                                String isbn=rs.getString("isbn");
                                String title=rs.getString("title");
                                String authors = rs.getString("authors");
                                boolean available = rs.getBoolean("available");


                                String imglink="http://www.openisbn.com/cover/"+isbn+"_72.jpg";

                                out.println("<tr>");

                                    out.println("<td>"+(++ser)+"</td>");
                                    //out.println("<td><img src=\""+imglink+"\" alt= ISBN:\""+isbn+"\"></td>"); //image
                                    out.println("<td>"+isbn+"</td>"); //isbn
                                    out.println("<td>"+title+"</td>"); //title
                                    out.println("<td>"+authors+"</td>"); //author

                                    if (available)
                                    {
                                        out.println("<td><font color='green'>AVAILABLE</font></td>");
                                        out.println("<td><input name=booksel type=checkbox value="+isbn+"></td>"); //checkbox
                                    }
                                    else
                                    {
                                        out.println("<td><font color='red'>OUT OF STOCK</font></td>");
                                        out.println("<td><input name=booksel type=checkbox value="+isbn+" disabled></td>"); //checkbox
                                    }
                                    //available 

                                out.println("</tr>");

                            }while(rs.next());
                            %>
                            </table><br><br>
                            <input type="SUBMIT" value="Select books and Submit" /><br><br>
                            
                            <right><p> <a href='#top'>Top</a></p></right> 
                            
                        </form>
                        <%
                    }
                }
                catch(Exception e)
                {
                    
                }
                finally
                {
                    db.CloseConnection();

                }
                
                
            }
            else
            {
                out.println("<h3>No Search Term provided</h3>");
                out.println("<a href=\"Checkbook.jsp\">Return<a>");
            }
        %>
        <hr><footer>©Konchady Gaurav Shenoy, UT Dallas</footer>
        
    </body>
</html>
