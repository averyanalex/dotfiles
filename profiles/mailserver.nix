{ config, inputs, ... }:
{
  imports = [
    inputs.mailserver.nixosModules.mailserver
  ];

  mailserver = {
    enable = true;
    fqdn = "hawk.averyan.ru";
    domains = [ "averyan.ru" ];

    indexDir = "/var/lib/dovecot/indices";
    fullTextSearch = {
      enable = true;
      autoIndex = true;
      indexAttachments = true;
    };

    vmailUserName = "vmail";
    vmailGroupName = "vmail";

    useFsLayout = true;

    certificateScheme = 1;
    certificateFile = config.security.acme.certs."averyan.ru".directory + "/fullchain.pem";
    keyFile = config.security.acme.certs."averyan.ru".directory + "/key.pem";

    dkimKeyBits = 2048;
  };
}
