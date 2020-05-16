import seedyrng.Random;
import StringTools.hex;
import hsluv.Hsluv;
import hxd.Key;
import hxd.Math.floor;

import WangMap.WangMap;
import Settings.Settings;

typedef TiledMapData = { layers:Array<{ data:Array<Int>}>, tilewidth:Int, tileheight:Int, width:Int, height:Int };

class Main extends hxd.App {
    var settings:Settings.Settings;
    var random:Random;
    var colours:Array<String>;
    var wangMap:WangMap;
    var bitmap:Null<h2d.Bitmap> = null;

    function rescale() {
        var stage = hxd.Window.getInstance();
        var size = getSize(stage.width, stage.height, 1.0);
        var tileMap = wangMap.makeTileMap(size, size);
        if(bitmap != null) {
            bitmap.remove();
        }
        bitmap = new h2d.Bitmap(tileMap, s2d);
        bitmap.x = (stage.width - size) / 2;
        bitmap.y = (stage.height - size) / 2;
    }

    function getSize(width:Int, height:Int, scaling:Float) {
        var size:Int;
        if(height > width) {
            size = floor(s2d.width * scaling);
        } else {
            size = floor(s2d.height * scaling);
        }
        return size;
    }

    function generateMap(map:WangMap) {
        var width = map.width;
        var height = map.height;
        var range = map.typeBytes.length;

        for(y in 0...height) {
            var left = 0;
            for(x in 0...width) { 
                var right, up, down;
                var index = 4 * (x + y * width);

                if(y == 0) {
                    up = 0; //random.randomInt(0, range - 1);
                } else {
                    var upIndex = 4 * (x + (y - 1) * width) + 1;
                    up = map.data[upIndex];
                }

                var wobble = random.randomInt(0, 8 );
                var leftOffset = random.randomInt(floor(-wobble / 2), floor(wobble / 2));

                var upWobble = wobble - hxd.Math.abs(leftOffset);
                var upOffset = random.randomInt(-floor(upWobble / 2), floor(upWobble / 2));

                right = floor(hxd.Math.clamp(left + leftOffset, 0, range - 1));
                down = floor(hxd.Math.clamp(up + upOffset, 0, range - 1));

                map.data[index + 0] = right;
                map.data[index + 1] = down;
                map.data[index + 2] = left;
                map.data[index + 3] = up;

                left = map.data[index + 0];
            }
        }
    }
    
    override function init() {
        super.init();
        settings = new Settings();
        settings.save();
        random = new Random();
        random.setStringSeed("hello");

        colours = new Array();
        var cLength = 16;
        var cOffset = random.random() * 360;
        for(i in 0...cLength) {
            colours[i] = Hsluv.hsluvToHex([360.0 * i / cLength + cOffset, 100.0, (i / (cLength - 1)) * 50.0]) + "FF";
        }

        wangMap = new WangMap(settings.xTileCount, settings.yTileCount, colours);
        generateMap(wangMap);
        rescale();

        hxd.Window.getInstance().addResizeEvent(rescale);
    }

    override function update(dt:Float) {
        if(Key.isPressed(Key.ESCAPE)) {
            hxd.System.exit();
        } else if(Key.isDown(Key.SPACE)) {
            generateMap(wangMap);
            this.rescale();
        }
    }

    static function main() {
        new Main();
    }
}