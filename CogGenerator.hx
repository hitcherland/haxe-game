import haxe.io.Bytes;
import hxd.Pixels;
import hxd.PixelFormat;

class DrawingStyle {
    public var lineThickness:Float = 1;
    public var lineColour:String = "#000000FF";
    public var fillColour:Null<String> = null;
    public function new(?lineThickness=100, ?lineColour="#000000FF", ?fillColour) {
        this.lineThickness = lineThickness;
        this.lineColour = lineColour;
        this.fillColour = fillColour;
    }
}

class CogGenerator {
    static public var style:DrawingStyle = new DrawingStyle();

    static function drawCircle(bytes:Bytes, size:Int, radius:Float) {
        var R = radius * radius;
        var dr = Math.pow(style.lineThickness / 2, 2);
        var lcb = Bytes.ofHex(style.lineColour.substring(1));
        var fcb;
        if(style.fillColour != null) {
            fcb = Bytes.ofHex(style.fillColour.substring(1));
        } else {
            fcb = null;
        }
        var c = size / 2;
        for(x in 0...size) {
            for(y in 0...size) {
                var r = hxd.Math.pow(x - c, 2) + hxd.Math.pow(y - c, 2);
                drawAlias(bytes, 4 * (x + y * size), lcb, fcb, r, R, dr);
            }
        }
    }

    public static function drawCogTeeth(bytes:Bytes, size:Int, nTeeth:Int, innerRadius:Float, outerRadius:Float) {
        var IR = innerRadius * innerRadius;
        var OR = outerRadius * outerRadius;
        var dr = Math.pow(style.lineThickness, 2);
        var lcb = Bytes.ofHex(style.lineColour.substring(1));
        var fcb;
        if(style.fillColour != null) {
            fcb = Bytes.ofHex(style.fillColour.substring(1));
        } else {
            fcb = null;
        }
        var c = size / 2;

        for(x in 0...size) {
            for(y in 0...size) {
                var angle = hxd.Math.atan2(y - c, x - c);
                var section = (angle + 2 * Math.PI) % (2 * Math.PI / nTeeth);
                var t = section / (2 * Math.PI / nTeeth);
                var R;
                var S = 0.2;
                if(t > 0.5 + S) {
                    R = OR;
                } else if (t > 0.5) {
                    var dt = (t - 0.5)/ S; 
                    R = hxd.Math.lerp(IR, OR, dt);
                } else if (t > S) {
                    R = IR;
                } else {
                    R = hxd.Math.lerp(OR, IR, t / S);
                }

                var r = hxd.Math.pow(x - c, 2) + hxd.Math.pow(y - c, 2);
                drawAlias(bytes, 4 * (x + y * size), lcb, fcb, r, R, dr);
            }
        }
    }

    /* this function doesn't handle the layering of transparency well */
    static function drawAlias(bytes:Bytes, index:Int, lineColour:Bytes, fillColour:Null<Bytes>, r:Float, R:Float, dr:Float) {
        var t = Math.abs(R - r) / dr;

        if(r >= R - dr && r <= R + dr) {
            var t = 1 - Math.pow(hxd.Math.abs(R - r) / dr, 1);
            trace(t);
            var fadeColour = lineColour.sub(0, lineColour.length);
            if(false) {
                fadeColour.set(3, hxd.Math.floor(t * 255));
            } else {
                for(I in 0...4) {
                    var p = bytes.get(index + I);
                    var n = fadeColour.get(I);

                    fadeColour.set(I, hxd.Math.floor((p * t + n * (1-t)) * 255));
                }

            }

            bytes.blit(index, fadeColour, 0, 4);
        } else if (r -dr < R && fillColour != null) {
            bytes.blit(index, fillColour, 0, 4);
        }
    }

    public static function generateCog(size:Int) {
        var nBytes = size * size * 4;
        var bytes = Bytes.alloc(nBytes);
        bytes.fill(0, nBytes, 0);

        drawCogTeeth(bytes, size, 9, 0.35 * size, size / 2 );

        var save = style.fillColour;
        style.fillColour = "#00000000";
        drawCircle(bytes, size, size * 0.1);
        style.fillColour = save;

        var pixels = new Pixels(size, size, bytes, PixelFormat.RGBA);
        return h2d.Tile.fromPixels(pixels);
    }
}