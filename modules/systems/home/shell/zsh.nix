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
  cfg' = config.modules.shell.zsh;
  configDir = builtins.toString ../../../../config;
  fileToLines = file: let
    contents = builtins.readFile file;
    lines = splitString "\n" contents;
  in ''
    ${concatStringsSep "\n" lines}
  '';
in {
  options.modules.home.shell.zsh = with types; {
    zshrc = mkOpt lines "";
    zshenv = mkOpt lines "";
  };

  config = mkIf cfg'.enable {
    programs = {
      zsh = {
        dotDir = ".config/zsh";
        enableAutosuggestions = true;
        initExtraFirst = ''
          [[ $TERM == "dumb" ]] && unsetopt zle && PS1='$ ' && return
        '';
        history = {
          size = 10000000;
          path = "$HOME/.cache/zsh/history";
        };
        # initExtra = fileToLines "${configDir}/zsh/.zshrc";
        # envExtra = fileToLines "${configDir}/zsh/.zshenv";
        initExtra = mkAliasDefinitions options.modules.home.shell.zsh.zshrc;
        envExtra = mkAliasDefinitions options.modules.home.shell.zsh.zshenv;
      };
    };
  };
}
