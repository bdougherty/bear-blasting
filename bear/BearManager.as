package bear {

	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;

	public class BearManager {

		private static const DEFAULT_X:int = BearBlastingApp.STAGE_WIDTH / 2;
		private static const DEFAULT_Y:int = 550;

		private var docClass:BearBlastingApp;
		private var hitObjectManager:HitObjectManager;
		private var theBear:Bear;

		private var isActive:Boolean;
		private var launchBear:Bear;
		private var offsetX:Number;
		private var pauseTimer:Timer;
		private var posX:Number;
		private var posY:Number;
		private var retryTimer:Timer;
		private var speedRotation:Number;
		private var speedX:Number;
		private var speedY:Number;

		private var pAcceleration:Number;
		private var pLevel:int;
		private var pWallFriction:Number;
		private var pWallRotFriction:Number;

		public function BearManager(theDocClass:BearBlastingApp, theHitManager:HitObjectManager) {
			trace("Created BearManager");
			docClass = theDocClass;
			hitObjectManager = theHitManager;
			pauseTimer = new Timer(1500, 1);
			retryTimer = new Timer(1500, 1);
			isActive = false;
			theBear = new Bear(DEFAULT_X, DEFAULT_Y);
		}

		// Changes the power of the blast
		public function changePower(howMuch:Number):void {
			if (isActive) {
				theBear.changePower(-howMuch);
			}
		}

		// Checks to see if the bear has hit the walls or the bottom
		public function checkBounce(someBear:Bear):void {
			// Did we hit the left?
			if (someBear.x <= (someBear.width / 2)) {
				negX();
				someBear.x = (someBear.width / 2) + 1;
			}
			// Did we hit the right side?
			else if (someBear.x >= BearBlastingApp.STAGE_WIDTH - (someBear.width / 2)) {
				negX();
				someBear.x = BearBlastingApp.STAGE_WIDTH - (someBear.width / 2) - 1;
			}
			// What about the bottom?
			if (someBear.y >= docClass.stage.stageHeight - (someBear.height / 2)) {
				hitBottom();
			}
		}

		// Asks the hitObjectManager if the bear has hit an object
		public function checkCollision(theManager:HitObjectManager):void {
			var temp:HitObject = theManager.checkCollision(launchBear);
			if (temp != null) {
				trace("     Hit "+temp)
				theManager.hit(temp);
			}
		}

		// Handles the dragging of the bear
		public function dragBear(event:MouseEvent):void {
			if (isActive) {
				// Move the bear to the cursor
				theBear.x = event.stageX - offsetX;

				// Make sure we can't drag past the sides
				if (theBear.x >= BearBlastingApp.STAGE_WIDTH - (theBear.width / 2)) {
					theBear.x = BearBlastingApp.STAGE_WIDTH - (theBear.width / 2);
				}
				else if (theBear.x <= (theBear.width / 2)) {
					theBear.x = theBear.width / 2;
				}

				// Instruct Flash Player to refresh the screen after this event.
				event.updateAfterEvent();
			}
		}

		// Removes the bear at the end
		public function endGame():void {
			docClass.removeChild(theBear);
		}

		// Resets the bear and stops listening for mouse clicks
		public function endLevel(theLevel:int):void {
			reset();
			theBear.removeEventListener(MouseEvent.MOUSE_DOWN, startDragging);
			theBear.removeEventListener(MouseEvent.MOUSE_UP, stopDragging);
		}

		// Fires the bear
		public function fire():void {
			if (isActive) {
				isActive = false;

				// Record the current position of the bear
				posX = theBear.x;
				posY = theBear.y;

				// Replace the bear with a different one to launch
				docClass.removeChild(theBear);
				launchBear = new Bear(posX, (posY - 5));
				launchBear.removeBlast();
				docClass.addChild(launchBear);

				// Figure out the speeds
				speedX = theBear.blastX;
				speedY = theBear.blastY - 3;
				speedRotation = speedX;
			}
		}

		// Stops the attempt when the bear hits the bottom
		public function hitBottom():void {

			// Stop movement
			speedX = 0;
			speedY = 0;
			speedRotation = 0;

			// Determine whether or not the level was completed
			if (hitObjectManager.items == 0) {
				docClass.hitBottom();
				pauseTimer.addEventListener(TimerEvent.TIMER, timerEndLevel);
				pauseTimer.start();
			}
			else {
				trace("Didn't hit all of the objects");
				docClass.hitBottom();
				retryTimer.addEventListener(TimerEvent.TIMER, timerRetryLevel);
				retryTimer.start();
			}

		}

		// Adds the bear to the stage when the game starts
		public function initGame():void {
			docClass.addChild(theBear);
		}

		// Makes the bear active and starts listening to the mouse
		public function initLevel(theLevel:int):void {
			isActive = true;
			pLevel = theLevel;
			theBear.addEventListener(MouseEvent.MOUSE_DOWN, startDragging);
			theBear.addEventListener(MouseEvent.MOUSE_UP, stopDragging);
		}

		// Tells the bear to move the blast
		public function moveBlast(howMuch:Number):void {
			if (isActive) {
				theBear.moveBlast(howMuch);
			}
		}

		// Reverses the X speed of the bear
		public function negX():void {
			speedX = -speedX * pWallFriction;
			speedRotation = speedRotation * pWallRotFriction;
		}

		// Gets rid of the launch bear and puts back the regular bear
		public function reset():void {
			if (!isActive) {
				docClass.removeChild(launchBear);
				docClass.addChild(theBear);
				theBear.x = posX;
				theBear.y = posY;
			}
		}

		// Records the offset and starts listenening to the mouse
		public function startDragging(event:MouseEvent):void {
			// Record the difference in the cursor and the position
			offsetX = event.stageX - theBear.x;

			// tell Flash Player to start listening for the mouseMove event
			docClass.stage.addEventListener(MouseEvent.MOUSE_MOVE, dragBear);
		}

		// Stops listening to the mouse for dragging
		public function stopDragging(event:MouseEvent):void {
			docClass.stage.removeEventListener(MouseEvent.MOUSE_MOVE, dragBear);
		}

		// Ends the level after the delay
		public function timerEndLevel(anEvent:TimerEvent):void {
			pauseTimer.reset();
			docClass.endLevel();
		}

		// Resets the level after the delay
		public function timerRetryLevel(anEvent:TimerEvent):void {
			retryTimer.reset();
			reset();
			hitObjectManager.redrawLevel(pLevel);
			isActive = true;
		}

		// Checks for collisions and moves the bear
		public function update(theManager:HitObjectManager):void {

			// Check for collisions and notify the hit manager of them
			checkCollision(theManager);

			// Apply projectile motion to Y movement
			speedY = speedY + (pAcceleration * (1 / docClass.stage.frameRate));

			// Move the bear
			launchBear.y = launchBear.y + speedY;
			launchBear.x = launchBear.x + speedX;
			launchBear.rotation += speedRotation;

			// Bounce the bear
			checkBounce(launchBear);

		}

		public function set acceleration(aValue:Number):void {
			pAcceleration = aValue;
		}

		public function get active():Boolean {
			return isActive;
		}

		public function set wallFriction(aValue:Number):void {
			pWallFriction = aValue;
		}

		public function set wallRotFriction(aValue:Number):void {
			pWallRotFriction = aValue;
		}

	}

}
