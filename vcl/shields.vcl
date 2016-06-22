    set req.backend = main;

    {
    if (req.backend == main && req.restarts == 0) {
      if (server.identity !~ "-LAX$" && req.http.Fastly-FF !~ "-LAX") {
        set req.backend = shield_lax_ca_us;
      }
      if (!req.backend.healthy) {
        # the shield datacenter is broken so dont go to it
        set req.backend = main;
      }
    }
  }

