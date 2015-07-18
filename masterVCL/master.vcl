# mylifetime_main.vcl
include "device_detect";
include "redirect";

sub vcl_recv {
#FASTLY recv
    # set device-type request header X-UA-Device
    call detect_device;

    #set custom reqeuest headers
    set req.http.X-Original-Url = req.url;
    set req.http.X-CountryCode = geoip.country_code;
    set req.http.X-Client-IP = client.ip;

    #check url against 301 redirect table
    set req.http.X-Redirect = table.lookup(url_301_redirect,req.url);
    if (req.http.X-Redirect) {
      error 701 req.http.X-Redirect;
    }
    unset req.http.X-Redirect;

    #check url against 302 redirect table
    set req.http.X-Redirect = table.lookup(url_302_redirect,req.url);
    if (req.http.X-Redirect) {
      error 702 req.http.X-Redirect;
    }
    unset req.http.X-Redirect;

    # from fastly base config
    if (req.request != "HEAD" && req.request != "GET" && req.request != "FASTLYPURGE") {
      return(pass);
    }

    return(lookup);
}

sub vcl_fetch {
set beresp.do_stream = true;
#FASTLY fetch

  if ((beresp.status == 500 || beresp.status == 503) && req.restarts < 1 && (req.request == "GET" || req.request == "HEAD")) {
    restart;
  }

  if(req.restarts > 0 ) {
    set beresp.http.Fastly-Restarts = req.restarts;
  }

  if (beresp.http.Set-Cookie) {
    set req.http.Fastly-Cachetype = "SETCOOKIE";
    return (pass);
  }

  if (beresp.http.Cache-Control ~ "private") {
    set req.http.Fastly-Cachetype = "PRIVATE";
    return (pass);
  }

  if (beresp.status == 500 || beresp.status == 503) {
    set req.http.Fastly-Cachetype = "ERROR";
    set beresp.ttl = 1s;
    set beresp.grace = 5s;
    return (deliver);
  }

  if (beresp.http.Expires || beresp.http.Surrogate-Control ~ "max-age" || beresp.http.Cache-Control ~"(s-maxage|max-age)") {
    # keep the ttl here
  } else {
    # apply the default ttl (15min)
    set beresp.ttl = 900s;
  }

  return(deliver);
}

sub vcl_hit {
#FASTLY hit

  if (!obj.cacheable) {
    return(pass);
  }
  return(deliver);
}

sub vcl_miss {
#FASTLY miss
  return(fetch);
}

sub vcl_deliver {
#FASTLY deliver
  return(deliver);
}

sub vcl_error {
  if (obj.status == 701) {
    if(req.is_ssl){
      set obj.http.Location = "https://" req.http.host obj.response;
    } else {
      set obj.http.Location = "http://" req.http.host obj.response;
    }
    set obj.status = 301;
    set obj.response = "Moved Permanently";
    return(deliver);
  }
  if (obj.status == 702) {
    if(req.is_ssl){
      set obj.http.Location = "https://" req.http.host obj.response;
    } else {
      set obj.http.Location = "http://" req.http.host obj.response;
    }
    set obj.status = 302;
    set obj.response = "Found";
    return(deliver);
  }

#FASTLY error
}

sub vcl_pass {
#FASTLY pass
}