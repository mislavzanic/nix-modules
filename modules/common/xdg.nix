{config, ...}: {

  core.sessionVariables = {
    "XDG_CACHE_HOME" = "$HOME/.cache";
    "XDG_CONFIG_HOME" = "$HOME/.config";
    "XDG_DATA_HOME" = "$HOME/.local/share";
    "XDG_BIN_HOME" = "$HOME/.local/bin";

    "CABAL_CONFIG" = "$XDG_CONFIG_HOME/cabal/config";
    "CABAL_DIR" = "$XDG_CACHE_HOME/cabal";
  };
}

