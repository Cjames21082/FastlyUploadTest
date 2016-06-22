sub vcl_fetch {

   call construct_skey;

  /* handle 5XX (or any other unwanted status code) */
  if (beresp.status >= 500 && beresp.status < 600) {

    /* deliver stale if the object is available */
    if (stale.exists) {
      return(deliver_stale);
    }

    if (req.restarts < 1 && (req.request == "GET" || req.request == "HEAD")) {
      restart;
    }

    /* else go to vcl_error to deliver a synthetic */
    error 503;

  }

  /* set stale_if_error and stale_while_revalidate (customize these values) */
  set beresp.stale_if_error = 86400s;
  set beresp.stale_while_revalidate = 60s;

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

 /* this code will never be run, commented out for clarity */
 /* if (beresp.status == 500 || beresp.status == 503) {
   set req.http.Fastly-Cachetype = "ERROR";
   set beresp.ttl = 1s;
   set beresp.grace = 5s;
   return (deliver);
 } */

 if (beresp.http.Expires || beresp.http.Surrogate-Control ~ "max-age" || beresp.http.Cache-Control ~"(s-maxage|max-age)") {
   # keep the ttl here
 } else {
   # apply the default ttl
   set beresp.ttl = 3600s;
 }

 return(deliver);
}
