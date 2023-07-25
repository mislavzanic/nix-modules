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
    modules.shell.zsh.rcInit = ''eval "$(direnv hook zsh)"'';

    # user.packages = with pkgs; [direnv nix-direnv];

    # nix.settings = {
    #   keep-outputs = true;
    #   keep-derivations = true;
    # };

    # nixpkgs.overlays = [
    #   (new: old: {nix-direnv = old.nix-direnv.override {enableFlakes = true;};})
    # ];

    # home.configFile = {
    #   "direnv/direnvrc".text = "source ${pkgs.nix-direnv}/share/nix-direnv/direnvrc";
    # };
  };
}
