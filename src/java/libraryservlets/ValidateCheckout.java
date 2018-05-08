package libraryservlets;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.http.HttpSession;
import utilities.DataBaseKit;
import utilities.datework;

/**
 *
 * @author konchady
 */
@WebServlet(urlPatterns = {"/ValidateCheckout"})
public class ValidateCheckout extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
//    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException, SQLException, ClassNotFoundException {
//        response.setContentType("text/html;charset=UTF-8");
//        
//        
//        
//        
//        try (PrintWriter out = response.getWriter()) {
//            /* TODO output your page here. You may use following sample code. */
//            out.println("<!DOCTYPE html>");
//            out.println("<html>");
//            out.println("<head>");
//            out.println("<title>Servlet Validate Checkout</title>");            
//            out.println("</head>");
//            out.println("<body>");
//            out.println("<h2> Processing </h2>");
//            //out.println("<h1>Servlet ValidateCheckout Processing at " + request.getContextPath() + "</h1>");
//            out.println("</body>");
//            out.println("</html>");
//        }
//    }

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

            //processRequest(request, response);

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
        DataBaseKit db= null;
        try {
           //processRequest(request, response);
        db=new DataBaseKit();
        
        HttpSession cart=request.getSession();
        
           //db  
        String boid = (String)request.getParameter("boid");
        
        ResultSet rs=db.QueryResult("select card_id from borrower where card_id='"+boid+"'");
        
        if(rs.next())
        {
            String[] booklist=(String[])cart.getAttribute("booklist");
            rs=db.QueryResult("select count(card_num) from book_loans where card_num='"+boid+"'");
            if(rs.next())
            {
                int borrowCount = rs.getInt(1);
                if (borrowCount+booklist.length >3 )
                {
                    cart.setAttribute("error", "Excess");
                    response.sendRedirect("BookCheckout.jsp");
                }
                else
                {
                    
                    
                    for (int i=0;i<booklist.length;i++)
                    {
                        String updateStmt="UPDATE BOOK SET available=false where isbn='"+booklist[i]+"'";
                        db.UpdateTask(updateStmt);
                        
                        
                        //java.util.Date d= new java.util.Date();
                        //java.util.Date d14=d.after();
                        //SimpleDateFormat d = new SimpleDateFormat("MM-DD-YYYY");
                        //SimpleDateFormat d14 = datework.addDates(d, 14);
                        
                        java.sql.Date d = new java.sql.Date(new java.util.Date().getTime());
                        java.sql.Date d14 = new java.sql.Date(new java.util.Date().getTime()+(24*60*60*1000*14));
                        //d14.setDate(14);

                        updateStmt="INSERT into BOOK_LOANS(book_id,card_num,date_out,due_date) values ('"
                                +booklist[i]+"','"+boid+"',DATE_FORMAT('"+d.toString()+"','%Y-%m-%d'),DATE_FORMAT('"+d14.toString()+"','%Y-%m-%d'))";
                        PrintWriter out = response.getWriter();
                        out.println("<HTML><BODY>"+updateStmt+"<p></p></BODY></HTML>");
                        db.UpdateTask(updateStmt);
                        
                        //db.UpdateTask("update borrower set borrowcount=select count(*) from BOOK_LOANS where card_num="+boid);
                        

                        cart.setAttribute("success", "COMPLETED");
                        response.sendRedirect("Checkbook.jsp");
                        
                        
                        
                    }
                    
                }
            }
        }
        
        else 
        {
            cart.setAttribute("error", "WRONG ID");
            response.sendRedirect("BookCheckout.jsp");
        }
        } catch (SQLException ex) {
            Logger.getLogger(ValidateCheckout.class.getName()).log(Level.SEVERE, null, ex);
        } catch (ClassNotFoundException ex) {
            Logger.getLogger(ValidateCheckout.class.getName()).log(Level.SEVERE, null, ex);
        }
        finally
        {
            //if(db!=null)db.CloseConnection();
            //db.CloseConnection();
            //response.sendRedirect("Checkbook.jsp");
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
