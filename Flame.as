package
{
	import flash.display.*;
	import flash.events.*;
	
	public class Flame extends Sprite
	{
		[Embed(source="images/flame.png")]
		public static var FlameGfx:Class;
		
		public var level: Level;
		
		public function Flame (_x: Number, _y: Number, _level: Level)
		{
			x = _x;
			y = _y;
			
			y += 5;
			
			level = _level;
			
			var img: DisplayObject = new FlameGfx();
			
			img.scaleX = 0.25;
			img.scaleY = 0.25;
			
			img.x = -img.width * 0.5;
			img.y = -img.height;
			
			addChild(img);
			
			buttonMode = true;
			mouseChildren = false;
			
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		public function update (): void
		{
			if (Math.random() < 0.5) { return; }
			
			scaleX = Math.random() * 0.5 + 1;
			scaleY = Math.random() * 0.5 + 1;
		}
		
		private function onMouseDown(e:MouseEvent):void {
			level.remove(this);
		}
	}
}
