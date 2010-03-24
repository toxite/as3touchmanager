package benkuper.touch.core{
	
	import benkuper.touch.objects.ITObject;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	import benkuper.touch.core.TManager;
	import benkuper.touch.events.TCursorEvent;
	
	public class TCursor extends Sprite{
		
		private var id:int;
		
		private var type:String;
		
		
		
		//Default values for picture simple & complex drag initialisation
		//(see TPicture.as, simpleDrag & complexDrag)
		public var initZeroX:Number;
		public var initZeroY:Number;
		public var initZeroRot:Number;
		public var initZeroScale:Number;
		
		
		//Cursor Mode, depending on application using
		private static var cursorMode:String;
		
		private var targetObject:ITObject;
		
		private var cursorInfo:TCursorInfo;
		
		
		private var deltaX:Number;
		private var deltaY:Number;
		
		
		
		public function TCursor(cID:int){
			
			id = cID;
			
			type = "TCursor";
			
			graphics.beginFill(Math.random() * uint(0xffffff));
			graphics.drawCircle(0, 0, 5);
			graphics.endFill();
			
		}
		
		
		
		public function update(tx:Number,ty:Number){
			
			//trace("TCursor update,mode="+cursorMode);
			
			
				
				
			 
			if (this.x == 0) {
				
				checkFirst(tx,ty);
				
			}else if (targetObject != null) {
				
				cursorInfo.cursorX = tx;
				cursorInfo.cursorY = ty;
				
				deltaX = tx - this.x;
				deltaY = ty - this.y;
				
				if (!isObjectOver(targetObject,tx,ty)) {
					
					if(cursorInfo.state == "in"){
						cursorInfo.state = "out";
						targetObject.dispatchEvent(new TCursorEvent(TCursorEvent.CURSOR_OUT, cursorInfo , targetObject));
					}
					
					//targetObject = null;
					
					if (targetObject.dispatchWhileOut) {
						targetObject.dispatchEvent(new TCursorEvent(TCursorEvent.CURSOR_MOVE, cursorInfo, targetObject,deltaX,deltaY));
					}
					
				}else {
					
					if (cursorInfo.state == "out") {
						cursorInfo.state = "in";
						targetObject.dispatchEvent(new TCursorEvent(TCursorEvent.CURSOR_IN, cursorInfo , targetObject));
					}
					
					
					targetObject.dispatchEvent(new TCursorEvent(TCursorEvent.CURSOR_MOVE, cursorInfo, targetObject,deltaX,deltaY));
				}
				
			}
			
			
			
			this.x = tx;
			this.y = ty;
			
			
			
		}
		
		
		private function checkFirst(tx:Number,ty:Number):Boolean {
			
			var curObject:ITObject;
			
			
			for (var i:String in TManager.objectList) {
				
				curObject = TManager.objectList[i] as ITObject;
				
				if (isObjectOver(curObject,tx,ty) && !curObject.hasMaxCursor) {
					
					targetObject = curObject;
					
					cursorInfo = new TCursorInfo(this.id,tx, ty);
					cursorInfo.state = "in";
					
					
					
					targetObject.dispatchEvent(new TCursorEvent(TCursorEvent.CURSOR_OVER,cursorInfo, curObject));
					
					
					
					return true;
				}
				
				
			}
			
			return false;
			
		}
		
		private function isObjectOver(tObject:ITObject,tx:Number,ty:Number):Boolean {
			return DisplayObject(tObject).hitTestPoint(tx, ty,true);
			
		}
		
		
		
		
		public function deactivate(){
			
			if (targetObject != null) {
				
				targetObject.dispatchEvent(new TCursorEvent(TCursorEvent.CURSOR_UP, new TCursorInfo(this.id,this.x,this.y),  targetObject,deltaX,deltaY));
				targetObject = null;
				
			}
			
			parent.removeChild(this);
			TManager.cursorList[id].relatedTCursor = null;
			TManager.cursorList[id] = null;
			delete TManager.cursorList[id];
		}
		
		
		public static function set mode(m:String):void{
			cursorMode = m;
		}
		
		public static function get mode():String{
			return(cursorMode);
		}
	}
		
}
