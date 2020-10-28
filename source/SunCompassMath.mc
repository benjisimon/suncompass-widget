//
// Implement math needed for our sun compass. See:
// http://www.blogbyben.com/2019/01/go-towards-light-direction-and-time.html
//

class SunCompassMath {

    function localStandardTimeMerdian(tzOffset) {
        return 15 * tzOffset;
    }    
    
    function equationOfTime(dayOfYear) {
        var b = Math.toRadians((360.0 / 365.0) * (dayOfYear - 81));
        return (9.87 * Math.sin(2 * b)) -
               (7.53 * Math.cos(b)) -
               (1.5 * Math.sin(b));
    }

    function timeCorrectionFactor(lng, lstm, eot) {
        return 4 * (lng - lstm) + eot; 
    }

    function declination(dayOfYear) {
        var x = (360.0 / 365.0) * (dayOfYear - 81);
        return 23.45 * Math.sin(Math.toRadians(x));
    }

    function localSolarTime(hour, tcf) {
        return hour + (tcf / 60.0);
    }
    
    function hourAngle(lst) {
        return (15 * (lst - 12));
    }
    
    function elevation(decl, lat, hra) {
        var declR = Math.toRadians(decl);
        var latR  = Math.toRadians(lat);
        var hraR  = Math.toRadians(hra);
        
        var a = Math.sin(declR) * Math.sin(latR);
        var b = Math.cos(declR) * Math.cos(latR) * Math.cos(hraR);
        var c = a + b;
        return Math.toDegrees(Math.asin(c));
    }
    
    function azimuth(decl, lat, hra) {
        var declR = Math.toRadians(decl);
        var latR  = Math.toRadians(lat);
        var hraR  = Math.toRadians(hra);
        var e     = self.elevation(decl, lat, hra);
        var eR    = Math.toRadians(e);
        
        var a = Math.sin(declR) * Math.cos(latR);
        var b = Math.cos(declR) * Math.sin(latR) * Math.cos(hraR);
        var c = a - b;
        var d = Math.toDegrees(Math.acos(c / Math.cos(eR)));
        return hra < 0 ? d : (360 - d);
    }
}