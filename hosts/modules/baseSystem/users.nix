# Common users and groups.
{ lib, config, pkgs, ... }:
with lib;

let
  cfg = config.baseSystem.users;
  useZsh = config.baseSystem.zsh;
in {
  options.baseSystem.users = {
    shell = mkOption {
      type = types.package;
      default = if useZsh then pkgs.zsh else pkgs.bash;
    };
    dave = {
      authorizedKeys = mkOption {
        type = types.listOf types.str;
        default = [ ];
      };
      extraGroups = mkOption {
        type = types.listOf types.str;
        default = [ ];
      };
    };
  };

  config = {
    users.groups.nixosvmtest = {
    };

    # user for testing nixos-rebuild build-vm
    users.users.nixosvmtest = {
      isSystemUser = true;
      group = "nixosvmtest";
      initialPassword = "nixosvmtest";
      # i think they need to have a home dir to start window manager
      createHome = true;
      home = "/home/nixosvmtest";
      shell = cfg.shell;
      packages = with pkgs; [
      ];
    };

    users.users.dave = {
      isNormalUser = true;
      createHome = true;
      uid = 1001;
      home = "/home/dave";
      extraGroups = [ "wheel" ] ++ cfg.dave.extraGroups;
      shell = cfg.shell;
      packages = with pkgs; [
      ];
      hashedPassword = "REDACTED";
      openssh.authorizedKeys.keys = cfg.dave.authorizedKeys;
    };

    # XXX CAREFUL!!!!
    users.mutableUsers = false;
  };
}
