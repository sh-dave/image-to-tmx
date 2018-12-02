package;

class Tilemap {
	var inputImage: String;
	var inputTileset: String;
	var tiles: Array<Int> = [];
	var tileset: Tileset;

	var mapWidth: Int;
	var mapHeight: Int;

	public function new( inputImage: String, tileset: Tileset, tileWidth: Int, tileHeight: Int, inputTileset: String ) {
		this.inputImage = inputImage;
		this.inputTileset = inputTileset;
		this.tileset = tileset;

		var bytes = sys.io.File.getBytes(inputImage);
		var png = new format.png.Reader(new haxe.io.BytesInput(bytes)).read();
		var header = format.png.Tools.getHeader(png);
		var pngbytes = format.png.Tools.extract32(png);
		var imageWidth = header.width;
		var imageHeight = header.height;
		mapWidth = Std.int(header.width / tileWidth);
		mapHeight = Std.int(header.height / tileHeight);
		var tile = haxe.io.Bytes.alloc(tileWidth * tileHeight * 4);

		for (my in 0...mapHeight) {
			for (mx in 0...mapWidth) {
				for (by in 0...tileHeight) {
					for (bx in 0...tileWidth) {
						var di = (by * tileWidth + bx) * 4;
						var si = (((my * tileHeight) + by) * imageWidth + mx * tileWidth + bx) * 4;
						tile.set(di + 0, pngbytes.get(si + 0));
						tile.set(di + 1, pngbytes.get(si + 1));
						tile.set(di + 2, pngbytes.get(si + 2));
						tile.set(di + 3, pngbytes.get(si + 3));
					}
				}

				var tileString = tile.toHex();
				tiles.push(tileset.findTileIndex(tileString));
			}
		}

		//trace(tiles);
	}

	public function write() {
		var doc = Xml.createDocument();
		var map = Xml.createElement('map');
		map.set('version', '1.0');
		map.set('orientation', 'orthogonal');
		map.set('width', '${mapWidth}');
		map.set('height', '${mapHeight}');
		map.set('tilewidth', '${this.tileset.tileWidth}');
		map.set('tileheight', '${this.tileset.tileHeight}');

		var tileset = Xml.createElement('tileset');
		tileset.set('name', '${this.tileset.name}');
		tileset.set('firstgid', '1');
		tileset.set('tilewidth', '${this.tileset.tileWidth}');
		tileset.set('tileheight', '${this.tileset.tileHeight}');

		var image = Xml.createElement('image');
		image.set('source', inputTileset);

		var layer = Xml.createElement('layer');
		layer.set('name', 'background');
		layer.set('width', '${mapWidth}');
		layer.set('height', '${mapHeight}');

		var data = Xml.createElement('data');
		data.set('encoding', 'csv');

		var csv = Xml.createPCData('data');
		csv.nodeValue = tiles.join(',');

		doc.addChild(map);
		map.addChild(tileset);
		tileset.addChild(image);
		map.addChild(layer);
		layer.addChild(data);
		data.addChild(csv);

		sys.io.File.saveContent('${haxe.io.Path.withoutExtension(inputImage)}.tmx', doc.toString());
	}
}
