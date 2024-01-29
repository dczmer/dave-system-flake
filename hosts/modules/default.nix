# Common system settings for all of my nixos hosts
{ lib, config, pkgs, ... }:
with lib;

let
  cfg = config.baseSystem;
in {
  imports = [
    # common users and groups
    ./baseSystem/users.nix
    # gnome and x stuff
    ./baseSystem/gnome.nix
    # docker
    ./baseSystem/docker.nix
    # sshd
    ./baseSystem/ssh.nix
    # home printer
    ./baseSystem/printing.nix
  ];

  options.baseSystem = {
    zsh = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = {
    nix.settings = {
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      substituters = [
        "https://cache.nixos.org"
      ];
      builders-use-substitutes = true;
      trusted-users = [ "dave" ];
    };

    time.timeZone = "America/Detroit";
    i18n.defaultLocale = "en_US.UTF-8";
    console.keyMap = "us";

    programs.zsh.enable = cfg.zsh;
    environment.defaultPackages = [];
    environment.variables = { EDITOR = "vim"; };

    networking.nameservers = [ "8.8.8.8" ];
    networking.firewall.enable = true;

    security.polkit.enable = true;

    environment.systemPackages = with pkgs; [
      man
      git
      wget
      rsync
      perl
      rsync
      nix-prefetch
      nix-prefetch-git
      nix-prefetch-docker
      nix-output-monitor

      # always have a working vim install for root
      ((vim_configurable.override {}).customize{
        name = "vim";
        vimrcConfig.packages.myplugins = with pkgs.vimPlugins; {
          start = [ vim-nix vim-lastplace ];
          opt = [];
        };
        vimrcConfig.customRC = ''
          set nocompatible
          autocmd!
          set history=500
          set showmode
          set wildmode=list:longest,full
          set showcmd
          set showmatch
          set autowrite
          set completeopt=menuone
          set scrolloff=6
          set backspace=indent,eol,start
          set ruler
          set nu
          set nomodeline
          set nowrap
          set textwidth=0
          set shiftwidth=4
          set tabstop=4
          set softtabstop=4
          set shiftround
          set autoindent
          set expandtab
          set incsearch
          set hidden
          set noswapfile
          set nomousehide
          set encoding=utf-8
          set termencoding=utf-8
          filetype on
          filetype indent on
          filetype plugin on
          syntax on
          noremap <F4> <ESC>:set paste!<CR>
          noremap <silent> <F11> <ESC>:bprev<CR>
          noremap <silent> <F12> <ESC>:bnext<CR>
          colorscheme industry
        '';
      })
    ];
  };
}
