{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.daveHome.kitty;
in {
  options.daveHome.kitty = {
    enable = mkEnableOption "kitty terminal emulator";
  };

  config = mkIf cfg.enable {
    programs.kitty = {
      enable = true;
      font = {
        # TODO: implicit dependency on this font
        name = "Hack Nerd Font";
      };
      shellIntegration.enableZshIntegration = true;
      theme = "Afterglow";
      settings = {
        scrollback_lines = 50000;
        hide_window_decorations = true;
        background_opacity = "0.9";
        cursor = "none";
        custor_text_color = "#FFFFFF";
      };
      package = pkgs.symlinkJoin {
        name = "kitty-tmux";
        paths = [ pkgs.kitty ];
        buildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/kitty --add-flags "-e tmux new-session -AD -s dave"
        '';
      };
    };
  };
}
