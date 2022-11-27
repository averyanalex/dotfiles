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

    loginAccounts = {
      "alex@averyan.ru" = {
        hashedPasswordFile = config.age.secrets.mail-alex.path;
      };
    };
  };

  age.secrets.mail-alex.file = ../secrets/mail/alex.age;

  persist.state.dirs = [
    { directory = "/var/dkim"; user = "opendkim"; group = "opendkim"; mode = "u=rwx,g=rx,o=rx"; }
    { directory = "/var/sieve"; user = "vmail"; group = "vmail"; mode = "u=rwx,g=rwx,o="; }
    { directory = "/var/vmail"; user = "vmail"; group = "vmail"; mode = "u=rwx,g=rws,o="; }
    { directory = "/var/lib/dovecot"; user = "root"; group = "root"; mode = "u=rwx,g=rx,o=rx"; }
    { directory = "/var/lib/opendkim"; user = "opendkim"; group = "opendkim"; mode = "u=rwx,g=,o="; }
    { directory = "/var/lib/postfix"; user = "root"; group = "root"; mode = "u=rwx,g=rx,o=rx"; }
    { directory = "/var/lib/redis-rspamd"; user = "redis-rspamd"; group = "redis-rspamd"; mode = "u=rwx,g=,o="; }
    { directory = "/var/lib/rspamd"; user = "rspamd"; group = "rspamd"; mode = "u=rwx,g=,o="; }
    { directory = "/var/spool/mail"; user = "root"; group = "root"; mode = "u=rwx,g=rwx,o=rwt"; }
  ];
}
