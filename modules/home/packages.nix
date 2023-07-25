{options, config, pkgs, lib, ...}:
with lib;
with lib.my;
let
  cfg = config.modules.home;
in {
  options.modules.home = with types; {
    userPackages = mkOpt (listOf package) [];
    packages = mkOpt (listOf package) [];
    fonts = mkOpt (listOf package) [];
  };

  config = {
    home.packages = packages ++ fonts ++ userPackages;
  };
}
