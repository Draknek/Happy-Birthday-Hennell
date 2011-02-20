package
{
	import flash.display.*;
	import flash.events.*;
	
	public class MainMenu extends Screen
	{
		public function MainMenu ()
		{
			addChild(new MyTextField(320, 20, "Time-Dilation\nBirthday Buddies", 0xFFFFFF, "center", 50));
			
			var newGame:Button = new Button("Invite friend", 30);
			
			newGame.x = 320 - newGame.width*0.5;
			newGame.y = 200;
			
			addChild(newGame);
			
			var joinGame:Button = new Button("Join friend", 30);
			
			joinGame.x = 320 - joinGame.width*0.5;
			joinGame.y = 320;
			
			addChild(joinGame);
			
			newGame.addEventListener(MouseEvent.CLICK, function ():void {
				Main.screen = new Launchpad;
			});
			
			joinGame.addEventListener(MouseEvent.CLICK, function ():void {
				Main.screen = new Launchpad;
			});
		}
	}
}
