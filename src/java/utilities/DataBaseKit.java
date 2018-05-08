/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package utilities;

import java.sql.*;

/**
 *
 * @author konchady
 */
public class DataBaseKit {
    
    Connection conn;
    public ResultSet rs;
    public Statement st;
    PreparedStatement ps;
    
    public DataBaseKit() throws ClassNotFoundException,SQLException
    {
        conn=null;
        rs=null;
        st=null;
        ps=null;
        
        Class.forName("com.mysql.jdbc.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:8430/library_project?"+ "user=root&password=welcome1");
        
        st=conn.createStatement();
        
        
        
    }
    public ResultSet QueryResult(String query) throws SQLException
    {
        rs=st.executeQuery(query);
        return rs;
    }
    
    public int UpdateTask(String statement) throws SQLException
    {
        int res = st.executeUpdate(statement);
        return res;
    }
    
    public void CloseConnection()
    {
        try
        {
            if (ps!=null)
            {
                ps.close();    
            }
            
            if (rs!=null)
            {
                rs.close();    
            }
            
            if (st!=null)
            {
                st.close();    
            }            

            if (conn!=null)
            {
                conn.close();    
            }            
            
        }
        catch (SQLException e)
        {
            
        }
    }
    
//    public void CloseConnection(int i)
//    {
//        if(i==1)
//        {
//            try
//            {
//                if (ps!=null)
//                {
//                    ps.close();    
//                }
//
//                if (st!=null)
//                {
//                    st.close();    
//                }            
//
//                if (conn!=null)
//                {
//                    conn.close();    
//                }            
//
//            }
//            catch (SQLException e)
//            {
//
//            }
//        }
//        else
//        {
//            CloseConnection();
//        }
//    }
    
    
    
    
}
