<%@page import="java.net.URLDecoder"%>
<%@ page import="hcc_search.*" %>
<%@ page import="hcc_search.result.*" %>
<%@ page import="html.htmlUtils.*" %>
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
   hcc_search.hcc_search_opts so = null ;
   String  strClientPrefs = null ;
   String  strMsgPath = "repository/messages/" ;   
   String  strResult = null ;   
   hcc_search.result.sResult oResult  = null ;
   String  pDisplayCount = null ;
   String  pLog = null ;
   String  strCustomIndex = null ;
   String  strRet = null ;
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
            out.println("---Using INI setting " + oSearchBean.getIni(strCustomIndex) + " for index. <br>" );
            out.println(oSearchBean.getIni("getIni: " + oSearchBean.getIni(strCustomIndex))) ;                    
            out.println(hcc_utils.escapeTerm(strQuery)  + "<br>");
        }
        %>
            
            
                <%  
                   strRet = "" ;
                    strQuery = hcc_utils.escapeTerm("hcc-medical.com/buildingblocks/pmd_migrate/hcc_pmd_migrate.php") ;
                    so = new hcc_search_opts( strQuery,
                             "URN", oSearchBean.getIni(strCustomIndex), 
                            true,  hcc_search_opts._HTML_, null ) ;   
                    
                    oResult = oSearchBean.search2(  so.m_strIndexDir,  so, strClientPrefs, false);
                    if( null != oResult && null != oResult.m_strSearchResult ){                        
                        strRet = oResult.m_strSearchResult ;
                              
                    }
                    oResult = null ;
                    //escapeTerm behandelt die Slashes.
                    so.m_strQuery = hcc_utils.escapeTerm("healthcare-components.com/inforecord/hcc_inforecord.php") ;
                    oResult = oSearchBean.search2(so.m_strIndexDir,  so, strClientPrefs, false);
                    if( null != oResult && null != oResult.m_strSearchResult )
                        strRet +=  oResult.m_strSearchResult ;
                    oResult = null ;
                    so.m_strQuery = hcc_utils.escapeTerm("2112portals.com/PMD_ShowCases/DialysePMD_2010.htm") ;
                    oResult = oSearchBean.search2(so.m_strIndexDir,
                     so, strClientPrefs, false);
                    if( null != oResult && null != oResult.m_strSearchResult )
                        strRet +=  oResult.m_strSearchResult ;
                                          
                
                    
                    if(  ( null == oResult || oResult.m_strSearchResult.isEmpty() ) )
                    { //deliver customized html
                        strResult = oSearchBean.emptyResult(strFSPath, strMsgPath, "emptySearchResult.html", "de");
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
                    if( strRet == null ) strRet = "" ;
               %>
               <br></br>
               <%= html.htmlUtils.highlightQuery(strRet, "Smartforms Sapscript inforecord dialyse") %>
               <% session.invalidate(); 
                oResult = null ; 
                strQuery = null ;
              %>

        