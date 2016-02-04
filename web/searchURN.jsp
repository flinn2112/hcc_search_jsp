<%@page import="java.net.URLDecoder"%>
<%@ page import="hcc_search.*" %>

<%-- 
    Document   : index
    Created on : Dec 2, 2011, 11:50:19 AM
    Author     : frankkempf
--%>



<jsp:useBean id="hcc_search" class="hcc_search.hcc_search_Bean" ></jsp:useBean>
 <%!  
   hcc_search.hcc_search_Bean oSearchBean = new hcc_search.hcc_search_Bean() ; 
   String  strFSPath = null ;
   String  strQuery  = null ; 
   hcc_search_opts so = null ;
   String  strClientPrefs = null ;
   String  strMsgPath = "repository/messages/" ;   
   String  strResult = null ;   
   hcc_search.result.sResult oResult  = null ;
   String  pDisplayCount = null ;
   String  pLog = null ;
   String  strCustomIndex = null ;
   
%>

        <% 
            strQuery = request.getParameter("query"); 
            pLog = request.getParameter("DEBUG")  ; 
            strClientPrefs = request.getParameter("pref"); 
            pDisplayCount = request.getParameter("SHOWCOUNT") ;
            strFSPath = request.getRealPath("/") ;  
            strCustomIndex = request.getParameter("index")  ; 
            if( null == strCustomIndex ){ strCustomIndex = "index"; }    
            oSearchBean.readConfig(strFSPath + "/config/settings.cfg", "index") ;                    
        %>
                
        
        <%
        if( null != pLog)
        {
            out.println(strQuery);
            out.println("Index: " + strCustomIndex + "<br>");
            out.println("---Using INI setting " + oSearchBean.getIni(strCustomIndex) + " for index. <br>" );
                            
            out.println(hcc_utils.escapeTerm(strQuery)  + "<br>");
        }
        %>
            
            <div id="hccSearchResults" style="position:absolute;left:250px;">
                <%  if(null != strQuery && strQuery.length() > 0){ 
                    strQuery = URLDecoder.decode(strQuery) ;//"\\/testindex.html" ;                 
                    so = new hcc_search_opts(  strQuery, "URN", oSearchBean.getIni(strCustomIndex), true,  hcc_search_opts._HTML_, null ) ;                    
                    oResult = oSearchBean.search2(so.m_strIndexDir, hcc_utils.escapeTerm(strQuery), so, strClientPrefs, false);                                          
                }
                    
                if( strQuery != null && ( null == oResult || oResult.m_strSearchResult.isEmpty() ) )
                { //deliver customized html
                    strResult = oSearchBean.emptyResult(strFSPath, strMsgPath, "emptySearchResult.html", "de");
                }
                else{
                    strResult = oResult.m_strSearchResult ;
                }               



                                                  
               %>
               
               <%  
                   if(null != pDisplayCount ){
                       
                     StringBuilder sb = new StringBuilder() ;
                     sb.append("Found ") ;
                     sb.append(oResult!=null?oResult.m_lNumDocs.toString():"0") ;
                     sb.append( " documents ") ;   
                     out.println(sb.toString()) ;
                    }
               %>
               <br></br>
               <%= oResult!=null?strResult:"" %>
               <% session.invalidate(); 
                oResult = null ; 
                strQuery = null ;
              %>
            </div><!-- result -->
        