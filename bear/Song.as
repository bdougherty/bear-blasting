package bear {
	
	public class Song {
		
		private var pFile:String;
		
		public function set file(aFileName:String):void {
			pFile = aFileName;
		}
		
		public function get file():String {
			return pFile;
		}
		
	}
	
}