# Setup dockerd.
{ lib, config, pkgs, ... }:
with lib;

let
  cfg = config.baseSystem.docker;
in {
  options.baseSystem.docker = {
    enable = mkEnableOption "docker service";
  };

  config = mkIf cfg.enable {
    virtualisation.docker.enable = true;
    virtualisation.docker.enableOnBoot = false;
    virtualisation.docker.rootless = {
      enable = true;
      setSocketVariable = true;
    };
    virtualisation.docker.daemon.settings = {
      data-root = "/var/lib/docker";
      exec-root = "/var/run/docker";
    };
    users.users.dave.extraGroups = [ "docker" ];
  };
}
