using Toybox.WatchUi;
using Toybox.System;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.Position;


class SunCompassView extends WatchUi.View {

	var loc = null;
	var inputs = null;
	var math = null;

    function initialize() {
        View.initialize();
        inputs = new SunCompassInputs();
        math = new SunCompassMath();
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
        if(loc) {
	        var lstm = math.localStandardTimeMerdian(inputs.tzOffset());
	        var eot = math.equationOfTime(inputs.dayOfYear());
	        var tcf  = math.timeCorrectionFactor(inputs.lng(loc), lstm, eot);
	        var decl  = math.declination(inputs.dayOfYear());
	        var lst  = math.localSolarTime(inputs.hour(), tcf);
	        var hra = math.hourAngle(lst);
	        var elevation = math.elevation(decl, inputs.lat(loc), hra);
            var azimuth = math.azimuth(decl, inputs.lat(loc), hra);
	        
	        View.findDrawableById("loc").setText("(" + inputs.lat(loc).format("%.02f") + "," + inputs.lng(loc).format("%.02f") + ")");        
	        View.findDrawableById("info").setText(azimuth.format("%.02f"));       
	     } else {
	        View.findDrawableById("loc").setText("(??, ??)");	   
	        View.findDrawableById("info").setText("??");
	     }
        View.onUpdate(dc);
    }

	
    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

}
