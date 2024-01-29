{ config, lib, pkgs, ... }:
{
  imports = [
    # base settings for all of my machines
    ../modules

    ./hardware-configuration.nix
  ];

  # for nixos-rebuild build-vm
  virtualisation.vmVariant = {
    virtualisation = {
      memorySize = 2048;
      cores = 2;
      restrictNetwork = true;
    };
  };

  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    #gfxmodeEfi = "1920x1080";
    #splashImage = ./my-background.png;
  };
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices = {
    root = {
      device = "/dev/disk/by-uuid/01c250b0-76cc-491c-8c9d-4bf227c8c309";
      preLVM = true;
      allowDiscards = true;
    };
  };

  networking.hostName = "marvin";
  networking.networkmanager.enable = true;
  networking.hosts = {
    "127.0.0.1" = [ "marvin" ];
    "192.168.1.69" = [ "guinness" ];
    "192.168.1.135" = [ "lucky" ];
  };
  networking.extraHosts = ''
    127.0.0.1     marvin
    192.168.1.69  guinness
    192.168.1.135 lucky
  '';

  security.pki.certificateFiles = [
    /var/certs/daveCA.pem
  ];

  baseSystem.zsh = true;
  baseSystem.gnome.enable = true;
  baseSystem.printing.enable = true;
  baseSystem.printing.allowDiscovery = false;

  programs.hyprland.enable = true;

  environment.systemPackages = with pkgs; [
    powertop
    wol
    glxinfo
    gnome.gnome-tweaks
    gnomeExtensions.appindicator
  ];

  powerManagement.enable = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?
}
