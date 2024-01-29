{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.daveHome.obsidian;
in {
  options.daveHome.obsidian = {
    enable = mkEnableOption "Obsidan KMS";
  };

  config = mkIf cfg.enable {
    # XXX this is for obsidian :(
    nixpkgs.config.permittedInsecurePackages = [
      "electron-25.9.0"
    ];

    home.packages = [ pkgs.obsidian ];
  };
}
