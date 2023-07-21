let
  alex = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDP6BYhOQG5swda8e3YRo4LqhdNNAQd3NwkQME193izZ";
  users = [alex];

  alligator = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE7y1Vw/aeF69RDccAB2BB1IATUvVEQ7sIgAO5fUZKyC";
  hamster = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICN/Mu9oGr3VFS+GMBNPASaoMyiMO1G8T4fUKjJJpy30";
  desktops = [alligator hamster];

  ferret = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJCrSdgjm9hxyFMCVCW+SzgF7AThC+fZy8RBQoFqCWT2";
  family = [ferret];

  hawk = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGNROiWZEvzjR6TVoeVrVoUI2Vsx3wmJSb9QojvdLK0e";
  whale = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICtyxNV8IPSMHudJrMbemcK82LosU9tdNDV2rhf0Z9ps";
  lizard = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEkmHS0r9G9Qgsponr/XayqOXB28eR+eUiYtBA+x5vTK";
  servers = [hawk whale lizard];

  systems = desktops ++ family ++ servers;
in {
  "secrets/remote-builder-ssh-key.age".publicKeys = users ++ systems;

  "secrets/accounts/mail.age".publicKeys = users ++ desktops;
  "secrets/accounts/deluge.age".publicKeys = users ++ [whale];
  "secrets/accounts/radicale.age".publicKeys = users ++ desktops ++ [whale];

  "secrets/passwords/alex.age".publicKeys = users ++ systems;
  "secrets/passwords/olga.age".publicKeys = users ++ systems;

  "secrets/mail/alex.age".publicKeys = users ++ [hawk];
  "secrets/mail/sonya8128.age".publicKeys = users ++ [hawk];

  "secrets/creds/bvilove.age".publicKeys = users ++ [whale];
  "secrets/creds/kluckva.age".publicKeys = users ++ [whale];
  "secrets/creds/cloudflare.age".publicKeys = users ++ [hawk];
  "secrets/creds/cpmbot.age".publicKeys = users ++ [whale];
  "secrets/creds/firesquare.age".publicKeys = users ++ [whale];
  "secrets/creds/ipfs-cluster.age".publicKeys = users ++ [whale];
  "secrets/creds/searx.age".publicKeys = users ++ [hawk];

  "secrets/intpass/pterodactyl-panel.age".publicKeys = users ++ [whale];
  "secrets/intpass/pterodactyl-redis.age".publicKeys = users ++ [whale];
  "secrets/intpass/photoprism.age".publicKeys = users ++ [whale];

  "secrets/wireguard/hawk.age".publicKeys = users ++ [hawk];
  "secrets/wireguard/whale.age".publicKeys = users ++ [whale];
  "secrets/wireguard/pterodactyl.age".publicKeys = users ++ [whale];
  "secrets/wireguard/firesquare.age".publicKeys = users ++ [whale];
  "secrets/wireguard/whale-frsqr.age".publicKeys = users ++ [whale];

  "secrets/yggdrasil/alligator.age".publicKeys = users ++ [alligator];
  "secrets/yggdrasil/whale.age".publicKeys = users ++ [whale];
  "secrets/yggdrasil/hawk.age".publicKeys = users ++ [hawk];

  "secrets/nebula/ca-crt.age".publicKeys = users ++ systems;
  "secrets/nebula/ca-key.age".publicKeys = users;
  "secrets/nebula/alligator-crt.age".publicKeys = users ++ systems;
  "secrets/nebula/alligator-key.age".publicKeys = users ++ [alligator];
  "secrets/nebula/hamster-crt.age".publicKeys = users ++ systems;
  "secrets/nebula/hamster-key.age".publicKeys = users ++ [hamster];
  "secrets/nebula/hawk-crt.age".publicKeys = users ++ systems;
  "secrets/nebula/hawk-key.age".publicKeys = users ++ [hawk];
  "secrets/nebula/whale-crt.age".publicKeys = users ++ systems;
  "secrets/nebula/whale-key.age".publicKeys = users ++ [whale];
  "secrets/nebula/lizard-crt.age".publicKeys = users ++ systems;
  "secrets/nebula/lizard-key.age".publicKeys = users ++ [lizard];

  "secrets/nebula-frsqr/ca-crt.age".publicKeys = users ++ systems;
  "secrets/nebula-frsqr/whale-crt.age".publicKeys = users ++ systems;
  "secrets/nebula-frsqr/whale-key.age".publicKeys = users ++ [whale];
  "secrets/nebula-frsqr/hamster-crt.age".publicKeys = users ++ systems;
  "secrets/nebula-frsqr/hamster-key.age".publicKeys = users ++ [hamster];
  "secrets/nebula-frsqr/alligator-crt.age".publicKeys = users ++ systems;
  "secrets/nebula-frsqr/alligator-key.age".publicKeys = users ++ [alligator];
}
