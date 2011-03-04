package
{
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.*;
	import flash.ui.*;
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
		
		public var code:MyTextField;
		public var errorMessage:MyTextField;
		
		public var timer:Timer;
		
		public static var id:String;
		
		public var forRemoval:Array = [];
		
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
				var yourScore:MyTextField = new MyTextField(320, 10, "You are "+score+"\nyears old!", 0xFFFFFF, "center", 40);
			
				yourScore.x = this["ship"+player].x + (shipA.width - yourScore.width)*0.5
			
				addChild(yourScore);
				
				checkForScore();
			}
			
			if (mode == "new") {
				player = "A";
				Main.message("invite=1", setID);
				
				function setID (_id:String):void
				{
					id = _id;
					
					var message:MyTextField = new MyTextField(320, 20, "Invite code:", 0xFFFFFF, "center", 40);
				
					addChild(message);
				
					code = new MyTextField(320, message.y + message.height+10, id, 0xFFFFFF, "center", 40);
					code.selectable = true;
					code.mouseEnabled = true;
				
					addChild(code);
				
					var explanation:MyTextField = new MyTextField(320, code.y + code.height+10, "Send this code\nto a friend\nto start game", 0xFFFFFF, "center", 20);
				
					addChild(explanation);
					
					forRemoval.push(message, code, explanation);
					
					checkForStartTime();
				}
				
			}
			
			if (mode == "join") {
				player = "B";
				
				var message:MyTextField = new MyTextField(320, 20, "Invite code:", 0xFFFFFF, "center", 40);
				
				addChild(message);
				
				code = new MyTextField(320, message.y + message.height+10, "0000000", 0xFFFFFF, "center", 40);
				code.selectable = true;
				code.mouseEnabled = true;
				code.border = true;
				code.borderColor = 0x888888;
				code.type = TextFieldType.INPUT;
				code.autoSize = "none";
				var _textFormat : TextFormat = code.defaultTextFormat;
				_textFormat.align = "left";
				code.defaultTextFormat = _textFormat;
				code.text = "";
				code.maxChars = 6;
				
				addChild(code);
				
				errorMessage = new MyTextField(320, code.y + code.height+10, "", 0xFF0000, "center", 20);
				
				addChild(errorMessage);
				
				forRemoval.push(message, code);
			}
			
			if (mode == "scores" || mode == "join")
			{
				pilotB.x = shipB.x + (shipB.width - pilotB.width)*0.5;
				pilotB.y = 480 - pilotB.height;
				addChild(pilotB);
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
		
		public override function uninit ():void
		{
			if (timer) timer.stop();
		}
		
		private function joinGame ():void
		{
			if (! code.selectable) return;
			
			code.selectable = false;
			code.mouseEnabled = false;
			code.type = TextFieldType.DYNAMIC;
			
			var opponentID:String = code.text;
			
			Main.message("join="+opponentID, setID, errorEvent);
			
			function setID (_id:String):void
			{
				id = _id;
				checkForStartTime();
			}
			
			function errorEvent (error:String):void
			{
				code.selectable = true;
				code.mouseEnabled = true;
				code.type = TextFieldType.INPUT;
				
				errorMessage.text = error;
			}
		}
		
		private function checkForStartTime (param:*=null):void
		{
			Main.message("id="+id+"&getstart=1", startCountdown);
			
			function startCountdown (delay:String):void
			{
				if (delay) {
					countDown = new MyTextField(320, 10, "00:00", 0xFFFFFF, "center", 40);
					addChild(countDown);
					launchTime = int(delay) + getTimer();
					waiting = false;
					updateTime();
					for each (var o:* in forRemoval) {
						removeChild(o);
					}
					forRemoval.length = 0;
					
					if (int(delay) > 6000) {
						timer = new Timer(int(delay)-6000, 1);
						timer.addEventListener(TimerEvent.TIMER, AudioControl.playCountdown);
						timer.start();
					} else {
						AudioControl.countdown.play(6000 - int(delay));
					}
				} else {
					timer = new Timer(1000, 1);
					timer.addEventListener(TimerEvent.TIMER, checkForStartTime);
					timer.start();
				}
			}
		}
		
		private function checkForScore (param:*=null):void
		{
			Main.message("id="+id+"&age="+score+"&complete=1", showOtherScore);
			
			var launchpad:Launchpad = this;
			
			function showOtherScore (otherScore:String):void
			{
				if (otherScore) {
					var otherPlayer:String = (player == "A") ? "B" : "A";
					
					var text:MyTextField = new MyTextField(320, 10, "They are "+otherScore+"\nyears old!", 0xFFFFFF, "center", 40);
			
					text.x = launchpad["ship"+otherPlayer].x + (shipA.width - text.width)*0.5
			
					addChild(text);
				} else {
					timer = new Timer(1000, 1);
					timer.addEventListener(TimerEvent.TIMER, checkForScore);
					timer.start();
				}
			}
		}
		
		public override function update (): void {
			if (Input.keyPressed(27)) {
				Main.screen = new MainMenu;
				Input.keyboard[27] = false;
			}
			
			if (mode == "join") {
				Main.instance.stage.focus = code;
				
				if (Input.keyPressed(Keyboard.ENTER)) {
					joinGame();
				}
			}
			
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
