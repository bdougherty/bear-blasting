package bear {

	import flash.display.*;
	import flash.events.*;
	import flash.ui.*;

	public class InputManager {

		private var docClass:BearBlastingApp;

		private var isActive:Boolean;
		private var pDecreasePower:Boolean;
		private var pFire:Boolean;
		private var pIncreasePower:Boolean;
		private var pMoveLeft:Boolean;
		private var pMoveRight:Boolean;

		public function InputManager(theDocClass:BearBlastingApp) {
			trace("Created InputManager");
			reset();
			docClass = theDocClass;
			isActive = false;

			// Tell the stage to listen for events
			docClass.stage.addEventListener(KeyboardEvent.KEY_DOWN, doKeyDown);
			docClass.stage.addEventListener(KeyboardEvent.KEY_UP, doKeyUp);
		}

		// Runs when a key is pressed
		public function doKeyDown(anEvent:KeyboardEvent):void {
			if (isActive) {
				if (!anEvent.ctrlKey) {
					switch (anEvent.keyCode) {
						case Keyboard.DOWN:		pDecreasePower = true;
					   							break;
						case Keyboard.UP:		pIncreasePower = true;
					   							break;
						case Keyboard.LEFT:		pMoveLeft = true;
					   							break;
						case Keyboard.RIGHT:	pMoveRight = true;
					   							break;
				   }
				}
			}
		}

		// Runs when a key is let go
		public function doKeyUp(anEvent:KeyboardEvent):void {
			if (isActive) {

				if (anEvent.ctrlKey) {
					if (anEvent.keyCode == Keyboard.UP) {
						docClass.cheatNextLevel();
					}
				}
				else {
					switch (anEvent.keyCode) {
						case Keyboard.DOWN:		pDecreasePower = false;
					   							break;
						case Keyboard.UP:		pIncreasePower = false;
					   							break;
						case Keyboard.LEFT:		pMoveLeft = false;
					   							break;
						case Keyboard.RIGHT:	pMoveRight = false;
					   							break;
						case Keyboard.SPACE:	pFire = true;
					   							break;
				   }
				}
			}
		}

		// Sets to active and resets the states
		public function initLevel(theLevel:int):void {
			isActive = true;
			reset();
		}

		// Sets to inactive
		public function endLevel(theLevel:int):void {
			isActive = false;
		}

		// Sets all of the actions to false
		public function reset():void {
			pMoveRight = false;
			pMoveLeft = false;
			pIncreasePower = false;
			pDecreasePower = false;
			pFire = false;
		}

		public function get active():Boolean {
			return isActive;
		}

		public function set active(isActive:Boolean):void {
			isActive = isActive;
		}

		public function get decreasePower():Boolean {
			return pDecreasePower;
		}

		public function get fire():Boolean {
			return pFire;
		}

		public function set fire(aValue:Boolean):void {
			pFire = aValue;
		}

		public function get increasePower():Boolean {
			return pIncreasePower;
		}

		public function get moveLeft():Boolean {
			return pMoveLeft;
		}

		public function get moveRight():Boolean {
			return pMoveRight;
		}

	}

}
