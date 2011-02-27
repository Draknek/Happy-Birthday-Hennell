package
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.*;
	import flash.text.*;
	
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
		
		public var mode:String;
		
		public function Launchpad (_mode:String)
		{
			mode = _mode;
			
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
			
			if (mode == "scores") {
				var yourScore:MyTextField = new MyTextField(320, 25, ""+score, 0xFFFFFF, "center", 40);
			
				yourScore.x = this["ship"+player].x + (shipA.width - yourScore.width)*0.5
			
				addChild(yourScore);
			} /*else {
				waiting = false;
				launchTime = getTimer() + 5999;
				countDown = new MyTextField(320, 10, "00:00", 0xFFFFFF, "center", 40);
				addChild(countDown);
			}*/
			
			if (mode == "new") {
				var message:MyTextField = new MyTextField(320, 20, "Invite code:", 0xFFFFFF, "center", 40);
				
				addChild(message);
				
				var code:MyTextField = new MyTextField(320, message.y + message.height+10, "ujg", 0xFFFFFF, "center", 40);
				code.selectable = true;
				code.mouseEnabled = true;
				
				addChild(code);
			}
			
			if (mode == "join") {
				message = new MyTextField(320, 20, "Invite code:", 0xFFFFFF, "center", 40);
				
				addChild(message);
				
				code = new MyTextField(320, message.y + message.height+10, "", 0xFFFFFF, "center", 40);
				code.selectable = true;
				code.mouseEnabled = true;
				code.type = TextFieldType.INPUT;
				Main.instance.stage.focus = code;
				
				addChild(code);
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
