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
  cfg' = config.modules.shell.zsh;
  configDir = toString ../../../../config;
in {
  options.modules.nixos.shell.zsh = with types; {
    zshrc = mkOpt lines "";
    zshenv = mkOpt lines "";
  };

  config = mkIf cfg'.enable {
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
      "zsh/.zshrc" = {
        text = ''${cfg.zshrc}'';
      };
      "zsh/.zshenv" = {
        text = ''${cfg.zshenv}'';
      };
    };
  };
}
