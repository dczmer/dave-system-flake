# Common settings for my local network.
{ lib, config, pkgs, ... }:
with lib;

let
  cfg = config.baseSystem.network;
in {
  options.baseSystem.network = {
    certificateFiles = mkOption {
      type = types.listOf types.path;
      default = [
        /var/certs/daveCA.pem
      ];
    };
  };

  config = {
    security.pki.certificateFiles = cfg.certificateFiles;
    networking.defaultGateway = "192.168.1.1";
    networking.nameservers = [ "8.8.8.8" ];
    networking.firewall.enable = true;
  };
}
