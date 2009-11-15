package benkuper.touch.core{
	
	import benkuper.touch.objects.ITObject;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
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
		
		
		
		
		private var screenW:int;
		private var screenH:int;
		
		
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
			
			
			//TCursor.mode = "keyboard";
			
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
			
			screenW = stage.stageWidth;
			screenH = stage.stageHeight;
		}
		
		
		
		
		public function connect(host:String = "127.0.0.1",port:int = 3000){
			
			tConnector = new TConnector();
			tConnector.connect(host,port);
			
			tConnector.addEventListener(TConnectorEvent.CONNECTED,handleConnected);
			tConnector.addEventListener(TConnectorEvent.DISCONNECTED,handleDisconnected);
			tConnector.addEventListener(TConnectorEvent.CONNECTION_ERROR,handleError);
			tConnector.addEventListener(TConnectorEvent.MESSAGE_RECEIVED,sendMessageToParser);
			
		}
		
		
		
		
		private function handleConnected(e:TConnectorEvent){
			//controlPanel.statusOutput.text = "Connected";
		}
		
		private function handleDisconnected(e:TConnectorEvent){
			//controlPanel.statusOutput.text = "Disconnected";
		}
		
		private function handleError(e:TConnectorEvent){
			//controlPanel.statusOutput.text = "Connection Error";
		}
		
		
		
		private function sendMessageToParser(e:TConnectorEvent){
			
			//Debug
			//incomingOutput.text = e.message;
			
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
			
			cursorList[e.cursorID].relatedTCursor.update(((e.newX * factorX + 1) % 1) * screenW,((e.newY * factorY + 1) % 1) * screenH);
			
			
		}
		
		
		//MANAGEMENT OF TOUCH OBJECTS
		
		public function registerObject(object:ITObject):int {
			
			objectList.unshift(object);
			
			return objectList.length;
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