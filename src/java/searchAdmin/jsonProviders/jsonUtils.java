/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package searchAdmin.jsonProviders;
import java.io.* ;
/**
 *
 * @author hcc
 */
public class jsonUtils {
    /* getting contents of a usually HTML File as JSON String
     * The format will be then "strColumnName":"Filename"
    */
     public static String getDirectoryList( String strPath, 
                                       String strResultsetName, 
                                       String strColumnName){
      FileInputStream fis;
      BufferedReader br = null ;
      StringBuilder sb = new StringBuilder() ;
      String strTmp = new String() ;
      String rAttributes [] = null ;
      
      
      try {
          fis = new FileInputStream(new File(strPath));
          br = new BufferedReader(new InputStreamReader(fis, "UTF-8")) ;
        } catch (Exception ex) {
          // at least on windows, some temporary files raise this exception with an "access denied" message
          // checking if the file can be read doesn't help         
     
          return null ;
        }

        
        try{  
             sb.append("{\"" + strResultsetName + "\": [") ;
             while ((strTmp = br.readLine()) != null) {
                 
                    //split this string
                   rAttributes = strTmp.split(";") ;
                   rAttributes[0] = rAttributes[0].replace("\\", "\\\\") ;
                   sb.append("{\"" + strColumnName + "\":\"" + rAttributes[0] + "\","  );
                   sb.append("\"Status\":\"" + rAttributes[1]  );
                   sb.append( "\"}, ") ;
             }
             sb.append("\r\n]}") ;            
             br.close();
             fis.close();
        } catch (java.io.IOException ex){
           
        }finally{          
           
        }
       
       strTmp = sb.toString() ;
       strTmp = strTmp.replaceAll(",\\s*\\}", "}") ;
       strTmp = strTmp.replaceAll(",\\s*\\]", "]") ;
       //!our bit dirty programming -> since we did not care about comma counting, we remove the unwanted ones now.
       return strTmp ;
     }
  
}
