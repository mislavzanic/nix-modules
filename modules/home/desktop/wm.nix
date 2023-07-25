{options, config, pkgs, lib, ...}:
with lib;
with lib.my;
let
  cfg = config.modules.home.desktop.wm;
in {
  options.modules.home.desktop.wm = with types; {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    xsession = {
      enable = true;
      windowManager.command = with pkgs; "${haskellPackages.mzanic-xmonad}/bin/mzanic-xmonad";
    };
  };
}
