{ options, config, lib, pkgs, ... }:
with lib;
let
  cfg = config.modules.themes;
  customToINI = generators.toINI {
    mkKeyValue = generators.mkKeyValueDefault {
      mkValueString = v:
             if v == true then ''yes''
        else if v == false then ''no''
        else ''${v}''
    } " = ";
  };
in {}
# in customToINI {
#   global = {
#     font = "mono 9";
#     allow_markup = true;
#     format = "<b>%a:</b> %s\n%b";
#     sort = true;
#     indicate_hidden = true;
#     alignment = "left";
#     bounce_freq = 0;
#     show_age_threshold = 60;
#     word_wrap = true;
#     ignore_newline = false;
#     geometry = "300x5-30+20";
#     transparency = 0;
#     idle_threshold = 120;
#     monitor = 0;
#     follow = "keyboard";
#     sticky_history = true;
#     line_height = 0;
#     separator_height = 2;
#     padding = 8;
#     horizontal_padding = 8;
#     separator_color = auto;
#   };

#   shortcuts = {
#     close = "mod4+m";
#     close_all = "mod4+shift+m";
#     history = "mod4+n";
#     context = "mod4+shift+i";
#   };

#   frame = {
#     width = 0;
#     color = "${cfg.colors.black}";
#   };

#   urgency_low = {
#     background = "${cfg.colors.grey}";
#     foreground = "${cfg.colors.silver}";
#     timeout = 10;
#   };
    
#   urgency_normal = {
#     background = "${cfg.colors.black}";
#     foreground = "${cfg.colors.red}";
#     timeout = 10;
#   };

#   urgency_critical = {
#     background = "${cfg.colors.red}";
#     foreground = "${cfg.colors.black}";
#     timeout = 0;
#   };
# }
