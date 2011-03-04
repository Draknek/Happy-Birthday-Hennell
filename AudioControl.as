package
{
	import flash.display.*;
	import flash.events.*;
	import flash.media.*;
	
	public class AudioControl extends Sprite
	{
		[Embed(source="audio/music.mp3")]
		public static var musicSrc:Class;
		
		[Embed(source="audio/countdown.mp3")]
		public static var countdownSrc:Class;
		
		private static var music : Sound = new musicSrc();
		public static var countdown : Sound = new countdownSrc();
		private static var musicChannel : SoundChannel;
		
		public static var mute : Boolean = false;
		
		public static function play (): void {
			musicChannel = music.play();
		}
		
		public static function playCountdown (param:*=null): void {
			countdown.play();
		}
	}
}

