<%@page import="java.net.URLDecoder"%>
<%@page import="java.io.File"%>
<%@ page import="hcc_search.*" %>
<%@ page import="hcc_search.result.*" %>
<%@ page import="hcc_search.logger.*" %>

<%-- 
    Document   : index
    Created on : Dec 2, 2011, 11:50:19 AM
    Author     : frankkempf
    Purpose    : support for proxy search:
                 1. Client requests page from a server (i.e. allis1.com/dyndns/index.php)
                 2. The server determines the home ip address(maintained by fritzbox).
                 3. The server make the request to this page.
                 4. !Since for the client the servers page(i.e. index.php) is the interface
                    the server needs to point the SUBMIT button  N O T to this page, but to himself,
                    and then proxy the request to this page and deliver back the result.
                


--%>



<jsp:useBean id="hcc_search" class="hcc_search.hcc_search_Bean" ></jsp:useBean>
 <%!  
   hcc_search.hcc_search_Bean searchBean = new hcc_search.hcc_search_Bean() ; 
   hcc_search_opts so = null ;
   String strFSPath = null ;
   String strQuery  = null ; 
   String strProxy = null ;
   String strEncoding = null ;
   String strClientPrefs = null ;
   String strIndexPath = null ;
   String strMsgPath = "repository/messages/" ;  
   String strResult = null ;   
   hcc_search.result.sResult oResult  = null ;
   fileLogger fLog = null ;
   String strCustomIndex = null ;
%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>hcc::search</title>
        <link type="text/css" rel="stylesheet" href="http://www.hcc-medical.com/assests/hcc_search.css">
    </head>
    <body>
        <%             
            strProxy = request.getHeader("referer");  //funktioniert nicht...
            strQuery = request.getParameter("query") ;
            
            strClientPrefs = request.getParameter("pref"); 
            strFSPath = request.getRealPath("/") ;     
            //readConfig is the basis for getIni
            searchBean.readConfig(strFSPath + "/config/settings.cfg", strCustomIndex) ; 
            strCustomIndex = request.getParameter("index") ; 
            if( null == strCustomIndex ){ strCustomIndex = "index"; }  
            strIndexPath = searchBean.getIni(strCustomIndex) ;
            so = new hcc_search_opts( strQuery, "contents", strIndexPath, false, 
                             hcc_search_opts._HTML_, searchBean.getIni("pathSubst"), 
                             true,  
                             "highlightText") ;
            so.m_bLogResult = true ; //dev only
            fLog = new fileLogger("hcc_search.index.jsp.txt", strFSPath  + "logs" );                          
        %>
        <div id="search" align="center">
           <img src="http://www.hcc-medical.com/images/hcc_banner.jpg" alt="logo hcc" />
           <FORM METHOD=GET ACTION=/dyndns12/xpindex.php >
            <BR>
            <BR> <INPUT   NAME="query" size="72" value="<%= strQuery!=null?strQuery:"" %>">
             <INPUT TYPE=SUBMIT VALUE="Search">
            </FORM>
        </div> <!-- search -->
        <div id="canvas">
            <div id="left" class="technicalInfo" style="width:250px;">  
                <%= strFSPath %><br>
                Query [<%= strQuery %>]<br></br>
                <%= strCustomIndex + "[" + strIndexPath + "]" %><br></br>
                Prefs [<%= strClientPrefs %>]<br></br>
                Subst [<%= searchBean.getIni("pathSubst")%> ]<br></br>
                <%= fLog.getStatus()  %>
                </br>
                <br></br>
                    
            </div>
                 
            
            <div id="result" style="position:absolute;left:250px;">
                <%  if(null != strQuery && strQuery.length() > 0){
                    fLog.log("index.jsp.log - query.", "Index: " + strIndexPath, 0) ; 
                    oResult = searchBean.search2(strIndexPath, strQuery, so, strClientPrefs, false);
                }
                if( strQuery != null && ( null == oResult || oResult.m_strSearchResult.isEmpty() ) )
                { //deliver customized html
                    strResult = searchBean.emptyResult(strFSPath, strMsgPath, "emptySearchResult.html", "de");
                }
               %>
               
          
               
          
               
               <% 
               if(oResult!=null){
                    fLog.log("index.jsp.log - query", oResult!=null?oResult.m_lNumDocs.toString():"0" + " docs for [" +  strQuery + "]", 0);
                    fLog.log("index.jsp.log - query", oResult.m_strSearchResult, 0);
                }
               %>
               Found <%= oResult!=null?oResult.m_lNumDocs.toString():"0" %> documents.
               <br></br>
               <%= oResult!=null?oResult.m_strSearchResult:"empty" %>
               <% session.invalidate(); 
                oResult = null ; 
                strQuery = null ;
                //null!=oResult.m_sbLog?oResult.m_sbLog.toString():"no log" ;
              %>
            </div><!-- result -->
        </div>
            
    </body>
</html>
