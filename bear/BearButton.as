package bear {

	import flash.display.*;
	import flash.events.*;

	public class BearButton extends SimpleButton {

		public function BearButton() {
			addEventListener(MouseEvent.MOUSE_UP, initGame);
		}

		// Go to initgame when the button is pressed
		public function initGame(anEvent:Event):void {
			BearBlastingApp(parent).gotoAndPlay("initgame");
		}

	}

}
