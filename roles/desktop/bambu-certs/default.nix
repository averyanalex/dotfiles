{ pkgs, ... }:
let
  mergedBambuCa = import ./package.nix { inherit pkgs; };

  installBambuCerts = pkgs.writeShellApplication {
    name = "install-bambu-certs";
    runtimeInputs = with pkgs; [
      coreutils
      diffutils
    ];
    text = ''
      if (( EUID != 0 )); then
        exec sudo "$0" "$@"
      fi

      if (( $# != 0 )); then
        echo "Usage: install-bambu-certs" >&2
        exit 2
      fi

      target_tmp=""
      cleanup() {
        [[ -z "$target_tmp" || ! -e "$target_tmp" ]] || rm -f -- "$target_tmp"
      }
      trap cleanup EXIT

      merged=${mergedBambuCa}/share/bambu-certs/printer.cer
      echo "Using packaged CA bundle: $merged"
      installed=0
      for target in \
        /var/lib/flatpak/app/com.bambulab.BambuStudio/current/active/files/share/BambuStudio/cert/printer.cer \
        /var/lib/flatpak/app/com.orcaslicer.OrcaSlicer/current/active/files/share/OrcaSlicer/cert/printer.cer
      do
        target_dir="$(dirname "$target")"
        if [[ ! -d "$target_dir" ]]; then
          echo "Skipping absent Flatpak: $target"
          continue
        fi

        installed=1
        if [[ -f "$target" ]] && cmp -s "$merged" "$target"; then
          echo "Already current: $target"
          continue
        fi

        # Flatpak deployments are hard-linked to OSTree objects. Replace the
        # path atomically instead of modifying an OSTree object in place.
        target_tmp="$(mktemp --tmpdir="$target_dir" .printer.cer.XXXXXX)"
        install -m 0644 -o root -g root "$merged" "$target_tmp"
        mv -fT -- "$target_tmp" "$target"
        target_tmp=""
        echo "Installed: $target"
      done

      if (( installed == 0 )); then
        echo "No Bambu Studio or OrcaSlicer system Flatpak is installed"
      fi
    '';
  };
in
{
  environment.systemPackages = [
    mergedBambuCa
    installBambuCerts
  ];

  systemd.services.bambu-printer-certs = {
    description = "Install Bambu and Bambuddy printer CA certificates";
    wantedBy = [ "multi-user.target" ];
    after = [ "local-fs.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${installBambuCerts}/bin/install-bambu-certs";
    };
  };

  # Reapply the bundle when a manual Flatpak update swaps either deployment.
  systemd.paths.bambu-printer-certs = {
    description = "Watch Bambu slicer Flatpak deployments";
    wantedBy = [ "multi-user.target" ];
    pathConfig.PathChanged = [
      "/var/lib/flatpak/app/com.bambulab.BambuStudio/current/active"
      "/var/lib/flatpak/app/com.orcaslicer.OrcaSlicer/current/active"
    ];
  };

  # nix-flatpak updates run in this unit, so restore the merged bundle before
  # the update job is considered complete as well.
  systemd.services.flatpak-managed-install.serviceConfig.ExecStartPost = [
    "${installBambuCerts}/bin/install-bambu-certs"
  ];
}
