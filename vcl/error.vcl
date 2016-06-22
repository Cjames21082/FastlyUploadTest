sub vcl_error {
#FASTLY error
	/* handle 503s */
 if (obj.status >= 500 && obj.status < 600) {

   /* deliver stale object if it is available */
   if (stale.exists) {
     return(deliver_stale);
   }

   /* otherwise, return a synthetic */

   /* include your HTML response here */
   synthetic {"<!DOCTYPE html><html>We will be back shortly!</html>"};
   return(deliver);
 }

}