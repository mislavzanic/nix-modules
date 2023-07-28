{
  config,
  options,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.shell.pass;
in {
  options.modules.shell.pass = with types; {
    enable = mkBoolOpt false;

    git = mkOpt str "";
    dir = mkOpt str "$HOME/.secrets/password-store";
  };

  config = mkIf cfg.enable (mkMerge [
    {
      core.userPackages = with pkgs; [
        (pass.withExtensions (exts:
          [
            exts.pass-otp
            exts.pass-genphrase
          ]
          ++ (
            if config.modules.shell.gnupg.enable
            then [exts.pass-tomb]
            else []
          )))
        pass-git-helper
      ];
      env.PASSWORD_STORE_DIR = cfg.dir;
    }
  ]);
}
