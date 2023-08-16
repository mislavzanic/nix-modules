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
    core.userPackages = [ pkgs.fzf ];
    modules.shell.zsh.rcInit = ''
      source "${pkgs.fzf}/share/fzf/key-bindings.zsh"
      source "${pkgs.fzf}/share/fzf/completion.zsh"
    '';
  };
}
