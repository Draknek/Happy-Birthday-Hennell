package
{
	import flash.display.*;
	import flash.events.*;
	
	public class Input
	{
		public static var keyboard : Object = new Object();
		
		public static function attach (dispObj : DisplayObject) : void
		{
			dispObj.addEventListener( KeyboardEvent.KEY_DOWN, keyDownListener, false, 0, true );
			dispObj.addEventListener( KeyboardEvent.KEY_UP, keyUpListener, false, 0, true );
			dispObj.addEventListener( Event.ACTIVATE, activateListener, false, 0, true );
			dispObj.addEventListener( Event.DEACTIVATE, deactivateListener, false, 0, true );
		}
		
		private static function keyDownListener( ev:KeyboardEvent ):void
		{
			keyboard[ev.keyCode] = true;
		}
		
		private static function keyUpListener( ev:KeyboardEvent ):void
		{
			keyboard[ev.keyCode] = false;
		}
		
		private static function activateListener( ev:Event ):void
		{
			keyboard = new Object();
		}

		private static function deactivateListener( ev:Event ):void
		{
			keyboard = new Object();
		}
		
		public static function keyPressed (key : uint) : Boolean
		{
			return keyboard[key];
		}
		
	}
}

