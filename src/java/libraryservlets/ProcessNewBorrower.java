/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package libraryservlets;
import utilities.DataBaseKit;
import utilities.PhoneStandard;

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

/**
 *
 * @author konchady
 */
@WebServlet(name = "ProcessNewBorrower", urlPatterns = {"/ProcessNewBorrower"})
public class ProcessNewBorrower extends HttpServlet {

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
            out.println("<title>Servlet ProcessNewBorrower</title>");            
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ProcessNewBorrower at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
        
        //response.sendRedirect("newBorrower.jsp");
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
        //processRequest(request, response);
        
        DataBaseKit db=null;
        boolean bexist=false;
        String ssn=null;
        //ResultSet rs=null;
        String fname,minit,lname,addr1,address,city,zipcode,state,phonenumber;
        
        HttpSession cart=request.getSession();
        try {
            db=new DataBaseKit();
            //ResultSet rs= new ResultSet();
            
            ssn = (String) request.getParameter("ssn");
            
            
            if(ssn!=null)
            {
                //123-45-6789
                //012_34_5678
                ssn = ssn.substring(0,3)+"-"+ssn.substring(3,5)+"-"+ssn.substring(5,ssn.length());
                
                ResultSet rs = db.QueryResult("select count(ssn) from borrower where ssn='"+ssn+"'");

                while(rs.next())
                {
                    int count=rs.getInt(1);

                    if(count==1)
                    {
                        bexist = true;

                    }
                    else
                    {
                        rs=db.QueryResult("select CARD_ID from borrower order by CARD_ID DESC LIMIT 1");
                        rs.next();
                        
                        
                        String f=(String)request.getParameter("fname");
                        fname= f.substring(0, 1).toUpperCase() + f.substring(1);
                        //minit=(String)request.getParameter("fname").trim();
                        f=(String)request.getParameter("lname");
                        lname= f.substring(0, 1).toUpperCase() + f.substring(1);
                        
                        addr1=(String)request.getParameter("addr1");
                        
                        f=(String)request.getParameter("city");
                        city=f.substring(0, 1).toUpperCase() + f.substring(1);
                        
                        //zipcode=(String)request.getParameter("zipcode");
                        state=(String)request.getParameter("state");
                        phonenumber=(String)request.getParameter("telephone");
                        
                        phonenumber=PhoneStandard.telephoneFormat(phonenumber);
                        
                        String fullname=fname+" "+lname;
                        String baddress=addr1+","+city+","+state;
                        
                        int card_id= Integer.parseInt(rs.getString(1).substring(2));
                        ++card_id;
                        
                        String c=""+card_id;
                        //String z="0";
                        
                        String newcard_id= "ID"+String.format("%06d", card_id);
                        
                        String InsertString ="insert into borrower(CARD_ID,SSN,BNAME,Address,Phone) values ('"+newcard_id+"','"
                                +ssn+"','"+fullname+"','"+baddress+"','"+phonenumber+"')";
                        
                        db.UpdateTask(InsertString);
                        
                        //response.sendRedirect("newBorrower.jsp");
                        //processRequest(request, response);
                        
                        cart.setAttribute("newuseradded", Boolean.TRUE);
                        cart.setAttribute("newcard_id", newcard_id);
                        cart.setAttribute("ssn",ssn.substring(ssn.length()-4));
                        cart.setAttribute("fullname",fullname);
                        cart.setAttribute("baddress",baddress);
                        cart.setAttribute("phonenumber", phonenumber);
                        
                        response.sendRedirect("newBorrower.jsp");

                    }
                }
            }
        } catch (ClassNotFoundException | SQLException ex) {
            //Logger.getLogger(ProcessNewBorrower.class.getName()).log(Level.SEVERE, null, ex);
        }
        finally
        {
            if(db!=null)db.CloseConnection();
            
            if(bexist)
            {
                cart.setAttribute("error", "SSNEXISTS");
                response.sendRedirect("newBorrower.jsp");
            }
            
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
