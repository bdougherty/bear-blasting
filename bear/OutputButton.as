package bear {
	
	import flash.display.*;
	import flash.events.*;
	
	public class OutputButton extends SimpleButton {
		
		public function OutputButton() {
			addEventListener(MouseEvent.MOUSE_UP, outputXML);
		}
		
		public function outputXML(anEvent:Event):void {
			BearBlastingDesignerApp(parent.parent).outputXML();
		}
		
	}
	
}