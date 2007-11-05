package bear {

	public class HitObjectManager {

		private var docClass:BearBlastingApp;

		private var pLevel:int;
		private var pLevels:Array;
		private var pLevelsAll:Array;

		public function HitObjectManager(theDocClass:BearBlastingApp) {
			trace("Created HitObjectManager");
			docClass = theDocClass;
			pLevel = 0;
			pLevels = new Array();
			pLevelsAll = new Array();
			pLevels[0] = null;
			pLevelsAll[0] = null;
		}

		public function addHitObject(theLevel:int, thePosX:int, thePosY:int, theScale:Number, theScoreValue:int):void {
			if (pLevels[theLevel] == null) {
				pLevels[theLevel] = new Array();
			}
			var temp:HitObject = new HitObject(theLevel, thePosX, thePosY, theScale, theScoreValue);
			trace(temp);
			pLevels[theLevel].push(temp);
		}

		// Check to see if the bear has collided with any of the objects,
		// if it has, return a reference to the object
		public function checkCollision(theBear:Bear):HitObject {
			var temp:HitObject = null;
			for (var x:int = 0; x < pLevels[pLevel].length; x++) {
				if (pLevels[pLevel][x].active && pLevels[pLevel][x].hitTestObject(theBear)) {
					temp = pLevels[pLevel][x];
					break;
				}
			}
			return temp;
		}

		// Clears any remaining items in the level
		public function clearLevel(aLevel:int):void {
			for each (var hitObject:HitObject in pLevels[aLevel]) {
				docClass.removeChild(hitObject);
			}
		}

		// This is called when an object is hit
		public function hit(aHitObject:HitObject):void {
			docClass.hit(aHitObject.score);
			for (var x:int = 0; x < pLevels[pLevel].length; x++) {
				if (pLevels[pLevel][x] == aHitObject) {
					docClass.removeChild(pLevels[pLevel][x]);
					pLevels[pLevel].splice(x, 1);
					break;
				}
			}
		}

		// Make a copy of the objects array so we can resore it if we need to
		public function initGame():void {
			pLevelsAll = pLevels.slice();
			for (var x:int = 1; x < pLevels.length; x++) {
				pLevelsAll[x] = pLevels[x].slice();
			}
			trace("\nCopying levels array: "+pLevelsAll);
		}

		// Adds the level's items to the stage
		public function initLevel(levelNumber:int):void {
			pLevel = levelNumber;
			for each (var hitObject:HitObject in pLevels[pLevel]) {
				docClass.addChild(hitObject);
			}
		}

		// Clears the stage of objects and adds the level's items
		public function redrawLevel(levelNumber:int):void {
			trace("Redrawing level "+levelNumber);
			for each (var hitObject:HitObject in pLevels[pLevel]) {
				docClass.removeChild(hitObject);
			}
			pLevels[levelNumber] = pLevelsAll[levelNumber].slice();
			docClass.nextAttempt();
			initLevel(levelNumber);
		}

		public function reset():void {
			pLevel = 0;
			pLevels = new Array();
			pLevels[0] = null;
			for (var x:int = 1; x < pLevelsAll.length; x++) {
				pLevels[x] = pLevelsAll[x].slice();
			}
		}

		// Gets the number of items in the current level
		public function get items():int {
			if (pLevels[pLevel] == null) {
				return 0;
			}
			else {
				return pLevels[pLevel].length;
			}
		}

	}

}
