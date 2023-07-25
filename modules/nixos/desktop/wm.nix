{options, config, pkgs, lib, ...}:
with lib;
with lib.my;
let
  cfg = config.modules.nixos.desktop.wm;
in {
  options.modules.nixos.desktop.wm = with types; {
    enable = mkBoolOpt false;
    defaultSession = mkOpt str "none+myxmoand";
    session = mkOpt attrs {};
  };

  config = mkIf cfg.enable {
    services = {
      xserver = {
        enable = true;
        displayManager = {
          defaultSession = cfg.defaultSession;
        };

        windowManager = {
          session = [cfg.session];
        };
      };
    };
  };
}
