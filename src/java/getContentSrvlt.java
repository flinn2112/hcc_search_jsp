/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 * Comment 10/2017: This servlet will fetch a file from the server.
 */

import hcc_search.hcc_utils;
import searchRT.utils.* ;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.ServletContext;


import java.io.File;

import java.io.FileInputStream;

import java.io.IOException;

import java.io.OutputStream;



/**
 *
 * @author frankkempf
 */
@WebServlet(name = "getContent", urlPatterns = {"/getContentSrvlt"})
public class getContentSrvlt extends HttpServlet {

    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
          
          String strExt = hcc_utils.getExtension(request.getParameter("fullpath")) ;
          String strApp = "text" ;
          String strType = "plain" ;
          String strOS = System.getProperty("os.name").toLowerCase() ; //1.8.10.5
          String strMsg = null ;
          String strFullpath = null ;
          StringBuilder  sbAppPath = new StringBuilder() ;
          StringBuilder  sbResult  = new StringBuilder() ;
          hcc_search.ht_container htc = new hcc_search.ht_container() ; 
          byte[] buf = new byte[8192];
          int len = 0;
          File file = null ;
          FileInputStream in = null ;
          OutputStream out  =null ;
          PrintWriter outpw = null ;
          htc.m_ht = mime.ht_MapMime ;   
          
          sbAppPath.append(request.getRealPath("/") );   
          sbAppPath.append( "config" + File.separatorChar + "mimemap.txt") ;
          
          ServletContext app = getServletContext() ;
          String strMime = null ;  //app.getMimeType(request.getParameter("fullpath")) ;
          
        try{  
           strFullpath = request.getParameter("fullpath") ; 
           //10/2017 it can happen that server and content is located together on a UNIX Box
           //Leading to paths that contain mixed slashes(when indexer put som Windows files:
           //This would prevent the fetch from being successful.
           //When UNIX then 
        
           if( strOS.contains("windows")){
           }
           else{               
               strFullpath = strFullpath.replace("\\", "/") ;
           }
       /*
           outpw = response.getWriter(); 
                strMsg = "Path [" + strFullpath  + "]<br> OS " + strOS ;                
                outpw.print(strMsg) ;
        */   
           
          // strFullpath = "\\\\DLINK-12F187\\Volume_2\\SharedDownloads\\Projekte\\hcc\\hcc_search_jsp\\src\\java\\getContentSrvlt.java" ;
           //
           //strFullpath = "C:\\tmp\\netdrive.loghcc.txt" ;
           
           file = new File(strFullpath);
           in = new FileInputStream(file);
            //uses the config mitmemap.txt to return the mimetype depending on the file extension.
           strMime = searchRT.utils.mime.get(htc, sbAppPath.toString(), strExt.toLowerCase(), sbResult);
           
           
           
           //response.setContentType("application/pdf");
          response.setContentType(strMime);
           response.setContentLength((int)file.length());
           response.addHeader("Content-Disposition", "attachment; filename=" + file.getName());
           //response.setHeader( "Content-Disposition", "attachment;filename=" + file.getName() );
            //
            out = response.getOutputStream();
            while ((len = in.read(buf)) >= 0){
                out.write(buf, 0, len); 
            }
            in.close();
            
            /*
            out.write(strMime.getBytes());
            out.write(strExt.getBytes());
            out.write(sbAppPath.toString().getBytes());
            */
           
            
            //outpw.print(sbResult.toString()) ;
            
            
        }
        catch (IOException ex){
                outpw = response.getWriter(); 
                strMsg = "The server cannot open [" + file.getAbsolutePath()  + "]<br>" ;                
                outpw.print(strMsg) ;
                strMsg = "Exception [" + ex.toString()  + "]<br>" ;                
                outpw.print(strMsg) ;            
        }               
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
