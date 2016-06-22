sub vcl_miss {
#FASTLY miss
  if (req.backend != shield_lax_ca_us) {
    call waf_syslog;
  }
  return(fetch);
}
