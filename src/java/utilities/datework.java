/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package utilities;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

/**
 *
 * @author konchady
 */
public class datework {
    public static SimpleDateFormat addDates(SimpleDateFormat d,int offset)
    {
        SimpleDateFormat sdf=d;
        Calendar c = Calendar.getInstance();
        c.setTime(new Date());
        c.add(Calendar.DATE, offset);
        sdf.setCalendar(c);
        
        return sdf;
    }
    
    public static String getCurrentStringDate()
    {
        Calendar c = Calendar.getInstance();
        return c.get(Calendar.YEAR)+"-"+c.get(Calendar.MONTH+1)+"-"+c.get(Calendar.DATE);
    }
            
           
    
}
