{options, config, pkgs, lib, ...}:
with lib;
with lib.my;
let
  cfg = config.modules.desktop.wm; cfgType = config.type;
  configDir = ../../../config;
in {
  options.modules.desktop.wm = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    modules.${cfgType} = {
      packages = with pkgs; [
        xmonad-log
        haskellPackages.mzanic-xmonad
        haskellPackages.mzanic-xmobar
        trayer
        i3lock
        xss-lock
      ];

      fonts = [
        font-awesome_5
        nerdfonts
        cantarell-fonts
        noto-fonts-emoji
      ];
      desktop.wm = {
        enable = true;
        defaultSession = "none+myxmonad";
        session = {
          name = "myxmonad";
          start = ''
            /usr/bin/env mzanic-xmonad &
            waitPID=$!
          '';
        };
      };
    };

    home.configFile = {
      "xmobar/xpm".source = "${configDir}" ++ /xmobar/xpm;
      "xmobar/trayer-padding-icon.sh" = {
        source = "${configDir}" ++ /xmobar/trayer-padding-icon.sh;
        mode = "755";
      };
    };
  };
}
