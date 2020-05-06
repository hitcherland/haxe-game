class Main extends hxd.App {
    var bmp : h2d.Bitmap;
    var anim : h2d.Anim;
    var interaction : h2d.Interactive;

    override function init() {
        var width:Int = hxd.Math.floor(s2d.width * 0.2);
        var height:Int = hxd.Math.floor(s2d.height * 0.2);

        if(width > height)
            width = height;
        else
            height = width;

        var t1 = h2d.Tile.fromColor(0xFF0000, width, height);
        var t2 = h2d.Tile.fromColor(0x00FF00, width, height);
        var t3 = h2d.Tile.fromColor(0x0000FF, width, height);
        for(t in [t1, t2, t3]) {
            t.dx = -t.width / 2;
            t.dy = -t.height / 2;
        }
        anim = new h2d.Anim([t1, t2, t3], s2d);
        anim.speed = 1;
        anim.onAnimEnd = function() {
            trace("animation ended");
        }

        anim.x = s2d.width * 0.5;
        anim.y = s2d.height * 0.5;

        var tf = new h2d.Text(hxd.res.DefaultFont.get(), s2d);
        tf.text = "Hello World !";
        tf.textAlign = Center;
        tf.x = s2d.width * 0.5;

        interaction = new h2d.Interactive(width, height, anim);
        interaction.onOver = function(event: hxd.Event) {
            anim.alpha = 0.7;
        }
        interaction.onOut = function(event: hxd.Event) {
            anim.alpha = 1.0;
        }
    }

    override function update(dt:Float) {
        //anim.rotation += 0.1 * dt;
    }
    static function main() {
        new Main();
    }
}