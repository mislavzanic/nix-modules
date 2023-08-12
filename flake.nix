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
    inherit (lib.my) mapModulesRec mapModulesRec' mapShell;
    inherit (nix-utils) mkPkgs mkLib;
    system = "x86_64-linux";

    overlays = xmonad-config.overlays;
    pkgs = mkPkgs {inherit system overlays; pkgs = nixpkgs;};
    lib = nixpkgs.lib.extend (mkLib {inherit pkgs inputs;});

    mkModuleArr = path: mapModulesRec' path import;
    allModules = (mapModulesRec ./modules import);
    hmModules = (mkModuleArr (toString ./modules/common)) ++ (mkModuleArr (toString ./modules/systems/home));
    nixosModules = (mkModuleArr (toString ./modules/common)) ++ (mkModuleArr (toString ./modules/systems/nixos));

  in {
    inherit overlays hmModules nixosModules allModules;

    mkHomeCfg = attrs @ {mods, ...}: home-manager.lib.homeManagerConfiguration {
      modules = hmModules ++ mods;
    } // attrs;

    devShells."${system}" = mapShell ./shells {inherit pkgs lib;};
  };
}
