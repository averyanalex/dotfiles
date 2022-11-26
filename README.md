# Nebula

- Hawk 10.5.3.12
- Whale 10.5.3.20
- Hamster 10.5.3.100
- Alligator 10.5.3.101

# Commands

```shell
_ rm -rf /root/.cache && _ nixos-rebuild switch --flake 'git+https://git.frsqr.xyz/averyanalex/nixos.git?ref=main'
nix flake update --commit-lock-file
```
