import hsluv.Hsluv;
import hxd.Key;
import hxd.Math.floor;
import seedyrng.Random;
import h2d.Bitmap;

import WangMap.WangMap;

typedef TiledMapData = { layers:Array<{ data:Array<Int>}>, tilewidth:Int, tileheight:Int, width:Int, height:Int };

class Main extends hxd.App {
    var random:Random = new Random();
    var colours:Array<String>;
    var wangMap:WangMap;

    var scaling:Float = 0.8;
    var _last_update = 0;

    var layers:h2d.Layers;
    var tileBmp:Bitmap;
    var bgBmp:Bitmap;

    override function init() {
        super.init();
        Global.init();

        tileBmp = new h2d.Bitmap();
        bgBmp = new h2d.Bitmap();

        layers = new h2d.Layers(s2d);
        layers.add(bgBmp, 0);
        layers.add(tileBmp, 1);

        var uiLayout = new ui.Layout(this, s2d);
        uiLayout.minWidth = s2d.width;
        uiLayout.minHeight = s2d.height;
        uiLayout.horizontalAlign = h2d.Flow.FlowAlign.Right;
        uiLayout.verticalAlign = h2d.Flow.FlowAlign.Top;
        //layers.add(uiLayout, 2);
        generateColours(16);
        wangMap = new WangMap(Global.settings.xTileCount,
            Global.settings.yTileCount,
            colours);

        //hxd.Save.delete("settings");
        load();
        //save();
    }
    
    function initRandom() {
        if(Global.settings.seed != null) {
            random.setStringSeed(Global.settings.seed);
        } else {
            random.setStringSeed("");
        }
    }

    override function onResize() {
		rescale();
	}

    function rescale() {
        var stage = hxd.Window.getInstance();
        var width = stage.width;
        var height = stage.height;
        var size = getSize(width, height);

        tileBmp.tile = wangMap.makeTileMap(size, size);
        tileBmp.x = (stage.width - size) / 2;
        tileBmp.y = (stage.height - size) / 2;

        bgBmp.tile = h2d.Tile.fromColor(0xFFFFFF, width, height);
    }

    function getSize(width:Int, height:Int) {
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
    
    function save() {
        Global.save();
    }

    function load() {
        Global.load();
        updateMap();
    }

    public function updateMap() {
        initRandom();
        generateColours(16);
        wangMap.width = Global.settings.xTileCount;
        wangMap.height = Global.settings.yTileCount;
        wangMap.typeMap = colours;
        generateMap(wangMap);
        rescale();
    }


    function generateColours(cLength:Int) {
        this.colours = new Array();
        var cOffset = random.random() * 360;
        for(i in 0...cLength) {
            this.colours[i] = Hsluv.hsluvToHex([-360.0 * i / cLength + cOffset, 100.0, 100 - (i / (cLength - 1)) * 80.0]) + "FF";
        }
    }

    override function update(dt:Float) {
        if(Key.isPressed(Key.ESCAPE)) {
            hxd.System.exit();
        } else if(Key.isDown(Key.SPACE) && _last_update + 10 < hxd.Timer.frameCount) {
            _last_update = hxd.Timer.frameCount;
            generateMap(wangMap);
            this.rescale();
        }
    }

    static function main() {
        hxd.Res.initEmbed();
        new Main();
    }
}