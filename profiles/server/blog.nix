{
  inputs,
  pkgs,
  ...
}: {
  services.nginx.virtualHosts."averyan.ru" = {
    root = inputs.averyanalex-blog.packages.${pkgs.hostPlatform.system}.blog;
    useACMEHost = "averyan.ru";
  };
}
