package bear {

	import flash.events.*;
	import flash.media.*;
	import flash.net.*;

	public class SoundManager {

		private var docClass:BearBlastingApp;
		private var growl:SoundChannel;
		private var growlFactory:Sound;
		private var hit:SoundChannel;
		private var hitFactory:Sound;

		public function SoundManager(theDocClass:BearBlastingApp) {
			trace("Created SoundManager");
			docClass = theDocClass;

			var growlFile:String = "sounds/growl.mp3";
			var growlRequest:URLRequest = new URLRequest(growlFile);
			growlFactory = new Sound();
			growlFactory.load(growlRequest);

			var hitFile:String = "sounds/hit.mp3";
			var hitRequest:URLRequest = new URLRequest(hitFile);
			hitFactory = new Sound();
			hitFactory.load(hitRequest);

		}

		public function playFireSound():void {
			growl = growlFactory.play();
		}

		public function playHitSound():void {
			hit = hitFactory.play();
		}

		public function reset():void {

		}

	}

}
