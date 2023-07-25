{options, config, pkgs, lib, ...}:
with lib;
with lib.my;
let
  cfg = config.modules.nixos.desktop.wm;
in {
  options.modules.nixos.desktop.wm = with types; {
    packages = mkOpt (listOf path) [];
    fonts = mkOpt (listOf path) [];
  };

  config = mkIf (packages != [] || fonts != []){
    environment.systemPackages = packages;
    fonts.fonts = fonts;
  };
}
