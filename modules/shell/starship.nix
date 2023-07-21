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
  configDir = builtins.toString ../../config;
in {
  options.modules.shell.starship = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = [pkgs.starship];

    modules.shell.zsh.rcInit = ''eval "$(starship init zsh)"'';

    home.configFile = {
      "starship.toml" = {
        source = "${configDir}/starship/starship.toml";
      };
    };
  };
}
