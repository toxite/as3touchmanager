package benkuper.touch.events {
	
	import benkuper.touch.core.TCursorInfo;
	import benkuper.touch.objects.ITObject;
	import flash.display.DisplayObject;


	/**
	
	* This class is dispatched when a cursor is over a display object.
	
	*/
	
	import flash.events.Event;

	public class TCursorEvent extends Event {


		public static const CURSOR_OVER:String = "cursorOver";	//Dispatched when finger's touched a touchable object
		public static const CURSOR_UP:String = "cursorUp";	//Dispatched when finger was over his touchable object and leaves the table
		public static const CURSOR_IN:String = "cursorIn";	//Dispatched when finger  was out of his touchable object and moves inside this object;
		public static const CURSOR_OUT:String = "cursorOut";	//Dispatched when finger's still on the table but out of his touchable object;
		public static const CURSOR_MOVE:String = "cursorMove";	//Dispatched when finger's on his touchable object and moves
		public static const CURSOR_QUIT:String = "cursorQuit";	//Dispatched when finger's outside an element and property liveTouch of cursor is set to true

		private var objectOver:ITObject;
		private var _deltaX:Number;
		private var _deltaY:Number;
		private var _cursorInfo:TCursorInfo;

		/**
		
		* Constructor.
		
		* @param target DisplayObject that is touched by the cursor (for simulate click)
		
		*/
		
		public function TCursorEvent(type:String, cursorInfo:TCursorInfo, oO:ITObject = null, deltaX:Number = 0, deltaY:Number = 0, bubbles:Boolean = false, cancelable:Boolean = false) {;
			
			super(type, bubbles, cancelable);
			
			//trace("Cursor Event : " + type);
			
			this._deltaX = deltaX;
			this._deltaY = deltaY;
			this._cursorInfo = cursorInfo;
			this.objectOver = oO;
			
		}
		
		
		public function get targetObject():ITObject {
			
			return objectOver;
			
		}
		
		public function get deltaX():Number { return _deltaX; }
		
		public function get deltaY():Number { return _deltaY; }
		
		public function get cursorInfo():TCursorInfo { return _cursorInfo; }

		/**
		
		* Creates and returns a copy of the current instance.
		
		* @return A copy of the current instance.
		
		*/
		
		public override function clone():Event {
			
			
			trace("cloning " + type);
			
			return new TCursorEvent(type, cursorInfo,objectOver,_deltaX,_deltaY);
			
		}
		
		/**
		
		* Returns a String containing all the properties of the current
		
		* instance.
		
		* @return A string representation of the current instance.
		
		*/

		public override function toString():String {

			return formatToString("CursorEvent","type","bubbles","cancelable","eventPhase");

		}

	}

}