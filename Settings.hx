typedef SettingPairs = Map<String, Dynamic>;

class Settings {
    var loader:hxd.res.Loader;

    var dataPairs:SettingPairs;
    function getter(name) {
        return this.dataPairs[name];
    }

    function setter(name, value) {
        return this.dataPairs[name] = value;
    }

    @:isVar public var xTileCount(get, set):Int;
    @:isVar public var yTileCount(get, set):Int;

    function get_xTileCount() { return getter("xTileCount"); }
    function set_xTileCount(value:Int):Int { return setter("xTileCount", value); }

    function get_yTileCount() { return getter("yTileCount"); }
    function set_yTileCount(value:Int):Int { return setter("yTileCount", value); }

    public function new() {
        this.dataPairs = [
            "xTileCount" => 150,
            "yTileCount" => 150
        ];
        this.load();
    }

    public function load() {
        //dataPairs = hxd.Save.load(dataPairs, "settings");
    }

    public function save() {
        hxd.Save.save(this.dataPairs, "settings");
    }
}