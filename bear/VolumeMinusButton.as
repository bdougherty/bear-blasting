package bear {
	
	import flash.display.*;
	import flash.events.*;
	
	public class VolumeMinusButton extends SimpleButton {
		
		public function VolumeMinusButton() {
			addEventListener(MouseEvent.MOUSE_UP, volumeDown);
		}
		
		// Go to initgame when the button is pressed
		public function volumeDown(anEvent:Event):void {
			BearBlastingApp(parent).decreaseVolume();
		}
		
	}
	
}