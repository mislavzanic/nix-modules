{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/master";

    nix-utils = {
      url = "github:mislavzanic/nix-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wallpapers = {
      url = "github:mislavzanic/wallpapers";
      flake = false;
    };
  };

  outputs = inputs @ {
    nixpkgs,
    nix-utils,
    ...
  }: let
    inherit (lib.my) mapModulesRec mapModulesRec';
    inherit (nix-utils) mkPkgs mkLib;
    system = "x86_64-linux";

    pkgs = mkPkgs {inherit system; pkgs = nixpkgs;};
    lib = nixpkgs.lib.extend (mkLib {inherit pkgs inputs;});
  in {
    modules = mapModulesRec ./modules import;
    modulesArr = mapModulesRec' (toString ./modules) import;
  };
}
