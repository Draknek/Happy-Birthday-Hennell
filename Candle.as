package
{
	import flash.display.*;
	import flash.events.*;
	
	public class Candle extends Sprite
	{
		[Embed(source="images/candle.png")]
		public static var CandleGfx:Class;
		
		[Embed(source="images/target.png")]
		public static var TargetGfx:Class;
		
		public var target:Bitmap;
		public var flame:Flame;
		
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
			
			target = new TargetGfx;
			
			target.visible = false;
			
			target.x = Math.floor(-target.width*0.5);
			target.y = Math.floor(-target.height*0.5);
			
			addChild(target);
		}
		
		public function update (): void
		{
			//var dzSq:Number = mouseX*mouseX + mouseY*mouseY;
			
			target.visible = false;//(dzSq < 25);
		}
	}
}
