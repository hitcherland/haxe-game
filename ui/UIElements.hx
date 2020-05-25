package ui;

@:uiComp("setting")
class Setting extends h2d.Flow implements h2d.domkit.Object {

	static var SRC = <setting>
		<text public id="labelDom"/>
		<input public id="inputDom"/>
	</setting>

	public dynamic function convertTo(a:Dynamic):String {
		return '${a}';
	}

	public dynamic function convertFrom(a:String):Dynamic {
		return a;
	}

	public var label(get, set): String;
	function get_label() return labelDom.text;
	function set_label(s) {
		labelDom.text = s;
		return s;
	}

	public var input(get, set): Dynamic;
	function get_input() return convertFrom(inputDom.text);
	function set_input(s) {
		trace(s, convertTo(s));
		inputDom.text = convertTo(s);
		return s;
	}

	public function new(?parent:h2d.Object, ?convertFrom:Dynamic, ?convertTo:Dynamic) {
		super(parent);
		padding = 4;
		horizontalSpacing = 4;
		if(convertTo != null)
			this.convertTo = convertTo;

		if(convertFrom != null)
			this.convertFrom = convertFrom;
		initComponent();

		enableInteractive = true;
		interactive.onClick = function(_) onClick();
		interactive.onOver = function(_) {
			dom.hover = true;
		};
		interactive.onPush = function(_) {
			dom.active = true;
		};
		interactive.onRelease = function(_) {
			dom.active = false;
		};
		interactive.onOut = function(_) {
			dom.hover = false;
		};
	}

	public dynamic function onClick() {
	}
}

@:uiComp("button")
class Button extends h2d.Flow implements h2d.domkit.Object {

	static var SRC = <button>
		<text public id="labelDom"/>
	</button>

	public var label(get, set): String;
	function get_label() return labelDom.text;
	function set_label(s) {
		labelDom.text = s;
		return s;
	}

	public function new( ?parent ) {
		super(parent);
		padding = 4;
		initComponent();

		enableInteractive = true;
		interactive.onClick = function(_) onClick();
		interactive.onOver = function(_) {
			dom.hover = true;
		};
		interactive.onPush = function(_) {
			dom.active = true;
		};
		interactive.onRelease = function(_) {
			dom.active = false;
		};
		interactive.onOut = function(_) {
			dom.hover = false;
		};
	}

	public dynamic function onClick() {
	}
}