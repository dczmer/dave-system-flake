{ lib, pkgs, config, ... }:
with lib;

let
  cfg = config.daveHome.direnv;
in {
  options.daveHome.direnv = {
    enable = mkEnableOption "direnv integration";
  };

  config = mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;

      nix-direnv.enable = true;
    };
  };
}
