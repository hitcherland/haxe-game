import haxe.io.Bytes;
import hxd.Pixels;
import hxd.PixelFormat;

class WangMap {
    public var data:Array<Int>;
    public var typeBytes:Array<Bytes>;
    var format:PixelFormat = PixelFormat.RGBA;
    public var width:Int;
    public var height:Int;
    var borderBytes:Null<Bytes>;

    public function new(width:Int, height:Int, typeMap:Array<String>, ?format=PixelFormat.RGBA, ?border:Null<String>) {
        this.width = width;
        this.height = height;
        this.format = format;

        this.data = new Array();
        for(h in 0...(4 * height * width)) {
            this.data.push(0);
        }

        this.typeBytes = typeMap.map(function (str:String) {
            return Bytes.ofHex(str.substring(1));
        });

        if(border == null) {
            this.borderBytes = null;
        } else {
            this.borderBytes = Bytes.ofHex(border.substring(1));
        }
    }

    public function makeTileMap(pixelWidth:Int, pixelHeight:Int, ?offsetAngle:Float=0) {
        var bytesPerPixel = Pixels.calcStride(1, this.format);
        var nBytes = pixelWidth * pixelHeight * bytesPerPixel;
        var bytes = Bytes.alloc(nBytes);

        var tileWidth = Math.floor(pixelWidth / width);
        var tileHeight = Math.floor(pixelHeight / height);
        var dx = Math.floor((pixelWidth - tileWidth * width) / 2);
        var dy = Math.floor((pixelHeight - tileHeight * height) / 2);

        for(y in 0...tileHeight * this.height) {
            var tileY:Int = Math.floor(y / tileHeight);
            var innerY:Int = y % tileHeight;
            for(x in 0...tileWidth * this.width) {
                var tileX:Int = Math.floor(x / tileWidth);                
                var innerX:Int = x % tileWidth;
                
                var relX = innerX - tileWidth / 2;
                var relY = innerY - tileHeight / 2;
                var byteIndex:Int = bytesPerPixel * (x + dx + (y + dy) * pixelWidth);

                if(this.borderBytes != null && (innerX == 0 ||
                                                innerX == tileWidth - 1 ||
                                                innerY == 0 ||
                                                innerY == tileHeight - 1)) {
                    bytes.blit(byteIndex, this.borderBytes, 0, bytesPerPixel);                            
                } else {
                    var ang = Math.atan2(relY, relX) + offsetAngle;
                    var sector = (Math.floor(2 * ang / Math.PI + 0.5) + 4) % 4;

                    var dataIndex:Int = sector + 4 * (tileX + tileY * this.width);
                    var typeIndex:Int = this.data[dataIndex];

                    var colourByte = this.typeBytes[typeIndex];
                    bytes.blit(byteIndex, colourByte, 0, bytesPerPixel);
                }
            }
        }

        var pixels = new Pixels(pixelWidth, pixelHeight, bytes, format);
        var tilemap = h2d.Tile.fromPixels(pixels);
        return tilemap;
    }
}