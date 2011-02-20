package
{
	import flash.display.*;
	import flash.utils.*;
	
	[Embed(source="images/smoke.png")]
	public class Smoke extends Bitmap
	{
		private var vx : Number;
		private var vy : Number;
		
		public function Smoke (_x : Number, _y : Number)
		{
			super();
			
			scaleX = 0.4 + Math.random() * 0.3;
			scaleY = 0.4 + Math.random() * 0.3;
			
			x = _x + Math.random() * 4 - 2 - width * 0.5;
			y = _y + Math.random() * 4 - 2 - height * 0.5;
			
			alpha = Math.random() * 0.4 + 0.6;
			
			vx = Math.random() * 0.3 - 0.15;
			vy = -Math.random() * 0.3 - 0.15;
		}

		public function update () : void
		{
			vx += Math.random() * 0.1 - 0.05;
			//vy += Math.random() * 0.3 - 0.15;
			
			x += vx;
			y += vy;
			
			alpha -= Math.random() * 0.01;
		}
		
		public function dead () : Boolean
		{
			return alpha <= 0;
		}
	}
}

