package bear {

	import flash.display.*;
	import flash.events.*;

	public class Bear extends MovieClip {

		private var pPosX:int;
		private var pPosY:int;
		private var pStartBlastX:int;
		private var pStartBlastY:int;

		public function Bear(thePosX:int, thePosY:int) {
			// Set the position
			pPosX = thePosX;
			pPosY = thePosY;

			// Get the position of the blast
			pStartBlastX = blast_mc.x;
			pStartBlastY = blast_mc.y;

			// Add a listener for when the bear is added to the stage
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}

		// Sets the location on the stage to the internal x and y position
		public function addedToStage(anEvent:Event):void {
			// Position on the stage
			x = pPosX;
			y = pPosY;
		}

		// Changes the power of the blast (moves blast_mc up or down)
		public function changePower(howMuch:Number):void {
			blast_mc.y = blast_mc.y + howMuch;
			if (blast_mc.y <= pStartBlastY - 20) {
				blast_mc.y = pStartBlastY - 20;
			}
			else if (blast_mc.y >= pStartBlastY) {
				blast_mc.y = pStartBlastY;
			}
		}

		// Moves the blast side to side
		public function moveBlast(howMuch:Number):void {
			blast_mc.x = blast_mc.x + howMuch;
			if (blast_mc.x <= pStartBlastX - 40) {
				blast_mc.x = pStartBlastX - 40;
			}
			else if (blast_mc.x >= pStartBlastX + 45) {
				blast_mc.x = pStartBlastX + 45;
			}
		}

		// Removes blast_mc from the bear (for the launch bear)
		public function removeBlast():void {
			removeChild(blast_mc);
		}

		// Resets the blast to its default position
		public function resetBlast():void {
			blast_mc.x = pStartBlastX;
			blast_mc.y = pStartBlastY;
		}

		public function get blastX():Number {
			return -(blast_mc.x - pStartBlastX);
		}

		public function get blastY():Number {
			return -(pStartBlastY - blast_mc.y);
		}

		public function get posX():int {
			return pPosX;
		}

		public function get posY():int {
			return pPosY;
		}

	}

}
