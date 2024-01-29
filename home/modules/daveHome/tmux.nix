{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.daveHome.tmux;
in {
  options.daveHome.tmux = {
    enable = mkEnableOption "tmux terminal multiplexer";
  };

  config = mkIf cfg.enable {
    programs.tmux = {
      enable = true;
      clock24 = true;
      historyLimit = 50000;
      keyMode = "vi";
      prefix = "`";
      terminal = "screen-256color";
      newSession = true;
      extraConfig = ''
        set -g status-style bg='#27385d',fg='#CFCFCF'
        set -g status-interval 1
        set-option -g status-position bottom

        bind-key j command-prompt -p "join pane from: " "join-pane -s '%%'"
        bind-key s command-prompt -p "join pane to: " "join-pane -t '%%'"
        bind-key b command-prompt "break-pane"

        # vim/tmux-navigator keybinds
        is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
            | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
        bind-key -n C-h if-shell "$is_vim" "send-keys C-h" "select-pane -L"
        bind-key -n C-j if-shell "$is_vim" "send-keys C-j" "select-pane -D"
        bind-key -n C-k if-shell "$is_vim" "send-keys C-k" "select-pane -U"
        bind-key -n C-l if-shell "$is_vim" "send-keys C-l" "select-pane -R"
        bind-key -T copy-mode-vi C-h select-pane -L
        bind-key -T copy-mode-vi C-j select-pane -D
        bind-key -T copy-mode-vi C-k select-pane -L
        bind-key -T copy-mode-vi C-l select-pane -R
      '';
    };
  };
}

