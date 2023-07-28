{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.home.apps.alacritty;
in {
  options.modules.home.apps.alacritty = with types; {
    packages = mkOpt (listOf path) [];
  };

  config = mkIf (cfg.packages != []) {
    home.packages = packages;
  };
}
