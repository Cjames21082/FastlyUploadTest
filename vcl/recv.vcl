sub vcl_recv {
	if (req.http.Fastly-FF) {
   		set req.max_stale_while_revalidate = 0s;
  	}

 	# call device detection
  	if (!req.http.Fastly-FF){
    	call detect_device;
  	}

#FASTLY recv


  include "shields.vcl"
	include "redirects.vcl";

	if (req.request != "HEAD" && req.request != "GET" && req.request != "FASTLYPURGE") {
      return(pass);
    }

    return(lookup);
}

