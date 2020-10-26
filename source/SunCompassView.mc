using Toybox.WatchUi;
using Toybox.System;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.Position;


class SunCompassView extends WatchUi.View {

	var loc = null;

    function initialize() {
        View.initialize();
        Position.enableLocationEvents( Position.LOCATION_CONTINUOUS, method(:onPosition));        
    }

	function onPosition(info) {
		loc = info.position;
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
    	View.findDrawableById("tz").setText(self.calcTz());
        View.findDrawableById("day_of_year").setText(self.calcDayOfYear());
        View.findDrawableById("loc").setText(self.calcLoc());
        View.onUpdate(dc);
    }

	function calcTz() {
		var t = System.getClockTime(); // ClockTime object
		return "Tz Off: " + (t.timeZoneOffset / (60 * 60)).format("%02d");
	}
	
	function calcDayOfYear() {
		var janFirst = Gregorian.moment({
			:day => 1,
			:month => Gregorian.MONTH_JANUARY
		});
		var today = Gregorian.moment({});
		var diff = today.subtract(janFirst);
		var days = (diff.value() / (60*60*24)) + 1;
		return "D of Y: " + days.format("%d");
	}
	
	function calcLoc() {
		return loc == null ? "??" : 
		       loc.toDegrees()[0].format("%.3f") + "," + 
		       loc.toDegrees()[1].format("%.3f");
	}

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

}
