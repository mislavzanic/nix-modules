{options, config, pkgs, lib, ...}:
with lib;
with lib.my;
let
  cfg = config.modules.nixos.desktop.wm;
in {
  options.modules.nixos.desktop.wm = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services = {
      xserver = {
        displayManager = {
          defaultSession = "none+myxmonad";
        };

        windowManager = {
          session = [
            {
              name = "myxmonad";
              start = ''
                /usr/bin/env mzanic-xmonad &
                waitPID=$!
              '';
            }
          ];
        };
      };
    };
  };
}
