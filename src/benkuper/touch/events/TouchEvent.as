package benkuper.touch.events 
{
	import flash.events.Event;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Ben Kuper
	 */
	public class TouchEvent extends Event 
	{
		
		public static const TAP:String = "tap";
		public static const DOUBLE_TAP:String = "doubleTap";
		
		public var tapPoint:Point;
		
		public function TouchEvent(type:String,tapPoint:Point, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			this.tapPoint = tapPoint;
		} 
		
		public override function clone():Event 
		{ 
			return new TouchEvent(type,tapPoint, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("TouchEvent", "type","tapPoint", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}