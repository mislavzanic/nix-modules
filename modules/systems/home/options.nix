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

    xsession.windowManager.command = mkAliasDefinition options.core.xserver.wmCommand;

    xsession.initExtra = concatStringsSep "\n"
      [config.core.extraInit config.core.xserver.sessionCommands];

    xsession.profileExtra = 
      concatStringsSep "\n"
      (mapAttrsToList (n: v: "export ${n}=\"${v}\"") coreCfg.sessionVariables);

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
