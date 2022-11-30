{ config, ... }:
{
  age.secrets.account-mail = {
    file = ../secrets/accounts/mail.age;
    owner = "alex";
    group = "users";
  };

  home-manager.users.alex = {
    accounts.email.accounts."alex@averyan.ru" = {
      address = "alex@averyan.ru";
      userName = "alex@averyan.ru";
      realName = "Alexander Averyanov";
      primary = true;

      passwordCommand = "cat ${config.age.secrets.account-mail.path}";

      imap = {
        host = "hawk.averyan.ru";
      };
      smtp = {
        host = "hawk.averyan.ru";
      };

      gpg = {
        key = "6AF4D168E4B6C49A";
        signByDefault = true;
      };

      # thunderbird.enable = true;
    };

    # programs.thunderbird = {
    #   enable = true;
    #   profiles.main = {
    #     name = "Main";
    #     isDefault = true;
    #   };
    #   settings = {
    #     "privacy.donottrackheader.enabled" = true;
    #   };
    # };
  };
}
