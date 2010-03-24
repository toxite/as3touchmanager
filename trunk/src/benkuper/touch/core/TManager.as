package benkuper.touch.core{
	
	import benkuper.touch.objects.ITObject;
	import flash.display.DisplayObject;
	import flash.display.Screen;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	import gs.plugins.ShortRotationPlugin;
	import gs.plugins.TransformAroundPointPlugin;
	

	//for tweening
	import gs.OverwriteManager;
	import gs.plugins.ColorMatrixFilterPlugin;
	import gs.plugins.TweenPlugin;
	
	import benkuper.touch.core.*;
	import benkuper.touch.events.*;
	
	
	
	public class TManager extends Sprite
	{
		
		private var host:String;
		private var port:int;
		
		private var targetScreen:Screen;
		
		private var screenW:int;
		private var screenH:int;
		
		private var decalageX:int;
		private var decalageY:int;
		
		
		//List of current fingers on table
		public static var cursorList:Array;
		
		private var factorX:int;
		private var factorY:int;
		private var factorRot:int;
		
		public static var instance:TManager;
		public var tConnector:TConnector;
		public var tParser:TParser;
		
		
		//Debug
		private static var debugMode:Boolean;
		
		
		//List of touch(able) objects register via the registerObject function
		public static var objectList:Array;
		
		
		//Container for touch overlay (cursor display, etc..)
		private var container:Sprite;
		
		
		public function TManager(){
			
			//for tweening
			OverwriteManager.init();
			TweenPlugin.activate([ColorMatrixFilterPlugin,TransformAroundPointPlugin,ShortRotationPlugin]);
			
			//Manager Related
			objectList = new Array();
			cursorList = new Array();
			
			instance = this;
			
			
			
			tParser = new TParser();
			tParser.addEventListener(TParserEvent.NEW_OBJECT, addObject);
			tParser.addEventListener(TParserEvent.NEW_CURSOR, addCursor);
			
			tParser.addEventListener(TParserEvent.REMOVE_OBJECT, removeObject);
			tParser.addEventListener(TParserEvent.REMOVE_CURSOR, removeCursor);
			
			tParser.addEventListener(TParserEvent.UPDATE_OBJECT, updateObject);
			tParser.addEventListener(TParserEvent.UPDATE_CURSOR, updateCursor);
			
		
			
			//Table related -> init Factors
			factorX = 1;
			factorY = 1;
			factorRot = 1;
			
			container = new Sprite();
			addChild(container);
			
			addEventListener(Event.ADDED_TO_STAGE, init);
			
		}
		
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			//VERY IMPORTANT
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			screenW = stage.stageWidth;
			screenH = stage.stageHeight;
			
			trace("tManager initialized, width :", screenW, "height :", screenH);
			
			//decalageX = -stage.nativeWindow.x;
			//decalateY = 
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, reConnect);
		}
		
		
		
		
		public function connect(host:String = "127.0.0.1",port:int = 3000){
			
			
			this.host = host;
			this.port = port;
			
			tConnector = new TConnector();
			tConnector.connect(host,port);
			
			tConnector.addEventListener(TConnectorEvent.CONNECTED,handleConnected);
			tConnector.addEventListener(TConnectorEvent.DISCONNECTED,handleDisconnected);
			tConnector.addEventListener(TConnectorEvent.CONNECTION_ERROR,handleError);
			tConnector.addEventListener(TConnectorEvent.MESSAGE_RECEIVED,sendMessageToParser);
			
		}
		
		
		public function reConnect(e:KeyboardEvent):void
		{
			if (e.altKey && e.ctrlKey && e.keyCode == Keyboard.C) {
				tConnector = new TConnector();
				tConnector.connect(host,port);

				tConnector.addEventListener(TConnectorEvent.CONNECTED,handleConnected);
				tConnector.addEventListener(TConnectorEvent.DISCONNECTED,handleDisconnected);
				tConnector.addEventListener(TConnectorEvent.CONNECTION_ERROR,handleError);
				tConnector.addEventListener(TConnectorEvent.MESSAGE_RECEIVED,sendMessageToParser);
			}
		}
		
		
		
		private function handleConnected(e:TConnectorEvent){
			trace("Connected");
		}
		
		private function handleDisconnected(e:TConnectorEvent){
			//trace("Disconnected");
		}
		
		private function handleError(e:TConnectorEvent){
			//trace("Connection Error");
		}
		
		
		
		private function sendMessageToParser(e:TConnectorEvent){
			
			//Debug
			//trace("incoming :\n", e.message);
			
			tParser.parseXMLData(e.message);
			
		}
		
		
		private function addObject(e:TParserEvent){
			trace("new Object, objectTmpID="+e.objectTmpID)
			
			/*objectList[e.objectTmpID] = {index:e.objectTmpID, relatedTObject:new TImageObject()};
			objectList[e.objectTmpID].relatedTObject.tmpID = e.objectTmpID;
			container.addChild(objectList[e.objectTmpID].relatedTObject);*/
		}
		
		private function addCursor(e:TParserEvent){
			//trace("new Cursor, cursorID="+e.cursorID)
			//trace("addCursor : ", e.cursorID);
			cursorList[e.cursorID] = {index:e.cursorID,relatedTCursor:new TCursor(e.cursorID)};
			container.addChild(cursorList[e.cursorID].relatedTCursor);
			
		}
		
		private function removeObject(e:TParserEvent){
			//objectList[e.objectTmpID].relatedTObject.deactivate();
			trace("TManager, remove Object tmpID:"+e.objectTmpID);
		}
		
		private function removeCursor(e:TParserEvent){
			
			cursorList[e.cursorID].relatedTCursor.deactivate();			
		}
		
		private function updateObject(e:TParserEvent){
			
			//objectList[e.objectTmpID].relatedTObject.update(e.objectID,((e.newX * factorX + 1) % 1) * screenW,((e.newY * factorY + 1) % 1) * screenH,e.newRotation * factorRot);
			
		}
		
		private function updateCursor(e:TParserEvent){
			
			//trace("update Cursor : " + e.cursorID, e.newX, "->", ((e.newX * factorX + 1) % 1) * screenW, ",", e.newY, "->", e.newY * screenH);
			
			if(cursorList[e.cursorID] != undefined){
				cursorList[e.cursorID].relatedTCursor.update(((e.newX * factorX + 1) % 1) * screenW, ((e.newY * factorY + 1) % 1) * screenH);
			}
			
			
		}
		
		
		//MANAGEMENT OF TOUCH OBJECTS
		
		public function registerObject(object:ITObject, priority:int = 0):int
		{
			if(objectList.indexOf(object) == -1){
				objectList.splice(priority,0, object);
				//trace("register : ", objectList.length, "items");
				
			}else {
				//trace("register : object already exists");
				setPriority(object, priority);
			}
			
			return objectList.length;
		}
		
		public function unregisterObject(object:ITObject):Boolean {
			if (objectList.indexOf(object) == -1) {
				//trace("unregister : object isn't registered");
				return false;
			}
			
			objectList.splice(objectList.indexOf(object), 1);
			//trace("unregister : ", objectList.length, "items");
			return true;
		}
		
		public function setPriority(object:ITObject, priority:int):Boolean
		{
			
			if (priority > objectList.indexOf(object)) {
				priority -= 1;
			}
			
			if (unregisterObject(object)) {
				registerObject(object,priority);
				return true;
			}
			
			return false;
		}
		
		public function getPriority(object:ITObject):int
		{
			return objectList.indexOf(object);
		}
		
		
		
		// FUNCTIONS RELATED TO CONTROL PANEL BUTTONS
		
		//Table Related -- Invert Coords
		/*private function invertCoords(e:MouseEvent){
			
			trace("invertCoords");
			
			
			switch(e.target.name){
				case "invertX":
					factorX =  - factorX;
				break;
				
				case "invertY":
					factorY =  -factorY;
				break;
				
				case "invertRot":
					factorRot =  -factorRot;
				break;
			}
			
			
			
		}*/
		
		//Screen Related -- Hide/Show Control Panel
		
		//private function toggleControlView(e:MouseEvent){
			//controlPanel.visible = !controlPanel.visible;
			//toggleControlViewBT.scaleX = -toggleControlViewBT.scaleX;
		//}
		
		
		/*private function switchScreen(e:MouseEvent){
			if(stage.nativeWindow.x == 0){
				stage.nativeWindow.x = Screen.mainScreen.bounds.width
				stage.nativeWindow.width = Screen.screens[1].bounds.width;
				stage.nativeWindow.height = Screen.screens[1].bounds.height;
			}else{
				stage.nativeWindow.x = 0;
				stage.nativeWindow.width = Screen.screens[0].bounds.width;
				stage.nativeWindow.height = Screen.screens[0].bounds.height;
			}
			
			screenW = stage.stageWidth;
			screenH = stage.stageHeight;
			
			trace(Screen.screens[1].bounds+"/"+stage.stageWidth);
		}*/
		
		
	}
}