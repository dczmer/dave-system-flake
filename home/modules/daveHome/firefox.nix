{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.daveHome.firefox;
in {
  options.daveHome.firefox = {
    enable = mkEnableOption "Firefox";
  };

  config = mkIf cfg.enable {
    programs.browserpass = {
      enable = true;
      browsers = [ "firefox" ];
    };

    programs.firefox.enable = true;
    programs.firefox.profiles.dave = {
      name = "dave";
      isDefault = true;
      #search.default
      #search.engines
      #search.order
      #search.privateDefault
      settings = {
        "browser.startup.homepage" = "https://nixos.org";
        "identity.sync.tokenserver.uri" = "https://guinness/1.0/sync/1.5";
        "services.sync.engine.addons" = false;
        "services.sync.engine.bookmarks" = true;
        "services.sync.engine.creditcards" = false;
        "services.sync.engine.history" = true;
        "services.sync.engine.passwords" = false;
        "services.sync.engine.prefs" = false;
        "services.sync.engine.tabs" = false;
      };
      #userContent = "custom css goes here";
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        privacy-badger
        browserpass
        darkreader
      ];
    };
  };
}
