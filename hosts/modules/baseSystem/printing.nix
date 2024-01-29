{ lib, config, pkgs, ... }:
with lib;

let
  cfg = config.baseSystem.printing;
in {
  options.baseSystem.printing = {
    enable = mkEnableOption "Home printer";
    allowDiscovery = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = {
    services.avahi = mkIf cfg.allowDiscovery {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    services.printing.enable = true;
    services.printing.drivers = [ pkgs.hplip ];

    hardware.printers = {
      ensurePrinters = [
        {
          name = "HP_DeskJet_4155e";
          location = "Home";
          deviceUri = "socket://192.168.1.123";
          model = "HP/hp-deskjet_4100_series.ppd.gz";
          #ppdOptions
        }
      ];
      ensureDefaultPrinter = "HP_DeskJet_4155e";
    };
  };
}
