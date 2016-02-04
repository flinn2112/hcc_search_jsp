/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.http.HttpServletRequest;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;


/**
 * A simple encoding-filter to ensure correct
 * handling of request encoding.
 *
 * @author Wolfram Rittmeyer, www.jsptutorial.org
 * 2012: flinn2112 - funktioniert sogar (eintrag in web.xml vorausgesetzt)
 * Aber nur technisch - im JSP sind immer noch Schrottdaten...
 */
public class EncodingFilterSrvlt implements Filter {

   private static final Log logger = LogFactory.getLog(EncodingFilterSrvlt.class);
   private String encoding = "UTF-8";

   /**
    * Set the character-encoding of the request to the
    * encoding specified in the deployment descriptor.
    * If none is specified use UTF-8.
    */
   public void doFilter(ServletRequest request, ServletResponse response, FilterChain filterChain) throws IOException, ServletException {
      if (logger.isDebugEnabled()) {
         logger.debug("filtering: " + ((HttpServletRequest)request).getRequestURL());
      }
      request.setCharacterEncoding(encoding);
      filterChain.doFilter(request, response);
      //Setting the character set for the response
      response.setContentType("text/html; charset=UTF-8");
      response.setCharacterEncoding(encoding);
   }

   /**
    * Initialize the filter.
    */
   public void init(FilterConfig filterConfig) throws ServletException {
      logger.info("Filter EncodingFilter initializing...");
      String str = filterConfig.getInitParameter("encoding");
      if (str != null) {
         encoding = str;
      }
      logger.info("Using encoding: " + this.encoding);
   }

   public void destroy() {
        logger.info("Filter EncodingFilter destroyed...");
   }
}