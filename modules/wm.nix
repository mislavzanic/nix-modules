{options, config, pkgs, lib, ...}:
with lib;
with lib.my;
let
  cfg = config.modules.wm;
in {
  options.modules.wm = with types; {
    enable = mkBoolOpt false;
    type = mkOpt str "xmonad";
    bar = mkOpt str "xmobar";
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf (cfg.type == "xmonad") {
      environment.systemPackages = with pkgs; [
        xmonad-log
        haskellPackages.mzanic-xmonad
        trayer
        i3lock
        xss-lock
      ];

      fonts.fonts = with pkgs; [
        font-awesome_5
        nerdfonts
        cantarell-fonts
        noto-fonts-emoji
      ];

      services = {
        xserver = {
          enable = true;
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
    })
    (mkIf (cfg.bar == "xmobar") {
      environment.systemPackages = with pkgs; [
        haskellPackages.mzanic-xmobar
      ];

      environment.etc = {
        "xmobar/xpm".source = ../config/xmobar/xpm;
        "xmobar/trayer-padding-icon.sh" = {
          source = ../config/xmobar/trayer-padding-icon.sh;
          mode = "755";
        };
      };
    })
  ]);
}
