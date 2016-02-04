/*snapIn2112
 The 2112Portals replacement for YUI-Panel:
 -More performance! (++)
 -Maximum control
 -Most flexible
 A snapIn needs to have a function to be hooked up by the portal system.

*/

/*
  Create your own !UNIQUE! Namespace by using the JAVA convention of
  reversing your domain name or get a key from 2112Portals, or generate a GUID
  The Problem with domains are:
  1. You could not use domains starting with numbers (like ours 2112Portals.com)
     Since JS does not eval variable starting with numbers.
     So you could circumvent it by adding an underscore.
  2. Well - for every dot-separated string an object would be created.
     So on large Portals with many snapIns this may cause some performance
     issues on the clients.
  3. My recommendation: 
     Use a single unique ID i.e. turn the dots in your Domain Name 
     into myDomain_de/myDomain_net.
*/


//alert(runIsolated) ;
window.NS2112 = window.NS2112 || {};

var runIsolated = (typeof NS2112.portalMan == 'undefined') ;

NS2112.namespace("INTRINSICS") ;

//This function would add a listener and keep the scope of the this 
var snapIn2112_addListener = function() {
    if ( window.addEventListener ) {
        return function(el, type, fn) {
            el.addEventListener(type, fn, false);
        };
    } else if ( window.attachEvent ) {
        return function(el, type, fn) {
            var f = function() {
                fn.call(el, window.event);
            };
            el.attachEvent('on'+type, f);
        };
    } else {
        return function(el, type, fn) {
            element['on'+type] = fn;
        }
    }
}();


/*
REMARKS:

Important to note that borders are treated differently on different browsers:
FF: Borders are added outside so a panel height would be the height + 2 times the borderwidth.
ID: Border grow to the inside.
So to keep it simple we subtract the borders from the panels target size. This would result to smaller 
panels on IE.
But otherwise dealing with panels that are to large would disturb our reposition mechanism.


*/

