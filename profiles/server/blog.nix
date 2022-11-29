{ inputs, ... }:
{
  services.nginx.virtualHosts."averyan.ru" = {
    root = inputs.averyanalex-blog.packages.x86_64-linux.blog;
    useACMEHost = "averyan.ru";
    forceSSL = true;
    kTLS = true;
    http3 = true;
  };
}
