sub waf_syslog {
  log {"syslog 1tI08tdp19DxuKjEeOyst8 wordpress_logs :: "}

    {" client_ip="}     req.http.Fastly-Client-IP
    {" timestamp="}     now.sec
    {" request="}       req.request
    {" url="}           {"""}req.url{"""}
    {" waf_logged="}    waf.logged
    {" waf_blocked="}   waf.blocked
    {" waf_failures="}  waf.failures
    {" waf_rule_id="}   waf.rule_id
    {" waf_severity="}  waf.severity
    {" waf_logdata="}   waf.logdata
    {" waf_message="}   waf.message
    {" infostate="}     req.http.Fastly-Cachetype
    {" pop="}           server.datacenter
    {" useragent="}     req.http.Orig-User-Agent
    {" device="}        req.http.X-UA-Device;
}
