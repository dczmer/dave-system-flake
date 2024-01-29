# https://wiki.hyprland.org/Nix/Hyprland-on-Home-Manager/
# https://wiki.hyprland.org/Getting-Started/Master-Tutorial/
{ lib, config, pkgs, ... }:
with lib;
let
  cfg = config.daveHome.hyprland;
in {
  options.daveHome.hyprland = {
    enable = mkEnableOption "hyprland";
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.xdg-desktop-portal-hyprland ];

    wayland.windowManager.hyprland = {
      enable = true;
      plugins = [ ];
      settings = {
				"$mod" = "SUPER";
				bind =
					[
						"$mod, F, exec, firefox"
						", Print, exec, grimblast copy area"
					]
					++ (
						# workspaces
						# binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
						builtins.concatLists (builtins.genList (
								x: let
									ws = let
										c = (x + 1) / 10;
									in
										builtins.toString (x + 1 - (c * 10));
								in [
									"$mod, ${ws}, workspace, ${toString (x + 1)}"
									"$mod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
								]
							)
							10)
					);
      };

      # this should enable dconf integration
      systemd.enable = true;
      xwayland.enable = true;
    };
  };
}
