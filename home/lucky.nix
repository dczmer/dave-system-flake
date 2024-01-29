{ config, pkgs, nur, dave-nvim-flake, ... }:
{
  imports = [
    ./modules
  ];

  daveHome.kitty.enable = true;
  daveHome.tmux.enable = true;
  daveHome.obsidian.enable = true;
  daveHome.zsh.enable = true;
  daveHome.zsh.cfgFile = ./zsh/lucky-p10k.zsh;
  daveHome.firefox.enable = true;
  daveHome.gnome.enable = true;
  daveHome.hyprland.enable = true;

  programs.ssh.matchBlocks."guinness".identityFile = "/home/dave/.ssh/keys/id_ed25519";
  programs.kitty.font.size = 14;
  programs.firefox.profiles.dave.settings."layout.css.devPixelsPerPx" = 1.25;

  # NOTE: run `dconf watch /` and change settings in control panel
  dconf.settings = {
    "org/gnome/shell" = {
      favorite-apps = [
        "firefox.desktop"
        "kitty.desktop"
        "obsidian.desktop"
        "steam.desktop"
      ];
    };
    "org/gnome/desktop/background" = {
      picture-uri = "/home/dave/Wallpapers/nix-wallpaper-mosaic-blue.png";
      picture-uri-dark = "/home/dave/Wallpapers/nix-wallpaper-nineish-dark-gray.png";
    };
    "org/gnome/settings-daemon/plugins/power" = {
      idle-dim = false;
      sleep-inactive-ac-type = "suspend";
      sleep-inactive-ac-timeout = 2400;
    };
    "org/gnome/desktop/session" = {
      idle-delay = 1200;
    };
    "org/gnome/desktop/screensaver" = {
      lock-enabled = true;
    };
    "org/gnome/desktop/media-handling" = {
      autorun-never = true;
    };
  };

  home.packages = with pkgs; [
    handbrake
  ];
}
