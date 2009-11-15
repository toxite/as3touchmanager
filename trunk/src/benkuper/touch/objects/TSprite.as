package benkuper.touch.objects 
{
	import benkuper.touch.core.TCursorInfo;
	import benkuper.touch.events.TCursorEvent;
	import benkuper.touch.events.TouchEvent;
	import benkuper.touch.objects.ITObject;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	import gs.easing.Strong;
	import gs.TweenLite;
	
	/**
	 * ...
	 * @author Ben Kuper
	 */
	public class TSprite extends Sprite implements ITObject
	{
		
		//Array of cursors that interact with the sprite
		private var _cursorArray:Array;
		
		//Basically length of the cursorArray, to know how manu cursors are handled by the sprite [read-only]
		private var _numCursors:int;
		
		//Max cursors that can interact with the sprite, based on functionnality (movable = 1, scalable/rotatable = 2) [read-only]
		protected var maxCursors:int;
		
		//temp var for cursor removal filterCursor function
		private var _tmpCursorID:int;
		
		
		//Coordinates var for calculation
		private var initDiffX:Number;
		private var initDiffY:Number;
		private var initScale:Number;
		private var initRot:Number;
		
		
		
		//Functionnalities [read-write]
		private var _movable:Boolean;
		private var _scalable:Boolean;
		private var _rotatable:Boolean;
		private var _tapable:Boolean;
		
		private var _softMove:Boolean;
		private var _softRelease:Boolean;
		
		//Timer for tap detection
		private var tapTimer:Timer;
		private var doubleTapTimer:Timer;
		
		
		//Controls
		protected var minScale:Number;
		protected var maxScale:Number;
		
		
		
		
		public function TSprite() 
		{
			super();
			_cursorArray = new Array();
			
			maxCursors = 0;
			_numCursors = 0;
			
			addEventListener(TCursorEvent.CURSOR_OVER, handleCursor);
			addEventListener(TCursorEvent.CURSOR_UP, handleCursor);
			addEventListener(TCursorEvent.CURSOR_IN, handleCursor);
			addEventListener(TCursorEvent.CURSOR_OUT, handleCursor);
			addEventListener(TCursorEvent.CURSOR_MOVE, handleCursor);
			
			
			
		}
		
		
		private function handleCursor(e:TCursorEvent):void 
		{
			
			
			
			
			switch (e.type) {
				case TCursorEvent.CURSOR_OVER:
					
					addCursor(e.cursorInfo);
					
					
					
					
					if (_movable) initMovable();
					
					//trace(e.cursorInfo.infos);
					
					if (numCursors == 2) {
						if (_scalable || _rotatable) initTransform();
					}else if (numCursors == 1) {
						highlight(true);
						
						if(tapable) {
							initTapable(e.type);
						}
					}
					
					
					
					
				break;
				
				
				case TCursorEvent.CURSOR_UP:
					
					removeCursor(e.cursorInfo);
					
					if(_numCursors == 0){
						highlight(false);
						
						
						if (movable && softRelease && Math.abs(e.deltaX + e.deltaY) > .8) {
							
							var globalCoords:Point = parent.localToGlobal(new Point(this.x, this.y));
							globalCoords.x += e.deltaX * 10;
							globalCoords.y += e.deltaY * 10;
							
							var localTarget:Point = parent.globalToLocal(globalCoords);
							
							//trace(e.deltaX+ e.deltaY);
							
							TweenLite.to(this, .7, { x:localTarget.x, y:localTarget.y, ease:Strong.easeOut } );
							
						}else if(tapable){
							initTapable(e.type);
						}
						
					}else if (_numCursors == 1) {
						if(movable)	initMovable();
					}
					
					//trace("cursorX: " + e.cursorInfo.cursorX);
					//trace("cursorY: " + e.cursorInfo.cursorY);
					
				break;
				
				case TCursorEvent.CURSOR_IN:
					
					if (!(_movable || _scalable || _rotatable)) {
						
						addCursor(e.cursorInfo);
						
						if (_numCursors == 1) {
							
							highlight(true);
						}
					}
					
					
				break;
				
				case TCursorEvent.CURSOR_OUT:
					
					if (!(_movable || _scalable || _rotatable)) {
						//trace("cursorOut");
						removeCursor(e.cursorInfo);
						
						
						if (_numCursors < 0) {
							highlight(false);
							
							
						}
						
					}
					
					
					
				break;
				
				
				case TCursorEvent.CURSOR_MOVE:
					
					//updateCursorInfo(e.cursorInfo);
					
					
					if (_numCursors >= 2) {
						if(_scalable ||_rotatable) handleTransform(e.cursorInfo);
					}else {
						if (_movable) handleMove();
					}
					
					//trace(e.deltaX+ e.deltaY);
					
				break;
			}
			
			
		}
		
		
		
		
		protected function highlight(doHighlight:Boolean):void {
			
			
			var targetFilter:Object = new Object;
			if (doHighlight) {
				targetFilter.brightness = 1.5;
			}
			
			TweenLite.to(this, .2, { colorMatrixFilter:targetFilter} );
		}
		
		
		private function initTapable(eventType:String):void
		{
			if(eventType == TCursorEvent.CURSOR_OVER){
				
				tapTimer = new Timer(150, 1);
				tapTimer.start();
				tapTimer.addEventListener(TimerEvent.TIMER_COMPLETE, notap);
				
			}else if (tapTimer != null && (eventType == TCursorEvent.CURSOR_OUT || eventType == TCursorEvent.CURSOR_UP)) {
				
				//trace("tap !");
				
				dispatchEvent(new TouchEvent(TouchEvent.TAP,true));
				
				if (doubleTapTimer == null) {
					
					doubleTapTimer = new Timer(300, 1);
					doubleTapTimer.start();
					doubleTapTimer.addEventListener(TimerEvent.TIMER_COMPLETE, notap);
					
				}else {
					
					//trace("double tap !");
					dispatchEvent(new TouchEvent(TouchEvent.DOUBLE_TAP, true));
					doubleTapTimer = null;
				}
				
				tapTimer = null;
			}
			
			
		}
		
		private function notap(e:TimerEvent):void 
		{
			
			
			if (e.target == tapTimer) {
				//trace("tapTimer : notap");
				
				tapTimer = null;
				
			}else if(e.target == doubleTapTimer) {
				//trace("doubleTapTimer : notap");
				doubleTapTimer = null;
			}
		}
		
		
		private function initMovable():void
		{
			
			
			
			TweenLite.killTweensOf(this);
			
							
			//Initialisation of init* params
			var baseCursor:TCursorInfo = _cursorArray[0] as TCursorInfo;
			var basePoint:Point = parent.globalToLocal(new Point(baseCursor.cursorX, baseCursor.cursorY ));
			initDiffX = basePoint.x - this.x;
			initDiffY = basePoint.y - this.y;
			
		}
		
		protected function handleMove():void
		{
			
			//trace("handleMove");
			var baseCursor:TCursorInfo = _cursorArray[0] as TCursorInfo;
			
			
			var targetCursorPoint:Point = parent.globalToLocal(new Point(baseCursor.cursorX,baseCursor.cursorY ));
			var targetX:Number = targetCursorPoint.x - initDiffX;
			var targetY:Number = targetCursorPoint.y - initDiffY;
			
			
			if(softMove){
				TweenLite.to(this, .2, { x:targetX, y:targetY, ease:Strong.easeOut } );
			}else {
				this.x = targetX;
				this.y = targetY;
			}
			
			
			
			
		}
		
		
		
		private function initTransform():void{
			
			
			var baseCursor:TCursorInfo = _cursorArray[0] as TCursorInfo;
			var moveCursor:TCursorInfo = _cursorArray[1] as TCursorInfo;
			
			//Initialisation of init* params
			initScale = this.scaleX;
			
			initRot = this.rotation;
			
			if(moveCursor.cursorX < baseCursor.cursorX){
				initRot += 180;
			}
			
			for (var i:String in _cursorArray) {
				TCursorInfo(_cursorArray[i]).cursorInitX = TCursorInfo(_cursorArray[i]).cursorX;
				TCursorInfo(_cursorArray[i]).cursorInitY = TCursorInfo(_cursorArray[i]).cursorY;
			}
			
		}

		
		protected function handleTransform(basePointInfo:TCursorInfo):void
		{
			
			
			//handleMove();
			
			
			var baseCursor:TCursorInfo = _cursorArray[0] as TCursorInfo;
			var moveCursor:TCursorInfo = _cursorArray[1] as TCursorInfo;
			
			var targetProps:Object = new Object();
			
			
			if (baseCursor == basePointInfo) {
				targetProps.point = new Point(moveCursor.cursorX,moveCursor.cursorY);
			}else {
				targetProps.point = new Point(baseCursor.cursorX,baseCursor.cursorY);
			}
			
			
			var compensateX:Number = this.parent.localToGlobal(new Point(0, 0)).x;
			var compensateY:Number = this.parent.localToGlobal(new Point(0, 0)).y;
			

			
			targetProps.point.x -= compensateX;
			targetProps.point.y -= compensateY;
			
			//TODO : PARENT-CHILD ROTATION & SCALE COMPENSATION
			
			
			if(_scalable){
				
				
				var baseDist:Number = Math.sqrt(Math.pow(moveCursor.cursorInitX - baseCursor.cursorInitX, 2) + Math.pow(moveCursor.cursorInitY - baseCursor.cursorInitY , 2));
				var curDist:Number = Math.sqrt(Math.pow(moveCursor.cursorX - baseCursor.cursorX, 2) + Math.pow(moveCursor.cursorY - baseCursor.cursorY , 2));
				var targetScale:Number = (curDist / baseDist) * initScale;
				
				targetProps.scaleX = targetScale;
				targetProps.scaleY = targetScale;
				
			}
			
			
			if (_rotatable) {
				
				var baseRot:Number = Math.atan((moveCursor.cursorInitY - baseCursor.cursorInitY)/(moveCursor.cursorInitX - baseCursor.cursorInitX)) * (180 / Math.PI);
				var targetRot:Number = Math.atan((moveCursor.cursorY - baseCursor.cursorY)/(moveCursor.cursorX - baseCursor.cursorX)) * (180 / Math.PI);
				
				
				if(moveCursor.cursorX < baseCursor.cursorX){
					targetRot += 180;
				}	
				
				targetRot -= baseRot;
				targetRot += initRot;
				
				targetProps.shortRotation = {rotation:targetRot};
				
			}
			
			
			//trace("handleTransform");
			TweenLite.to(this, 0, {transformAroundPoint:targetProps, onComplete:transformFinish } );
			
			
			
		}
		
		
		private function transformFinish():void {
			//trace("transformFinish");
		}
		
		
		
		
		public function addCursor(cursorInfo:TCursorInfo):void {
			
			_cursorArray.push(cursorInfo);
			
			//trace("addCursor " + cursorInfo.cursorID + ", " + _cursorArray.length + " cursors on this TSprite "+this);
			
			_numCursors ++;
			
			
			
		}
		
		public function removeCursor(cursorInfo:TCursorInfo):void {
			
			//trace("removeCursor : "+cursorInfo.cursorID);
			
			_tmpCursorID = cursorInfo.cursorID;
			
			var tmpLength:int = _cursorArray.length;
			_cursorArray = _cursorArray.filter(filterCursor);
			
			if(cursorArray.length < tmpLength){
				_numCursors --;
			}
			
		}
		
		 private function filterCursor(element:TCursorInfo, index:int, arr:Array):Boolean {
			
			 //trace("filterCursor : ", int(element), "->" + _tmpCursorID);
			
            return (element.cursorID != _tmpCursorID);
        }
		
		
		
		public function get hasMaxCursor():Boolean {
			if (_numCursors >= maxCursors) {
				return true;
			}
			
			return false;
		}
		
		public function get cursorArray():Array { return _cursorArray; }
		
		public function set cursorArray(value:Array):void 
		{
			
			if (_cursorArray.length >= maxCursors) {
				trace("maxCursors (" + maxCursors + ") reached for this TObject [" + this.name + "]");
				return ;
			}
			
			_cursorArray = value;
			
		}
		
		
		
		public function get scalable():Boolean { return _scalable; }
		
		public function set scalable(value:Boolean):void 
		{
			_scalable = value;
			
			if (maxCursors < 2) {
				
				if(value){
					maxCursors = 2;
					
				}else {
					
					if (!rotatable) {
						maxCursors = int(movable || tapable);
					}
				}
			}
		}
		
		public function get rotatable():Boolean { return _rotatable; }
		
		public function set rotatable(value:Boolean):void 
		{
			_rotatable = value;
			
			if (maxCursors < 2) {
				
				if(value){
					maxCursors = 2;
					
				}else {
					
					if (!scalable) {
						maxCursors = int(movable || tapable);
					}
				}
			}
		}
		
		public function get movable():Boolean { return _movable; }
		
		public function set movable(value:Boolean):void 
		{
			_movable = value;
			
			if(maxCursors < 1){
				maxCursors = int(value);
			}
		}
		
		public function get tapable():Boolean { return _tapable; }
		
		public function set tapable(value:Boolean):void 
		{
			_tapable = value;
			
			if(maxCursors < 1){
				maxCursors = int(value);
			}
			
			
		}
		
		public function get numCursors():int { return _numCursors; }
		
		
		
		override public function set scaleX(value:Number):void {
			
			
			if(!isNaN(minScale) && value < minScale ) {
				value = minScale;
			}else if (!isNaN(maxScale) && value > maxScale) {
				value = maxScale;
			}
			
			super.scaleX = value;
			
			
		}
		
		
		override public function set scaleY(value:Number):void {
			
			if(!isNaN(minScale) && value < minScale ) {
				value = minScale;
			}else if (!isNaN(maxScale) && value > maxScale) {
				value = maxScale;
			}
			
			super.scaleY = value;
			
		}
		
		public function get softMove():Boolean { return _softMove; }
		
		public function set softMove(value:Boolean):void 
		{
			_softMove = value;
		}
		
		public function get softRelease():Boolean { return _softRelease; }
		
		public function set softRelease(value:Boolean):void 
		{
			_softRelease = value;
		}
		
	}

}