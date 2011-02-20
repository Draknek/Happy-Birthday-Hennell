package
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.*;
	
	public class Launchpad extends Screen
	{
		[Embed(source="images/spaceship.png")]
		public static var ShipGfx:Class;
		[Embed(source="images/spaceman.png")]
		public static var ManGfx:Class;
		[Embed(source="images/bg.png")]
		public static var BgGfx:Class;
		
		public var shipA:Bitmap = new ShipGfx;
		public var shipB:Bitmap = new ShipGfx;
		
		public var pilotA:Bitmap = new ManGfx;
		public var pilotB:Bitmap = new ManGfx;
		
		public var frame:int = 0;
		
		public var waiting:Boolean = true;
		
		public var countDown:MyTextField;
		
		public var launchTime:int;
		
		public static var score:int = -1;
		public static var player:String = "A";
		
		public function Launchpad ()
		{
			addChild(new BgGfx);
			
			shipA.x = (640 - shipA.width*2)/3;
			shipB.x = 640 - shipA.x - shipB.width;
			
			shipA.y = 480 - shipA.height;
			shipB.y = 480 - shipB.height;
			
			pilotA.x = shipA.x + (shipA.width - pilotA.width)*0.5;
			pilotA.y = 480 - pilotA.height;
			
			addChild(shipA);
			addChild(shipB);
			
			// USS PartyShip 9749
			
			addChild(pilotA);
			return;
			if (score < 0) {
				waiting = false;
				launchTime = getTimer() + 5999;
				countDown = new MyTextField(320, 10, "00:00", 0xFFFFFF, "center", 40);
				addChild(countDown);
			} else {
				var yourScore:MyTextField = new MyTextField(320, 25, ""+score, 0xFFFFFF, "center", 40);
			
				yourScore.x = this["ship"+player].x + (shipA.width - yourScore.width)*0.5
			
				addChild(yourScore);
			}
		}
		
		public function updateTime ():void
		{
			var t:int = launchTime - getTimer();
			
			t = t / 1000;
			
			countDown.text = "" + t;
			
			if (t <= 0) {
				Main.screen = new Level(1);
			}
		}
		
		public override function update (): void {
			if (! waiting) {
				updateTime();
			}
			
			frame++;
			
			if (frame % 5 == 0) {
				shipA.transform.colorTransform = new ColorTransform(Math.random(), Math.random(), Math.random());
				shipB.transform.colorTransform = new ColorTransform(Math.random(), Math.random(), Math.random());
			}
		}
	}
}
