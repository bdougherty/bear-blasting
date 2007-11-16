package bear {
	
	import flash.display.*;
	import flash.events.*;
	
	public class MusicMuteButton extends MovieClip {
		
		public function MusicMuteButton() {
			addEventListener(MouseEvent.MOUSE_UP, toggleMute);
		}
		
		// Go to initgame when the button is pressed
		public function toggleMute(anEvent:Event):void {
			BearBlastingApp(parent).toggleMusic();
		}
		
	}
	
}