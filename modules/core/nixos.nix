{
  config,
  options,
  lib,
  home-manager,
  ...
}:
with lib;
with lib.my; {
  options = with types; {
    home = {
      file = mkOpt' attrs {} "Files to place directly in $HOME";
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

  config = {
    type = "nixos";
    # Install user packages to /etc/profiles instead. Necessary for
    # nixos-rebuild build-vm to work.
    home-manager = {
      useUserPackages = true;

      # aliases
      #   home.file        ->  home-manager.users.mislav.home.file
      #   home.configFile  ->  home-manager.users.mislav.home.xdg.configFile
      #   home.dataFile    ->  home-manager.users.mislav.home.xdg.dataFile
      users.${config.user.name} = {
        home = {
          file = mkAliasDefinitions options.home.file;
          # Necessary for home-manager to work with flakes, otherwise it will
          # look for a nixpkgs channel.
          stateVersion = config.system.stateVersion;
        };
        xdg = {
          configFile = mkAliasDefinitions options.home.configFile;
          dataFile = mkAliasDefinitions options.home.dataFile;
        };
      };
    };

    users.users.${config.user.name} = mkAliasDefinitions options.user;

    env.PATH = ["$DOTFILES_BIN" "$XDG_BIN_HOME" "$PATH"];
    environment.extraInit =
      concatStringsSep "\n"
      (mapAttrsToList (n: v: "export ${n}=\"${v}\"") config.env);
  };
}
