package bear {

	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;

	public class BearBlastingDesignerApp extends MovieClip {

		public static const STAGE_WIDTH:int = 500;

		private var objects:Array;

		public function BearBlastingDesignerApp() {
			objects = new Array();
			addClickListener();
		}

		public function addClickListener():void {
			stage.addEventListener(MouseEvent.MOUSE_DOWN, doClick);
		}

		public function clearItems():void {
			for each (var temp:DesignerHitObject in objects) {
				removeChild(temp);
			}
			objects = new Array();
		}

		public function doClick(anEvent:MouseEvent):void {

			if (anEvent.stageX >= BearBlastingDesignerApp.STAGE_WIDTH - (72/2)) {

			}
			else {
				var temp:DesignerHitObject = new DesignerHitObject(this, BearBlastingDesignerApp.roundToNearest(anEvent.stageX, 5), BearBlastingDesignerApp.roundToNearest(anEvent.stageY, 5), 1);
				objects.push(temp);
				addChild(temp);
				trace("Adding new salmon");
			}

		}

		public function outputXML():void {
			trace("\nOutputting XML");
			trace("<level>");
			for each (var temp:DesignerHitObject in objects) {
				trace("    <item posx=\""+temp.posX+"\" posy=\""+temp.posY+"\" scale=\""+temp.scale.toFixed(1)+"\" />");
			}
			trace("</level>");
		}

		public function removeClickListener():void {
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, doClick);
		}

		public function removeObject(theObject:DesignerHitObject):void {
			for (var x:int = 0; x < objects.length; x++) {
				if (objects[x] == theObject) {
					trace("     Removing "+theObject);
					removeChild(objects[x]);
					objects.splice(x, 1);
					break;
				}
			}
		}

		public static function roundToNearest(numberToRound:Number, nearest:Number):Number {
			return Math.round(numberToRound / nearest) * nearest;
		}

	}

}
