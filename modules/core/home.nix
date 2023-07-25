{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; {
  options = with types; {
    genericLinux = mkBoolOpt false;
  };
  config = {
    type = "home";
    programs.home-manager.enable = true;
    targets.genericLinux.enable = config.genericLinux;
    home = {
      homeDirectory = config.user.home;
      username = config.user.name;
    };
    xdg = {
      configFile = mkAliasDefinitions options.home.configFile;
      dataFile = mkAliasDefinitions options.home.dataFile;
    };
  };
}
