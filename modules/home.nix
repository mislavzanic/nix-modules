{
  config,
  options,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; {
  options = with types; {
    user = mkOpt attrs {};
    
    dotfiles = {
      dir = mkOpt path "";
      binDir = mkOpt path "${config.dotfiles.dir}/bin";
      configDir = mkOpt path "${config.dotfiles.dir}/config";
    };

    home = {
      file = mkOpt' attrs {} "Files to place directly in $HOME";
      configFile = mkOpt' attrs {} "Files to place in $XDG_CONFIG_HOME";
      dataFile = mkOpt' attrs {} "Files to place in $XDG_DATA_HOME";
    };

    env = mkOption {
      type = attrsOf (oneOf [str path (listOf (either str path))]);
      apply =
        mapAttrs
        (n: v:
          if isList v
          then concatMapStringsSep ":" (x: toString x) v
          else (toString v));
      default = {};
      description = "TODO";
    };
  };

  config = (mkMerge [
    {
      user = let
        user = builtins.getEnv "USER";
        name = if elem user ["" "root"] then "mzanic" else user;
      in {
        inherit name;
        description = "The primary user account";
        extraGroups = ["wheel" "networkmanager" "audio" "video"];
        isNormalUser = true;
        home = "/home/${name}";
        group = "users";
        uid = 1000;
      };

      # Install user packages to /etc/profiles instead. Necessary for
      # nixos-rebuild build-vm to work.
      home = {
        file = mkAliasDefinitions options.home.file;
        homeDirectory = config.user.home;
      };
      xdg = {
        configFile = mkAliasDefinitions options.home.configFile;
        dataFile = mkAliasDefinitions options.home.dataFile;
      };

      nix.settings = let
        users = ["root" config.user.name];
      in {
        trusted-users = users;
        allowed-users = users;
      };

      # must already begin with pre-existing PATH. Also, can't use binDir here,
      # because it contains a nix store path.
      env.PATH = ["$DOTFILES_BIN" "$XDG_BIN_HOME" "$PATH"];
    }
  ]);
}
