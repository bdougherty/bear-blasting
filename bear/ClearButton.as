package bear {
	
	import flash.display.*;
	import flash.events.*;
	
	public class ClearButton extends SimpleButton {
		
		public function ClearButton() {
			addEventListener(MouseEvent.MOUSE_UP, clearItems);
		}
		
		public function clearItems(anEvent:Event):void {
			BearBlastingDesignerApp(parent.parent).clearItems();
		}
		
	}
	
}