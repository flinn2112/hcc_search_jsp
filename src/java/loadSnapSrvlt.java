/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

import hcc_search.hcc_utils;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Enumeration;
/**
 *
 * @author frankkempf
 */
public class loadSnapSrvlt extends HttpServlet {

    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String strURL = null ;
        String strPassThru  = null ;
        String[] rParams ;
        
        //only one of each will be set
        strURL = request.getParameter("SNAPINURL") ;
        if( null == strURL ){
            strURL    = request.getParameter("MODULE") ;
        }
        
        if( null == strURL ){          
            return ;
        }
        //Passthru would route PARAMETERS to the URL as POST
        //Remember? - the challenge is to load not only a URL via get but to
        //additionally pass parameters to that URL itself.
        //Passing the MODULE simply like this:
        /*
        MODULE="http://sandbox.allis1.de/xmlProviders/xmlCustomerRequest2010.php?
			TOPIC=FORM&PREFIX=CR2112&JS_ACTION=EXEC ;
        would result in an error (due to the "?".
         * //->
         javascript:
         * var strURI = NS2112.snapInLoaderGlobals.URI 
	        + "?PASSTHRU=1&MODULE=" 
			+ "http://sandbox.allis1.de/xmlProviders/xmlCustomerRequest2010.php?"
			+ "TOPIC=FORM&PREFIX=CR2112&JS_ACTION=" + strAction ;
         * 
         * We need to extract the Contents following the MODULE PARAM
         */
        
        
        String strProto = strURL.substring(0, 4) ;
        StringBuilder sb = new StringBuilder() ;
        strProto = strProto.toLowerCase() ;
        PrintWriter out = response.getWriter();
        
         //out.println("URL:" + strURL) ;
        
        if(strProto != "http"){
                //use the referer base
            sb.append(request.getScheme()) ;
            sb.append("://") ;
            sb.append(request.getServerName()) ;
            if( 0 !=  request.getServerPort()){
                sb.append(":") ;
                sb.append(request.getServerPort()) ;
            }
            sb.append(strURL) ;             
        }
        else{
            sb.append(strURL) ;
        }
        
         //special to some snapins - passing through a complete URL
        if( null != request.getParameter("PASSTHRU")){ //collect all parameters for passthrough
            //rParams = request.
            strPassThru = this.compileParameters(request) ;
        }
        
        if( null != strPassThru ){
            //out.println("passthru:  " + strPassThru ) ;
            sb.append("&") ;
            sb.append(strPassThru) ;
        }
        
        strURL = sb.toString() ;
        
       // out.println("New URL: " + strURL) ;
        
        response.setContentType("text/html;charset=UTF-8");
        
        
        
        
        
        
        
        try {
            /*
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet loadSnapSrvlt</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet loadSnapSrvlt at " + request.getContextPath () + "</h1>");
            */
            
            //out.print("<p>URL is [" + strURL + "]") ;
            //out.print("<p>Passthru is [" + strPassThru + "]") ;
            out.println(hcc_utils.loadURL(strURL)) ;
            /*
            out.println("</body>");
            out.println("</html>");
             */
        } finally {            
            out.close();
        }
    }
    
    
    //javax.​servlet.​ServletRequest oRequest
    private String compileParameters(javax.servlet.ServletRequest oRequest){
        Enumeration en = oRequest.getParameterNames();
        StringBuilder sb = new StringBuilder() ;
        String paramName = null ;
        while (en.hasMoreElements()) {            
            paramName = (String) en.nextElement();
            if( paramName.equals( "MODULE" ) ){
                continue ; //Do not add the MODULE mutltiple times.
            }
            sb.append( paramName ); 
            sb.append(  "=" ) ; 
            sb.append( oRequest.getParameter(paramName)) ; 
            sb.append(  "&" );
            //the & does not hurt when no element follows - leave it
        }
        return sb.toString() ;
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
