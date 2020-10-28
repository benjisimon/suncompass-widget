using Toybox.WatchUi;
using Toybox.System;
using Toybox.Time;
using Toybox.Time.Gregorian;
using Toybox.Position;
using Toybox.Application.Storage;


class SunCompassView extends WatchUi.View {

	var loc = null;
	var locStatus = null;
	var inputs = null;
	var sunMath = null;

    function initialize() {
        View.initialize();
        inputs = new SunCompassInputs();
        sunMath = new SunCompassMath();
        Position.enableLocationEvents( Position.LOCATION_ONE_SHOT, method(:onPosition));        
    }

	function onPosition(info) {
		loc = info.position;
		locStatus = "fresh";
		Application.Storage.setValue("location", info.position.toDegrees());
		WatchUi.requestUpdate();
	}

    // Load your resources here
    function onLayout(dc) {
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
        if(loc == null) {
            guessLoc();
        }
    
        var azimuth = loc ? sunMath.azimuth(loc, inputs) : "??";
        
        dc.setColor(Graphics.COLOR_TRANSPARENT, Graphics.COLOR_BLACK);
        dc.clear();
        renderText(dc, azimuth);
        renderDial(dc, azimuth);
    }
    
    function renderText(dc, azimuth) {
        dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
        var text = azimuth.format("%d");
        dc.drawText(dc.getWidth() / 2,
                    dc.getHeight() * .38,
                    Graphics.FONT_LARGE,
                    text,
                    Graphics.TEXT_JUSTIFY_CENTER);
                    
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        var info = "(" + inputs.lat(loc).format("%0.2f") + "," + inputs.lng(loc).format("%0.2f") + "," + locStatus + ")";
        dc.drawText(dc.getWidth() / 2,
                    dc.getHeight() * 0.6,
                    Graphics.FONT_TINY,
                    info,
                    Graphics.TEXT_JUSTIFY_CENTER);                  
        
    }

    function renderDial(dc, azimuth) {
      dc.setColor(Graphics.COLOR_RED, Graphics.COLOR_TRANSPARENT);
      dc.drawText(dc.getWidth() / 2, 0, Graphics.FONT_MEDIUM, "N", Graphics.TEXT_JUSTIFY_CENTER);
      dc.drawText(dc.getWidth(), dc.getHeight() / 2 - textHeight(dc, "E") / 2, Graphics.FONT_MEDIUM, "E", Graphics.TEXT_JUSTIFY_RIGHT);
      dc.drawText(dc.getWidth() / 2, dc.getHeight() - textHeight(dc, "S"), Graphics.FONT_MEDIUM, "S", Graphics.TEXT_JUSTIFY_CENTER);
      dc.drawText(0, dc.getHeight() / 2 - textHeight(dc, "W") / 2, Graphics.FONT_MEDIUM, "W", Graphics.TEXT_JUSTIFY_LEFT);      
    }
    
    function textHeight(dc, text) {
        return dc.getTextDimensions(text, Graphics.FONT_MEDIUM)[1];
    }

    function guessLoc() {
        var lastLoc = Application.Storage.getValue("location");
        if(lastLoc != null) {
            locStatus = "stale";
            loc = new Position.Location({ 
                    :latitude => lastLoc[0],
                    :longitude => lastLoc[1],
                    :format => :degrees 
                }); 
         }
    }
	
    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

}
