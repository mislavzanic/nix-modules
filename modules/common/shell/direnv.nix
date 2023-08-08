{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.shell.direnv;
in {
  options.modules.shell.direnv = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    modules.shell.zsh.rcInit = ''
      eval "$(${pkgs.direnv}/bin/direnv hook zsh)"
    '';
  };
}
