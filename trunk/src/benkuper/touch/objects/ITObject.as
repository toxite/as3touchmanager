package benkuper.touch.objects 
{

	import benkuper.touch.core.TCursorInfo;
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Ben Kuper
	 */
	public interface ITObject
	{
		
		function addCursor(cursorInfo:TCursorInfo):void;
		function removeCursor(cursorInfo:TCursorInfo):void;
		function get hasMaxCursor():Boolean;
		function get cursorArray():Array;
		function set cursorArray(value:Array):void;
		
		function get dispatchWhileOut():Boolean;
		function dispatchEvent(evt:Event):Boolean;
	}

}