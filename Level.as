package
{
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;
	
	public class Level extends Screen
	{
		[Embed(source="images/cake.png")]
		public static var CakeGfx:Class;
		
		private const w: Number = 280;
		private const h: Number = 180;
		
		public var candles: Array = [];
		public var flames: Array = [];
		public var particles: Array = [];
		
		public var flameCount: int = 0;
		
		public var n: int;
		
		public function Level (_n: int)
		{
			n = _n;
			
			if (n == 1) {
				AudioControl.play();
				
				addChild(new MyTextField(320, 25, "Click to blow out candles", 0xFFFFFF, "center", 25));
			} else if (n == 23) {
				addChild(new MyTextField(320, 20, "Happy Birthday\nHennell", 0xFFFFFF, "center", 60));
			} else {
				addChild(new MyTextField(320, 25, "Level " + n, 0xFFFFFF, "center", 45));
			}
			
			var cake: DisplayObject = new CakeGfx();
			
			cake.x = 320 - cake.width * 0.5;
			cake.y = 240 - h * 0.5;
			
			addChild(cake);
			
			for (var i: int = 0; i < n; i++) {
				var theta: Number = Math.random() * Math.PI * 2;
				var r: Number = Math.sqrt(Math.random());
				
				var _x: Number = 320 + Math.cos(theta) * r * w * 0.5;
				var _y: Number = 240 + Math.sin(theta) * r * h * 0.5;
				
				var candle: Candle = new Candle(_x, _y);
				
				candles.push(candle);
			}
			
			candles.sort(sortOnY);
			
			for each (var c: Candle in candles) {
				addChild(c);
				
				var flame: Flame = new Flame(c.x, c.y, this);
				
				flames.push(flame);
				
				flameCount++;
				
				addChild(flame);
			}
		}
		
		public function remove (f: Flame): void {
			if (n == 23) {
				f.alpha = 0;
				
				var timer: Timer = new Timer(Math.random() * 4000 + 1000, 1);
				timer.addEventListener(TimerEvent.TIMER, function (param: *): void {f.alpha = 1});
				timer.start();
				
				return;
			}
			
			removeChild(f);
			flameCount--;
			
			if (flameCount == 0) {
				Main.screen = new Level(n+1);
			}
			
			for (var i: int = 0; i < 4; i++) {
				var p: Smoke = new Smoke(f.x, f.y);
				
				particles.push(p);
				
				addChild(p);
			}
		}
		
		private static function sortOnY (a:DisplayObject, b:DisplayObject):Number {
		   if(a.y > b.y) {
		        return 1;
		    } else if(a.y < b.y) {
		        return -1;
		    } else  {
		        return 0;
		    }
		}
		
		public override function init (): void
		{
			
		}
		
		private var frame: int = 0;
		
		public override function update (): void
		{
			frame++;
			
			//if (Math.random() < 0.15) {
			if (frame % 10 == 0) {
				bg();
			}
			
			for each (var f: Flame in flames) {
				f.update();
			}
			
			particles = particles.filter(removeParticlesFilter);
		}
		
		
		private function removeParticlesFilter (p: Smoke, index: int, arr: Array): Boolean
		{
			p.update();
			
			if (p.dead())
			{
				// Remove from display list
				removeChild(p);
				
				// And remove from array
				return false;
			}
			else
			{
				// p remains in array
				return true;
			}
		}
	}
}
