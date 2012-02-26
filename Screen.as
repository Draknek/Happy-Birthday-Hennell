
package
{
	import flash.display.Sprite;
	import flash.events.Event;

	public class Screen extends Sprite
	{
		public function Screen ()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			bg();
		}
		
		private function onAddedToStage (param: *): void
		{
			init();
		}
		
		public function init (): void {}
		public function update (): void {}
		
		public function bg (): void {
			graphics.clear();
			
			graphics.beginFill(int(0x509ffc));
			graphics.drawRect(0, 0, 640, 480);
			graphics.endFill();
		}
	}
}


