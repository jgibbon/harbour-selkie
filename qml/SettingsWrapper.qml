/**
  Convenience Wrapper for easy QML Access/Manipulations.
 **/
import QtQuick 2.0
import selkie.settings 1.0

QtObject {
    property var values: ({})
    function set(key, value) {
        console.log('set', key, value, typeof value)
        if(typeof key === 'number') { //use enum
            csettings.setValue(key, value.toString());
        } else if(typeof key === 'string' && key in Settings) { //string for convenience
            csettings.setValue(Settings[key], value.toString());
        } else {
            console.log('set: key', key, 'not found in Settings. wanted to set value: ', value);
        }
    }

    property Settings settingsObj: csettings

    function _update(key, val) {
        /*
          overwriting the whole object comes with a small performance penalty,
          but enables easy value binding in qml.
        */
        var oldValues = JSON.parse(JSON.stringify(values));
        oldValues[key] = val;
        values = oldValues;
    }

    Component.onCompleted: {
        csettings.valueChanged.connect(function(key, val){
            console.log('CHANGED SETTING', key, val);
            _update(key, val);
        })
        //simple prefill of existing values
        csettings.keyFound.connect(function(key, val){
//            console.log('setting:', key, val);
            _update(key, val);
        })
        csettings.findKeys();
    }
}

