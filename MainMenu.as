package
{
	import flash.display.*;
	import flash.events.*;
	
	public class MainMenu extends Screen
	{
		public function MainMenu ()
		{
			addChild(new MyTextField(320, 20, "Hennell", 0xFFFFFF, "center", 50));
			
			addChild(new MyTextField(320, 150, "It is your birthday.", 0xFFFFFF, "center", 25));
			addChild(new MyTextField(320, 200, "I didn't get you a present.", 0xFFFFFF, "center", 25));
			addChild(new MyTextField(320, 250, "And I haven't made a game\nfor KnP Pirate Kart 2.", 0xFFFFFF, "center", 25));
			addChild(new MyTextField(320, 350, "Fortunately there is a solution\nto both these problems!", 0xFFFFFF, "center", 25));
			
			//addChild(new MyTextField(320, 450, "(Make again click for playing)", 0xFFFFFF, "center", 16));
		}
		
		public override function init (): void
		{
			stage.addEventListener(MouseEvent.MOUSE_DOWN, startGame);
		}
		
		public override function update (): void {}
		
		private function startGame (param: * = null): void
		{
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, startGame);
			
			Main.screen = new Level(1);
		}
	}
}
