sub construct_skey {
  # will apply surrogate keys for each level of the heirarchy
  # including the filename for up to 15 levels of heirarchy.
  # This technique can be extended

  if (req.url ~ "^(/[^/\?]*)(/[^/\?]*)?(/[^/\?]*)?(/[^/\?]*)?(/[^/\?]*)?(/[^/\?]*)?(/[^/\?]*)?(/[^/\?]*)?(/[^/\?]*)?" && !std.strstr(beresp.http.Surrogate-Key,re.group.1)) {
    if (!re.group.1) {
      return;
    }
    set req.http.skey = re.group.1;
    set beresp.http.Surrogate-Key = if(beresp.http.Surrogate-Key, beresp.http.Surrogate-Key " ", "") req.http.skey;

    if (!re.group.2) {
      return;
    }
    set req.http.skey = req.http.skey re.group.2;
    set beresp.http.Surrogate-Key = beresp.http.Surrogate-Key " " req.http.skey;

    if (!re.group.3) {
      return;
    }
    set req.http.skey = req.http.skey re.group.3;
    set beresp.http.Surrogate-Key = beresp.http.Surrogate-Key " " req.http.skey;

    if (!re.group.4) {
      return;
    }
    set req.http.skey = req.http.skey re.group.4;
    set beresp.http.Surrogate-Key = beresp.http.Surrogate-Key " " req.http.skey;

    if (!re.group.5) {
      return;
    }
    set req.http.skey = req.http.skey re.group.5;
    set beresp.http.Surrogate-Key = beresp.http.Surrogate-Key " " req.http.skey;

    if (!re.group.6) {
      return;
    }
    set req.http.skey = req.http.skey re.group.6;
    set beresp.http.Surrogate-Key = beresp.http.Surrogate-Key " " req.http.skey;

    if (!re.group.7) {
      return;
    }
    set req.http.skey = req.http.skey re.group.7;
    set beresp.http.Surrogate-Key = beresp.http.Surrogate-Key " " req.http.skey;

    if (!re.group.8) {
      return;
    }
    set req.http.skey = req.http.skey re.group.8;
    set beresp.http.Surrogate-Key = beresp.http.Surrogate-Key " " req.http.skey;

    if (!re.group.9) {
      return;
    }
    set req.http.skey = req.http.skey re.group.9;
    set beresp.http.Surrogate-Key = beresp.http.Surrogate-Key " " req.http.skey;

    if (!req.url ~ "^(/[^/\?]+){10}"){
      return;
    }

   set req.http.skey = req.http.skey re.group.1;
   set beresp.http.Surrogate-Key = beresp.http.Surrogate-Key " " req.http.skey;

   if (!req.url ~ "^(/[^/\?]+){11}"){
     return;
   }
   set req.http.skey = req.http.skey re.group.1;
   set beresp.http.Surrogate-Key = beresp.http.Surrogate-Key " " req.http.skey;

   if (!req.url ~ "^(/[^/\?]+){12}"){
     return;
   }
   set req.http.skey = req.http.skey re.group.1;
   set beresp.http.Surrogate-Key = beresp.http.Surrogate-Key " " req.http.skey;

    if (!req.url ~ "^(/[^/\?]+){13}"){
     return;
   }
   set req.http.skey = req.http.skey re.group.1;
   set beresp.http.Surrogate-Key = beresp.http.Surrogate-Key " " req.http.skey;

    if (!req.url ~ "^(/[^/\?]+){14}"){
     return;
   }
   set req.http.skey = req.http.skey re.group.1;
   set beresp.http.Surrogate-Key = beresp.http.Surrogate-Key " " req.http.skey;

    if (!req.url ~ "^(/[^/\?]+){15}"){
     return;
   }
   set req.http.skey = req.http.skey re.group.1;
   set beresp.http.Surrogate-Key = beresp.http.Surrogate-Key " " req.http.skey;
  }
}
