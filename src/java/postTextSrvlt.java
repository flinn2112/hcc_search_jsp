/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.util.* ;//calendar
import javax.management.* ;

import hcc_search.indexer.hcc_index_bean ;

/**
 *
 * @author frankkempf
 * There is also a jsp with the same name that will post its data to this servlet.
 * A user or automated system may use this servlet to add text to the search enging.
 */
public class postTextSrvlt extends HttpServlet {

    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int iRet = 0 ;
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        try {
            /* TODO output your page here*/
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet postText</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet postText at " + request.getContextPath () + "</h1>");
            
            out.println("<TABLE BORDER=1 ALIGN=CENTER>\n" +
                "<TR BGCOLOR=\"#FFAD00\">\n" +
                "<TH>Parameter Name<TH>Parameter Value(s)");
            Enumeration paramNames = request.getParameterNames();
            while(paramNames.hasMoreElements()) {
              String paramName = (String)paramNames.nextElement();
              out.println("<TR><TD>" + paramName + "\n<TD>");
              String[] paramValues = request.getParameterValues(paramName);
              if (paramValues.length == 1) {
                String paramValue = paramValues[0];
                if (paramValue.length() == 0)
                  out.print("<I>No Value</I>");
                else
                  out.print(paramValue);
              } else {
                out.println("<UL>");
                for(int i=0; i<paramValues.length; i++) {
                  out.println("<LI>" + paramValues[i]);
                }
                out.println("</UL>");
              }
            }
            out.println("</TABLE>\n");
             
        } finally {            
            
        }
        iRet = this.indexPost(
                    request.getParameter("indexpath"),
                    request.getParameter("domain"),
                    request.getParameter("title"),
                    request.getParameter("shorttext"),
                    request.getParameter("memopath"),
                    request.getParameter("doctype"),
                    request.getParameter("category"),
                    request.getParameter("src"),
                    request.getParameter("url"),
                    request.getParameter("ttl"),
                    request.getParameter("content")
                    );
            if( iRet < 1 ){
                //return error page
                out.println("<p>Invalid parameters</p>");
            }
            else{
                out.println("<p>posted to index</p>");
            }
            out.println("<p>done</p>");
            out.println("</body>");
            out.println("</html>");
            out.close();
    }
    
    /*
     * Post data to indexer
     */
    private int indexPost( 
                           String strIndexPath,
                           String strDomain,
                           String strTitle,
                           String strShortText,
                           String strMemoPath,
                           String strDocType,
                           String strCategory,
                           String strSrc,
                           String strURL,                           
                           String strExpires,
                           String strContent){
        Date now = new Date();
        Date dtEx = null ;
        Calendar calendar = Calendar.getInstance();
        Date today = calendar.getTime();
        String strURN = null ; 
        dtEx = calendar.getTime() ;
        
        //check all parameters
        if( null == strDocType){
            strDocType = "unknown" ;
        }
        if( null == strCategory){
           strCategory = "unknown" ;
        }
        if( null == strSrc){
            strSrc = "unknown" ;
        }
        if( null == strURL){
           //nothing - can be null
            strURL = "" ;
        }
        
        if( null == strExpires){
            strExpires = "1 Year" ;
            calendar.add(Calendar.DATE, 365);
            dtEx = calendar.getTime() ;            
        }
        
        if( null == strContent){
            //makes no sense!
            return -1;
        }
        
        hcc_index_bean idxB = new hcc_index_bean();
        strURN = "local:memo:" +  System.currentTimeMillis(); 
        idxB.index(strIndexPath, 
                strDomain, strTitle, strShortText, strMemoPath, strURN, idxB.getDateString(), strDocType, strCategory, 
                   strSrc, strURL, dtEx, strContent,
                   null  //no extended Attributes
                );
        
        return 1 ;
    } 
    
    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
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
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>
}
