{options, config, pkgs, lib, ...}:
with lib;
with lib.my;
let
  cfg = config.modules.nixos;
in {
  options.modules.nixos = with types; {
    userPackages = mkOpt (listOf package) [];
    packages = mkOpt (listOf package) [];
    fonts = mkOpt (listOf package) [];
  };

  config = {
    user.packages = userPackages;
    fonts.fonts = fonts;
    environment.systemPackages = packages;
  };
}
