class MapWriter extends mcli.CommandLine {
	public var tileWidth: Int = 16;
	public var tileHeight: Int = 16;
	public var inputImage: String;
	public var inputTileset: String;

	// TODO (DK)
	//public var embedImage : Bool = false;

	public static function main() {
		new mcli.Dispatch(Sys.args()).dispatch(new MapWriter());
	}

	public function runDefault() {
		if (inputTileset == null || inputImage == null) {
			help();
			return;
		}

		var tileset = new Tileset(inputTileset, tileWidth, tileHeight);
		var map = new Tilemap(inputImage, tileset, tileWidth, tileHeight, inputTileset);
		map.write();
	}

	public function help() {
		Sys.println(this.showUsage());
		Sys.exit(0);
	}
}
