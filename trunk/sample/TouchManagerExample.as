package  
{
	import benkuper.touch.core.TManager;
	import benkuper.touch.events.TouchEvent;
	import benkuper.touch.objects.TSprite;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author Ben Kuper
	 */
	public class TouchManagerExample extends MovieClip
	{
		
		public var tManager:TManager;

		public static var instance:TouchManagerExample;
		
		public function TouchManagerExample() 
		{
			
			instance = this;
			
			var sampleSprite:TSprite = new TSprite();
			
			var loader:Loader = new Loader();
			loader.load(new URLRequest("sample.jpg"));
			sampleSprite.addChild(loader);
			addChild(sampleSprite);
			
			sampleSprite.x = 20;
			sampleSprite.y = 20;
			
			
			sampleSprite.movable = true;
			sampleSprite.scalable = true;
			sampleSprite.rotatable = true;
			
			tManager = new TManager();
			tManager.connect();
			addChild(tManager);
			
			sampleSprite.addEventListener(TouchEvent.TAP, traceTest);
			sampleSprite.addEventListener(TouchEvent.DOUBLE_TAP, traceTest);
			
			tManager.registerObject(sampleSprite);
		}
		
		private function traceTest(e:TouchEvent):void 
		{
			trace(e.type);
		}
		
	}

}