import hxd.Save;
import h2d.Flow;

class Global {
    static public var settings:data.Data.Settings;

    static public function init() {
        initSettings();
    }

    static public function initSettings() {
        data.Data.load(hxd.Res.loader.load("data.cdb").entry.getText());
        settings = data.Data.settings.all[0];
        applyLocale(data.Data.global_settings.all[0].locale.toInt());
    }

    static public function applyLocale(localeIndex) {
        var locales = data.Data.Global_settings_locale.NAMES;
        var localeName = locales[localeIndex];
        var localization = hxd.Res.loader.load('locales/${localeName}.xml').entry.getText();
        data.Data.applyLang(localization);
    }

    static public function save() {
        Save.save(settings, "settings");
    }

    static public function load() {
        settings = Save.load(settings, "settings");
    }
}