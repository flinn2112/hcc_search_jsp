<%-- 
    Document   : VBScriptLoad
    Created on : Dec 22, 2011, 9:08:02 AM
    Author     : frankkempf
--%>

<%@page contentType="text/vbscript" pageEncoding="UTF-8"%>
If Not IsObject(SAPGuiApp) Then
   Set SAPGuiAuto = GetObject("SAPGUI")
   Set SAPGuiApp = SAPGuiAuto.GetScriptingEngine
End If
If Not IsObject(Connection) Then
   Set Connection = SAPGuiApp.Children(0)
End If
If Not IsObject(SAP_Session) Then
   Set SAP_Session = Connection.Children(0)
End If
If IsObject(WScript) Then
   WScript.ConnectObject SAP_Session, "on"
   WScript.ConnectObject SAPGuiApp, "on"
End If
 
SAP_Session.findById("wnd[0]").Maximize
