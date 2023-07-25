{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.apps.alacritty;
  cfgType = config.type;
  configDir = toString ../../../config;
  nixGLWrap = pkg: pkgs.runCommand "${pkg.name}-nixgl-wrapper" {} ''
    mkdir $out
    ln -s ${pkg}/* $out
    rm $out/bin
    mkdir $out/bin
    for bin in ${pkg}/bin/*; do
     wrapped_bin=$out/bin/$(basename $bin)
     echo "exec ${getExe pkgs.nixgl.auto.nixGLDefault} $bin \$@" > $wrapped_bin
     chmod +x $wrapped_bin
    done
  '';
in {
  options.modules.apps.alacritty = {
    enable = mkBoolOpt false;
    withNixGL = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    modules.${cfgType}.userPackages = with pkgs;
      if cfg.withNixGL then [(nixGLWrap alacritty)] else [alacritty];

    home.configFile = {
      "alacritty" = {
        source = "${configDir}/alacritty";
        recursive = true;
      };
    };
  };
}
