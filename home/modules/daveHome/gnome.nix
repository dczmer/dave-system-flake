{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.daveHome.gnome;
in {
  options.daveHome.gnome = {
    enable = mkEnableOption "gnome3";
  };

  config = mkIf cfg.enable {
    gtk = {
      enable = true;
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };
      theme = {
        name = "Materia-dark";
        package = pkgs.materia-theme;
      };
      cursorTheme = {
        name = "Numix-Cursor";
        package = pkgs.numix-cursor-theme;
      };
      gtk3.extraConfig = {
        Settings = ''
          gtk-application-prefer-dark-theme=1
        '';
      };
      gtk4.extraConfig = {
        Settings = ''
          gtk-application-prefer-dark-theme=1
        '';
      };
    };
    home.sessionVariables.GTK_THEME = "Materia-dark";

    # NOTE: run `dconf watch /` and change settings in control panel
    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        enable-hot-corners = false;
      };
      "org/gnome/desktop/preferences" = {
      };
      "org/gnome/settings-daemon/plugins/color" = {
        night-light-enabled = true;
      };
    };
    home.packages = [ pkgs.gnome.eog ];
  };
}
