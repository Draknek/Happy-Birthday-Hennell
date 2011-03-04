package
{
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;
	import flash.geom.*;
	
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
		
		public static var startTime: int;
		
		public var countDown:MyTextField;
		
		
		public var stars: Vector.<Star> = new Vector.<Star>();
		public var buffer:BitmapData;
		
		public function Level (_n: int)
		{
			var window:Shape = new Shape;
			
			window.graphics.lineStyle(3, 0xFFFFFF);
			window.graphics.beginFill(0x0);
			window.graphics.drawRoundRect(-200, 0, 400, 250, 20);
			window.graphics.endFill();
			
			window.x = 320;
			window.y = 60;
			
			addChild(window);
			
			buffer = new BitmapData(400, 250, true);
			
			var b:Bitmap = new Bitmap(buffer);
			b.x = 320 - 200;
			b.y = 60;
			addChild(b);
			
			n = _n;
			
			if (n == 1) {
				AudioControl.play();
				
				startTime = getTimer();
				
				addChild(new MyTextField(320, 75, "Click candles to age", 0xFFFFFF, "center", 25));
			} else if (n == 2) {
				addChild(new MyTextField(320, 75, "Oldest person wins!", 0xFFFFFF, "center", 25));
			}
			
			countDown = new MyTextField(320, 10, "00:00", 0xFFFFFF, "center", 40);
			
			updateTime();
			
			addChild(countDown);
			
			if (Kongregate.api) {
				Kongregate.api.stats.submit("Level", n);
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
			
			for (i = 0; i < 150; i++) {
				var s: Star = new Star();
				
				s.vx = Math.random() * 3 + n;
				s.size = int(s.vx-n) + 1;
				s.vx *= 1.5;
				s.vx += 1.0;
				
				s.x = Math.random() * (640 - s.size);
				s.y = Math.random() * (480 - s.size);
				
				stars.push(s);
			}
			
		}
		
		public function remove (f: Flame): void {
			if (Kongregate.api) {
				Kongregate.api.stats.submit("Candles", 1);
			}
			
			var timer: Timer;
			
			/*if (n == 23) {
				f.alpha = 0;
				
				timer = new Timer(Math.random() * 4000 + 1000, 1);
				timer.addEventListener(TimerEvent.TIMER, function (param: *): void {f.alpha = 1});
				timer.start();
				
				return;
			}*/
			
			removeChild(f);
			flameCount--;
			
			if (flameCount == 0) {
				timer = new Timer(500, 1);
				timer.addEventListener(TimerEvent.TIMER, function (param: *): void {Main.screen = new Level(n+1);});
				timer.start();
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
			
			updateTime();
			
			//if (Math.random() < 0.15) {
			if (frame % 10 == 0) {
				bg();
			}
			
			for each (var f: Flame in flames) {
				f.update();
			}
			
			particles = particles.filter(removeParticlesFilter);
			
			var rect:Rectangle = buffer.rect;
			buffer.fillRect(rect, 0x0);
			
			for each (var s: Star in stars) {
				rect.x = s.x;
				rect.y = s.y;
				rect.width = s.size;
				rect.height = s.size;
				
				buffer.fillRect(rect, 0xFFEEEEEE);
								
				s.x -= s.vx;
				
				if (s.x < s.size) {
					s.x = buffer.width - s.vx*Math.random();
					s.y = Math.random() * (buffer.height - s.size);
				}
			}
			
		}
		
		public function updateTime ():void
		{
			var t:int = getTimer() - startTime;
			
			t = 120 - t / 1000;
			
			var s:int = t % 60
			
			countDown.text = "0" + int(t / 60) + ":" + ((s < 10) ? "0" : "") + s;
			
			if (t <= 0) {
				Launchpad.score = n;
				Main.screen = new Launchpad("scores");
			}
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
