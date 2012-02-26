package
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.*;
	
	import com.greensock.*;
	
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
		
		public var cuts:int = 0;
		
		public var listening:Boolean = false;
		public var blowing:Boolean = false;
		public var cutting:Boolean = false;
		public var flash:Boolean = false;
		public var blowFrom:Point;
		
		public var feedback:MyTextField;
		public var instructions:MyTextField;
		
		public var cake: DisplayObject;
		
		public function Level (_n: int)
		{
			startTime = getTimer();
			
			addChild(instructions = new MyTextField(320, 25, "Blow out candles with\nfive continuous breaths", 0xFFFFFF, "center", 30));
			
			cake = new CakeGfx();
			
			cake.x = 320 - cake.width * 0.5;
			cake.y = 240 - h * 0.5;
			
			addChild(cake);
			
			reset();
			
			Main.instance.stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			Main.instance.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		
		public function reset ():void
		{
			flameCount = 0;
			
			blowFrom = null;
			
			cutting = false;
			
			if (feedback) {
				removeChild(feedback);
				feedback = null;
			}
			
			if (line) {
				var displayObject:*;
				
				for each (displayObject in candles) {
					if (displayObject.parent) {
						removeChild(displayObject);
					}
				}
				
				for each (displayObject in flames) {
					if (displayObject.parent) {
						removeChild(displayObject);
					}
				}
				
				candles = [];
				flames = [];
				
				points = [];
				
				blowing = false;
		
				removeChild(line);
			}
			
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
				
				c.flame = flame;
			}
			
			line = new Sprite;
			
			addChild(line);
			
			AudioControl.musicVolume = 0;
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
				/*timer = new Timer(500, 1);
				timer.addEventListener(TimerEvent.TIMER, function (param: *): void {Main.screen = new Level(n+1);});
				timer.start();*/
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
			if (flash && frame % 10 == 0) {
				graphics.clear();
			
				graphics.beginFill(int(Math.random() * 0xFFFFFF));
				graphics.drawRect(0, 0, 640, 480);
				graphics.endFill();
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
				line.graphics.lineStyle(2, cutting ? 0xFFFFFF : 0x000000);
			
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
				
				if ((cutting && points.length == 1) || ! blowing) {
					test(last.x, last.y, mouseX, mouseY);
					//line.graphics.lineTo(mouseX, mouseY);
				}
			}
		}
		
		public function test (x1:Number, y1:Number, x2:Number, y2:Number):void
		{
			var dx:Number;
			var dy:Number;
			var distSq:Number;
			
			if (! cutting) {
				for each (var c:Candle in candles) {
					if (blowing) {
						distSq = SqDistPointSegment(blowFrom.x, blowFrom.y, x2, y2, c.x, c.y);
					} else {
						distSq = SqDistPointSegment(x1, y1, x2, y2, c.x, c.y);
					}
			
					if (distSq < 25) {
						if (blowing) {
							if (c.flame && c.flame.parent) {
								distSq = SqDistPointSegment(blowFrom.x, blowFrom.y, x1, y1, c.x, c.y);
				
								if (distSq < 49) {
									remove(c.flame);
									c.flame = null;
								}
							}
						} else {
							c.target.visible = true;
						}
					}
				}
			}
			
			// Draw
			
			dx = x2 - x1;
			dy = y2 - y1;

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
			if (e.keyCode == Key.ESCAPE || e.keyCode == Key.R) {
				points = [];
			}
		}
		
		private function onMouseDown(e:MouseEvent):void {
			if (cutting) {
				points.push(new Point(mouseX, mouseY));
				
				if (points.length == 2) {
					cutTheCake();
				}
				
				return;
			}
			
			if (! blowing) {
				if (points.length == 0) {
					AudioControl.play();
				}
				points.push(new Point(mouseX, mouseY));
				
				if (points.length == 1) {
					TweenLite.to(AudioControl, 0.5, {musicVolume: 0.15});
					
					AudioControl.blow();
					
					blowing = true;
					
					blowOut(false);
				} else {
					TweenLite.to(AudioControl, 1.0, {musicVolume: AudioControl.musicVolume + 0.01});
				}
			}
		}
		
		private function cutTheCake ():void
		{
			var full:BitmapData
			
			if (cake.width == 640) {
				full = (cake as Bitmap).bitmapData;
			} else {
				full = new BitmapData(640, 480, true, 0x0);
				full.draw(cake, cake.transform.matrix);
				
				removeChild(cake);
			
				cake = new Bitmap(full);
			
				addChildAt(cake, 0);
			}
			
			var lineShape:Shape = new Shape;
			
			lineShape.graphics.lineStyle(0, 0xFFFFFF);
			lineShape.graphics.moveTo(points[0].x, points[0].y);
			lineShape.graphics.lineTo(points[1].x, points[1].y);
			
			var half1:BitmapData = new BitmapData(640, 480, true, 0x0);
			
			half1.draw(lineShape);
			
			if (! full.hitTest(new Point, 128, half1, new Point, 128)) {
				points.length = 0;
				return;
			}
			
			half1.fillRect(half1.rect, 0x0);
			
			var dx:Number = points[1].x - points[0].x;
			var dy:Number = points[1].y - points[0].y;
			
			var dz:Number = Math.sqrt(dx*dx + dy*dy);
			
			dx /= dz;
			dy /= dz;
			
			var cx:Number = (points[0].x + points[1].x)*0.5;
			var cy:Number = (points[0].y + points[1].y)*0.5;
			
			var mask:Shape = new Shape;
			
			mask.graphics.beginFill(0xFFFFFF);
			mask.graphics.moveTo(cx + dx*1000, cy + dy*1000);
			mask.graphics.lineTo(cx - dx*1000, cy - dy*1000);
			mask.graphics.lineTo(cx + dy*1000, cy - dx*1000);
			mask.graphics.endFill();
			
			cake.mask = mask;
			
			
			
			half1.draw(cake);
			
			cake.mask = null;
			
			
			mask.graphics.clear();
			mask.graphics.beginFill(0xFFFFFF);
			mask.graphics.moveTo(cx + dx*1000, cy + dy*1000);
			mask.graphics.lineTo(cx - dx*1000, cy - dy*1000);
			mask.graphics.lineTo(cx - dy*1000, cy + dx*1000);
			mask.graphics.endFill();
			
			cake.mask = mask;
			
			var half2:BitmapData = new BitmapData(640, 480, true, 0x0);
			
			half2.draw(cake);
			
			cake.mask = null;
			
			cake.visible = false;
			
			var bitmap1:Bitmap = new Bitmap(half1);
			var bitmap2:Bitmap = new Bitmap(half2);
			
			addChild(bitmap1);
			addChild(bitmap2);
			
			cutting = false;
			
			var move:Number = 5;
			
			dx *= move;
			dy *= move;
			
			TweenLite.to(bitmap1, 0.5, {x: dy, y: -dx});
			TweenLite.to(bitmap2, 0.5, {x: -dy, y: dx});
			
			TweenLite.delayedCall(0.6, function ():void {
				cutting = true;
				
				full.fillRect(full.rect, 0x0);
				
				full.draw(bitmap1, bitmap1.transform.matrix);
				full.draw(bitmap2, bitmap2.transform.matrix);
				
				removeChild(bitmap1);
				removeChild(bitmap2);
				
				cake.visible = true;
				
				cuts++;
				
				if (cuts == 5) {
					cutting = false;
			
					instructions.text = "That's not 25 pieces!\nFortunately, you don't have\n24 friends anyway."
			
					TweenLite.to(AudioControl, 13.0, {musicVolume: 0, delay: 2});
			
					TweenLite.delayedCall(5.0, function ():void {
						instructions.text = "You don't have any friends."
					});
			
					TweenLite.delayedCall(7.0, function ():void {
						instructions.text = "So the cake is all yours."
					});
			
					TweenLite.delayedCall(9.0, function ():void {
						instructions.text = "You win."
					});
			
					TweenLite.delayedCall(11.0, function ():void {
						instructions.text = "You win.\nLoser."
					});
			
					TweenLite.delayedCall(16.0, function ():void {
						instructions.text = "Happy Birthday Hennell!"
						instructions.scaleX = instructions.scaleY = 1.5;
						instructions.x -= 25;
						AudioControl.musicVolume = 0.2;
						flash = true;
					});
				}
			});
			
			points.length = 0;
		}
		
		private function blowOut (remove:Boolean = true):void {
			if (remove) {
				points.shift();
			}
			
			blowFrom = points[0].clone();
			
			if (points.length == 1) {
				points = [];
				
				if (true || flameCount == 0) {
					for each (var c:Candle in candles) {
						TweenLite.to(c, 3.0, {y: c.y - 480, delay: Math.random() + 0.5});
					}
					for each (var f:Flame in flames) {
						if (f.parent) {
							removeChild(f);
						}
					}
					
					cutting = true;
					
					instructions.text = "Excellent. Now cut the cake into\n25 slices using only 5 cuts"
					
				} else {
					feedback = new MyTextField(320, 350, "FAIL!", 0xFFFFFF, "center", 60);
					addChild(feedback);
					TweenLite.delayedCall(1.5, reset);
				}
				
				return;
			}
			
			TweenLite.to(points[0], 1.0, {x: points[1].x, y: points[1].y, onComplete: blowOut});
		}
	}
}
