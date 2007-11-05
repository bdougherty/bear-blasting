package bear {
	
	import flash.display.*;
	import flash.events.*;
	
	public class BearButtonEnd extends SimpleButton {
		
		public function BearButtonEnd() {
			addEventListener(MouseEvent.MOUSE_UP, initGame);
		}
		
		// Go to initgame when the button is pressed
		public function initGame(anEvent:Event):void {
			BearBlastingApp(parent).restartGame();
		}
		
	}
	
}