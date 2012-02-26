
package
{
	import flash.display.*;
	import flash.events.MouseEvent;

	public class Preloader extends Screen
	{
		public static function init (startup: Function): void
		{
			var preloader: Preloader = new Preloader(startup);
			
			Main.screen = preloader;
			
			//preloader.stage.addEventListener(MouseEvent.MOUSE_DOWN, preloader.onMouseDown);
		}
		
		private var startup: Function;
		private var progressBar: Shape;
		private var text: MyTextField;
		
		public function Preloader (_startup: Function)
		{
			startup = _startup;
			
			graphics.beginFill(0x000000);
			graphics.drawRect(0, 0, 640, 480);
			graphics.endFill();
			
			graphics.beginFill(0xFFFFFF);
			graphics.drawRect(68, 228, 504, 24);
			graphics.endFill();
			
			progressBar = new Shape();
			
			addChild(progressBar);
			
			text = new MyTextField(320, 260, "0%", 0xFFFFFF);
			
			addChild(text);
		}

		public override function update (): void
		{
			if (hasLoaded())
			{
				graphics.clear();
				
				text.scaleX = 2.5;
				text.scaleY = 2.5;
				
				text.text = "100%";//"Make click for play"
				
				//text.y = 240 - text.height * 0.5;
				//text.x = 320 - text.width * 0.5;
				
				startup();
			} else {
				var p:Number = (this.loaderInfo.bytesLoaded / this.loaderInfo.bytesTotal);
				
				progressBar.graphics.beginFill(0x000000);
				progressBar.graphics.drawRect(70, 230, p * 500, 20);
				progressBar.graphics.endFill();
				
				text.text = int(p * 100) + "%";
			}
		}
		
		private function onMouseDown(e:MouseEvent):void {
			if (hasLoaded())
			{
				stage.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
				startup();
			}
		}
		
		private function hasLoaded (): Boolean {
			return (loaderInfo.bytesLoaded >= loaderInfo.bytesTotal);
		}
	}
}


