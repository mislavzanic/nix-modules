{options, config, pkgs, lib, inputs, ...}:
with lib;
with lib.my;
let
  cfg = config.modules.editor;
  cfgType = config.type;
in {
  options.modules.editor = with types; {
    type = mkOpt str "emacs";
  };

  imports = [
    inputs.emacs-config.modules.editor
  ];

  config = mkIf (cfg.type == "emacs") {
    modules.editor.emacs.enable = true;
    home.configFile = {
      "emacs" = {
        source = cfg.emacs.path;
        recursive = true;
      };
    };
  };
}
