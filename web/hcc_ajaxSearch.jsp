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
   String  strFSPath = null ;
   String  strQuery  = null ; 
   String  strEncoding = null ;
   String  strClientPrefs = null ;
   String  strMsgPath = "repository/messages/" ;  
   String  strResult = null ;   
   hcc_search.result.sResult oResult = null ;
   fileLogger fLog = null ;
   String strCustomIndex = null ;
   String pDisplayCount = null ;
%>

        <%             
            strQuery = request.getParameter("query") ;
            strCustomIndex = request.getParameter("INDEX")  ; 
            if( null == strCustomIndex ){ strCustomIndex = "index"; }  
            pDisplayCount = request.getParameter("SHOWCOUNT") ;
            strClientPrefs = request.getParameter("pref"); 
            strFSPath = request.getRealPath("/") ;     
            searchBean.readConfig(strFSPath + "/config/settings.cfg", strCustomIndex) ; 
            so = new hcc_search_opts(strQuery, "contents", searchBean.getIni(strCustomIndex),false, 
                             hcc_search_opts._HTML_, searchBean.getIni("pathSubst"), 
                             true,  
                             "highlightText") ;
            fLog = new fileLogger("hcc_search.index.jsp.txt", strFSPath  + "logs" );                          
        %>
      
        
                <%  
                    if(null != strQuery && strQuery.length() > 0){
                        oResult = searchBean.search2(searchBean.getIni("index"),  so, strClientPrefs, false);
                    }
                    
                    if( strQuery != null && ( null == oResult || oResult.m_strSearchResult.isEmpty() ) )
                    { //deliver customized html
                        strResult = searchBean.emptyResult(strFSPath, strMsgPath, "emptySearchResult.html", "de");
                    }
                    else{
                        fLog.log("index.jsp.log - highlight",  "[" +  strQuery + "]", 0);
                        strResult = html.htmlUtils.highlightQuery(oResult.m_strSearchResult, so.m_strQuery) ; 
                    }                         
               %>
               
               
               <% 
                    fLog.log("index.jsp.log - query", oResult!=null?oResult.m_lNumDocs.toString():"0" + " docs for [" +  strQuery + "]", 0); %>
               <%
                    if(null != pDisplayCount ){                       
                         StringBuilder sb = new StringBuilder() ;
                         sb.append("Found ") ;
                         sb.append(oResult!=null?oResult.m_lNumDocs.toString():"0") ;
                         sb.append( " documents ") ;   
                         out.println(sb.toString()) ;
                    }
               %>
               <%= oResult!=null?strResult:"" %>
               <% session.invalidate(); 
                oResult = null ; 
                strQuery = null ;
              %>
          
            
  