# image-to-tmx

haxe port of https://github.com/bjorn/tiled/wiki/Import-from-Image

## build

```bash
$ npm install
$ npx haxe build-nodejs.hxml
```

## usage

```bash
$ node bin/nodejs/image-to-tmx.js --input-image MAP.png --tileset-image TILESET.png --tile-width 16 --tile-height 16
```

- **input-image** the png of the map you want to convert
- **input-tileset**
- **tile-width** width of a tile
- **tile-height** height of a tile
