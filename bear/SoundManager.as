package bear {

	import flash.events.*;
	import flash.media.*;
	import flash.net.*;

	public class SoundManager {

		private var docClass:BearBlastingApp;

		private var hitSound:HitSound;			// References to embedded sounds
		private var growlSound:GrowlSound;
		private var soundEffects:Boolean;

		private var musicChannel:SoundChannel;	// Channel for controlling music
		private var musicList:Array;			// List of songs
		private var musicIndex:int;				// Index of currently playing song
		private var music:Sound;				// Music sound holder
		private var musicVolume:Number;

		public function SoundManager(theDocClass:BearBlastingApp) {
			trace("Created SoundManager");
			docClass = theDocClass;

			hitSound = new HitSound();
			growlSound = new GrowlSound();
			soundEffects = true;

			musicList = new Array();

			musicChannel = null;
			resetIndex();
		}

		// Add a song to the array
		public function addSong(aSong:Song):void {
			musicList.push(aSong);
		}

		public function changeIcon(aNumber:Number) {
			if (aNumber >= 0.5) {
				docClass.musicmute_mc.gotoAndStop("high");
			}
			else {
				docClass.musicmute_mc.gotoAndStop("low");
			}
		}

		// Decrease the volume of the music
		public function decreaseVolume():void {
			if (musicChannel.soundTransform.volume > 0) {
				musicVolume = musicVolume - 0.1;
				if (musicVolume < 0.1) {
					musicVolume = 0.1;
				}
				changeIcon(musicVolume);
				musicChannel.soundTransform = new SoundTransform(musicVolume, 0);
			}
		}

		public function doID3(anEvent:Event):void {
			//trace("id3: "+anEvent);
		}

		// Play the song when it's done loading
		public function doSongLoaded(anEvent:Event):void {
			if (musicChannel != null) {
				musicChannel.removeEventListener(Event.SOUND_COMPLETE, nextSong);
			}
			trace("Playing " + music.id3.songName);
			docClass.newSong(music.id3.album, music.id3.artist, music.id3.songName);
			musicChannel = music.play();
			musicChannel.addEventListener(Event.SOUND_COMPLETE, nextSong);
			musicChannel.soundTransform = new SoundTransform(0.5, 0);
			musicVolume = musicChannel.soundTransform.volume;
		}

		// Increase the volume of the music
		public function increaseVolume():void {
			if (musicChannel.soundTransform.volume > 0) {
				musicVolume += 0.1;
				if (musicVolume > 1) {
					musicVolume = 1;
				}
				changeIcon(musicVolume);
				musicChannel.soundTransform = new SoundTransform(musicVolume, 0);
			}
		}

		// Begin loading the next song
		public function nextSong(anEvent:Event):void {
			if (music != null) {
				music.removeEventListener(Event.COMPLETE, doSongLoaded);
			}

			music = new Sound();
			music.addEventListener(Event.COMPLETE, doSongLoaded);
			music.addEventListener(Event.ID3, doID3);
			musicIndex = (musicIndex + 1) % musicList.length;

			SoundMixer.stopAll();
			music.load(new URLRequest(musicList[musicIndex].file));
		}

		// Play the fire sound
		public function playFireSound():void {
			if (soundEffects) {
				growlSound.play();
			}
		}

		// Play the sound when a salmon is hit
		public function playHitSound():void {
			if (soundEffects) {
				hitSound.play();
			}
		}

		public function reset():void {

		}

		public function resetIndex():void {
			musicIndex = -1;
		}

		// Start the music playing
		public function startMusic():void {
			resetIndex();
			nextSong(new Event(Event.SOUND_COMPLETE));
		}

		// Toggle mutedness of the sound effects
		public function toggleSoundEffects():void {
			if (soundEffects) {
				soundEffects = false;
				docClass.effectsmute_mc.gotoAndStop("muted");
			}
			else {
				soundEffects = true;
				docClass.effectsmute_mc.gotoAndStop("high");
			}
		}

		// Toggle the mutedness of the music
		public function toggleMusic():void {
			if (musicChannel.soundTransform.volume > 0) {
				trace("musics muting");
				musicVolume = musicChannel.soundTransform.volume;
				musicChannel.soundTransform = new SoundTransform(0, 0);
				docClass.musicmute_mc.gotoAndStop("muted");
			}
			else {
				trace("musics unmuting");
				musicChannel.soundTransform = new SoundTransform(musicVolume, 0);
				docClass.musicmute_mc.gotoAndStop("high");
			}
		}

		/*
		// Stop the song and reset the index
		public function resetSong():void {
			if (musicChannel != null) {
				musicChannel.stop();
			}
			resetIndex();
		}
		*/

	}

}
