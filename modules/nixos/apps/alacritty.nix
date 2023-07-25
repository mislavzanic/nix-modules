{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.nixos.apps.alacritty;
in {
  options.modules.nixos.apps.alacritty = with types; {
    packages = mkOpt (listOf path) [];
  };

  config = mkIf (cfg.packages != []) {
    user.packages = packages;
  };
}
