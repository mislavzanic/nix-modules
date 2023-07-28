{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.home.theme;
in {
  options.modules.home.theme = with types; {
    sessionCommands = mkOpt lines "";
  };

  config = mkIf (config.modules.theme.active != null) (mkMerge [
  ]);
}
