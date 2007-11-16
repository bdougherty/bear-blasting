package bear {

	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.utils.*;

	import fl.transitions.*;
	import fl.transitions.easing.*;

	public class InfoHUD extends MovieClip {

		private var docClass:BearBlastingApp;
		private var soundManager:SoundManager;

		private var animating:Boolean;
		private var pTimer:Timer;
		private var pTween:Tween;

		public function InfoHUD(theDocClass:BearBlastingApp, theSoundManager:SoundManager) {
			docClass = theDocClass;
			soundManager = theSoundManager;
			reset();
			this.x = 50;
			this.y = -(height - 10);
			pTimer = new Timer(1500, 1);
			animating = false;
		}

		public function doneAnimation(anEvent:TweenEvent):void {
			animating = false;
		}

		public function enteredFrame(anEvent:TweenEvent):void {
			pTimer.addEventListener(TimerEvent.TIMER, finishMotion);
			pTimer.start();
		}

		public function finishMotion(anEvent:TimerEvent):void {
			pTimer.reset();
			pTimer.removeEventListener(TimerEvent.TIMER, finishMotion);

			// Tween out
			pTween = new Tween(this, 'y', Back.easeIn, y, -(height - 10), 1, true);
			pTween.addEventListener(TweenEvent.MOTION_FINISH, doneAnimation);
		}

		public function showHUD(theAlbum:String, theArtist:String, theSong:String):void {
			if (!animating) {
				album_txt.text = theAlbum;
				artist_txt.text = theArtist;
				song_txt.text = theSong;

				// Enter in
				animating = true;
				pTween = new Tween(this, 'y', Back.easeOut, -(height - 10), 0, 1, true);
				pTween.addEventListener(TweenEvent.MOTION_FINISH, enteredFrame);
			}
		}

		public function reset():void {
			album_txt.text = "";
			artist_txt.text = "";
			song_txt.text = "";
		}

		public function get album():String {
			return album_txt.text;
		}

		public function get artist():String {
			return artist_txt.text;
		}

		public function get song():String {
			return song_txt.text;
		}

	}

}
