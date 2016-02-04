/***************************************************************************************************/

//Namespace 2112
//Create Object Node if not already done.
window.NS2112 = window.NS2112 || {};
//SNAPIN Constants / Flags



//encapsulation of the YUI Event - needs to be replaced by an own class to someday
//finally get rid of the YUI stuff.
NS2112.CustomEvent = function( type , oScope , silent , signature ) 
{  //this is just an encapsulation and in the future the YAHOO CE should be eradicated.
   this.ce = new YAHOO.util.CustomEvent(type, oScope, silent, signature);

   this.subscribe = function( fn , obj , override ){
      this.ce.subscribe( fn , obj , override ) ;
   } 

   this.unsubscribe = function( fn , obj  ){
      this.ce.unsubscribe( fn , obj ) ;
   } 

   this.fire = function( arguments ) {
      this.ce.fire(arguments) ;
   }

   return this.ce ;
}






NS2112.clone = function(myObj)
{
	if(typeof(myObj) != 'object') return myObj;
	if(myObj == null) return myObj;

	var myNewObj = new Object();

	for(var i in myObj)
		myNewObj[i] = NS2112.clone(myObj[i]);

	return myNewObj;
}


NS2112.include = function (file) {
  var script  = document.createElement('script');
  script.src  = file;
  script.type = 'text/javascript';

  document.getElementsByTagName('head').item(0).appendChild(script);
}


//Now we can use the NS2112.
//This namespace will be used later for declaring Classes within it.

NS2112.namespace = function(ns) {

    if (!ns || !ns.length) {
        return null;
    }

    var levels = ns.split(".");
    var nsobj = NS2112;

    // NS2112 is implied, so it is ignored if it is included
    // Creating sublevels if not already done so.
    for (var i=(levels[0] == "NS2112") ? 1 : 0; i<levels.length; ++i) {
        nsobj[levels[i]] = nsobj[levels[i]] || {};  //create empty object if necessary
        nsobj = nsobj[levels[i]];
    }

    return nsobj;
};

//Extending by prototypal inheritance using this function.
NS2112.extend = function(subclass, superclass) {
    var f = function() {};
    f.prototype = superclass.prototype;
    subclass.prototype = new f();
    subclass.prototype.constructor = subclass;
    subclass.superclass = superclass.prototype;
    if (superclass.prototype.constructor == Object.prototype.constructor) {
        superclass.prototype.constructor = superclass;
    }
};

NS2112.namespace("NS2112");
NS2112.namespace("windowStyle");



NS2112.windowStyle.WS_SHOWTITLE    =  0x1  ;
NS2112.windowStyle.WS_CANCLOSE     =  0x2  ;
NS2112.windowStyle.WS_CANGROW      =  0x4  ;
NS2112.windowStyle.WS_MAXIMIZE     =  0x8  ;


NS2112.windowStyle.WS_DROPDOWN     =  0x10 ;   
NS2112.windowStyle.WS_BORDERS      =  0x20 ;
NS2112.windowStyle.WS_FREEFLOAT    =  0x40 ;
NS2112.windowStyle.WS_MANAGEHEIGHT =  0x80 ;
NS2112.windowStyle.WS_FITTOHOST    =  0x100 ;
NS2112.windowStyle.WS_CANRELOAD    =  0x200 ;
NS2112.windowStyle.WS_CANNAVIGATE  =  0x400 ; //Back/Forth Navigation with buttons
NS2112.windowStyle.WS_CANUNDOCK    =  0x800 ;
NS2112.windowStyle.WS_RESERVED     =  0x1000 ;
NS2112.windowStyle.WS_VANILLA      =  NS2112.windowStyle.WS_SHOWTITLE 
                                    | NS2112.windowStyle.WS_CANCLOSE
                                    | NS2112.windowStyle.WS_BORDERS ;

