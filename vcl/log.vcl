sub vcl_log {
  # custom syslog
  set req.http.X-Shield = "0";
  if (req.http.fastly-ff) { set req.http.X-Shield = "1"; }

  if(fastly_info.state !~ "(PASS|MISS)"){
    log {"syslog 1tI08tdp19DxuKjEeOyst8 wordpress_logs :: "}
    {" client_ip="}     req.http.Fastly-Client-IP
    {" timestamp="}     now.sec
    {" request="}       req.request
    {" host="}          req.http.host
    {" url="}           {"""}req.url{"""}
    {" contenttype="}   resp.http.content-type
    {" status="}        resp.status
    {" infostate="}     fastly_info.state
    {" setcookie="}     {"""}resp.http.Set-Cookie{"""}
    {" size="}          resp.bytes_written
    {" pop="}           server.datacenter
    {" shield="}        req.http.x-shield
    {" server_region="} server.region
    {" continent="}     geoip.continent_code
    {" country="}       geoip.country_code
    {" region="}        geoip.region
    {" referrer="}      {"""}req.http.referer{"""}
    {" useragent="}     req.http.Orig-User-Agent
    {" device="}        req.http.X-UA-Device
    {" vary="}          {"""}resp.http.vary{"""}
    {" hits="}          obj.hits
    {" restarts="}      req.restarts
    {" elapsed="}       time.elapsed.msec;
  }
}


