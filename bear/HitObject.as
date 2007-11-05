package bear {

	import flash.display.*;
	import flash.events.*;

	public class HitObject extends MovieClip {

		private var isActive:Boolean;
		private var pLevel:int;
		private var pPosX:int;
		private var pPosY:int;
		private var pScale:Number;
		private var pScoreValue:int;

		public function HitObject(theLevel:int, thePosX:int, thePosY:int, theScale:Number, theScoreValue:int) {
			pLevel = theLevel;
			pPosX = thePosX;
			pPosY = thePosY;
			pScale = theScale;
			pScoreValue = theScoreValue * (1 + (1 - pScale));
			isActive = false;
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}

		public function addedToStage(anEvent:Event):void {
			// Position on the stage
			x = pPosX;
			y = pPosY;

			// Change the scale
			scaleX = scaleY = pScale;

			// Make active
			isActive = true;
		}

		public override function toString():String {
			return "L"+pLevel+" ("+pPosX+","+pPosY+") x"+pScale+" "+pScoreValue+"p";
		}

		public function get active():Boolean {
			return isActive;
		}

		public function get level():int {
			return pLevel;
		}

		public function get posX():int {
			return pPosX;
		}

		public function get posY():int {
			return pPosY;
		}

		public function get scale():Number {
			return pScale;
		}

		public function get score():int {
			return pScoreValue;
		}



	}

}
