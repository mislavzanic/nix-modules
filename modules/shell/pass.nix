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
    pass = {
      git = mkOpt str "";
      dir = mkOpt str "$HOME/.secrets/password-store";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      user.packages = with pkgs; [
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
      env.PASSWORD_STORE_DIR = cfg.pass.dir;
    }
    (mkIf (cfg.git != "") {
      system.userActivationScripts = {
        getPass = ''
          if [ -d /home/${config.user.name}/.ssh ] || [ -d /etc/.ssh ]; then
              export PATH="/home/${config.user.name}/.ssh:$PATH"
              export PATH="${pkgs.openssh}/bin"
              if [ ! -d  "${cfg.pass.dir}" ]; then
                  ${pkgs.git}/bin/git clone "${cfg.pass.git}" "${cfg.pass.dir}"
              fi
          fi
        '';
      };
    })
  ]);
}
