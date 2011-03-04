package
{
	import flash.display.*;
	import flash.events.*;
	import flash.ui.*;
	import flash.utils.getTimer;
	import flash.utils.getDefinitionByName;
	import flash.net.*;
	
	[SWF (width=640, height=480, frameRate=50)]
	public class Main extends Sprite
	{
		private var time: int;
		
		public static var instance: Main;
		
		public static var screenObj: Screen;
		
		public static var level: *;
		
		public static var url:String = "http://www.draknek.org/games/birthday2/update.php";
		
		public static function message (params:String, callback:Function, errorCallback:Function = null):void {
			var request:URLRequest = new URLRequest(url + "?" + params);

			trace("Sent: " + params);

			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, doComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, doError);
			
			loader.load(request);
			
			function doComplete ():void
			{
				var response:String = loader.data;
				
				trace("Received: " + response);
				
				callback(response);
			}
			
			function doError ():void
			{
				if (errorCallback != null) {
					var response:String = loader.data;
				
					trace("Received: " + response);
				
					errorCallback(response);
				}
			}
		}
		
		public static function set screen (newScreenObj: Screen): void
		{
			if (screenObj)
			{
				instance.removeChild(screenObj)
			}
			
			screenObj = newScreenObj;
			
			instance.addChild(screenObj);
			
			instance.stage.focus = instance.stage;
		}
		
		public static function get screen (): Screen
		{
			return screenObj;
		}
		
		public function Main ()
		{
			graphics.beginFill(0x000000);
			graphics.drawRect(0, 0, 640, 480);
			graphics.endFill();
			
			instance = this;
			
			Input.attach(stage);
			
			//Kongregate.connect(this);
			
			Preloader.init(startup);
			
			time = getTimer();
			
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void
		{
			var dt:int = getTimer() - time;
			
			while (dt >= 20) {
				time += 20;
				dt -= 20;
				
				if (screen) {
					screen.update();
				}
			}
		}
		
		private function startup (): void
		{
			var mainClass:Class = getDefinitionByName("MainMenu") as Class;
			
			screen = new mainClass() as Screen;
		}
	}
}
