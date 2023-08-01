{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.shell.starship;
in {
  options.modules.shell.starship = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    programs.starship = {
      enable = true;
      settings = {
        gcloud = {
          disabled = true;
        };
        nix_shell = {
          symbol = "🐚 ";
          format = "[$symbol$state $name](bold blue) ";
        };
      };
    };
    modules.shell.zsh.rcInit = mkIf (config.type == "home") ''
      eval "$(starship init zsh)"
    '';
  };
}
