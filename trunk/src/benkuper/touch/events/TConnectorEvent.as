package benkuper.touch.events {
	
	import flash.events.MouseEvent;


	/**
	
	* This custom Event class adds a message property to a basic Event.
	
	*/
	
	import flash.events.Event;

	public class TConnectorEvent extends Event {


		public static const CONNECTED:String = "connected";
		public static const DISCONNECTED:String = "disconnected";
		public static const MESSAGE_RECEIVED:String = "messageReceived";
		public static const CONNECTION_ERROR:String = "connectionError";

		private var mess:XML;

		/**
		
		* Constructor.
		
		* @param message XML received from reactIvision or simulator
		
		*/

		public function TConnectorEvent(type:String, message:XML = null,bubbles:Boolean = false, cancelable:Boolean = false) {
			
			super(type, bubbles, cancelable);
			
			if(type == "messageReceived"){
				mess = message;
			}
			
		}
		
		/**
		
		* Get message received from reactIvision or simulator in XML Format
		
		*@return message received from reactIvision or simulator in XML format
		
		*/
		
		public function get message():XML{
			
			return mess;
			
		}

		/**
		
		* Creates and returns a copy of the current instance.
		
		* @return A copy of the current instance.
		
		*/

		public override function clone():Event {


			trace("cloning " + type);

			return new TConnectorEvent(type);

		}

		/**
		
		* Returns a String containing all the properties of the current
		
		* instance.
		
		* @return A string representation of the current instance.
		
		*/

		public override function toString():String {

			return formatToString("ConnectorEvent","type","bubbles","cancelable","eventPhase");

		}

	}

}