{options, config, pkgs, lib, ...}:
with lib;
with lib.my;
let
  cfg = config.modules.home.desktop.wm;
in {
  options.modules.home.desktop.wm = with types; {
    packages = mkOpt (listOf path) [];
    fonts = mkOpt (listOf path) [];
  };

  config = mkIf (packages != [] || fonts != []){
    home.packages = packages ++ fonts;
  };
}
