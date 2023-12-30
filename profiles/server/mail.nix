{
  config,
  inputs,
  ...
}: let
  commonSieve = ''
    require ["fileinto"];

    if header :contains ["Chat-Version"] [""] {
      fileinto "DeltaChat";
      stop;
    }
  '';
in {
  imports = [
    inputs.mailserver.nixosModules.mailserver
  ];

  services.dovecot2.sieve.extensions = ["fileinto"];

  mailserver = {
    enable = true;
    fqdn = "hawk.averyan.ru";
    domains = ["averyan.ru"];

    indexDir = "/var/lib/dovecot/indices";
    fullTextSearch = {
      enable = true;
      autoIndex = true;
      indexAttachments = true;
    };

    vmailUserName = "vmail";
    vmailGroupName = "vmail";

    useFsLayout = true;

    certificateScheme = "manual";
    certificateFile = config.security.acme.certs."averyan.ru".directory + "/fullchain.pem";
    keyFile = config.security.acme.certs."averyan.ru".directory + "/key.pem";

    dkimKeyBits = 2048;

    mailboxes = {
      Trash = {
        auto = "create";
        specialUse = "Trash";
      };
      Archive = {
        auto = "create";
        specialUse = "Archive";
      };
      Junk = {
        auto = "subscribe";
        specialUse = "Junk";
      };
      Drafts = {
        auto = "subscribe";
        specialUse = "Drafts";
      };
      Sent = {
        auto = "subscribe";
        specialUse = "Sent";
      };
    };

    loginAccounts = {
      "alex@averyan.ru" = {
        hashedPasswordFile = config.age.secrets.mail-alex.path;
        sieveScript = commonSieve;
      };
      "sonya8128@averyan.ru" = {
        hashedPasswordFile = config.age.secrets.mail-sonya8128.path;
        sieveScript = commonSieve;
      };
      "cofob@averyan.ru" = {
        hashedPasswordFile = config.age.secrets.mail-cofob.path;
        sieveScript = commonSieve;
      };
    };
  };

  age.secrets.mail-alex.file = ../../secrets/mail/alex.age;
  age.secrets.mail-sonya8128.file = ../../secrets/mail/sonya8128.age;
  age.secrets.mail-cofob.file = ../../secrets/mail/cofob.age;

  persist.state.dirs = [
    {
      directory = "/var/dkim";
      user = "opendkim";
      group = "opendkim";
      mode = "u=rwx,g=rx,o=rx";
    }
    {
      directory = "/var/sieve";
      user = "vmail";
      group = "vmail";
      mode = "u=rwx,g=rwx,o=";
    }
    {
      directory = "/var/vmail";
      user = "vmail";
      group = "vmail";
      mode = "u=rwx,g=rws,o=";
    }
    {
      directory = "/var/lib/dovecot";
      user = "root";
      group = "root";
      mode = "u=rwx,g=rx,o=rx";
    }
    {
      directory = "/var/lib/postfix";
      user = "root";
      group = "root";
      mode = "u=rwx,g=rx,o=rx";
    }
    {
      directory = "/var/lib/redis-rspamd";
      user = "redis-rspamd";
      group = "redis-rspamd";
      mode = "u=rwx,g=,o=";
    }
    {
      directory = "/var/lib/rspamd";
      user = "rspamd";
      group = "rspamd";
      mode = "u=rwx,g=,o=";
    }
    {
      directory = "/var/spool/mail";
      user = "root";
      group = "root";
      mode = "u=rwx,g=rwx,o=rwt";
    }
  ];
}
