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
   String strOS = System.getProperty("os.name") ;
   String strFSPath = null ;
   String strQuery  = null ; 
   String strEncoding = null ;
   String strClientPrefs = null ;
   String strIndexPath = null ;
   String strMsgPath = "repository/messages/" ;  
   String strResult = null ;
   String strDriveSubst = null ; //1.8.2.16
   String strTmp        = null ;
   String strIniVal = null ;
   boolean bSubstIsSet   = true ; //DEFAULT
   boolean bClearStorage   = true ;
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
        <link type="text/css" rel="stylesheet" href="assets/window12.css">
        <link type="text/css" rel="stylesheet" href="hcc_search.css">
        <script language="JavaScript" type="text/javascript" src="tool-man/core.js"></script>
        <script language="JavaScript" type="text/javascript" src="tool-man/events.js"></script>
        <script language="JavaScript" type="text/javascript" src="tool-man/css.js"></script>
        <script language="JavaScript" type="text/javascript" src="tool-man/coordinates.js"></script>
        <script language="JavaScript" type="text/javascript" src="tool-man//drag.js"></script>
        <script type="text/javascript"  src="NS2112.js"></script>
        <script type="text/javascript" src="snapIn2112.js" ></script> 
        <script>
            
            
             clearClientCtxtIf = function(bClear){
                     debugger ;
                if( typeof(Storage) !== 'undefined' && typeof bClear != 'undefined' && bClear){
                    localStorage.clear() ;
                }
                
            }
            
            //! JSP sends 'null' when Param was not set NOT null
            setClientCtxt = function(strName, 
                            strValue, 
                            strIniDefault, //from the servers ini file 
                            bParamIsSet){
                var elFormParam = null ;
    //debugger ;            
                if( strIniDefault && strIniDefault == 'null' ){ //yes string 'null'
                    strIniDefault = null ; //xlat
                }      
                
                
   //     debugger ;        
                //elFormParam = document.Forms.FRMSEARCH{["subst"] ;
                
                //alert("[" + strValue + "] " + bSubstIsSet) ;
                
                if(typeof(Storage) !== 'undefined') {
                    
                } else {
                    return false ;
                }
                
                if(  bParamIsSet ){ // param is set, check if stored already and use                    
                    //nop
                    
                }else{ //no such parameter - take from local storage or from ini(if set)
                    if( localStorage.getItem(strName) ){ //set, use this
                        strValue = localStorage.getItem(strName) ; //and continue
//document.FRMSEARCH.elements["subst"].value = localStorage.getItem(strName) ;
                        //return true ;                      
                    }else if( strIniDefault ){  //take from ini
                        strValue = strIniDefault ;
                    }
                    else{//all empty
                        //strValue = "" ;
                        //value stays as is
                    }
                    
                }
                
                if( strValue == 'null' ){ 
                    //nothing
                    //alert("nop") ;
                    return false ;
                }
                if( strValue.length > 0){ //set/update
                    //alert("Setting") ;
                    localStorage.setItem(strName, strValue);
                    document.FRMSEARCH.elements[strName].value = strValue ;
                    return true ;
                }
            }
            
            
        </script> 
        
  <script type="text/javascript">      
  var pf = null ;
  var snap = null ;
  cbDrag = function(){} ;
  cbDrop = function(){} ;
  cbGrow = function(a, b, c)
  {
    
  } ;
  cbReload = function(){
	alert("A panel can be reloaded by setting it's .src property - but is not implemented in this sample") ;
  }
  cbUnload = function(){} ;
      
  initMe = function(){
      //snap = new 
      pf = new NS2112.INTRINSICS.PanelFactory2112() ;
      snap = pf.create( cbDrag, cbDrop, cbGrow, cbUnload, '',
		 'snapInID', 'Indexinfo', 300, 400, 
                              16, 12,          
                              NS2112.windowStyle.WS_VANILLA | NS2112.windowStyle.WS_CANRELOAD) ;	
      //snap.setReloadListener(cbReload) ;
      var el = document.getElementById("left") ;
      var body = snap.getBodyEl() ;
      body.appendChild(el) ;
      snap.hide() ;
      snap.moveTo(900,70) ;  //somewhere not disturbing
      
      
      <% //clientCtxt 
        strDriveSubst = request.getParameter("subst") ;
        bClearStorage = ( null != request.getParameter("clear") ) ;
        strClientPrefs = request.getParameter("pref"); 
        if( null == strDriveSubst ){ //parameter not set - leave clientStorage as is
            strIniVal = searchBean.getIni("pathSubst") ;
            bSubstIsSet = false ;
        }
        else{
            bSubstIsSet = true ;
        }
      %>
      clearClientCtxtIf(<%= bClearStorage %>) ;
     
      //JS Call)
      setClientCtxt( 'subst', '<%= strDriveSubst %>', '<%= strIniVal %>',<%= bSubstIsSet %> ) ;
      setClientCtxt( 'pref', '<%= strClientPrefs %>', null, <%= (strClientPrefs != null)%> ) ;
      
  }
     </script>   
    </head>
    <body onload="initMe()">
        
        
        <%
        /*
            //COOKIE HANDLING
            Cookie c = null ;
            Cookie[] cookies = request.getCookies();
            //boolean foundCookie = false;
            strDriveSubst = request.getParameter("subst") ;
            boolean bParamEmpty = ( null != strDriveSubst && strDriveSubst.length() == 0 ) ;
            boolean bParamSet = ( null != strDriveSubst && strDriveSubst.length() > 0 ) ;
                
            if( null != cookies ){
                for(int i = 0; i < cookies.length; i++) { 
                    c = cookies[i];                
                    if (c.getName().equals("subst")){
                        //foundCookie = true ;
                        strDriveSubst = c.getValue() ;
                    }                
                }
            }
             
            if( null != c  ){ //cookie is set, update or clear
                if( bParamEmpty ){ //the param subst was set but empty
                    strDriveSubst = null ;                   
                    c.setMaxAge(0); //delete
                    response.addCookie(c);
                    response.sendError(406, "Deleting Subst");
                }
                else if(bParamSet){  //cookie is set - update
                    strDriveSubst = request.getParameter("subst") ;
                    c.setValue(strDriveSubst) ;                      
                    response.addCookie(c);  
                    response.sendError(406, "Resetting Subst to [" + strDriveSubst + "]");
                }
            } //cookie not set yet
            else if(null == c && !bParamEmpty ) { //not set yet and have a value - then set
                c = new Cookie("subst", strDriveSubst) ;                
                response.addCookie(c); 
                response.sendError(406, "Setting Subst to [" + strDriveSubst + "]");
            }
            */
        %>
        
        <%            
            strQuery = request.getParameter("query") ;
            strCustomIndex = request.getParameter("index") ; 
            if( null == strCustomIndex ){ strCustomIndex = "index"; }
            
            strIndexPath = searchBean.getIni(strCustomIndex) ;
            
            strFSPath = request.getRealPath("/") ;     
            searchBean.readConfig(strFSPath + "/config/settings.cfg", strCustomIndex) ; 
            
            //response.sendError(404, "Setting Subst");
           
            
            
            so = new hcc_search_opts( strQuery, "contents", strIndexPath, false, 
                             hcc_search_opts._HTML_, strDriveSubst, 
                             true,  
                             "highlightText") ;
            
            so.m_bLogResult = true ; //dev only            
            fLog = new fileLogger("hcc_search.index.jsp.txt", strFSPath +  "logs" + File.separator + "hcc_search.log" );                          
            so.setLogger(fLog) ;
        %>
        
        
        
        
        <div id="search" align="center">
           <img src="/images/hcc_banner.jpg" alt="logo hcc" />
           <FORM NAME="FRMSEARCH" METHOD=GET ACTION=index.jsp>
            <BR>
            <label for="subst">Subst</label>
            <INPUT   NAME="subst"  type="#############################hidden" readonly="true">
            <label for="pref">Prefs</label>
            <INPUT   NAME="pref"  type="#############################hidden" readonly="true">
            <BR> <INPUT   NAME="query" size="72" value="<%= strQuery!=null?strQuery:"" %>">
             <INPUT TYPE=SUBMIT VALUE="Search">
            </FORM>
        </div> <!-- search -->
        <div id="canvas">
            <div id="left" class="technicalInfo">  
                <%= strOS %><br>
                <%= strFSPath %><br>
                Query [<%= strQuery %>]<br></br>
                <%= strCustomIndex + "[" + strIndexPath + "]" %><br></br>
                Prefs [<%= strClientPrefs %>]<br></br>
                Subst [<%= searchBean.getIni("pathSubst")%> ]<br></br>
                setup: [/hcc_search_jsp/index.jsp?subst=x:&pref=http://localhost:8088]<br>
                clearCtxt: [/hcc_search_jsp/index.jsp?clear=1
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
