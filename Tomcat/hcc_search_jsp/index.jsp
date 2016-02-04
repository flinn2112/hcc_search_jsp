<%@page import="java.net.URLDecoder"%>
<%@page import="java.io.File"%>
<%@ page import="hcc_search.*" %>
<%@ page import="hcc_search.result.*" %>
<%@ page import="hcc_search.logger.*" %>

<%-- 
    Document   : index
    Created on : Dec 2, 2011, 11:50:19 AM
    Author     : frankkempf
--%>



<jsp:useBean id="hcc_search" class="hcc_search.hcc_search_Bean" ></jsp:useBean>

 <%!  
   hcc_search.hcc_search_Bean searchBean = new hcc_search.hcc_search_Bean() ; 
   hcc_search_opts so = null ;
   String strFSPath = null ;
   String strQuery  = null ; 
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
        <link type="text/css" rel="stylesheet" href="hcc_search.css">
    </head>
    <body>
        <%             
            strQuery = request.getParameter("query") ;
            strCustomIndex = request.getParameter("index") ; 
            if( null == strCustomIndex ){ strCustomIndex = "index"; }  
            strIndexPath = searchBean.getIni(strCustomIndex) ;
            strClientPrefs = request.getParameter("pref"); 
            strFSPath = request.getRealPath("/") ;     
            searchBean.readConfig(strFSPath + "/config/settings.cfg", strCustomIndex) ; 
            so = new hcc_search_opts( strQuery, "contents", strIndexPath, false, 
                             hcc_search_opts._HTML_, searchBean.getIni("pathSubst"), 
                             true,  
                             "highlightText") ;
            so.m_bLogResult = true ; //dev only            
            fLog = new fileLogger("hcc_search.index.jsp.txt", strFSPath +  "logs" + File.separator + "hcc_search.log" );                          
            so.setLogger(fLog) ;
        %>
        <div id="search" align="center">
           <img src="/images/hcc_banner.jpg" alt="logo hcc" />
           <FORM METHOD=GET ACTION=index.jsp>
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
                 
            
            <div id="result" style="position:absolute;left:250px;top:200px;">
               
                <%  
                    fLog.log("index.jsp.log - query.", "Index!: " + so.m_strIndexDir, 0) ; 
                    if(null != strQuery && strQuery.length() > 0){                    
                    oResult = searchBean.search2(strIndexPath, so, strClientPrefs, false);                    
                }
                else{
                     fLog.log("index.jsp.log - query.", "Not executed...", 0) ; 
                }
                fLog.log("index.jsp.log - query.", so.toString(), 0) ;
                if( strQuery != null && ( null == oResult || oResult.m_strSearchResult.isEmpty() ) )
                { //deliver customized html
                    strResult = searchBean.emptyResult(strFSPath, strMsgPath, "emptySearchResult.html", "de");
                }
               
               if(oResult!=null){
                    fLog.log("index.jsp.log - query", oResult!=null?oResult.m_lNumDocs.toString():"0" + " docs for [" +  strQuery + "]", 0);
                    fLog.log("index.jsp.log - query", oResult.m_strSearchResult, 0);
                }
               else{
                   fLog.log("index.jsp.log - query.", "Index: " + strIndexPath, 0) ; 
                   fLog.log("index.jsp.log - query", "no results for query [" + strQuery + "]", 0);
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
