/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package utilities;

/**
 *
 * @author konchady
 */
public class PhoneStandard {
    public static String telephoneFormat(String telphone)
    {
        //4696022522
        //0123456789
        StringBuilder FormattedPhone=new StringBuilder();
        FormattedPhone.append("(");
        FormattedPhone.append(telphone.substring(0,3));
        FormattedPhone.append(") ");
        FormattedPhone.append(telphone.substring(3,6));
        FormattedPhone.append("-");
        FormattedPhone.append(telphone.substring(6));
        
        
        
        return FormattedPhone.toString();
    }
    
}
