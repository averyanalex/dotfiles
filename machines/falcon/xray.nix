{
  config,
  lib,
  ...
}: {
  age.secrets."xray-config.jsonc" = {
    file = ../../secrets/xray/falcon.age;
    owner = "xray";
    group = "xray";
  };

  services.xray = {
    enable = true;
    settingsFile = config.age.secrets."xray-config.jsonc".path;
  };

  networking.firewall.allowedTCPPorts = [443];

  systemd.services.xray.serviceConfig = {
    DynamicUser = lib.mkForce false;
    User = "xray";
  };

  users.users.xray = {
    isSystemUser = true;
    description = "XRay";
    group = "xray";
    uid = 745;
  };
  users.groups.xray.gid = 745;
}
