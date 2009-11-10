package benkuper.touch.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Ben Kuper
	 */
	public class TouchEvent extends Event 
	{
		
		public static const TAP:String = "tap";
		public static const DOUBLE_TAP:String = "doubleTap";
		
		
		
		public function TouchEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new TouchEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("TouchEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}