NS2112.INTRINSICS._2112SnapInPanel_ = function(strName) {
   var m_WindowName = strName ;
   var windowClass = 'window12' ;
   var panelClass  = 'panel12' ;   
   var headerClass = 'hd12' ;
   var bodyClass   = 'bd12' ;
   var bodyDropDownClass = 'bdDropDown12' ;  //for menu
   var footerClass = 'ft12' ; 
   var m_iHeaderHeight = 14 ;
   var m_iFooterHeight  = 5 ;
   var m_elWindow ;
   var m_elPanel ;
   var m_elBody ;
   var m_elHeader ;
   var m_elFooter ;
   var m_elTitle ;
   var m_TitlebarClickListener = null ;
   var m_DropListener = null ; //there will be only ONE! We do not want to admin a bunch of listeners.
   var m_DragListener = null ;
   var m_GrowListener = null ;
   var m_UnloadListener = null ;
   var m_ReloadListener = null ;
   var m_iWindowExtX ; 
   var m_iWindowExtY ; 
   var m_iBodyHeight ;
   this.ToolTip = null ;    
   
   var m_iBorderWidth = 1 ;
   
   elementFactory =  function(theParent, strUniqueName, strClass, iWidth, iHeight)
   {
      var a ;
      var theElement = document.createElement("div");   
         if( null != strUniqueName )
         {
            a = document.createAttribute("id");
            a.nodeValue = strUniqueName ;
            theElement.setAttributeNode(a);
         }
         a = document.createAttribute("class");
         a.nodeValue = strClass ;
         theElement.setAttributeNode(a);

         if( iWidth > 0 )
            theElement.style.width = iWidth + 'px' ;
         if ( iHeight > 0 )
            theElement.style.height = iHeight + 'px';   
            
                  
         theParent.appendChild ( theElement );
         return theElement ;
   }

   this.setHeaderHeight = function(iHeight){
      if(iHeight) m_iHeaderHeight = iHeight ;
   }

   this.setFooterHeight = function(iHeight){
      if(iHeight) m_iFooterHeight = iHeight ;
   }

   //the height of the main window

   this.setWindowExtY = function(iHeight){
      m_iWindowExtY = parseInt(iHeight + ( 4 * m_iBorderWidth +  m_iHeaderHeight + m_iFooterHeight )) ;
   }

   this.setWindowExtX = function(iWidth){
      m_iWindowExtX = parseInt(iWidth - 2 * m_iBorderWidth) ;
   }

   this.getWindowExtY = function(){      
      return  m_iWindowExtY  ;
   }

   this.getWindowExtX = function(){      
      return  m_iWindowExtX ;
   }

   this.getBodyHeight = function(){
       return parseInt( this.getWindowExtY() - ( 4 * m_iBorderWidth +  m_iHeaderHeight + m_iFooterHeight ) ) ; 
       //parseInt(this.getWindowExtY() - ( m_iHeaderHeight + m_iFooterHeight ) ) ; 
   }

   this.getBodyWidth = function(){
      //var iMozAdjust = m_elWindow.clientWidth / m_elWindow.clientWidth ;

      //alert(iMozAdjust + '/' +  document.clientWidth + '/' +  NaN + '/' +  isNaN(iMozAdjust) ) ;
     
      if( document.all )
      {
       //
         return this.getWindowExtX()  ;
      }      
      else
         return this.getWindowExtX() - 2 ;
;  //to change ; ;     
   }  

   this.getWindowName = function(){
      return m_WindowName;
   }
   
   this.getWindow = function(){
      return m_elWindow ;
   }
   
   this.getPanel = function(){
      return m_elPanel ;
   }
   
   this.getHeaderEl = function(){
      return m_elHeader ;
   }
   
   this.getBodyEl = function(){
      return m_elBody ;
   }
   
   this.create = function (strTitle, iWidth, iHeight, iHeaderHeight, iFooterHeight, windowStyle) 
   {     
      var el ;
      var strClass ;

      this.setHeaderHeight(iHeaderHeight) ;
      this.setFooterHeight(iFooterHeight) ;

      var bNoBorders = ((windowStyle & NS2112.windowStyle.WS_BORDERS) == 0 ) ;
      this.setWindowExtX(iWidth);
      this.setWindowExtY(iHeight) ;   
      m_elWindow = elementFactory(document.body, m_WindowName + '_' + windowClass, windowClass, 
                     this.getWindowExtX(), this.getWindowExtY()); 
      a = document.createAttribute("align");
      a.nodeValue = "left" ;      
      m_elWindow.setAttributeNode(a);
      m_elPanel  = elementFactory(m_elWindow, m_WindowName + '_' + panelClass, panelClass,
               -1, -1); //this.getWindowExtX()  this.getWindowExtY()
    
      if( true == bNoBorders )
      {
          m_elWindow.style.overflow = 'visible'  ;           
          m_elPanel.style.overflow = 'visible'  ;
      }
          
      m_elHeader = elementFactory(m_elPanel, m_WindowName  + '_' + headerClass, headerClass , 
                           -1, m_iHeaderHeight);
      snapIn2112_addListener(m_elHeader, "click", this.onTitlebarClick);
      m_iBodyHeight = this.getBodyHeight() ;
      m_iBodyWidth = this.getBodyWidth() ;                
      bNoBorders == true?strClass = bodyDropDownClass:strClass=bodyClass ;    
      m_elBody   = elementFactory(m_elPanel, m_WindowName + '_' + strClass, strClass, m_iBodyWidth, m_iBodyHeight);      
      if(bNoBorders == false ) //do show footer then.
      {
         m_elFooter = elementFactory(m_elPanel, m_WindowName + '_' + footerClass, footerClass, 
                           -1, m_iFooterHeight);     
         m_elFooter.innerHTML = "Buttons: Red/Hide, Blue/Max, Green/Reload" ;    
      }
      elementFactory(m_elHeader, null, 'tl' , -1, m_iHeaderHeight);
      elementFactory(m_elHeader, null, 'tr' , -1, m_iHeaderHeight);      
      
      m_elTitle = document.createElement("div");
      m_elTitle.innerHTML = strTitle ;      
      m_elHeader.appendChild ( m_elTitle );

      if( windowStyle & NS2112.windowStyle.WS_CANCLOSE )
      {    
         el = document.createElement("a");
         a = document.createAttribute("href");
         a.nodeValue = "#" ;      
         el.setAttributeNode(a);

         snapIn2112_addListener(el, "click", this.hide);

         a = document.createAttribute("class");
         a.nodeValue = "container-close" ;    //style=\"display:block;\"" ;
         el.setAttributeNode(a);
         m_elHeader.appendChild ( el );   
      }
  //5/2008 maximizing window
      if(windowStyle & NS2112.windowStyle.WS_CANGROW )
      {         
         el = document.createElement("a");
         a = document.createAttribute("href");
         a.nodeValue = "#" ;      
         el.setAttributeNode(a);

         snapIn2112_addListener(el, "click", this.grow);

         a = document.createAttribute("class");
         a.nodeValue = "container-grow" ;    //style=\"display:block;\"" ;
         el.setAttributeNode(a);
         m_elHeader.appendChild ( el );      
   
      }
      //6/2008 a reloading window

      if( windowStyle & NS2112.windowStyle.WS_CANRELOAD )
      { 
         //alert(strTitle + " CAN RELOAD") ;        
         
         el = document.createElement("a");
         a = document.createAttribute("href");
         a.nodeValue = "#" ;      
         el.setAttributeNode(a);

         snapIn2112_addListener(el, "click", this.onReload);

         a = document.createAttribute("class");
         a.nodeValue = "container-reload" ;    //style=\"display:block;\"" ;
         el.setAttributeNode(a);
         m_elHeader.appendChild ( el );      
   
      }

         return m_elBody ;  
   }

   this.show = function()
   {
      m_elWindow.style.display ='block' ;
   }
   
   this.destroy = function(){
      document.body.removeChild(m_elWindow) ;
      if(!m_UnloadListener) return ;
      m_UnloadListener(m_WindowName) ;
   }

   
   /*
    * 
    * @returns {undefined}
    * 11/2015 changed it to toggle
    */
   this.hide = function(){
   if(m_elBody.style.display == 'none' )
       m_elBody.style.display ='block' ;
   else
      m_elBody.style.display ='none' ;
      if(!m_UnloadListener) return ;
      m_UnloadListener(m_WindowName) ;
   }
   //an event for windows that have the 'WS_CANGROW'
   this.grow = function(){
      if(!m_GrowListener) return ;
      m_GrowListener(m_WindowName) ;
   }
   
   this.unlink = function(){
   
   }

   this.moveTo = function(x, y) 
   {     
      var tmp = m_elWindow.style.position ;
      m_elWindow.style.position = 'fixed' ;
      m_elWindow.style["top"] =  y + "px";
		m_elWindow.style["left"] = x + "px";
      m_elWindow.style.position = tmp ;
      tmp = m_elPanel.style.position ;
      m_elPanel.style.position = 'fixed' ;
      //m_elPanel.style["top"] =  y + "px";
		//m_elPanel.style["left"] = x + "px";
      m_elPanel.style.position = tmp;
  }
   
   this.resize = function(iWidth, iHeight)
   {
      this.setWindowExtX(iWidth);           //Width and Height get calculated
      this.setWindowExtY(iHeight) ;   
      m_iBodyHeight = this.getBodyHeight() ;
		m_iBodyWidth  = this.getBodyWidth() ;
      m_elWindow.style["width"] =  this.getWindowExtX() + "px";
		m_elWindow.style["height"] = this.getWindowExtY() + "px";
      m_elPanel.style["width"] =  this.getWindowExtX() + "px";
		m_elPanel.style["height"] = this.getWindowExtY() + "px";
		m_elBody.style["height"] = m_iBodyHeight + "px";
      m_elBody.style["width"] =  m_iBodyWidth + "px";   // DO NOT ADJUST WIDTH HERE! - it's AUTO.  ? //but IE7 would not work...
   }

   this.bringToFront = function(){
      m_elWindow.style.zIndex = 65535 ;
   }
   this.setTitle = function (strTitle)
   {
      m_elTitle.innerHTML = strTitle ;
   }

   this.getContentNode = function()
   {
      return m_elBody.firstChild ;
   }   
   
   this.setContent = function (theContent)
   {
      if (theContent.tagName) //it's a div
      {
         m_elBody.innerHTML = "";
         m_elBody.appendChild(theContent);
      }
      else 
      {
         m_elBody.innerHTML = theContent;
      }
   }

   //just to satisfy the contract for snapIns
   this.setBody = function(theContent)
   {
       this.setContent(theContent) ;
   }

   this.setTitlebarClickListener = function(Handler){
       m_TitlebarClickListener = Handler ;
   }

   
   this.setDropListener = function(Handler) 
   {
      m_DropListener = Handler ;
   }

   this.setReloadListener = function(Handler) 
   {
      m_ReloadListener = Handler ;
   }

   this.setGrowListener = function(Handler) 
   {
      m_GrowListener = Handler ;
   }

   this.setDragListener = function(Handler) 
   {
      m_DragListener = Handler ;
   }

   this.setUnloadListener = function(Handler) 
   {
      m_UnloadListener = Handler ;
   }

   this.onTitlebarClick = function(){
     if( null != m_TitlebarClickListener ) 
     {
       m_TitlebarClickListener(m_WindowName) ;
     }
   }

   this.onReload = function(){

     //alert(m_WindowName) ;
     if( null != m_ReloadListener ) 
     {
       m_ReloadListener(m_WindowName) ;
     }
   }

   
   this.onDrop = function(arg)
   {
      //the arg object gets translated into some atoms and the Listener is called.
     
     if( null != m_DropListener ) 
     {
       m_DropListener(m_WindowName, arg.mousePosition.x, arg.mousePosition.y ) ;
     }
   } 

   this.onStartDrag = function(arg)
   {
      if( null != m_DragListener ) 
     {
       m_DragListener( m_WindowName ) ;
     }
   }
}



