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
  fileToLines = file: let
    contents = builtins.readFile file;
    lines = splitString "\n" contents;
  in ''
    ${concatStringsSep "\n" lines}
  '';
in {
  options.modules.home.shell.zsh = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    programs = {
      zsh = {
        dotDir = ".config/zsh";
        enableAutosuggestions = true;
        enableSyntaxHighlighting = true;
        history = {
          size = 10000000;
          path = "$XDG_CACHE_HOME/zsh/history";
        };
        initExtra = fileToLines "${configDir}/zsh/.zshrc";
        envExtra = fileToLines "${configDir}/zsh/.zshenv";
      };
    };
  };
}
