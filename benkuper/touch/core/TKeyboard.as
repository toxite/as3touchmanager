package benkuper.touch.core 
{
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author ...
	 */
	public class TKeyboard extends MovieClip
	{
		
		
		private static var lettersStrings:Array = new Array("a", "b", "c", "d", "e", "f", "g", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z");
		public static var lettersArray:Array;
		
		
		private static var _activeKeyboard:TKeyboard;
		
		public function TKeyboard() 
		{	
			
			_activeKeyboard = this;
			
			lettersArray = new Array();
			trace("TKeyboard creation");
			
			for (var i:int = 0; i < lettersStrings.length; i++) {
				
				var curLetter:KLetter = new KLetter();
				curLetter.x = (curLetter.width + 10) *(i% 10) ;
				curLetter.y = Math.floor(i / 10) * curLetter.height + 10;
				curLetter.letter.text = lettersStrings[i];
				
				trace(curLetter);
				addChild(curLetter);
				
				lettersArray.push(curLetter);
				
			}
			
			
			
			
		}
		
		public function highlightLetter(letterID:int):void {
			
			lettersArray[letterID].fond.gotoAndStop(2)
		}
		
		
		
		static public function get activeKeyboard():TKeyboard { return _activeKeyboard; }
		
		
		
		
	}
	
}