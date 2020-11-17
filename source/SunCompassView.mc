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
    
        dc.setColor(Graphics.COLOR_TRANSPARENT, Graphics.COLOR_BLACK);
        dc.clear();
 
        self.renderDial(dc);
            
        if(loc) {
            self.renderUi(dc, loc);
        } else {
            dc.drawText(dc.getWidth() / 2,
                        dc.getHeight() / 2,
                        Graphics.FONT_MEDIUM,
                        "Loading...",
                        Graphics.TEXT_JUSTIFY_CENTER | Graphics.TEXT_JUSTIFY_VCENTER);
        }
        
    }
    
    function renderUi(dc, loc) {
        var nowAzimuth = loc ? sunMath.azimuth(inputs.hour(), loc, inputs) : 0;
        var sunriseAzimuth = loc ? sunMath.azimuth(sunMath.timeOf("sunrise", loc, inputs), loc, inputs) : 0;
        var sunsetAzimuth = loc ? sunMath.azimuth(sunMath.timeOf("sunset", loc, inputs), loc, inputs) : 0;
        
        self.renderText(dc, nowAzimuth);
        self.renderMark(dc, nowAzimuth, Graphics.COLOR_YELLOW);
        self.renderMark(dc, sunriseAzimuth, Graphics.COLOR_GREEN);
        self.renderMark(dc, sunsetAzimuth, Graphics.COLOR_GREEN); 
    }
    
    function renderText(dc, azimuth) {
        dc.setColor(Graphics.COLOR_BLUE, Graphics.COLOR_TRANSPARENT);
        var text = azimuth.format("%d");
        dc.drawText(dc.getWidth() / 2,
                    dc.getHeight() * .35,
                    Graphics.FONT_LARGE,
                    text,
                    Graphics.TEXT_JUSTIFY_CENTER);
                    
        dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_TRANSPARENT);
        var info =  inputs.lat(loc).format("%0.2f") + "," + inputs.lng(loc).format("%0.2f");
        dc.drawText(dc.getWidth() / 2,
                    dc.getHeight() * 0.5,
                    Graphics.FONT_TINY,
                    info,
                    Graphics.TEXT_JUSTIFY_CENTER);                       
 
        dc.drawText(dc.getWidth() / 2,
                    dc.getHeight() * 0.6,
                    Graphics.FONT_TINY,
                    locStatus,
                    Graphics.TEXT_JUSTIFY_CENTER);                       
               
    }

    function renderDial(dc) {
        var i = 0;
        for(i = 0; i < 360; i += 15) {
            if(i % 90 == 0) {
                var colors = [ Graphics.COLOR_RED, Graphics.COLOR_YELLOW, Graphics.COLOR_PURPLE, Graphics.COLOR_YELLOW ];
                self.renderDot(dc, i, colors[i / 90], 5);
            } else {
                self.renderDot(dc, i, Graphics.COLOR_LT_GRAY, 2);
            }
        }
    }

    
    function renderMark(dc, azimuth, color) {
        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        dc.setPenWidth(5);
        var s = self.polToRect(dc, dc.getWidth() / 2 - 30, azimuth);
        var e = self.polToRect(dc, dc.getWidth() / 2 - 5, azimuth);
        dc.drawLine(s[0], s[1], e[0], e[1]);
        
    }
    
    function renderDot(dc, degrees, color, diameter) {
        var p = self.polToRect(dc, dc.getWidth() / 2 - 15, degrees);
        dc.setColor(color, Graphics.COLOR_TRANSPARENT);
        dc.fillCircle(p[0], p[1], diameter);
    }
    
    function polToRect(dc, radius, degrees) {
        var a = Math.toRadians(degrees - 90);
        var oX = (radius * Math.cos(a));
        var oY = (radius * Math.sin(a));
        var centerX = dc.getWidth() / 2;
        var centerY = dc.getHeight() / 2;   
        return [centerX + oX, centerY + oY];
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
