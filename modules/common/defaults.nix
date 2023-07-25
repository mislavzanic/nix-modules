{
  config,
  options,
  lib,
  ...
}:
with lib;
with lib.my; {
  options = with types; {
    user = mkOpt attrs {};
    
    type = mkOpt str "";

    dotfiles = {
      dir = mkOpt path "";
      binDir = mkOpt path "${config.dotfiles.dir}/bin";
      configDir = mkOpt path "${config.dotfiles.dir}/config";
    };

    home = {
      configFile = mkOpt' attrs {} "Files to place in $XDG_CONFIG_HOME";
      dataFile = mkOpt' attrs {} "Files to place in $XDG_DATA_HOME";
    };
  };

  config = {
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

    nix.settings = let
      users = ["root" config.user.name];
    in {
      trusted-users = users;
      allowed-users = users;
    };

    env.PATH = ["$DOTFILES_BIN" "$XDG_BIN_HOME" "$PATH"];
  };
}
