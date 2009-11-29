package benkuper.touch.core{
	
	
	import flash.xml.XMLNode;
	
	
	import flash.events.EventDispatcher;
	
	import benkuper.touch.events.TParserEvent;
	
	
	
	public class TParser extends EventDispatcher{
		
		
		private var tmpID:int;
		
		
		public function TParser(){
			
			trace("TParser created");
			
			
		}
		
		
		public function parseXMLData(xml:XML):void{
			
			
			var curMessageNode:XML;
			
			for(var i:String in xml.children()){
				
				//trace("index="+i+"/"+xml.children()[i]);
				
				curMessageNode = xml.children()[i];
				
				

				if(curMessageNode.children()[0].attribute("value") == "set"){
							
					
					parseSetMsg(curMessageNode);
				
					
				}else if(curMessageNode.children()[0].attribute("value") == "alive"){
					
					
					parseAliveMsg(curMessageNode);
					
					
				}
					
			}
		}
		
		
		
		
		private function parseSetMsg(messageNode:XML):void{
			
			var attributesNumber:int;
			
			var objType:String = messageNode.attribute("name");
			
			
			
			if(objType == "/tuio/2dobj"){
				//attributesArray = new Array("sID","id","nx","ny","nRot","nX","nY","nA","nRotA");
				attributesNumber = 9;
			}else if(objType == "/tuio/2dcur"){
				//attributesArray = new Array("sID","nx","ny","nX","nY","nA");
				attributesNumber = 6;
			}

			
			var attributes:Array = new Array();
			
			for(var a:int = 1;a <= attributesNumber;a++){
				
				attributes.push(messageNode.children()[a].attribute("value"));
										
			}
			

			//var speed = Math.sqrt(Math.pow(attributes[5],2)+Math.pow(attributes.nY,2));
			
			
			/*
			attributes[0] = ((attributes[0] - .5) * factors[0] +  .5) * screenW;
			
			attributes[1] = ((attributes[1] - .5) * factors[1] +  .5) * screenH;
			*/
			

			//Debug coordinates
			//container.incomingOutput.text = "ty:"+attributes.ny+"\ncH:"+container.height+"\nscreenH:"+screenH;
			
			var evt:TParserEvent;
			
			if(objType == "/tuio/2dobj"){
				//objectList[attributes.sID].relatedTObject.update(attributes.id,attributes.nx,attributes.ny,attributes.nRot*factors[2]);
				evt = new TParserEvent("updateObject",attributes);
			}else if(objType == "/tuio/2dcur"){
				//cursorList[attributes.sID].relatedTCursor.update(attributes.nx,attributes.ny);
				evt = new TParserEvent("updateCursor",attributes);
			}
			
			dispatchEvent(evt);
					
		}
		
		
		
		private function parseAliveMsg(messageNode:XML):void{
			
			//trace("\n**************************"+messageNode);
			
			//message type, see XML construction of TUIO Message
			var objType:String = messageNode.attribute("name");


			//curList is the list of current elements which will be checked for checking difference between
			//what was alive and what's not anymore
			var curList:Array;
			
			
			//reference to object or cursor depending on message type
			if(objType == "/tuio/2dobj"){
				curList = TManager.objectList;
			}else if(objType == "/tuio/2dcur"){
				curList = TManager.cursorList;
			}
			
			
			//TParserEvent to dispatch later
			var evt:TParserEvent;
			
						
						
			//Number of objects/cursor that are in the message
			var childrenLength:int = messageNode.children().length();
			
			
			//Boolean to check existence of elements in the current list
			var indexExists:Boolean;
			
			
			//---- Remove Checking Phase
			//Check for elements that were in the currentList and that are not in the new message
			
			for(var o:String in curList){
				
				tmpID = curList[o].index;
				
				
				
				indexExists = false;
				
				for (var a:int=1;a < childrenLength;a++){
					if(messageNode.children()[a].attribute("value") == tmpID){
						indexExists = true;
						
						break;
					}
				}
				
				//trace("removePhase, index "+tmpID+" exists:"+indexExists);
				
				
				//If elements doesn't exists anymore, dispatch appriopriate removeEvent according to objType
				if(!indexExists){
					
					if(objType == "/tuio/2dobj"){
						
						//objectList[o].relatedTObject.deactivate(o);
						
						evt = new TParserEvent("removeObject",[tmpID]);
						
					}else if(objType == "/tuio/2dcur"){
						
						//cursorList[o].relatedTCursor.deactivate(o);
						
						evt = new TParserEvent("removeCursor",[tmpID]);
						
					}
					
					dispatchEvent(evt);
					
				}
				
			}
			
			
			
				
			
			//------      Add Check Phase
			//Check existence in the current array for all elements of the message
			
			for(var c:int=1;c < childrenLength;c++){
				
				//get tmpID, corresponds to a id chosen by reacTivistion or simulator to make the object/cursor unique
				tmpID = messageNode.children()[c].attribute("value");
				
				//check existence of this tmpID in the current objectList
				indexExists = curList.some(checkIndexExistence);
				
				//trace("addPhase, index "+tmpID+" exists:"+indexExists);
				
				
				//If element doesn't exist in the current list, i.e. it just been dropped on the table
				
				if(!indexExists){
					
					//Check for type and dispatch appropriate event according to objType
					
					if(objType == "/tuio/2dobj"){
						
						/*objectList[sid] = {index:sid, relatedTObject:new TImageObject()};
						container.addChild(objectList[sid].relatedTObject);*/
						
						evt = new TParserEvent("newObject",[tmpID]);
						
					}else if(objType == "/tuio/2dcur"){
						
						/*cursorList[sid] = {index:sid,relatedTCursor:new TCursor()};
						container.addChild(cursorList[sid].relatedTCursor);*/
						
						evt = new TParserEvent("newCursor",[tmpID]);
						
					}
					
					dispatchEvent(evt);
					
				}
				
			}
						
		}
		
		
		private function checkIndexExistence(element:Object,index:int,array:Array):Boolean{
			if(element == null){
				return(false);
			}
			return(element.index == tmpID);
		}
		
		
	}
	
}