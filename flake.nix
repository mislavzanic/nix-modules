{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/master";
    nix-utils = {
      url = "github:mislavzanic/nix-utils/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    nixpkgs,
    nix-utils,
    ...
  }: let
    inherit (lib.my) mapModulesRec;
    inherit (nix-utils) mkPkgs mkLib;
    system = "x86_64-linux";

    pkgs = mkPkgs {inherit system; pkgs = nixpkgs;};
    lib = nixpkgs.lib.extend (mkLib {inherit pkgs inputs;});
  in {
    modules = mapModulesRec ./modules import;
    modulesArr = mapModulesRec' ./modules import;
  };
}
