{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.shell.zsh;
  configDir = toString ../../../config;
  cfgType = config.type;
in {
  options.modules.shell.zsh = with types; {
    enable = mkBoolOpt false;

    aliases = mkOpt (attrsOf (either str path)) {};

    rcInit = mkOpt' lines "" ''
      Zsh lines to be written to $XDG_CONFIG_HOME/zsh/extra.zshrc and sourced by
      $XDG_CONFIG_HOME/zsh/.zshrc
    '';
    envInit = mkOpt' lines "" ''
      Zsh lines to be written to $XDG_CONFIG_HOME/zsh/extra.zshenv and sourced
      by $XDG_CONFIG_HOME/zsh/.zshenv
    '';

    rcFiles = mkOpt (listOf (either str path)) [];
    envFiles = mkOpt (listOf (either str path)) [];
  };

  config = mkIf cfg.enable {
    programs = {
      zsh = {
        enable = true;
        enableCompletion = true;
        syntaxHighlighting.enable = true;

        shellAliases = {
          ls = "${pkgs.exa}/bin/exa -al --color=always --group-directories-first";
          la = "${pkgs.exa}/bin/exa -a --color=always --group-directories-first";
          ll = "${pkgs.exa}/bin/exa -l --color=always --group-directories-first"; 
          lt = "${pkgs.exa}/bin/exa -aT --color=always --group-directories-first"; 
          g = "git";
          v = "vim";
        };
      };
    };

    modules.${cfgType}.shell.zsh.enable = true;

    core.userPackages = with pkgs; [
      zsh
      nix-zsh-completions
      exa
      fasd
      fd
      ripgrep
    ];

    env = {
      ZDOTDIR = "$XDG_CONFIG_HOME/zsh";
      ZSH_CACHE = "$XDG_CACHE_HOME/zsh";
    };

    home.configFile = {
      "zsh" = {
        source = "${configDir}/zsh";
        recursive = true;
      };

      "zsh/extra.zshrc".text = let
        aliasLines = mapAttrsToList (n: v: "alias ${n}=\"${v}\"") cfg.aliases;
      in ''
        # This file was autogenerated, do not edit it!
        ${concatStringsSep "\n" aliasLines}
        ${concatMapStrings (path: "source '${path}'\n") cfg.rcFiles}
        ${cfg.rcInit}
      '';
    };
  };
}
