# nix-modules
A flake that outputs home-manager (for non NixOS distros) and NixOS configurations.  
It provides a consistent interface for enabling/disabling modules for all Linux distributions.

## Usage
### Home Manager flake (for non NixOS distros)
```sh
nix flake init -t github:mislavzanic/nix-modules#homeConfig 
git init
```

### NixOS flake
```sh
nix flake init -t github:mislavzanic/nix-modules#nixosConfig
git init
```
