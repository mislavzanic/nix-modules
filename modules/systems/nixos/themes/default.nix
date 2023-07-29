{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.nixos.theme;
in {
  options.modules.nixos.theme = with types; {
    sessionCommands = mkOpt lines "";
  };

  config = mkIf (config.modules.theme.active != null) (mkMerge [
    {
      fonts.fontconfig.defaultFonts = {
        sansSerif = [config.modules.theme.fonts.sans.name];
        monospace = [config.modules.theme.fonts.mono.name];
        emoji = ["Noto Color Emoji"];
      };
    }
    (mkIf (config.modules.theme.onReload != {})
      (let
        reloadTheme = with pkgs; (writeScriptBin "reloadTheme" ''
          #!${stdenv.shell}
          echo "Reloading current theme: ${cfg.active}"
          ${concatStringsSep "\n"
            (mapAttrsToList (name: script: ''
                echo "[${name}]"
                ${script}
              '')
              cfg.onReload)}
        '');
      in {
        user.packages = [reloadTheme];
        system.userActivationScripts.reloadTheme = ''
          [ -z "$NORELOAD" ] && ${reloadTheme}/bin/reloadTheme
        '';
      })
    )
    # {
      # services.xserver.displayManager.lightdm.background = wallpapers + "${cfg.loginWallpaper}";
    #   modules.nixos.theme.onReload.wallpaper = cmd;
    # }
  ]);
}
