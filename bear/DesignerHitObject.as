package bear {

	import flash.display.*;
	import flash.events.*;

	public class DesignerHitObject extends MovieClip {

		private var docClass:BearBlastingDesignerApp;

		private var pPosX:int;
		private var pPosY:int;
		private var pScale:Number;
		private var offsetX:Number;
		private var offsetY:Number;

		public function DesignerHitObject(theDocClass:BearBlastingDesignerApp, thePosX:int, thePosY:int, theScale:Number) {
			docClass = theDocClass;
			pPosX = thePosX;
			pPosY = thePosY;
			pScale = theScale;
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}

		public function addedToStage(anEvent:Event):void {
			// Position on the stage
			x = pPosX;
			y = pPosY;

			// Change the scale
			scaleX = scaleY = pScale;

			addEventListener(MouseEvent.MOUSE_DOWN, startDragging);
			addEventListener(MouseEvent.MOUSE_UP, stopDragging);
		}

		public function doubleClick(event:MouseEvent):void {
			trace("doubleclicked");
		}

		public function dragObject(event:MouseEvent):void {
			// Move the bear to the cursor
			x = event.stageX - offsetX;
			y = event.stageY - offsetY;

			// Make sure we can't drag past the sides
			if (x <= (width / 2)) {
				x = width / 2;
			}
			if (y <= (height / 2)) {
				y = height / 2;
			}
			if (y >= docClass.stage.height - height) {
				y = docClass.stage.height - height;
			}

			// Instruct Flash Player to refresh the screen after this event.
			event.updateAfterEvent();
		}

		public function scaleObject(event:MouseEvent):void {

			if (scaleX >= .5) {
				scaleX = scaleY =  scaleX + (((event.stageX - x) - offsetX) / 10);
			}
			else {
				scaleX = scaleY = .5;
			}

			event.updateAfterEvent();
		}

		// Records the offset and starts listenening to the mouse
		public function startDragging(event:MouseEvent):void {

			// Tell the doc class to stop listening for clicks to create new salmon
			docClass.removeClickListener();

			// Record the difference in the cursor and the position
			offsetX = event.stageX - x;
			offsetY = event.stageY - y;

			if (event.shiftKey) {

				// start listening for the mouse move event
				trace("Changing scale of: "+this);
				docClass.stage.addEventListener(MouseEvent.MOUSE_MOVE, scaleObject);

			}
			else {

				// start listening for the mouseMove event
				trace("Starting drag of: "+this);
				docClass.stage.addEventListener(MouseEvent.MOUSE_MOVE, dragObject);

			}
		}

		// Stops listening to the mouse for dragging
		public function stopDragging(event:MouseEvent):void {

			if (event.shiftKey) {

				// Update the internal scale
				pScale = scaleX;
				trace("     Scale changed "+this);

				// Stop listening to mouse movement
				docClass.stage.removeEventListener(MouseEvent.MOUSE_MOVE, scaleObject);

			}
			else {

				// Round position to nearest 10
				x = BearBlastingDesignerApp.roundToNearest(x, 5);
				y = BearBlastingDesignerApp.roundToNearest(y, 5);

				// Update the internal position
				pPosX = x;
				pPosY = y;
				trace("     Moved to "+this);

				// Remove it if dragged over the score bar
				if (x > BearBlastingDesignerApp.STAGE_WIDTH - (width / 2)) {
					docClass.removeObject(this);
				}

				// Stop listening to mouse movement
				docClass.stage.removeEventListener(MouseEvent.MOUSE_MOVE, dragObject);

			}

			// Tell the doc class to start listening for clicks for new salmon
			docClass.addClickListener();

		}

		public override function toString():String {
			return "("+pPosX+","+pPosY+") x"+pScale;
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

	}

}
