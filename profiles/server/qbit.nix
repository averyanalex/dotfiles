{pkgs, ...}: {
  systemd.services.qbittorrent = {
    after = ["network.target"];
    description = "Qbittorrent Web";
    wantedBy = ["multi-user.target"];
    path = [pkgs.qbittorrent-nox];
    serviceConfig = {
      ExecStart = ''
        ${pkgs.qbittorrent-nox}/bin/qbittorrent-nox --webui-port=8173
      '';
      User = "alex";
      Group = "users";
    };
  };

  persist.state.homeDirs = [".config/qBittorrent" ".local/share/qBittorrent"];
}
