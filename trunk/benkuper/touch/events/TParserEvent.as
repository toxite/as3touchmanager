package benkuper.touch.events {
	

	import flash.events.Event;

	/**
	
	* This custom Event class adds a message property to a basic Event.
	
	*/

	public class TParserEvent extends Event {


		public static const NEW_OBJECT:String = "newObject";
		public static const NEW_CURSOR:String = "newCursor";
		public static const REMOVE_OBJECT:String = "removeObject";
		public static const REMOVE_CURSOR:String = "removeCursor";
		public static const UPDATE_OBJECT:String = "updateObject";
		public static const UPDATE_CURSOR:String = "updateCursor";

		private var oID:int;
		private var oTmpID:int;
		private var cID:int;
		
		private var nx:Number;
		private var ny:Number;
		private var nRot:Number;
		private var nsX:Number;
		private var nsY:Number;
		private var nA:Number;
		private var nRotA:Number;

		/**
		
		* Constructor.
		
		* @param message XML received from reactIvision or simulator
		
		*/

		public function TParserEvent(type:String, dataArray:Array = null,bubbles:Boolean = false, cancelable:Boolean = false) {

			super(type, bubbles, cancelable);

			switch(type){
				case "newObject":
					oTmpID = dataArray[0];
				break;
				
				case "newCursor":
					cID = dataArray[0];
				break;
				
				case "removeObject":
					oTmpID = dataArray[0];
				break;
				
				case "removeCursor":
					cID = dataArray[0];
				break;
				
				case  "updateObject":
					oTmpID = dataArray[0];
					oID = dataArray[1];
					nx = dataArray[2];
					ny = dataArray[3];
					nRot = dataArray[4];
					nsX = dataArray[5];
					nsY = dataArray[6];
					nRotA = dataArray[7];
					nA = dataArray[8];
				break;
				
				case "updateCursor":
					cID = dataArray[0];
					nx = dataArray[1];
					ny = dataArray[2];
					nsX = dataArray[3];
					nsY = dataArray[4];
					nA = dataArray[5];
				break;
			}

		}
		
		/**
		
		* Get object ID (real ID, i.e. 24 for fluidicial n°24);
		
		*@return objectID Object ID (real ID, i.e. 24 for fluidicial n°24);
		
		*/
		
		public function get objectID():int{
			
			return oID;
			
		}
		
		public function get objectTmpID():int{
			
			return oTmpID;
			
		}
		
		public function get cursorID():int{
			
			return cID;
			
		}
		
		
		
		public function get newX():Number{
			
			return nx;
			
		}
		
		public function get newY():Number{
			
			return ny;
			
		}
		
		public function get newRotation():Number{
			
			return nRot;
			
		}
		
		public function get newSpeedX():Number{
			
			return nsX;
			
		}
		
		public function get newSpeedY():Number{
			
			return nsY;
			
		}
		
		public function get newAcceleration():Number{
			
			return nA;
			
		}
		
		public function get newRotationAcceleration():Number{
			
			return nRotA;
			
		}
		
		

		/**
		
		* Creates and returns a copy of the current instance.
		
		* @return A copy of the current instance.
		
		*/

		public override function clone():Event {


			trace("cloning " + type);

			return new TParserEvent(type);

		}

		/**
		
		* Returns a String containing all the properties of the current
		
		* instance.
		
		* @return A string representation of the current instance.
		
		*/

		public override function toString():String {

			return formatToString("ParserEvent","type","bubbles","cancelable","eventPhase");

		}

	}

}