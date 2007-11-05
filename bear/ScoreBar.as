package bear {

	import flash.display.*;
	import flash.text.*;

	public class ScoreBar extends MovieClip {

		// Set everything to zero
		public function ScoreBar() {
			this.score = 0;
			this.level = 0;
			this.blasts = 0;
			this.time = "0:00:00";
			this.salmon = 0;
			this.attempt = 0;
		}

		// Set the attempt number
		public function set attempt(aValue:int):void {
			attempt_txt.text = String(aValue);
		}

		// Set the number of blasts
		public function set blasts(aValue:int):void {
			blasts_txt.text = String(aValue);
		}

		// Set the level on the score bar
		public function set level(aValue:int):void {
			level_txt.text = String(aValue);
		}

		// Set the number of salmon
		public function set salmon(aValue:int):void {
			salmon_txt.text = String(aValue);
		}

		// Set the score on the score bar
		public function set score(aValue:int):void {
			score_txt.text = String(aValue);
		}

		// Set the time
		public function set time(aValue:String):void {
			time_txt.text = aValue;
		}

	}

}
