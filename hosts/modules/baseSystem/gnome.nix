# Common x/gnome/opengl/audio config.
{ lib, config, pkgs, ... }:
with lib;

let
  cfg = config.baseSystem.gnome;
in {
  options.baseSystem.gnome = {
    enable = mkEnableOption "Base Gnome configuration";
  };

  config = mkIf cfg.enable {
    nixpkgs.config = {
      allowUnfree = true;
      vivaldi = {
        proprietaryCodecs = true;
        enableWideVine = true;
      };
    };

    services.xserver.enable = true;
    programs.dconf.enable = true;
    services.xserver.desktopManager.gnome.enable = true;
    services.xserver.displayManager.gdm.enable = true;
    services.gnome.gnome-keyring.enable = true;

    environment.gnome.excludePackages = (with pkgs; [
      gnome-photos
      gnome-tour
      gedit
    ]) ++ (with pkgs.gnome; [
      cheese
      gnome-music
      gnome-terminal
      epiphany
      geary
      evince
      gnome-characters
      totem
      tali iagno
      hitori
      atomix
    ]);

    sound.enable = true;
    hardware.pulseaudio.enable = true;

    hardware.opengl.enable = true;
    hardware.opengl.driSupport = true;
    hardware.opengl.driSupport32Bit = true;
    hardware.opengl.extraPackages = with pkgs; [
        rocmPackages.clr.icd
    ];

    fonts = {
      packages = with pkgs; [
        material-design-icons
        noto-fonts
        noto-fonts-emoji
        (nerdfonts.override {fonts = ["FiraCode" "JetBrainsMono"];})
      ];
      enableDefaultPackages = false;
      fontconfig.defaultFonts = {
        serif = ["Noto Serif" "Noto Color Emoji"];
        sansSerif = ["Noto Sans" "Noto Color Sans"];
        monospace = ["JetBrainsMono Nerd Font" "Noto Color Emoji"];
        emoji = ["Noto Color Emoji"];
      };
    };

    services.geoclue2.enable = true;
    services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];

    users.users.dave.extraGroups = [ "networkmanager" ];
  };
}
