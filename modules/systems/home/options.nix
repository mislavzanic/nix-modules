{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  coreCfg = config.core;
in {
  options = with types; {
    genericLinux = mkBoolOpt false;
  };
  config = {
    type = "home";

    programs.home-manager.enable = true;
    targets.genericLinux.enable = config.genericLinux;

    xsession.initExtra = concatStringsSep "\n"
      [config.core.extraInit config.core.xserver.sessionCommands];

    xsession.profileExtra = mkAliasDefinition options.core.sessionVariables;

    home = {
      homeDirectory = config.user.home;
      username = config.user.name;
      packages = coreCfg.packages ++ coreCfg.fonts ++ coreCfg.userPackages;
    };
    xdg = {
      configFile = mkAliasDefinitions options.home.configFile;
      dataFile = mkAliasDefinitions options.home.dataFile;
    };
  };
}
