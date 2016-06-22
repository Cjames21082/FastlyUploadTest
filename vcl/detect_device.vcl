# based on https://github.com/varnish/varnish-devicedetect/blob/master/devicedetect.vcl

sub detect_device {
    unset req.http.X-UA-Device;
    unset req.http.X-UA-Vendor;
    set req.http.Orig-User-Agent = req.http.User-Agent;

    set req.http.X-UA-Device = "desktop";
    set req.http.X-UA-Vendor = "generic";

    # Handle that a cookie or url param may override the detection altogether
    if (req.url ~ "[&|?]device_force=([^&\s]+)") {
        set req.http.X-UA-Device = regsub(req.url, ".*[&|?]device_force=([^&\s]+).*", "\1");
    } elsif (req.http.Cookie ~ "(?i)X-UA-Device-force") {
        # ;?? means zero or one ;, non-greedy to match the first
        set req.http.X-UA-Device = regsub(req.http.Cookie, "(?i).*X-UA-Device-force=([^;]+);??.*", "\1");
        # Clean up our mess in the cookie header
        set req.http.Cookie = regsuball(req.http.Cookie, "(^|; ) *X-UA-Device-force=[^;]+;? *", "\1");
        # If the cookie header is now empty, or just whitespace, unset it
        if (req.http.Cookie ~ "^ *$") { unset req.http.Cookie; } # "$ # stupid syntax highlighter
    } else {
        if (req.http.User-Agent ~ "(?i)(ads|google|bing|msn|yandex|baidu|ro|career|)bot" ||
            req.http.User-Agent ~ "(?i)(baidu|jike|symantec)spider" ||
            req.http.User-Agent ~ "(?i)scanner" ||
            req.http.User-Agent ~ "(?i)(web)crawler") {
            set req.http.X-UA-Device = "bot";
        } elsif (req.http.User-Agent ~ "(?i)ipad") {
            set req.http.X-UA-Device = "tablet";
            set req.http.X-UA-Vendor = "apple";
        } elsif (req.http.User-Agent ~ "(?i)ip(hone|od)") {
            set req.http.X-UA-Device = "smartphone";
            set req.http.X-UA-Vendor = "apple";
        # how do we differ between an android phone and an android tablet?
        #   http://stackoverflow.com/questions/5341637/how-do-detect-android-tablets-in-general-useragent
        #   http://googlewebmastercentral.blogspot.com/2011/03/mo-better-to-also-detect-mobile-user.html
        } elsif (req.http.User-Agent ~ "(?i)android.*(mobile|mini)") {
            set req.http.X-UA-Device = "smartphone";
            set req.http.X-UA-Vendor = "android";
        # android 3/honeycomb was just about tablet-only, and any phones will probably handle a bigger page layout
        } elsif (req.http.User-Agent ~ "(?i)android") {
            set req.http.X-UA-Device = "tablet";
            set req.http.X-UA-Vendor = "android";
        # see http://my.opera.com/community/openweb/idopera/
        } elsif (req.http.User-Agent ~ "Opera Mobi") {
            set req.http.X-UA-Device = "smartphone";
            set req.http.X-UA-Vendor = "android";
        } elsif (req.http.User-Agent ~ "PlayBook; U; RIM Tablet") {
            set req.http.X-UA-Device = "tablet";
            set req.http.X-UA-Vendor = "blackberry";
        } elsif (req.http.User-Agent ~ "hp-tablet.*TouchPad") {
            set req.http.X-UA-Device = "tablet";
            set req.http.X-UA-Vendor = "hp";
        } elsif (req.http.User-Agent ~ "Kindle/3") {
            set req.http.X-UA-Device = "tablet";
            set req.http.X-UA-Vendor = "kindle";
        } elsif (req.http.User-Agent ~ "Mobile.+Firefox") {
            set req.http.X-UA-Device = "mobile";
            set req.http.X-UA-Vendor = "firefoxos";
        } elsif (req.http.User-Agent ~ "^HTC") {
            set req.http.X-UA-Device = "smartphone";
            set req.http.X-UA-Vendor = "htc";
        } elsif (req.http.User-Agent ~ "Fennec") {
            set req.http.X-UA-Device = "smartphone";
            set req.http.X-UA-Vendor = "fennec";
        } elsif (req.http.User-Agent ~ "IEMobile") {
            set req.http.X-UA-Device = "smartphone";
            set req.http.X-UA-Vendor = "microsoft";
        } elsif (req.http.User-Agent ~ "BlackBerry" || req.http.User-Agent ~ "BB10.*Mobile") {
            set req.http.X-UA-Device = "smartphone";
            set req.http.X-UA-Vendor = "blackberry";
        } elsif (req.http.User-Agent ~ "GT-.*Build/GINGERBREAD") {
            set req.http.X-UA-Device = "smartphone";
            set req.http.X-UA-Vendor = "android";
        } elsif (req.http.User-Agent ~ "SymbianOS.*AppleWebKit") {
            set req.http.X-UA-Device = "smartphone";
            set req.http.X-UA-Vendor = "symbian";
        } elsif (req.http.User-Agent ~ "(?i)symbian" ||
            req.http.User-Agent ~ "(?i)^sonyericsson" ||
            req.http.User-Agent ~ "(?i)^nokia" ||
            req.http.User-Agent ~ "(?i)^samsung" ||
            req.http.User-Agent ~ "(?i)^lg" ||
            req.http.User-Agent ~ "(?i)bada" ||
            req.http.User-Agent ~ "(?i)blazer" ||
            req.http.User-Agent ~ "(?i)cellphone" ||
            req.http.User-Agent ~ "(?i)iemobile" ||
            req.http.User-Agent ~ "(?i)midp-2.0" ||
            req.http.User-Agent ~ "(?i)u990" ||
            req.http.User-Agent ~ "(?i)netfront" ||
            req.http.User-Agent ~ "(?i)opera mini" ||
            req.http.User-Agent ~ "(?i)palm" ||
            req.http.User-Agent ~ "(?i)nintendo wii" ||
            req.http.User-Agent ~ "(?i)playstation portable" ||
            req.http.User-Agent ~ "(?i)portalmmm" ||
            req.http.User-Agent ~ "(?i)proxinet" ||
            req.http.User-Agent ~ "(?i)sonyericsson" ||
            req.http.User-Agent ~ "(?i)symbian" ||
            req.http.User-Agent ~ "(?i)windows\ ?ce" ||
            req.http.User-Agent ~ "(?i)winwap" ||
            req.http.User-Agent ~ "(?i)eudoraweb" ||
            req.http.User-Agent ~ "(?i)htc" ||
            req.http.User-Agent ~ "(?i)240x320" ||
            req.http.User-Agent ~ "(?i)avantgo") {
            set req.http.X-UA-Device = "mobile";
        }
    }
        set req.http.User-Agent = req.http.X-UA-Device;

}