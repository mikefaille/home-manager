{ config, pkgs, emacs-overlay, nixpkgs-stable, ... }:
# Let Home Manager install and manage itself.

let
  pkgsUnstable = import <unstable> {};
in
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
  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  fonts.fontconfig.enable = true;

  # The home.packages option allows you to install Nix packages into your
  # environment.

  home.packages = [
    pkgs.ripgrep
    pkgs.nodePackages.node2nix
    pkgs.ruff # python static analysis in rust
    pkgs.starship
    pkgs.python311Packages.python-lsp-server
    pkgs.python311Packages.python-lsp-ruff
    pkgs.flameshot
    pkgs.librewolf-unwrapped
    pkgs.ripgrep
    pkgs.bat
    pkgs.awscli2
    # pkgs.emacs-git
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello
    pkgs.aws-sso-cli
    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    (pkgs.nerdfonts.override { fonts = [ "FiraCode" "0xProto" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  programs.starship = {
    enable = true;
    # Configuration written to ~/.config/starship.toml
    settings = {
      add_newline = true;

      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };

      # package.disabled = true;
    };
  };

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


  programs = {

    # Let Home Manager install and manage itself.
    home-manager.enable = true;
    kitty.enable = true;
    kitty.settings = {
      font_family = "0xProto Nerd Font Mono-12";
      bold_font        = "auto";
      italic_font      = "auto";
      bold_italic_font = "auto";
      background         =   "#001e26";
      foreground        =    "#708183";
      cursor             =   "#708183";
      selection_background =  "#002731";
      color0   =             "#002731";
      color8    =            "#465a61";
      color1     =           "#d01b24";
      color9      =          "#bd3612";
      color2       =         "#728905";
      color10       =        "#465a61";
      color3         =       "#a57705";
      color11         =      "#52676f";
      color4           =     "#2075c7";
      color12          =     "#708183";
      color5            =    "#c61b6e";
      color13         =      "#5856b9";
      color6           =     "#259185";
      color14          =     "#81908f";
      color7           =     "#e9e2cb";
      color15          =     "#fcf4dc";
      selection_foreground = "#001e26";
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


  services.spotifyd = {
    enable = true;
    settings =
      {
        global = {
          username = "224wzqgixkvx57pqnkwt6idgy";
          password = "4rn)Aa6qTtS,Z=F";
          dbus_mpris = "true";

          # The audio backend used to play the your music. To get
          # a list of possible backends, run `spotifyd --help`.
          # backend = "pulseaudio" # use portaudio for macOS [homebrew]

          # The name that gets displayed under the connect tab on
          # official clients. Spaces are not allowed!
          device_name = "spotifyd_pop";

          # The audio bitrate. 96, 160 or 320 kbit/s
          bitrate = 320;

          # If set to true, audio data does NOT get cached.
          no_audio_cache = false;

          # Volume on startup between 0 and 100
          # NOTE: This variable's type will change in v0.4, to a number (instead of string)
          initial_volume = "75";

          # If set to true, enables volume normalisation between songs.
          volume_normalisation = true;

          # The normalisation pregain that is applied for each song.
          normalisation_pregain = -10;

          # The displayed device type in Spotify clients.
          # Can be unknown, computer, tablet, smartphone, speaker, t_v,
          # a_v_r (Audio/Video Receiver), s_t_b (Set-Top Box), and audio_dongle.
          device_type = "computer";

          audio_format = "F32";
          backend = "pulseaudio";

        };
      }
    ;
  };


  nixpkgs.overlays = [

		(final: previous: {
      skim = pkgsUnstable.epkgs.tsc;
    })


    emacs-overlay.overlays.default


    (self: super: {
      emacs = (super.emacs-overlay.emacs-git.override {
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


  nixpkgs = {
    config.allowUnfree = true;
    # Workaround for https://github.com/nix-community/home-manager/issues/2942
    config.allowUnfreePredicate = _: true;

    config.enableParallelBuildingByDefault = true;
    config.cudaSupport = true;

  };

  # nixpkgs.overlays = [

  # (self: super: {
  #   emacs = (super.emacs-overlay.emacs-git.override {
  #     withGTK3 = true;
  #     withTreeSitter = true;
  #     withNativeCompilation = true;
  #   }).overrideAttrs (oldAttrs: {
  #     configureFlags = (oldAttrs.configureFlags or []) ++
  #                      [
  #                        "--with-json"
  #                        "--with-cairo-xcb"
  #                        "--without-webp"
  #                      ];
  #   });
  # })
  # ];

  nix = {
    package = pkgs.nix;
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
      substituters = "https://cache.nixos.org https://mikefaille.cachix.org https://nix-community.cachix.org";
      trusted-public-keys = "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= mikefaille.cachix.org-1:MHCo+uMU22i9oPN9KHz0WRf6kFc3/AHx0EHZbI3y/m8= nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=";
    };



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

  programs.git.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
