sub vcl_deliver {
  if (resp.status >= 500 && resp.status < 600) {

   /* restart if the stale object is available */
   if (stale.exists) {
     restart;
   }
 }

#FASTLY deliver
  return(deliver);
}
