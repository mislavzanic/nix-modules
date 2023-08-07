{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.nixos.shell.zsh;
  configDir = toString ../../../../config;
in {
  options.modules.nixos.shell.zsh = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    users.defaultUserShell = pkgs.zsh;

    programs = {
      zsh = {
        enableGlobalCompInit = false;
        autosuggestions.enable = true;
        syntaxHighlighting.enable = true;
        histSize = 10000000;
        histFile = "$XDG_CACHE_HOME/zsh/history";
      };
    };

    home.configFile = {
      "zsh" = {
        source = "${configDir}/zsh";
        recursive = true;
      };
    };
  };
}
