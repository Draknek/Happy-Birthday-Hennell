package
{
	import flash.display.*;
	import flash.events.*;
	
	public class MainMenu extends Screen
	{
		public function MainMenu ()
		{
			addChild(new MyTextField(320, 20, "Time-Dilation\nBirthday Buddies", 0xFFFFFF, "center", 50));
			
			addChild(new MyTextField(320, 125, "(A birthday present for Hennell)", 0xFFFFFF, "center", 20));
			
			addChild(new MyTextField(320, 170, "It's a race: to the future!\n\nWhoever is the oldest\nat the end of the game wins!", 0xFFFFFF, "center", 30));
			
			var newGame:Button = new Button("Invite friend", 30);
			
			newGame.x = 320 - newGame.width*0.5;
			newGame.y = 330;
			
			addChild(newGame);
			
			var joinGame:Button = new Button("Join friend", 30);
			
			joinGame.x = 320 - joinGame.width*0.5;
			joinGame.y = 400;
			
			addChild(joinGame);
			
			newGame.addEventListener(MouseEvent.CLICK, function ():void {
				Main.screen = new Launchpad("new");
			});
			
			joinGame.addEventListener(MouseEvent.CLICK, function ():void {
				Main.screen = new Launchpad("join");
			});
		}
	}
}
