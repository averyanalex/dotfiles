{ config, ... }:

{
  age.secrets.password-alex.file = ../secrets/passwords/alex.age;

  users = {
    users = {
      alex = {
        isNormalUser = true;
        description = "Alexander Averyanov";
        extraGroups = [ "wheel" ];
        uid = 1000;
        passwordFile = config.age.secrets.password-alex.path;
        openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINF5KDy1T6Z+RlDb+Io3g1uSZ46rhBxhNE39YlG3GPFM alex@averyan.ru" ];
      };
    };
  };
}
