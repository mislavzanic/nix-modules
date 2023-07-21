{
  options,
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.theme;
in {
  options.modules.theme = with types; {
    active = mkOption {
      type = nullOr str;
      default = null;
      apply = v: let
        theme = builtins.getEnv "THEME";
      in
        if theme != ""
        then theme
        else v;
      description = ''
        Name of the theme to enable. Can be overridden by the THEME environment
        variable. Themes can also be hot-swapped with 'hey theme $THEME'.
      '';
    };

    onReload = mkOpt (attrsOf lines) {};

    fonts = {
      # TODO Use submodules
      mono = {
        name = mkOpt str "Monospace";
        size = mkOpt int 12;
      };
      sans = {
        name = mkOpt str "Sans";
        size = mkOpt int 10;
      };
    };

    colors = {
      black         = mkOpt str "#000000";
      red           = mkOpt str "#ff8059"; # 1
      green         = mkOpt str "#44bc44"; # 2
      yellow        = mkOpt str "#d0bc00"; # 3
      blue          = mkOpt str "#2fafff"; # 4
      magenta       = mkOpt str "#feacd0"; # 5
      cyan          = mkOpt str "#00d3d0"; # 6
      silver        = mkOpt str "#bfbfbf"; # 7
      grey          = mkOpt str "#595959"; # 8
      brightred     = mkOpt str "#ef8b50"; # 9
      brightgreen   = mkOpt str "#70b900"; # 10
      brightyellow  = mkOpt str "#c0c530"; # 11
      brightblue    = mkOpt str "#79a8ff"; # 12
      brightmagenta = mkOpt str "#b6a0ff"; # 13
      brightcyan    = mkOpt str "#6ae4b9"; # 14
      white         = mkOpt str "#ffffff"; # 15

      # Color classes
      types = {
        bg        = mkOpt str cfg.colors.black;
        fg        = mkOpt str cfg.colors.white;
        panelbg   = mkOpt str cfg.colors.types.bg;
        panelfg   = mkOpt str cfg.colors.types.fg;
        border    = mkOpt str "#1d2021";
        error     = mkOpt str cfg.colors.red;
        warning   = mkOpt str cfg.colors.yellow;
        highlight = mkOpt str cfg.colors.white;
        opacity   = mkOpt str "255";
      };
    };
  };

  config = mkIf (cfg.active != null) (mkMerge [
    (let
      xrdb = ''cat "$XDG_CONFIG_HOME"/xtheme/* | ${pkgs.xorg.xrdb}/bin/xrdb -load'';
    in {
      home.configFile."xtheme.init" = {
        text = xrdb;
        executable = true;
      };
      modules.theme.onReload.xtheme = xrdb;
      services.xserver.displayManager.sessionCommands = mkIf services.xserver.enable ''
        cat ~/.config/xtheme/* | '${pkgs.xorg.xrdb}/bin/xrdb' -load
      '';
    })
    (mkIf (config.wm != {}) {
      home.configFile."wm/xinit" = {
        text = "$XDG_CONFIG_HOME/xtheme.init";
        executable = true;
      };
    })
    (mkIf config.modules.services.dunst.enable {
      home.configFile = {
        "dunst/dunstrc".text = import ./dunst.nix;
      };
    })
    {
      home.configFile = with cfg.modules; (mkMerge [
        (mkIf apps.alacritty.enable {
          "alacritty/color.yml".text = with cfg.colors; ''
            colors:
              primary:
                background: '${types.bg}'
                foreground: '${types.fg}'

              normal:
                black:   '${black}'
                red:     '${red}'
                green:   '${green}'
                yellow:  '${yellow}'
                blue:    '${blue}'
                magenta: '${magenta}'
                cyan:    '${cyan}'
                white:   '${silver}'

              bright:
                black:   '${grey}'
                red:     '${brightred}'
                green:   '${brightgreen}'
                yellow:  '${brightyellow}'
                blue:    '${brightblue}'
                magenta: '${brightmagenta}'
                cyan:    '${brightcyan}'
                white:   '${white}'
          '';
        })
        {
          "xtheme/00-init".text = with cfg.colors; ''
            #define brd  ${types.border}
            #define bg   ${types.bg}
            #define fg   ${types.fg}
            #define blk  ${black}
            #define red  ${red}
            #define grn  ${green}
            #define ylw  ${yellow}
            #define blu  ${blue}
            #define mag  ${magenta}
            #define cyn  ${cyan}
            #define wht  ${silver}
            #define bblk ${grey}
            #define bred ${brightred}
            #define bgrn ${brightgreen}
            #define bylw ${brightyellow}
            #define bblu ${brightblue}
            #define bmag ${brightmagenta}
            #define bcyn ${brightcyan}
            #define bwht ${white}
            #define alph ${types.opacity}
          '';
          "xtheme/05-colors".text = ''
            st.border: brd
            st.foreground: fg
            st.background: bg
            st.color0:  blk
            st.color1:  red
            st.color2:  grn
            st.color3:  ylw
            st.color4:  blu
            st.color5:  mag
            st.color6:  cyn
            st.color7:  wht
            st.color8:  bblk
            st.color9:  bred
            st.color10: bgrn
            st.color11: bylw
            st.color12: bblu
            st.color13: bmag
            st.color14: bcyn
            st.color15: bwht
            st.opacity: alph
          '';
        }
      ]);

      fonts.fontconfig.defaultFonts = {
        sansSerif = [cfg.fonts.sans.name];
        monospace = [cfg.fonts.mono.name];
        emoji = ["Noto Color Emoji"];
      };

      home.configFile = {
        "fontconfig/fonts.conf".text = ''
          <?xml version="1.0"?>
          <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
          <fontconfig>
          <alias>
            <family>monospace</family>
            <prefer>
              <family>IosevkaTerm Nerd Font</family>
              <family>DejaVu Sans Mono</family>
              <family>Noto Color Emoji</family>
              <family>Noto Emoji</family>
            </prefer>
          </alias>
          </fontconfig>
        '';
      };
    }

    (mkIf (cfg.onReload != {})
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
      }))
  ]);
}
