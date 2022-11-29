{ config, ... }:

{
  age.secrets.creds-cloudflare.file = ../secrets/creds/cloudflare.age;

  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "alex@averyan.ru";
      dnsResolver = "1.1.1.1:53";
      dnsProvider = "cloudflare";
      credentialsFile = config.age.secrets.creds-cloudflare.path;
    };

    certs = {
      "averyan.ru" = {
        extraDomainNames = [ "*.averyan.ru" ];
      };
      "memefinder.ru" = {
        extraDomainNames = [ "*.memefinder.ru" ];
      };
    };
  };

  persist.state.dirs = [{ directory = "/var/lib/acme"; user = "acme"; group = "acme"; mode = "u=rwx,g=rx,o=rx"; }];
}
