{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.apps.alacritty;
  configDir = toString ../config;
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
  options.shell.alacritty = {
    enable = mkBoolOpt false;
    withNixGL = mkBoolOpt false;
    homeManager = mkBoolOpt true;
  };

  config = mkIf cfg.enable (mkMerge [
    (mkIf cfg.homeManager {
      home.configFile = {
        "alacritty" = {
          source = "${configDir}/alacritty";
          recursive = true;
        };
      };
    })
    {
      environment.systemPackages = with pkgs;
        if cfg.withNixGL then [ nixGLWrap alacritty] else [alacritty];
    }
  ]);
}
