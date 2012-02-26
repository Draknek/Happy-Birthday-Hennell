package
{
	import flash.display.*;
	import flash.events.*;
	import flash.media.*;
	
	public class AudioControl extends Sprite
	{
		[Embed(source="audio/music.mp3")]
		public static var musicSrc:Class;
		
		[Embed(source="audio/blowing.mp3")]
		public static var blowingSrc:Class;
		
		private static var music : Sound = new musicSrc();
		private static var musicChannel : SoundChannel;
		private static var musicTransform :SoundTransform = new SoundTransform(0.0);
		
		private static var blowing : Sound = new blowingSrc();
		
		public static var mute : Boolean = false;
		
		public static function play (): void {
			musicChannel = music.play(0, int.MAX_VALUE, musicTransform);
		}
		
		public static function get musicVolume ():Number {
			return musicTransform.volume;
		}
		
		public static function set musicVolume (v:Number):void {
			musicTransform.volume = v;
			if (musicChannel) {
				musicChannel.soundTransform = musicTransform;
			}
		}
		
		public static function blow (): void {
			blowing.play();
		}
		
	}
}

