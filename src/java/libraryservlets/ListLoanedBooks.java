/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package libraryservlets;

import utilities.DataBaseKit;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import utilities.datework;

/**
 *
 * @author konchady
 */
@WebServlet(name = "ListLoanedBooks", urlPatterns = {"/ListLoanedBooks"})
public class ListLoanedBooks extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet ListLoanedBooks</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ListLoanedBooks at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        DataBaseKit db=null;
        boolean processcheckin=false;
        try {
            //processRequest(request, response);
            
            HttpSession cart = request.getSession();
            db = new DataBaseKit();
            
            try{
                processcheckin = (boolean)cart.getAttribute("checkinflag");
            }catch (NullPointerException nx)
            {
                processcheckin=false;
            }
            
            if(!processcheckin)
            {
                String searchterm = request.getParameter("searchloan");
                String searchquery="select l.loan_id,l.book_id,l.card_num,b.bname,l.date_out,l.due_date  " +
                    "from book_loans l,borrower b " +
                    "where l.card_num=b.card_id and l.date_in is null " +
                    "and (l.loan_id like '%"+searchterm.toUpperCase()+"%' OR l.book_id like '%"+
                        searchterm+"%' OR l.card_num like '%"+searchterm+
                        "%' OR lower(b.bname) like '%"+searchterm.toLowerCase()+"%')";

                ResultSet rs = db.QueryResult(searchquery);
                ResultSet rt = rs;
                if(rs.first())cart.setAttribute("loanresults",1);
                else cart.setAttribute("loanresults",2);
                rs.beforeFirst();
                cart.setAttribute("result", rt);
            }
            
            else
            {
                cart.removeAttribute("checkinflag");
                
                String[] booklist = request.getParameterValues("loanbook");
                if(booklist.length>0)
                {
                    for (int i=0;i<booklist.length;i++)
                    {
                        String updateStatement1="UPDATE BOOK_LOANS set date_in='"+datework.getCurrentStringDate()+"' where loan_id='"+
                            booklist[i]+"'";
                        String updateStatement2="UPDATE BOOK set available=true where isbn=(select book_id from book_loans where loan_id='"+
                            booklist[i]+"')";
                        
                        db.UpdateTask(updateStatement1);
                        db.UpdateTask(updateStatement2);                        
                        
                    }
                    cart.setAttribute("checkinlist", booklist);
                    cart.setAttribute("loanresults",3 ); 
                    
                }
                //processRequest(request, response);
                
            }
            
       
            
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(ListLoanedBooks.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SQLException ex) {
            Logger.getLogger(ListLoanedBooks.class.getName()).log(Level.SEVERE, null, ex);
        }
        finally
        {
            //if(db!=null)db.CloseConnection(1);
            response.sendRedirect("CheckinBook.jsp");
        }
        
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
