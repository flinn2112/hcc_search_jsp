/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author frankkempf
 */
@WebServlet(name = "scriptSrvlt", urlPatterns = {"/scriptSrvlt"})
public class scriptSrvlt extends HttpServlet {

    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/vbscript");
        PrintWriter out = response.getWriter();
        try {
            /* TODO output your page here
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet scriptSrvlt</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet scriptSrvlt at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
             */
            
            out.println(
               "If Not IsObject(SAPGuiApp) Then"
                + "   Set SAPGuiAuto = GetObject(\"SAPGUI\")"
                + "  Set SAPGuiApp = SAPGuiAuto.GetScriptingEngine "
                + "End If"
                + "If Not IsObject(Connection) Then"
                + "   Set Connection = SAPGuiApp.Children(0)"
                + "End If"
                + "If Not IsObject(SAP_Session) Then"
                + "  Set SAP_Session = Connection.Children(0)"
                + "End If"
                + "If IsObject(WScript) Then"
                + "   WScript.ConnectObject SAP_Session, \"on\""
                + "   WScript.ConnectObject SAPGuiApp, \"on\""
                + "End If"
                + "SAP_Session.findById(\"wnd[0]\").Maximize"
        );
            
        } finally {            
            out.close();
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
