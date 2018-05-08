/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package libraryservlets;

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
import utilities.DataBaseKit;

/**
 *
 * @author konchady
 */
@WebServlet(name = "FineGeneration", urlPatterns = {"/FineGeneration"})
public class FineGeneration extends HttpServlet {

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
            out.println("<title>Servlet FineGeneration</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet FineGeneration at " + request.getContextPath() + "</h1>");
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
        //processRequest(request, response);
        DataBaseKit db=null;
        ResultSet rs=null;
        HttpSession cart = request.getSession();
        try
        {
            db = new DataBaseKit();
            
            if(cart.getAttribute("FinesFlag")==null)cart.setAttribute("FinesFlag", 1);
            
            if((Integer)cart.getAttribute("FinesFlag")==1)
            {
                
                
                String existing_fine_statement="update fines F, BOOK_LOANS L "
                        + "set F.fine_amt=CASE "
                        + "WHEN L.DATE_IN is null AND F.Paid=false then DATEDIFF(CURDATE(),L.due_date)*0.25 "
                        + "WHEN L.DATE_IN > L.DUE_DATE AND F.Paid=false then DATEDIFF(L.DATE_IN,L.DUE_DATE)*0.25 "
                        + "ELSE F.fine_amt END "
                        + "where F.LOAN_ID=L.LOAN_ID";
                
                String insert_new_records="insert ignore into FINES (LOAN_ID,FINE_AMT) "
                        + "select T.loan_id,T.fine*0.25 "
                        + "from (select loan_id, "
                        + "if(date_in IS NULL,datediff(curdate(),due_date),"
                        + "IF(date_in>due_date,datediff(date_in,due_date),0))"
                        + " as fine"
                        + " from book_loans having fine>0 ) as T";
                
                db.UpdateTask(insert_new_records);
                db.UpdateTask(existing_fine_statement);
                
                cart.setAttribute("FineDataReady", true);
                response.sendRedirect("FinesProcess.jsp");
                
                
            }
            
          
        
        }   catch (ClassNotFoundException ex) {
                Logger.getLogger(FineGeneration.class.getName()).log(Level.SEVERE, null, ex);
            } catch (SQLException ex) {
                Logger.getLogger(FineGeneration.class.getName()).log(Level.SEVERE, null, ex);
            }
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
        processRequest(request, response);
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
