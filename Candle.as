package
{
	import flash.display.*;
	import flash.events.*;
	
	public class Candle extends Sprite
	{
		[Embed(source="images/candle.png")]
		public static var CandleGfx:Class;
		
		public function Candle (_x: Number, _y: Number)
		{
			x = _x;
			y = _y;
			
			var img: DisplayObject = new CandleGfx();
			
			img.scaleX = 0.25;
			img.scaleY = 0.25;
			
			img.x = -img.width * 0.5;
			img.y = 0;
			
			y -= img.height;
			
			addChild(img);
		}
		
		public function update (): void
		{
			
		}
	}
}
