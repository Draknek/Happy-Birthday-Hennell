package
{
	import flash.display.*;
	import flash.events.*;
	
	public class MainMenu extends Screen
	{
		public function MainMenu ()
		{
			addChild(new MyTextField(320, 20, "Happy Birthday\nHennell", 0xFFFFFF, "center", 50));
			
			addChild(new MyTextField(320, 125, "Puzzle Edition 2012", 0xFFFFFF, "center", 40));
			addChild(new MyTextField(320, 200, "Made for the GDC Pirate Kart\n(and for Hennell)", 0xFFFFFF, "center", 30));
			addChild(new MyTextField(320, 300, "Music by Chipso Facto", 0xFFFFFF, "center", 30));
			
			addChild(new MyTextField(320, 450, "Click to play", 0xFFFFFF, "center", 20));
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
