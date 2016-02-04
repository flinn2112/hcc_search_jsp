  


     var myC12 = null ;
     var loadTimer = null ;
	var rowHeight = 15 ;
	var numRows  ;
	var consoleTop = 100 ;
	var consoleLeft = 100 ;







   console12 = function(strConsoleDiv, strPromptDiv, iNumRows)
   {
      this.bufferLen = iNumRows ;  //limit
      var _consoleElementName = strConsoleDiv ;
      var _promptElementName = strPromptDiv ;
      var _screenBuffer = new Array() ;
      var _updateTimer ;
      var _promptTimer ;

      this.insert = function(strText){
   
         clearInterval(_updateTimer) ; //stop timer while inserting.
  
          //insert always at end
        if(_screenBuffer.length >= this.bufferLen)
          _screenBuffer.shift() ;      //out
        _screenBuffer.push(strText) ;
    
      }
      
      _updatePrompt = function(strText){
         //update will always alter the topmost array element.
         
         var myElement = document.getElementById(_promptElementName);
   	   if(myElement)
   	   {
   	      myElement.innerHTML = '' ;
   	         myElement.innerHTML = strText ;
   	   }
      }
      
      
      
      _redraw = function(strConsoleElName){

         var myElement = document.getElementById(strConsoleElName);
			var currentRow ;
			var currentRowName ;
   	   if(myElement)
   	   {  //fill the screen bottom up 	     
   	      for(var i = 0 ;i<_screenBuffer.length;i++){
				   currentRowName = i.toString() ;
					currentRow = document.getElementById(currentRowName);
					if(currentRow)
					   currentRow.innerHTML = _screenBuffer[_screenBuffer.length-i-1] ;
				}   	   	 
   	   }
  
      }
      
      
      
      _animateLoad = function(){  
         var strToken = '' ;
         var myElement = document.getElementById(_promptElementName);
			clearInterval(_promptTimer) ;
   	   if(myElement)
   	   {
   	      strToken = myElement.innerHTML ;
   	   }
   	   
         if ( '\\' == strToken )
            strToken = '|' ;
         else if ( '|' == strToken )
            strToken = '/' ;
         else if ( '/' == strToken )
            strToken = '-' ;
         else
           strToken = '\\' ;   
         _updatePrompt(strToken) ;   
      }

       _animatePrompt = function(){  
         var strToken = '' ;
         var myElement = document.getElementById(_promptElementName);
			clearInterval(_updateTimer) ;

   	   if(myElement)
   	   {
   	      strToken = myElement.innerHTML ;
   	   }
   	   
         if ( ']' == strToken )
            strToken = ' ' ;
         else
           strToken = ']' ;
   
         _updatePrompt(strToken) ;   
      }    
      
      
      this.animateLoad = function(){
           clearInterval(_promptTimer) ;
           _updateTimer = window.setInterval(_animateLoad, 200) ;           
      }
      
      this.animatePrompt = function(){
		    clearInterval(_updateTimer) ;
			 clearInterval(_promptTimer) ;
         _promptTimer = window.setInterval(_animatePrompt, 700) ;     
      }

		this.redraw = function(){
		      this.animatePrompt() ;	
            _redraw(_consoleElementName) ;		
				
      }
   }  
   
   
   
   
   
	addMessage = function(strMessage){
		var jetzt = new Date();
		if( null == myC12 ){
			myC12 = new console12('SystemCanvas', 'SystemPrompt', numRows) ;
		}
      myC12.insert('Test/' + jetzt.getTime());
		myC12.redraw() ;

	}

/*
   ==============================================
   i n i t C o n s o l e 
   ==============================================
*/
   initConsole12 = function(strCanvasEl, strPromptEl, iWidth, iHeight, iRowHeight){
   
   
	var elSystemCanvas = document.getElementById(strCanvasEl) ;
	var elRow ;
      var strContent ;
   
      clearInterval(loadTimer) ;
	if(!elSystemCanvas) return ;
   

      elSystemCanvas.style.width = iWidth.toString()  +'px' ;
      elSystemCanvas.style.height = iHeight.toString()  +'px' ;

       numRows = parseInt( (parseInt(iHeight - rowHeight ) ) / rowHeight) - 1;  //subtract 1 for the prompt 
	strContent = '' ;
   for(i=numRows-1; i>=0;i--) {
	  strContent+= '<div id=\"' + i.toString() + '\" class=\"equiRow\"' 
	               + ' style=height:' + rowHeight.toString()  
						+ 'px;\">' 
	               + '&nbsp;</div>\r\n' ;	 
	}

   strContent+= '<div id=\"SystemPrompt\"></div>' ;



    elSystemCanvas.innerHTML = strContent ;



    /*Buggy IE fix (not using browser switch
	   when clientHeight would exceed the predefined height - we stop.
		Therefore overflow of SystemCanvas is set to show - in IE this would tell us that Height is to large.
	 */
	 

    //this code would only apply to IE Browsers
	 if( (elSystemCanvas.clientHeight) > iHeight) //+ rowHeight because we need a row for the prompt
	 {//adjust numRows
	   numRows--; 
		//remove the last equiRow which will make room for the prompt.
      elRow = document.getElementById(numRows.toString()) ;
		if(elRow)
			elSystemCanvas.removeChild(elRow) ;
	 }



    if( null == myC12 )
      myC12 = new console12(strCanvasEl, strPromptEl, numRows) ;
/*
    myC12.insert('System is loaded...') ;
	 myC12.redraw() ;
*/
  }





  
  
  
  
  
  var console12Snap = null ;  
  var pf = null ;
  
   
  cbUnload = function(){} ;
  
  
  loadConsoleLayout = function(strConsoleElement, iWidth, iHeight){
		var strContent ;
		strContent = '<div id=\"SystemCanvas\">' +
						 '</div>' ;
		return strContent ;
  }
  

  loadConsole12 = function()
  {
	   if( pf){
		 
         console12Snap .show() ;
			return;
	   }
      pf = new NS2112.INTRINSICS.PanelFactory2112() ;
      console12Snap  = pf.create( null, null, null, cbUnload, 'TEST',
		 '2112AjaxConsole', 'Console', 400, 300, 
                              16, 12,          
                              NS2112.windowStyle.WS_VANILLA | NS2112.windowStyle.WS_CANRELOAD) ;	
     	   console12Snap .setBody(loadConsoleLayout('2112AjaxConsole_bd12', 400, 300)) ; //_bd12 is generated by 2112PowerWindows FrameWork
		document.getElementById('2112AjaxConsole_bd12').style.overflow = 'hidden' ;  //no scrolling
		initConsole12('SystemCanvas', 'SystemPrompt', 400, 300) ;
         console12Snap.moveTo(0,0) ;
return console12Snap ;

  }

  unloadConsole12 = function(){
    console12Snap.hide() ;
  }

  showConsole12 = function(){
    console12Snap.show() ;

  }
