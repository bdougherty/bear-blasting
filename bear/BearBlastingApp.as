package bear {

	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.utils.*;

	public class BearBlastingApp extends MovieClip {

		public static const STAGE_WIDTH:int = 500;

		private var pAttempt:int;		// The attempt number for the current round
		private var pAttemptPenalty:Number; // Percent to be taken off for each attempt
		private var pBlasts:int;		// The total number of blasts
		private var pInfoHUD:InfoHUD;	// The music information HUD
		private var pLevel:int;			// The current level
		private var pLevelScore:int;	// Score amassed in current level
		private var pSalmon:int;		// The number of salmon hit
		private var pScore:int;			// The current score
		private var pTimer:Timer;

		private var beginningDate:Date;
		private var date:Date;
		private var gameTimer:Timer;
		private var loader:XMLLoader;	// Data loader
		private var msDifference:Number; // Number of milliseconds since the game started

		// Managers
		private var bearManager:BearManager;
		private var hitObjectManager:HitObjectManager;
		private var inputManager:InputManager;
		private var soundManager:SoundManager;

		public function BearBlastingApp() {

			// Create the managers
			inputManager = new InputManager(this);
			hitObjectManager = new HitObjectManager(this);
			bearManager = new BearManager(this, hitObjectManager);
			soundManager = new SoundManager(this);

			pInfoHUD = new InfoHUD(this, soundManager);
			addChildAt(pInfoHUD, 10);

			reset();

			// load in XML information
			loader = new XMLLoader("xmldata/bearblasting.xml", this, bearManager, hitObjectManager, inputManager, soundManager);

		}

		// Ends the current level and moves to the next
		public function cheatNextLevel() {
			trace("All items magically hit!");
			hitObjectManager.clearLevel(pLevel);
			endLevel();
		}

		public function decreaseVolume():void {
			soundManager.decreaseVolume();
		}

		// Shows the error frame
		public function doError(anErrorMessage:String):void {
			gotoAndStop("error");
			//errormsg_txt.text = anErrorMessage;
		}

		// Goes to endgame
		public function endGame():void {
			trace("end game");
			bearManager.endLevel(pLevel);
			bearManager.endGame();
			gameTimer.stop();
		}

		// Runs end of level calculations and calls the next level to start
		public function endLevel():void {
			// Stop the timer
			pTimer.stop();

			// Tell the managers that the level is over
			inputManager.endLevel(pLevel);
			bearManager.endLevel(pLevel);

			// Calculate score
			pLevelScore = pLevelScore - (pLevelScore * ((pAttempt - 1) * pAttemptPenalty)); // Loose 10% of level score per attempt
			trace("Score for level " + pLevel + ": " + pLevelScore);
			if (pLevelScore > 0) {
				pScore += pLevelScore;
			}
			score_bar.score = pScore;

			// Increment the level and move on
			trace("Moving to next level");
			pLevel++;
			initLevel();
		}

		// When an object is hit
		public function hit(scoreValue:int):void {
			pLevelScore += scoreValue;
			pSalmon++;
			score_bar.salmon = pSalmon;
			soundManager.playHitSound();
		}

		// Stops the update timer when the bear hits the bottom
		public function hitBottom():void {
			pTimer.stop();
		}

		public function increaseVolume():void {
			soundManager.increaseVolume();
		}

		// Initializes the game
		public function initGame():void {

			// Tell the managers to init
			bearManager.initGame();
			hitObjectManager.initGame();

			// Set the keyboard manager to active
			inputManager.active = true;

			// Set the focus to the stage
			stage.focus = this;

			// Record the time
			beginningDate = new Date();

			// Set up music stuff
			musicmute_mc.gotoAndStop("high");
			effectsmute_mc.gotoAndStop("high");
			soundManager.startMusic();

			gameTimer.start();
			pLevel = 1;
			score_bar.score = pScore;
			gotoAndStop("initlevel");
		}

		// Initializes the current level
		public function initLevel():void {
			trace("\nInitializing level "+pLevel);

			// Reset attempts and level score
			pAttempt = 1;
			pLevelScore = 0;

			// Tell the managers to start the level
			hitObjectManager.initLevel(pLevel);
			inputManager.initLevel(pLevel);
			bearManager.initLevel(pLevel);

			// If there aren't any items for this level, end the game
			if (hitObjectManager.items < 1) {
				trace("No items in this level, ending game");
				gotoAndStop("endgame");
			}
			else {
				// Set the score bar to the latest level
				score_bar.level = pLevel;
				score_bar.attempt = pAttempt;

				// Start the timer for update
				pTimer.start();
			}
		}

		// Goes to instructions screen when done loading
		public function instructions():void {
			gotoAndStop("instructions");
		}

		public function newSong(theAlbum:String, theArtist:String, theSong:String):void {
			pInfoHUD.showHUD(theAlbum, theArtist, theSong);
		}

		// Begins the next attempt
		public function nextAttempt():void {
			pAttempt++;
			score_bar.attempt = pAttempt;
			pLevelScore = 0;
			pTimer.start();
		}

		// Adds leading zeros so the time shows correctly
		public function padTime(aValue:Number):String {
			if (aValue < 10) {
				return "0" + aValue;
			}
			else {
				return String(aValue);
			}
		}

		// Acts on information from inputManager and updates the bearManager
		public function update(anEvent:TimerEvent):void {

			if (inputManager.active) {
				if (inputManager.moveLeft) {
					bearManager.moveBlast(-2);
				}
				if (inputManager.moveRight) {
					bearManager.moveBlast(2);
				}
				if (inputManager.increasePower) {
					bearManager.changePower(0.5);
				}
				if (inputManager.decreasePower) {
					bearManager.changePower(-0.5);
				}
				if (inputManager.fire) {
					soundManager.playFireSound();
					inputManager.active = false;
					inputManager.fire = false;
					pBlasts++;
					score_bar.blasts = pBlasts;
					bearManager.fire();
				}
			}

			if (!bearManager.active) {
				bearManager.update(hitObjectManager);
			}

		}

		// Resets all the variables and goes back to initgame
		public function reset():void {
			// Set up the timers
			pTimer = new Timer(1000.0/30.0);
			pTimer.addEventListener(TimerEvent.TIMER, update);
			gameTimer = new Timer(1000);
			gameTimer.addEventListener(TimerEvent.TIMER, updateGameTimer);

			// Set the variables to zero
			pAttempt = 0;
			pLevel = 0;
			pLevelScore = 0;
			pScore = 0;
		}

		// Resets everything and goes back to the beginning of the game
		public function restartGame():void {
			reset();
			bearManager.reset();
			hitObjectManager.reset();
			soundManager.reset();
			gotoAndStop("initgame");
		}

		public function toggleEffects():void {
			soundManager.toggleSoundEffects();
		}

		public function toggleMusic():void {
			soundManager.toggleMusic();
		}

		// Update the time wasted timer
		public function updateGameTimer(anEvent:TimerEvent):void {

			date = new Date();
			msDifference = Math.floor((date.getTime() - beginningDate.getTime()));

			var hours:Number = Math.floor(msDifference / 3600000);
			var minutes:Number = Math.floor(msDifference / 60000) - (60 * hours);
			var seconds:Number = Math.floor(msDifference / 1000) - (60 * minutes);

			score_bar.time = hours + ":" + padTime(minutes) + ":" + padTime(seconds);

		}

		public function set attemptPenalty(aValue:Number):void {
			pAttemptPenalty = aValue;
		}

	}

}
