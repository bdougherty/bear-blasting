package bear {
	
	import flash.display.*;
	import flash.events.*;
	
	public class VolumePlusButton extends SimpleButton {
		
		public function VolumePlusButton() {
			addEventListener(MouseEvent.MOUSE_UP, volumeUp);
		}
		
		// Go to initgame when the button is pressed
		public function volumeUp(anEvent:Event):void {
			BearBlastingApp(parent).increaseVolume();
		}
		
	}
	
}