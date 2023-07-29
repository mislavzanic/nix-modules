{
  options,
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.theme.wallpapers;
  wallpapers = inputs.wallpapers;
in {
  options.modules.theme.wallpapers = with types; {
    wallpaper = mkOpt str "";
    # loginWallpaper = 
    #   mkOpt (either str null) 
    #   (
    #     if cfg.wallpaper != ""
    #     then toFilteredImage ("${wallpapers}/${cfg.wallpaper}") "-gaussian-blur 0x2 -modulate 70 -level 5%"
    #     else null
    #   );
  };

  config = 
  let
    cmd = ''
      ${pkgs.feh}/bin/feh --bg-fill --no-fehbg \
        ${
          if (cfg.wallpaper != "")
          then "$XDG_DATA_HOME/wallpaper"
          else "--randomize ${wallpapers}/*"
        }
    '';
  in {
    modules.core.xserver.sessionCommands = cmd;
    home.dataFile = mkIf (cfg.wallpaper != "") {
      "wallpaper".source = "${wallpapers}/${cfg.wallpaper}";
    };
  };
}
