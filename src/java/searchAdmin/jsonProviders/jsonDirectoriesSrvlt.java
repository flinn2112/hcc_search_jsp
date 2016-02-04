/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package searchAdmin.jsonProviders;

import hcc_search.hcc_utils;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File ;

/**
 *
 * @author hcc
 * json Provider for Directories that are to Index.
 */
@WebServlet(name = "jsonDirectoriesSrvlt", urlPatterns = {"/jsonDirectoriesSrvlt"})
public class jsonDirectoriesSrvlt extends HttpServlet {

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
        String strPath = null ;
        String strRSName = null ;
        String strColName = null ;
        try {
            strPath = request.getParameter("PATH") ;
            strRSName = request.getParameter("RESULTSETNAME") ;
            strColName = request.getParameter("COLUMNNAME") ;            
            out.println(jsonUtils.getDirectoryList(strPath, strRSName, strColName ));
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
