/** 
 * @author Mateusz Maćkowiak
 * @see http://mateuszmackowiak.wordpress.com/
 */
package pl.mateuszmackowiak.nativeANE.toast
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.external.ExtensionContext;
	import flash.system.Capabilities;
	/**
	 * <b>Toast Message</b><br> 
	 * A toast is a view containing a quick little message for the user. The toast class helps you create and show those.
	 * <img src="https://github.com/mateuszmackowiak/NativeAlert/raw/master/images/AndoridToast.png"></img>
	 * <img src="https://github.com/mateuszmackowiak/NativeAlert/raw/master/images/IOSToast.png"></img>
	 * @author Mateusz Maćkowiak
	 * @see http://mateuszmackowiak.wordpress.com/
	 * @see http://developer.android.com/reference/android/widget/Toast.html
	 * @see https://github.com/mateuszmackowiak/SlideNotification
	 * 
	 */
	public class Toast
	{
		
		//---------------------------------------------------------------------
		//
		// Constants
		//
		//---------------------------------------------------------------------
		/**
		 * @private
		 *  the id of the extension that has to be added in the descriptor file
		 */
		private static const EXTENSION_ID : String = "pl.mateuszmackowiak.nativeANE.NativeAlert";
		/**
		 * Show the view or text notification for a long period of time. This time could be user-definable.
		 */
		public static const LENGTH_LONG:int = 0x00000001;
		/**
		 * Show the view or text notification for a short period of time. This time could be user-definable. This is the default.
		 */
		public static const LENGTH_SHORT:int = 0x00000000;
		
		
		/**
		 * Push object to the bottom of its container, not changing its size.
		 * <br>Constant Value: 80 (0x00000050)
		 */
		public static const GRAVITY_BOTTOM:int = 0x00000050;
		/**
		 * Place the object in the center of its container in both the vertical and horizontal axis, not changing its size.
		 * <br>Constant Value: 17 (0x00000011)
		 */
		public static const GRAVITY_CENTER:int = 0x00000011;
		/**
		 * Push object to the top of its container, not changing its size.
		 * <br>Constant Value: 48 (0x00000030)
		 */
		public static const GRAVITY_TOP:int = 0x00000030;
		/**
		 * Push object to the left of its container, not changing its size.
		 * <br>Constant Value: 3 (0x00000003)
		 */
		public static const GRAVITY_LEFT:int = 0x00000003;
		/**
		 * Constant indicating that no gravity has been set
		 * <br>Constant Value: 0 (0x00000000)
		 */
		public static const GRAVITY_NON:int = 0x00000000;
		/**
		 * Push object to the right of its container, not changing its size.
		 * <br>Constant Value: 5 (0x00000005)
		 */
		public static const GRAVITY_RIGHT:int = 0x00000005;
		
		//---------------------------------------------------------------------
		//
		// Private Properties.
		//
		//---------------------------------------------------------------------
		/**
		 * @private
		 */
		private static var context:ExtensionContext;
		/**
		 * @private
		 */
		private static var _set:Boolean = false;
		/**
		 * @private
		 */
		private static var _isSupp:Boolean = false;
		
		
		
		
		/**
		 * @copy flash.external.ExtensionContext.dispose()
		 */
		public static function dispose():void{
			if(context)
				context.dispose();
		}
		
		
		
		/**
		 * Make a standard toast that just contains a text with the text from a resource.
		 * @param message the text displayed on the Toast 
		 * @param duration How long to display the message. Either <code>LENGTH_SHORT</code> or <code>LENGTH_LONG</code>
		 * @see pl.mateuszmackowiak.nativeANE.toast.Toast#LENGTH_SHORT
		 * @see pl.mateuszmackowiak.nativeANE.toast.Toast#LENGTH_LONG
		 */
		public static function show(message:String , duration:int=0x00000001):void
		{
			if(Capabilities.os.indexOf("Linux")>-1 || Capabilities.os.toLowerCase().indexOf("ip")>-1){
				if(message==null || message=="")
					return;
				if(isNaN(duration))
					duration = 0;
				
				if(context==null){
					try{
						context = ExtensionContext.createExtensionContext(EXTENSION_ID, "ToastContext");
						
					}catch(e:Error){
						showError(e.message,e.errorID);
					}
				}
				context.call("Toast",message,duration);
				
			}else
				trace("Toast extension is not supported on this platform");
		}
		/**
		 * Make a standard toast that just contains a text with the text from a resource.
		 * @param message the text displayed on the Toast 
		 * @param duration How long to display the message. Either <code>LENGTH_SHORT</code> or <code>LENGTH_LONG</code>
		 * @param gravity Set the location at which the notification should appear on the screen.(<code>GRAVITY_BOTTOM</code> , <code>GRAVITY_CENTER</code>,...) (<b>only on Android</b>)
		 * @param xOffset the x offset from the gravity point (<b>only on Android</b>)
		 * @param yOffset the y offset from the gravity point (<b>only on Android</b>)
		 * @see pl.mateuszmackowiak.nativeANE.toast.Toast#show()
		 * @see pl.mateuszmackowiak.nativeANE.toast.Toast#LENGTH_SHORT
		 * @see pl.mateuszmackowiak.nativeANE.toast.Toast#LENGTH_LONG
		 * 
		 * @see http://developer.android.com/reference/android/view/Gravity.html
		 */
		public static function showWithDifferentGravit(message:String , duration:int=0x00000001, gravity:int=NaN , xOffset:int=0 , yOffset:int=0 ):void
		{
			if(Capabilities.os.indexOf("Linux")>-1 || Capabilities.os.toLowerCase().indexOf("ip")>-1){
				if(message==null || message=="")
					return;
				if(isNaN(duration))
					duration = 0;
				if(isNaN(gravity) || isNaN(xOffset) || isNaN(yOffset))
					return;
				
				if(context==null){
					try{
						context = ExtensionContext.createExtensionContext(EXTENSION_ID, "ToastContext");
					}catch(e:Error){
						showError(e.message,e.errorID);
					}
				}
				
				context.call("Toast", message, duration, gravity, xOffset, yOffset);
			}else
				trace("Toast extension is not supported on this platform");
		}
		
		
		
		/**
		 * Whether a Toast system is available on the device (true);<br>otherwise false
		 */
		public static function get isSupported():Boolean{
			if(!_set){// checks if a value was set before
				try{
					_set = true;
					if(Capabilities.os.indexOf("Linux")>-1 || Capabilities.os.toLowerCase().indexOf("ip")>-1){
						if(context==null)
							var context:ExtensionContext = ExtensionContext.createExtensionContext(EXTENSION_ID, "ToastContext");
						_isSupp = context.call("isSupported")==true;
						context.dispose();
					}else
						_isSupp = false;
				}catch(e:Error){
					//showError(e.message,e.errorID);
					trace("Toast extension is not supported on this platform");
					return _isSupp;
				}
			}	
			return _isSupp;
		}
		
		
		
		//---------------------------------------------------------------------
		//
		// Private Methods.
		//
		//---------------------------------------------------------------------
		/**
		 * @private
		 */
		private static function showError(message:String,id:int=0):void
		{
			trace(message);
			//FlexGlobals.topLevelApplication.dispatchEvent(new NativeAlertErrorEvent(NativeAlertErrorEvent.ERROR,false,false,message,id));
		}
	}
}



