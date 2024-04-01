{ config, pkgs, emacs-overlay, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "michael";
  home.homeDirectory = "/home/michael";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    pkgs.ripgrep
    # pkgs.emacs-git
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  services.emacs.package = pkgs.emacs-git;


  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/michael/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "emacsclient --create-frame --alternate-editor emacs";
  };

  # Let Home Manager install and manage itself.
  programs = {
    home-manager.enable = true;
    emacs = { # Use "Pgtk" for pure GTK | Wayland ONLY; No EXWM
      enable = true;
      extraConfig = ''
      (setq scroll-bar-mode 'right)
      (setq scroll-bar-width 12)
      (setq scroll-bar-adjust-thumb-portion nil)
    (set-face-attribute 'default nil :height 120)
    (setq default-frame-alist '((undecorated . t)
                                (ns-transparent-titlebar . t)
                                (ns-appearance . dark)
                                (font . "your-font-name")
                                (left-fringe . 0)
                                (right-fringe . 0)
                                (tool-bar-lines . 0)))
    (setq frame-resize-pixelwise t)
    (use-package tree-sitter
      :config
      (global-tree-sitter-mode)
      (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode)
      (add-hook 'tree-sitter-after-on-hook #'tree-sitter-fold-mode))

    (use-package tree-sitter-langs
      :after tree-sitter)
    '';
      extraPackages = epkgs: with epkgs; [ tsc tree-sitter-langs tree-sitter ];

      # package = pkgs.emacs-git;
    };

  };
  # nixpkgs.overlays = [
  #   (self: super: {
  #     emacs = super.emacs.override {
  #       withGTK3 = true;
  #       withTreeSitter = true;
  #       withWebP = true;
  #       withNativeCompilation = true;
  #       withCairo = true;
  #       withHarfbuzz = true;
  #       withJSON = true;
  #       withThreads = true;
  #       withModules = true;
  #       withZlib = true;
  #       withBzip2 = true;
  #       withXz = true;
  #       withMailutils = true;
  #       withSystemd = true;
  #       withXwidgets = true;
  #       withImageMagick = true;

  #     };
  #   })
  #   (import (builtins.fetchTarball {
  #     url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
  #     sha256 = "025sjvk61050nrk5dx1l41bjlhs7s7xw67javz01mzgxqzrfbhm1";
  #   }))
  # ];

  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
      sha256 = "18pnmvbz1757w8vpf9szvzybi8rilvz689igq21kx1lnz7vqha2d";
    }))

    (self: super: {
      emacs = (super.emacs-git.override {
        withGTK3 = true;
        withTreeSitter = true;
        withNativeCompilation = true;
      }).overrideAttrs (oldAttrs: {
        configureFlags = (oldAttrs.configureFlags or []) ++
                         [
                           "--with-json"
                           "--with-cairo-xcb"
                           "--without-webp"
                         ];
      });
    })
  ];


  nix = {
    package = pkgs.nix;


    gc = {
      automatic = true;

      options = "--delete-older-than 30d";
    };

  };

    gtk.gtk3.extraConfig = {
          "gtk-primary-button-warps-slider" = false;
          "gtk-overlay-scrolling" = true;
          "gtk-scrollbar-width" = 12;
          "gtk-scrollbar-visible" = true;
        };
}
