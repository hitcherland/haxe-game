typedef TiledMapData = { layers:Array<{ data:Array<Int>}>, tilewidth:Int, tileheight:Int, width:Int, height:Int };

class Main extends hxd.App {
    var anim : h2d.Anim;
    var interaction : h2d.Interactive;
    var tf : h2d.Text;

    function rescale() {
        var stage = hxd.Window.getInstance();
        var size = getSize(stage.width, stage.height, 0.2);
        var tile = anim.getFrame();
        var actualSize = getSize(Std.int(tile.width), Std.int(tile.height), 1);
        var scale = size / actualSize;

        anim.setScale(scale);
        
        anim.x = stage.width / 2;
        anim.y = stage.height / 2;

        tf.x = stage.width / 2;
    }

    function getSize(width:Int, height:Int, scaling:Float) {
        var size:Int;
        if(height > width) {
            size = hxd.Math.floor(s2d.width * scaling);
        } else {
            size = hxd.Math.floor(s2d.height * scaling);
        }
        return size;
    }

    override function init() {
        super.init();
        var size:Int = getSize(s2d.width, s2d.height, 0.2);

        var mapData:TiledMapData = haxe.Json.parse(hxd.Res.wang_json.entry.getText());
        var tileImage = hxd.Res.wang_png.toTile();
        var group = new h2d.TileGroup(tileImage, s2d);

        var mw = mapData.width;
        var mh = mapData.height;
        var tw = mapData.tilewidth;
        var th = mapData.tileheight;

        var tiles = [
            for(y in 0 ... Std.int(tileImage.height / th))
            for(x in 0 ... Std.int(tileImage.width / tw))
            tileImage.sub(x * tw, y * th, tw, th)
        ];

        for(layer in mapData.layers) {
            // iterate on x and y
            for(y in 0 ... mh) for (x in 0 ... mw) {
                // get the tile id at the current position 
                var tid = layer.data[x + y * mw];
                if (tid != 0) { // skip transparent tiles
                    // add a tile to the TileGroup
                    group.add(x * tw, y * mapData.tilewidth, tiles[tid - 1]);
                }
            }
        }
        
        for(tile in tiles) {
            tile.dx = -tile.width / 2;
            tile.dy = -tile.height / 2;
        }

        anim = new h2d.Anim(tiles, s2d);
        anim.speed = 1;

        anim.x = s2d.width * 0.5;
        anim.y = s2d.height * 0.5;

        tf = new h2d.Text(hxd.res.DefaultFont.get(), s2d);
        tf.text = "Hello World !";
        tf.textAlign = Center;
        tf.x = s2d.width * 0.5;

        interaction = new h2d.Interactive(size, size, anim);
        interaction.x = size / -2;
        interaction.y = size / -2;

        interaction.onOver = function(event: hxd.Event) {
            anim.alpha = 0.7;
        }
        interaction.onOut = function(event: hxd.Event) {
            anim.alpha = 1.0;
        }

        rescale();

        hxd.Window.getInstance().addResizeEvent(function() {
            trace('resizing');
            rescale();
        });
    }

    override function update(dt:Float) {
        anim.rotation += 0.1 * dt;
    }

    static function main() {
        hxd.Res.initEmbed();
        new Main();
    }
}