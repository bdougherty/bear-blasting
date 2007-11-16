package bear {
	
	import flash.display.*;
	import flash.events.*;
	
	public class EffectsMuteButton extends MovieClip {
		
		public function EffectsMuteButton() {
			addEventListener(MouseEvent.MOUSE_UP, toggleMute);
		}
		
		// Go to initgame when the button is pressed
		public function toggleMute(anEvent:Event):void {
			BearBlastingApp(parent).toggleEffects();
		}
		
	}
	
}