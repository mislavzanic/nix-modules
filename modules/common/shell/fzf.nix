{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.shell.fzf;
  cfgType = config.type;
in {
  options.modules.shell.fzf = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    config.modules.${cfgType}.userPackages = [ pkgs.fzf ];
    modules.shell.zsh.rcInit = ''
      source "$(fzf-share)/key-bindings.zsh"
      source "$(fzf-share)/completion.zsh"
    '';
  };
}
