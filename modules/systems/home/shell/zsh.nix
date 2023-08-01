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
in {
  options.modules.home.shell.zsh = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    programs = {
      zsh = {
        dotDir = "$XDG_CONFIG_HOME/zsh";
        enableAutosuggestions = true;
        history = {
          size = 10000000;
          path = "$XDG_CACHE_HOME/zsh/history";
        };
      };
    };
  };
}
