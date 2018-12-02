package;

class Tileset {
	var tileList(default, null) : Array<haxe.io.Bytes> = [];
	var indexMap(default, null) : Map<String, Int> = new Map();

	public var name(default, null) : String = 'default';
	public var tileWidth : Int = 16;
	public var tileHeight : Int = 16;

	public function new( inputTileset : String, tileWidth : Int, tileHeight : Int ) {
		this.tileWidth = tileWidth;
		this.tileHeight = tileHeight;
		var bytes = sys.io.File.getBytes(inputTileset);
		var png = new format.png.Reader(new haxe.io.BytesInput(bytes)).read();
		var header = format.png.Tools.getHeader(png);
		var pngbytes = format.png.Tools.extract32(png);
		var imageWidth = header.width;
		var imageHeight = header.height;
		var tilesetWidth = Std.int(header.width / tileWidth);
		var tilesetHeight = Std.int(header.height / tileHeight);

		for (ty in 0...tilesetHeight) {
			for (tx in 0...tilesetWidth) {
				var tile = haxe.io.Bytes.alloc(tileWidth * tileHeight * 4);

				for (by in 0...tileHeight) {
					for (bx in 0...tileWidth) {
						var di = (by * tileWidth + bx) * 4;
						var si = (((ty * tileHeight) + by) * imageWidth + tx * tileWidth + bx) * 4;
						tile.set(di + 0, pngbytes.get(si + 0));
						tile.set(di + 1, pngbytes.get(si + 1));
						tile.set(di + 2, pngbytes.get(si + 2));
						tile.set(di + 3, pngbytes.get(si + 3));
					}
				}

				tileList.push(tile);

				var tileString = tile.toHex();

				if (!indexMap.exists(tileString)) {
					indexMap.set(tileString, tileList.length - 1);
				}
			}
		}

		//trace(indexMap);
	}

	static var findCounter = 0;

	public function findTileIndex( tile : String ) : Int {
		//trace('find: "${findCounter++}" "${tile}"');
		var index = indexMap.get(tile);
		return index == null ? 0 : index + 1;
	}
}
