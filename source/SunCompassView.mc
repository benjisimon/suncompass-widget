using Toybox.WatchUi;
using Toybox.System;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.Position;


class SunCompassView extends WatchUi.View {

	var loc = null;
	var inputs = null;
	

    function initialize() {
        View.initialize();
        inputs = new SunCompassInputs();
        Position.enableLocationEvents( Position.LOCATION_CONTINUOUS, method(:onPosition));        
    }

	function onPosition(info) {
		loc = info;
		WatchUi.requestUpdate();
	}

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.MainLayout(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
        View.findDrawableById("tz").setText(inputs.tzOffset().format("%0d"));
        View.findDrawableById("loc").setText(loc ? (inputs.lat(loc).format("%.3f") + "," + inputs.lat(loc).format("%.3f")) : "N/A");
        View.findDrawableById("day_of_year").setText(inputs.dayOfYear().format("%d"));
        View.findDrawableById("hour").setText(inputs.hour().format("%.2f"));
        
        View.onUpdate(dc);
    }

	
    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

}
