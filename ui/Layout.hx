package ui;

class Layout extends h2d.Flow {
    public var style:h2d.domkit.Style;
    public function new(app, ?parent) {
        super(parent);

        style = new h2d.domkit.Style();
        style.load(hxd.Res.css.ui);
        layout = h2d.Flow.FlowLayout.Vertical;
        horizontalAlign = h2d.Flow.FlowAlign.Right;

        var button = new UIElements.Button(this);
        button.label = "settings";

        var flow = new h2d.Flow(this);
        flow.minWidth = 100;
        flow.minHeight = 100;
        flow.layout = h2d.Flow.FlowLayout.Vertical;
        flow.verticalAlign = h2d.Flow.FlowAlign.Top;
        flow.horizontalAlign = h2d.Flow.FlowAlign.Right;
        flow.verticalSpacing = 2;
        flow.visible = false;

        button.onClick = function() {
            if(button.label == "settings") {
                button.label = "hide";
                flow.visible = true;
            } else {
                button.label = "settings";
                flow.visible = false;
            }
        }

        style.addObject(button);

        function convertFromInteger(a:String):Dynamic {
            return Std.parseInt(a);
        }
        
        var setting_fields = Reflect.fields(Global.settings);
        setting_fields.map(function (field) {
            var value = Reflect.field(Global.settings, field);

            var setting = new UIElements.Setting(flow);
            if(Std.is(value, Int)) {
                setting.convertFrom = convertFromInteger;
            }
            
            setting.horizontalAlign = h2d.Flow.FlowAlign.Right;
            setting.label = field;

            setting.input = value;
            setting.inputDom.onChange = function() {
                Reflect.setField(Global.settings, field, setting.input);
                app.updateMap();
            }
            style.addObject(setting);
            
            return setting;
        });
    }
}