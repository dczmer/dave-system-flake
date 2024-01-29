{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.daveHome.zsh;
in {
  options.daveHome.zsh = {
    enable = mkEnableOption "ZSH";
    cfgFile = mkOption {
      type = types.path;
    };
  };

  config = mkIf cfg.enable {
    home.file.".zsh/.p10k.zsh" = {
      source = cfg.cfgFile;
      recursive = true;
    };

    programs.zsh = {
      enable = true;
      enableCompletion = true;
      completionInit = "autoload -U compinit && compinit";
      syntaxHighlighting = {
        enable = true;
      };
      shellAliases = {
        "vi" = "nvim";
        "vim" = "nvim";
        "ls" = "ls --color";
        "ll" = "ls --color -l";
        "la" = "ls --color -al";
        "wake-guinness" = "wol d8:bb:c1:00:86:3b";
        "add-ssh-keys" = "grep -slR 'PRIVATE' ~/.ssh/keys | xargs ssh-add; ssh-add -l";
      };
      history = {
        ignoreSpace = true;
        size = 50000;
      };
      historySubstringSearch = {
        enable = true;
        searchUpKey = "$terminfo[kcuu1]";
        searchDownKey = "$terminfo[kcud1]";
      };
      zplug = {
        enable = true;
        plugins = [
          { name = "romkatv/powerlevel10k"; tags = [ as:theme depth:1 ]; }
        ];
      };
      initExtra = ''
        export GREP_COLOR='3;33'
        export LESS='--ignore-case --raw-control-chars'
        export EDITOR='nvim'
        export LC_COLLATE=C
        export KEYTIMEOUT=1
        export PATH="$PATH:/home/dave/bin"

        bindkey -v
        autoload edit-command-line
        zle -N edit-command-line
        bindkey "^e" edit-command-line
        bindkey "^K" kill-whole-line
        bindkey "^R" history-incremental-search-backward
        #bindkey "\e[3~" delete-char
        #bindkey "\e[1;5d" backward-word
        #bindkey "\e[1;5c" foward-word
        #bindkey "^h" backward-word
        #bindkey "^l" forward-word
        bindkey "''${terminfo[khome]} beginning-of-line
        bindkey "''${terminfo[kend]} end-of-line

        . ~/.zsh/.p10k.zsh
      '';
    };
  };
}
