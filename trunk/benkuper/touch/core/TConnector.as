package benkuper.touch.core{
	
	import flash.net.XMLSocket;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	
	import benkuper.touch.events.TConnectorEvent;
	import flash.events.EventDispatcher;
	
	public class TConnector extends EventDispatcher{
		
		
		private var socket:XMLSocket;
		
		
	
		public function TConnector(){
			
			trace("TConnector created");
		}
		
		
		public function connect(ip:String,port:int) {
			
			socket = new XMLSocket();
			socket.addEventListener(Event.CONNECT,handleConnect);
			socket.addEventListener(Event.CLOSE,handleClose);
			socket.addEventListener(DataEvent.DATA,handleIncoming);
			socket.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
			
			
			socket.connect(ip,port);
		}


		//Disconnect from the server
		public function disconnect () {
			
			/*for (var i:String in objectList) {
				container.removeChild(objectList[i].relatedTObject);
			}*/
			
			socket.close();
			
			var evt:TConnectorEvent = new TConnectorEvent("disconnected");
			dispatchEvent(evt);
			
		}
		
		
		
		
		
		//XMLSocket Handlers
		private function handleConnect(e:Event){
			var evt:TConnectorEvent = new TConnectorEvent("connected");
			dispatchEvent(evt);
		}
		
		
		
		private function ioErrorHandler(e:IOErrorEvent):void {
        	trace("ioErrorHandler: " + e);
			
			var evt:TConnectorEvent = new TConnectorEvent("connectionError");
			dispatchEvent(evt);
			
			// container.statusOutput.text = "Error Connecting; make sur server is launched (run.bat)\n"+container.statusOutput.text;
        }

		private function handleClose(e:Event){
			disconnect();
		}

		private function handleIncoming(de:DataEvent){
		
			
			// parse out the packet information
			var xmlInfo:XML = new XML(de.data.split("\n").join("").toLowerCase());
			
			//trace(xmlInfo);
			
			
			if (xmlInfo!= null && xmlInfo.name() == "oscpacket") {

				var evt:TConnectorEvent = new TConnectorEvent("messageReceived",xmlInfo);
				dispatchEvent(evt);
				
			}

		}
		
		// ********         XML Parsing and Creating TUIO Objects       *********************
		
		
		
	

		
	}
	
}