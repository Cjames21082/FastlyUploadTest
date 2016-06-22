sub vcl_pass {
#FASTLY pass
  if (req.backend != shield_lax_ca_us) {
    call waf_syslog;
  }
}
