using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;

class SunCompassDelegate extends WatchUi.InputDelegate {

    function initialize() {
        InputDelegate.initialize();
    }
    
    function onKey(evt) {
        if(evt.getKey() == WatchUi.KEY_ENTER) {
            nextCompassView();
            return true;
        } else {
            return false;
        }
    }
}
    