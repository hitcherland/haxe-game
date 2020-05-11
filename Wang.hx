import bitmap.PNGBitmap;
import bitmap.Types.PixelFormat;
import bitmap.IOUtil;

class Wang extends hxd.App {
    var size = 32;
    var colours = [0x9cd3dbff, 0xa5d610FF, 0xfde38dFF];

    function getIndex(size, x, y) {
        if(x < size / 2) {
            if(y < size / 2) {
                if (x > y) {
                    return 0;
                } else {
                    return 3;
                }
            } else {
                if(x + y < size) {
                    return 3;
                } else {
                    return 2;
                }
            }
        } else {
            if(y < size / 2) {
                if(x + y < size) {
                    return 0;
                } else {
                    return 1;
                }
            } else {
                if(x > y) {
                    return 1;
                } else {
                    return 2;
                }
            }
            
        }
        
    }

    function writeMySquare(png:PNGBitmap, size:Int, offset:Int, cols) {
        for(x in 0...size) {
            for(y in 0...size) {
                var i = getIndex(size, x, y);
                png.set(x + offset * size, y, cols[i]);
            }
        }

    }

    override function init() {
        var png = new PNGBitmap(size * 81, size, PixelFormat.RGBA);

        
        for(i in 0...82) {
            var cols = [for(j in 0...4) colours[Std.int(i / Math.pow(3, j)) % 3]];
            writeMySquare(png, size, i, cols);
        }

        IOUtil.writeBitmap("tiles/wang.png", png);
    }

    static function main() {
        new Wang();
    }
}