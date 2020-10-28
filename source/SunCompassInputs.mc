//
// Class to access all our inputs
//

using Toybox.WatchUi;
using Toybox.System;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.Position;

class SunCompassInputs {

	function dayOfYear() {
		var janFirst = Gregorian.moment({
			:day => 1,
			:month => Gregorian.MONTH_JANUARY
		});
		var today = Gregorian.moment({});
		var diff = today.subtract(janFirst);
		return (diff.value() / (60*60*24)); 
	}

	function lat(info) {
		return info.position.toDegrees()[0];
	}
	
	function lng(info) {
		return info.position.toDegrees()[1];
	}
	
	function tzOffset() {
		var t = System.getClockTime();
		return (t.timeZoneOffset / (60 * 60));
	}
	
	function hour() {
	   var t = System.getClockTime();
	   return t.hour + (t.min / 60.0);
	
	}
}