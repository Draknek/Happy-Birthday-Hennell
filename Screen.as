
package
{
	import flash.display.Sprite;
	import flash.events.Event;

	public class Screen extends Sprite
	{
		public function Screen ()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			
			bg();
		}
		
		private function onAddedToStage (param: *): void
		{
			init();
		}
		
		private function onRemovedFromStage (param: *): void
		{
			uninit();
		}
		
		public function init (): void {}
		public function uninit (): void {}
		public function update (): void {}
		
		public function bg (): void {
			graphics.clear();
			
			graphics.beginFill(int(Math.random()*0xFFFFFF));
			graphics.drawRect(0, 0, 640, 480);
			graphics.endFill();
		}
	}
}


