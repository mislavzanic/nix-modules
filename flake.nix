{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/master";
    wallpapers = {
      url = "github:mislavzanic/wallpapers";
      flake = false;
    };

    home-manager = {
      url = "github:rycee/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-utils = {
      url = "github:mislavzanic/nix-utils";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
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
    emacs-config,
    home-manager,
    ...
  }: let
    inherit (lib.my) mapModulesRec mapModulesRec' mapShell;
    inherit (nix-utils) mkPkgs mkLib;
    system = "x86_64-linux";

    pkgs = mkPkgs {inherit system; pkgs = nixpkgs;};
    lib = nixpkgs.lib.extend (mkLib {inherit pkgs inputs;});

    utilModules = nix-utils.modules;
    mkModuleArr = path: mapModulesRec' path import;
    allModules = (mapModulesRec ./modules import);
    hmModules = [utilModules.common utilModules.home]
                ++ (mkModuleArr (toString ./modules/common))
                ++ (mkModuleArr (toString ./modules/systems/home));
    nixosModules = [utilModules.common utilModules.nixos]
                   ++ (mkModuleArr (toString ./modules/common))
                   ++ (mkModuleArr (toString ./modules/systems/nixos));

  in {
    inherit hmModules nixosModules allModules;

    mkHomeCfg = mods: attrs: home-manager.lib.homeManagerConfiguration ({
      modules = hmModules ++ mods;
    } // attrs);

    devShells."${system}" = mapShell ./shells {inherit pkgs lib;};
  };
}
