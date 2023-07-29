{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/master";
    nix-utils.url = "github:mislavzanic/nix-utils";

    wallpapers = {
      url = "github:mislavzanic/wallpapers";
      flake = false;
    };

    home-manager = {
      url = "github:rycee/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    xmonad-config = {
      url = "github:mislavzanic/xmonad-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs-config = {
      url = "github:mislavzanic/emacs-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nix-utils.follows = "nix-utils";
      inputs.emacs-overlay.follows = "emacs-overlay";
    };
  };

  outputs = inputs @ {
    nixpkgs,
    nix-utils,
    wallpapers,
    xmonad-config,
    emacs-config,
    home-manager,
    ...
  }: let
    inherit (lib.my) mapModulesRec mapModulesRec';
    inherit (nix-utils) mkPkgs mkLib;
    system = "x86_64-linux";

    overlays = xmonad-config.overlays;
    pkgs = mkPkgs {inherit system overlays; pkgs = nixpkgs;};
    lib = nixpkgs.lib.extend (mkLib {inherit pkgs inputs;});

    mkModuleArr = path: mapModulesRec' path import;
  in {
    inherit overlays;
    modules = (mapModulesRec ./modules import);
    nixosModules = (mkModuleArr (toString ./modules/common)) ++ (mkModuleArr (toString ./modules/systems/nixos));
    hmModules = (mkModuleArr (toString ./modules/common)) ++ (mkModuleArr (toString ./modules/systems/home));
  };
}
