package htd;
import h2d.Text;
import h2d.TextInput;

class TextGenericBackground<T:h2d.Text> extends h2d.Bitmap {
    public var backgroundColor:Int = 0x000000;
    public var padding:Int=2;
    public var textChild:T;
    public var text(get, set):String;
    public var minWidth:Null<Int> = null;
    public var minHeight:Null<Int> = null;

    public function new(textChild:T, ?parent) {
        super(null, parent);
        this.addChild(textChild);
        this.textChild = textChild;
        resize();
    }

    function set_text(t:String):String {
        textChild.text = t;
        resize();
        return textChild.text;
    }
    function get_text():String {
        return textChild.text;
    }

    public function resize() {
        var bounds = new h2d.col.Bounds();

        textChild.getBoundsRec(this, bounds, true);
        var w:Int = Math.ceil(bounds.width) + 2 * padding;
        if(minWidth != null && w < minWidth) {
            w = minWidth;
        }
        var h:Int = Math.ceil(bounds.height) + 2 * padding;
        if(minHeight != null && h < minHeight) {
            h = minHeight;
        }
        textChild.x = padding;
        textChild.y = padding;
        var tile = h2d.Tile.fromColor(this.backgroundColor, w, h);
        this.tile = tile;
        width = w;
        height = h;

    }

    override function sync(ctx) {
        resize();
		super.sync(ctx);
	}
}

typedef TextBackground = TextGenericBackground<Text>;
typedef TextInputBackground = TextGenericBackground<TextInput>;