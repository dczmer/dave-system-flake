{ lib, config, pkgs, nur, dave-nvim-flake, ... }:
with lib;
let
  cfg = config.daveHome;
in {
  imports = [
    ./daveHome/kitty.nix
    ./daveHome/tmux.nix
    ./daveHome/obsidian.nix
    ./daveHome/zsh.nix
    ./daveHome/firefox.nix
    ./daveHome/gnome.nix
    ./daveHome/hyprland.nix
  ];

  config = {
    nixpkgs.config = {
      allowUnfree = true;
      # Workaround for https://github.com/nix-community/home-manager/issues/2942
      allowUnfreePredicate = _: true;
    };
    nixpkgs.overlays = [ nur.overlay ];

    home = {
      username = "dave";
      homeDirectory = "/home/dave";
      stateVersion = "23.11";
      # user-level packages, but not dev stuff or single purpose apps.
      # those can be run through a dev env or nix-shell.
      packages = with pkgs; [
        p7zip
        unzip
        bat
        htop
        mplayer
        vlc
        mpv
        silver-searcher
        pinentry
        noto-fonts
        noto-fonts-emoji
        nerdfonts
        dave-nvim-flake.packages.x86_64-linux.default
      ];
    };

    # simple borg backup script
    home.file."bin/backup.sh" = {
      source = ../scripts/backup.sh;
      recursive = true;
      executable = true;
    };

    home.file."Wallpapers" = {
      source = ../wallpaper;
    };

    programs.git = {
      enable = true;
      userName = "Dave Czmer";
      userEmail = "dczmer@gmail.com";
    };

    programs.ssh = {
      enable = true;
      matchBlocks = {
        "guinness" = {
          user = "dave";
          port = 6969;
        };
      };
      extraConfig = ''
      AddKeysToAgent yes
      '';
    };
    services.ssh-agent.enable = true;

    programs.taskwarrior = {
      enable = true;
      config = {
        taskd = {
          # TODO manage own ca and keys
          # certificate =
          # key =
          # ca =
          server = "guinness:53589";
        };
      };
    };
    services.taskwarrior-sync.enable = true;

    programs.gpg = {
      enable = true;
    };

    services.gpg-agent = {
      enable = true;
      # TODO: only if cfg.gnome.enabled; else `cli`
      pinentryFlavor = "gnome3";
    };

    programs.password-store = {
      enable = true;
      package = pkgs.pass.withExtensions (exts: [
        exts.pass-otp
        exts.pass-update
        exts.pass-audit
      ]);
      settings = {
        PASSWORD_STORE_DIR = "/home/dave/.password-store";
      };
    };

    # reload system units when changing config
    systemd.user.startServices = "sd-switch";

    programs.home-manager.enable = true;
  };
}
