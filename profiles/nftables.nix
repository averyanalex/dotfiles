{inputs, ...}: {
  imports = [inputs.self.nixosModules.modules.nftables];
  networking.nft-firewall.enable = true;
}
