package
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
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
		
		public static var startTime: int;
		
		public var points:Array = [];
		
		public var line:Sprite;
		
		public var listening:Boolean = false;
		
		public function Level (_n: int)
		{
			n = _n;
			
			if (n == 1) {
				AudioControl.play();
				
				startTime = getTimer();
				
				addChild(new MyTextField(320, 25, "Blow out candles with\nfive continuous breaths", 0xFFFFFF, "center", 25));
			} else if (n == 23) {
				addChild(new MyTextField(320, 20, "Happy Birthday\nHennell", 0xFFFFFF, "center", 60));
				
				if (Kongregate.api) {
					Kongregate.api.stats.submit("Time", getTimer() - startTime);
				}
			} else {
				addChild(new MyTextField(320, 25, "Level " + n, 0xFFFFFF, "center", 45));
			}
			
			if (Kongregate.api) {
				Kongregate.api.stats.submit("Level", n);
			}
			
			var cake: DisplayObject = new CakeGfx();
			
			cake.x = 320 - cake.width * 0.5;
			cake.y = 240 - h * 0.5;
			
			addChild(cake);
			
			for (var i: int = 0; i < 25; i++) {
				var ix:int = int(i / 5) - 2;
				var iy:int = int(i % 5) - 2;
				
				var _x: Number = 320 + ix * w * 0.15 + iy*10;
				var _y: Number = 240 + iy * h * 0.15 - ix*4;
				
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
			
			line = new Sprite;
			
			addChild(line);
			
			Main.instance.stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			Main.instance.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			Main.instance.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		
		public function remove (f: Flame): void {
			if (Kongregate.api) {
				Kongregate.api.stats.submit("Candles", 1);
			}
			
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
			
			//if (Math.random() < 0.15) {
			if (frame % 10 == 0) {
				//bg();
			}
			
			for each (var f: Flame in flames) {
				f.update();
			}
			
			for each (var c: Candle in candles) {
				c.update();
			}
			
			particles = particles.filter(removeParticlesFilter);
			
			line.graphics.clear();
			
			if (points[0]) {
				line.graphics.lineStyle(2, 0x000000);
			
				var last:Point;
				var next:Point;
				
				last = points[0];
				line.graphics.moveTo(last.x, last.y);
				
				for (var i:int = 1; i < points.length; i++) {
					next = points[i];
					
					//line.graphics.lineTo(points[i].x, points[i].y);
					
					test(last.x, last.y, next.x, next.y);
					
					last = next;
				}
				
				if (points.length < 6) {
					test(last.x, last.y, mouseX, mouseY);
					//line.graphics.lineTo(mouseX, mouseY);
				}
			}
		}
		
		public function test (x1:Number, y1:Number, x2:Number, y2:Number):void
		{
			for each (var c:Candle in candles) {
				var distSq:Number = SqDistPointSegment(x1, y1, x2, y2, c.x, c.y);
				
				if (distSq < 25) {
					c.target.visible = true;
				}
			}
			
			// Draw
			
			var dx:Number = x2 - x1;
			var dy:Number = y2 - y1;

			var distance : Number = Math.sqrt(dx * dx + dy * dy);

			var _dashSpace : Number = 5;

			// calculate the number of dashed to draw based on the distance between each point
			// always draw at least 1 line
			var loops : int = Math.max(1, Math.floor(distance / _dashSpace));

			// dash drawing loop
			for (var j : int = 0;j < loops;j++) {
				var a : Number = j / loops;
				
				if (j % 2) {
					line.graphics.moveTo(x1 + (dx * a), y1 + (dy * a));
				} else {
					line.graphics.lineTo(x1 + (dx * a), y1 + (dy * a));
				}
			}
			
			line.graphics.lineTo(x2, y2);
		}
		
		// Returns the squared distance between point c and segment ab
		public static function SqDistPointSegment(ax:Number, ay:Number, bx:Number, by:Number, cx:Number, cy:Number):Number
		{
			var abx:Number = bx - ax;
			var aby:Number = by - ay;
			var acx:Number = cx - ax;
			var acy:Number = cy - ay;
			var bcx:Number = cx - bx;
			var bcy:Number = cy - by;
	
			var e:Number = acx*abx + acy*aby;
	
			// Handle cases where c projects outside ab
			if (e <= 0.0) return acx*acx + acy*acy;
	
			var f:Number = abx*abx + aby*aby;
	
			if (e >= f) return bcx*bcx + bcy*bcy;
	
			// Handle case where c projects onto ab
			return acx*acx + acy*acy - e * e / f;
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
		
		private function onKeyDown(e:KeyboardEvent):void {
			if (e.keyCode == Key.ESCAPE) {
				points = [];
			}
		}
		
		private function onMouseDown(e:MouseEvent):void {
			listening = true;
		}
		
		private function onMouseUp(e:MouseEvent):void {
			if (listening && points.length < 6) {
				points.push(new Point(mouseX, mouseY));
			}
		}
	}
}
