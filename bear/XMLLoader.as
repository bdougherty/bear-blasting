package bear {

	import flash.display.*;
	import flash.events.*;
	import flash.net.*;

	public class XMLLoader {

		// Managers
		private var docClass:BearBlastingApp;
		private var bearManager:BearManager;
		private var hitObjectManager:HitObjectManager;
		private var inputManager:InputManager;
		private var soundManager:SoundManager;

		private var file:String;			// Retains the file path
		private var urlRequest:URLRequest;	// Request from file or Internet
		private var urlLoader:URLLoader;	// Content Loader

		public function XMLLoader(aFile:String, theDocClass:BearBlastingApp, theBearManager:BearManager, theHitObjectManager:HitObjectManager, theInputManager:InputManager, theSoundManager:SoundManager) {

			trace("XML Loader");

			// Set references to managers
			docClass = theDocClass;
			bearManager = theBearManager;
			hitObjectManager = theHitObjectManager;
			inputManager = theInputManager;
			soundManager = theSoundManager;

			// Set
			file = aFile;
			urlRequest = new URLRequest(file);
			urlLoader = new URLLoader();

			// Set up the event listeners
			urlLoader.addEventListener(Event.COMPLETE, loaderComplete);
			urlLoader.addEventListener(IOErrorEvent.IO_ERROR, doError);
			urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, doError);

			// Load the content
			urlLoader.load(urlRequest);

		}

		// Get information when the XML is loaded
		public function loaderComplete(anEvent:Event):void {

			var xmlData:XML = new XML(urlLoader.data);

			// Score information
			var scoreValue:int = xmlData.score.@value;
			docClass.attemptPenalty = xmlData.score.@attemptpenalty;

			// Bear information
			bearManager.acceleration = xmlData.bear.@acceleration;
			bearManager.wallFriction = xmlData.bear.@wallfriction;
			bearManager.wallRotFriction = xmlData.bear.@wallrotfriction;

			// Load items
			trace("\nLoading items:");
			var level:int = 1;
			for each (var xmlLevel:XML in xmlData.level) {

				for each (var xmlItem:XML in xmlLevel.*) {
					var posX:int = xmlItem.@posx;
					var posY:int = xmlItem.@posy;
					var scale:Number = xmlItem.@scale;
					hitObjectManager.addHitObject(level, posX, posY, scale, scoreValue);
				}
				level++;

			}

			// Load music
			trace("\nLoading music:");
			for each (var xmlSong:XML in xmlData.soundtrack.*) {
				var tempSong:Song = new Song();
				tempSong.file = xmlSong.@file;
				trace(tempSong.file);
				soundManager.addSong(tempSong);
			}

			// finished - go to the instructions screen
			docClass.instructions();

		}

		// If an error occurs
		public function doError(anEvent:Event):void {
			docClass.doError("XML FILE NOT FOUND");
		}

	}

}
