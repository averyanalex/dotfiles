let
  alex = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDP6BYhOQG5swda8e3YRo4LqhdNNAQd3NwkQME193izZ";
  users = [ alex ];

  alligator = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE7y1Vw/aeF69RDccAB2BB1IATUvVEQ7sIgAO5fUZKyC";
  hamster = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICN/Mu9oGr3VFS+GMBNPASaoMyiMO1G8T4fUKjJJpy30";
  desktops = [ alligator hamster ];

  hawk = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGNROiWZEvzjR6TVoeVrVoUI2Vsx3wmJSb9QojvdLK0e";
  whale = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICtyxNV8IPSMHudJrMbemcK82LosU9tdNDV2rhf0Z9ps";
  servers = [ hawk whale ];

  cpmdesk-1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICjkfDuT/ilCXUHDBiVh4sxnYVmDSJzrYuj5DcD2HlbX";
  cpmdesks = [ cpmdesk-1 ];

  systems = desktops ++ servers ++ cpmdesks;
in
{
  "secrets/accounts/mail.age".publicKeys = users ++ desktops;
  "secrets/accounts/deluge.age".publicKeys = users ++ [ whale ];
  "secrets/accounts/radicale.age".publicKeys = users ++ desktops ++ [ whale ];

  "secrets/passwords/alex.age".publicKeys = users ++ systems;

  "secrets/mail/alex.age".publicKeys = users ++ [ hawk ];

  "secrets/creds/cloudflare.age".publicKeys = users ++ [ hawk ];
  "secrets/creds/firesquare.age".publicKeys = users ++ [ whale ];
  "secrets/creds/ipfs-cluster.age".publicKeys = users ++ [ whale ];
  "secrets/creds/cpmbot.age".publicKeys = users ++ [ whale ];

  "secrets/intpass/pterodactyl-panel.age".publicKeys = users ++ [ whale ];
  "secrets/intpass/pterodactyl-redis.age".publicKeys = users ++ [ whale ];
  "secrets/intpass/photoprism.age".publicKeys = users ++ [ whale ];

  "secrets/wireguard/hawk.age".publicKeys = users ++ [ hawk ];
  "secrets/wireguard/pterodactyl.age".publicKeys = users ++ [ whale ];
  "secrets/wireguard/firesquare.age".publicKeys = users ++ [ whale ];
  "secrets/wireguard/whale-frsqr.age".publicKeys = users ++ [ whale ];

  "secrets/nebula/ca-crt.age".publicKeys = users ++ systems;
  "secrets/nebula/ca-key.age".publicKeys = users;
  "secrets/nebula/alligator-crt.age".publicKeys = users ++ systems;
  "secrets/nebula/alligator-key.age".publicKeys = users ++ [ alligator ];
  "secrets/nebula/hamster-crt.age".publicKeys = users ++ systems;
  "secrets/nebula/hamster-key.age".publicKeys = users ++ [ hamster ];
  "secrets/nebula/hawk-crt.age".publicKeys = users ++ systems;
  "secrets/nebula/hawk-key.age".publicKeys = users ++ [ hawk ];
  "secrets/nebula/whale-crt.age".publicKeys = users ++ systems;
  "secrets/nebula/whale-key.age".publicKeys = users ++ [ whale ];
  "secrets/nebula/cpmdesk-1-crt.age".publicKeys = users ++ systems;
  "secrets/nebula/cpmdesk-1-key.age".publicKeys = users ++ [ cpmdesk-1 ];

  "secrets/nebula-frsqr/ca-crt.age".publicKeys = users ++ systems;
  "secrets/nebula-frsqr/whale-crt.age".publicKeys = users ++ systems;
  "secrets/nebula-frsqr/whale-key.age".publicKeys = users ++ [ whale ];
  "secrets/nebula-frsqr/hamster-crt.age".publicKeys = users ++ systems;
  "secrets/nebula-frsqr/hamster-key.age".publicKeys = users ++ [ hamster ];
  "secrets/nebula-frsqr/alligator-crt.age".publicKeys = users ++ systems;
  "secrets/nebula-frsqr/alligator-key.age".publicKeys = users ++ [ alligator ];
}
