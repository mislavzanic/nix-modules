{options, config, pkgs, lib, inputs, ...}:
with lib;
with lib.my;
let
  cfg = config.modules.apps.emacs;
  cfgType = config.type;
in {
  options.modules.apps.emacs = with types; {
    enable = mkBoolOpt false;
  };

  imports = [
    inputs.emacs-config.modules.editor
  ];

  config = mkIf cfg.enable {
    modules.editor.emacs.enable = true;
  };
}
