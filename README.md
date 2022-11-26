# Nebula

- Eagle (proxy) 10.5.3.10
- Rat (proxy) 10.5.3.11
- Whale (server) 10.5.3.20
- Hamster (desktop) 10.5.3.100
- Alligator (desktop) 10.5.3.101

# Commands

```shell
_ rm -rf /root/.cache && _ nixos-rebuild switch --flake 'git+https://git.frsqr.xyz/averyanalex/nixos.git?ref=main'
nix flake update --commit-lock-file
```
