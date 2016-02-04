/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package searchAdmin.descriptors;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author hcc
 */
@WebServlet(name = "descDirectoriesSrvlt", urlPatterns = {"/descDirectoriesSrvlt"})
public class descDirectoriesSrvlt extends HttpServlet {

    /**
     * Processes requests for both HTTP
     * <code>GET</code> and
     * <code>POST</code> methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        StringBuilder sb = new StringBuilder() ;
        String strMandt = request.getParameter("MANDT") ; 
        
        try {
            sb.append("[{\"Name\": \"Directory\", \"ResultlistName\": \"DirectoryList\", \"Title\":\"Index Directories\",") ; 
            sb.append("\"URL\": \"/hcc_search_jsp/jsonDirectoriesSrvlt?PATH=C:\\\\SharedDownloads\\\\Projekte\\\\hcc\\\\hcc_search\\\\dist\\\\config\\\\directories.cfg&TOPIC=list&MANDT=" 
                             + strMandt 
                             + "&RESULTSETNAME=DirectoryList&COLUMNNAME=Directory"
                             + "&JSON=1\",") ;    
            sb.append("\"overrideClass\": \"\",") ;
            sb.append("\"fields\": [\"Directory\", \"Status\"],") ;
            sb.append("\"columnDefs\": [") ;
            sb.append("{\"key\":\"Directory\", \"sortable\":\"true\"},");	
            sb.append("{\"key\":\"Status\", \"sortable\":\"true\"}");
            sb.append("]" ) ;
            sb.append("}]") ;
            out.println(sb.toString());
        } finally {            
            out.close();
        }
    }
    

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP
     * <code>GET</code> method.
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
     * Handles the HTTP
     * <code>POST</code> method.
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
