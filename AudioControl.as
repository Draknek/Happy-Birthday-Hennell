package
{
	import flash.display.*;
	import flash.events.*;
	import flash.media.*;
	
	public class AudioControl extends Sprite
	{
		[Embed(source="audio/music.mp3")]
		public static var musicSrc:Class;
		
		private static var music : Sound = new musicSrc();
		private static var musicChannel : SoundChannel;
		
		public static var mute : Boolean = false;
		
		public static function play (): void {
			musicChannel = music.play(0, int.MAX_VALUE);
		}
	}
}

