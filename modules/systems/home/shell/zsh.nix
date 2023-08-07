{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.home.shell.zsh;
  configDir = builtins.toString ../../../../config;
in {
  options.modules.home.shell.zsh = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    programs = {
      zsh = {
        dotDir = "/home/mzanic/.config/zsh";
        enableAutosuggestions = true;
        history = {
          size = 10000000;
          path = "$XDG_CACHE_HOME/zsh/history";
        };
        initExtra = builtins.readFile "${configDir}/zsh/.zshrc";
        envExtra = builtins.readFile "${configDir}/zsh/.zshenv"
      };
    };
  };
}
