package benkuper.touch.core 
{
	/**
	 * ...
	 * @author Ben Kuper
	 */
	public class TCursorInfo
	{
		
		private var _cursorID:int;
		private var _cursorInitX:Number;
		private var _cursorInitY:Number;
		
		private var _cursorX:Number;
		private var _cursorY:Number;
		
		private var _state:String;
		
		private static var instances:Array;
		
		
		public function TCursorInfo(cursorID:int, cursorInitX:Number, cursorInitY:Number) 
		{
			
			if (instances == null) {
				instances = new Array();
			}
			
			instances.push(this);
			
			this.cursorID = cursorID;
			this.cursorInitX = cursorInitX;
			this.cursorInitY = cursorInitY;
			
			this.cursorX = cursorInitX;
			this.cursorY = cursorInitY;
			
		}
		
		public static function getCursorInfoByID(id:int):TCursorInfo {
			for (var i:String in instances) {
				if (TCursorInfo(instances[i]).cursorID == id) {
					return instances[i] as TCursorInfo
				}
			}
			
			return null;
		}
		
		public function get cursorX():Number { return _cursorX; }
		
		public function set cursorX(value:Number):void 
		{
			_cursorX = value;
		}
		
		public function get cursorY():Number { return _cursorY; }
		
		public function set cursorY(value:Number):void 
		{
			_cursorY = value;
		}
		
		
		public function get infos():String {
			return "Cursor Info : id=" + cursorID + ", initX=" + cursorInitX + ", initY=" + cursorInitY + ", x=" + cursorX + ", y=" + cursorY;
		}
		
		public function get cursorInitX():Number { return _cursorInitX; }
		
		public function set cursorInitX(value:Number):void 
		{
			_cursorInitX = value;
		}
		
		public function get cursorInitY():Number { return _cursorInitY; }
		
		public function set cursorInitY(value:Number):void 
		{
			_cursorInitY = value;
		}
		
		public function get cursorID():int { return _cursorID; }
		
		public function set cursorID(value:int):void 
		{
			_cursorID = value;
		}
		
		public function get state():String { return _state; }
		
		public function set state(value:String):void 
		{
			_state = value;
		}
		
		
	}

}