NS2112.INTRINSICS.PanelFactory2112 = function()
{
   this.create = function (cbDrag, cbDrop, cbGrow, cbUnload, theContent, snapInID, strTitle, 
                        iPreferredWidth, iPreferredHeight, iHeaderHeight, iFooterHeight, windowStyle) 
   {
      var x = new NS2112.INTRINSICS._2112SnapInPanel_(snapInID) ;
      var drag = ToolMan.drag() ;
      var coordinates = ToolMan.coordinates() ;

//debugger;
      var myBody = x.create( strTitle, iPreferredWidth, iPreferredHeight, 
                              iHeaderHeight, iFooterHeight,          
                              windowStyle) ;
      if(null != cbDrop)
         x.setDropListener( cbDrop );
      if(null != cbDrag)
         x.setDragListener( cbDrag );
      if(null != cbGrow)
         x.setGrowListener( cbGrow );
      if(null != cbUnload)
         x.setUnloadListener( cbUnload );
      x.setContent(theContent) ; 
      drag.createProxy(x.getWindow(), x.getHeaderEl(), x.onStartDrag, x.onDrop) ;
      return x ;
   }
      
//currently just a shell
  this.show = function(thePanel) 
  {
      thePanel.show() ;
  }
  
  this.destroy = function(){
      //EMPTY
  }


  

}

NS2112.INTRINSICS.snapIn2112 = function(el, userConfig)
{  

if( false == runIsolated )
{
   this.constructor.superclass.constructor.call(this, el, userConfig);
}
   this.Title = "2112SnapInMod" ;
   this.Name = '2112SnapInMod';
   this.Width = 200 ;
   this.Height = 100 ;
   this.Intrinsic = true ;
   this.IntrinsicType = 'snapin' ;
   this.IntrinsicObject = null ;
   
   //The load callback - load your stuff here
   this.load = function(myDiv)
   {  
     this.IntrinsicObject = new NS2112.INTRINSICS.PanelFactory2112();
     return myDiv ;
   }

    
   this.unload = function()
   {
      if( null != this.IntrinsicObject )
         this.IntrinsicObject.destroy() ;
   }
   //remember? - u need a unique name. 
}



if( false == runIsolated )
{
   NS2112.extend(NS2112.INTRINSICS.snapIn2112, NS2112.snapIn12);
   //NS2112.loadCSS('/2112PowerWindows/assets/window12.css') ;
   NS2112.masterControl.registerSnapIn(new NS2112.INTRINSICS.snapIn2112(), "com._2112_.intrinsics") ;   
}










