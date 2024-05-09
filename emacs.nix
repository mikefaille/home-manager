{ config, pkgs, emacs-overlay,  ... }:
let
  # myEmacs = pkgs.emacs-git;
  # emacsWithPackages = (pkgs.emacsPackagesFor myEmacs).emacsWithPackages;

  # programs.emacs.package = pkgs.emacs-git;
in
let
  # Specify the package you want to monitor

  # oldOutputPath = builtins.readFile (builtins.toString ./result/bin/hello); # Or adjust path as needed
  # newOutputPath = builtins.readFile (builtins.toString ./result-switch/bin/hello);

in
{
  home.sessionVariables = {
    EDITOR = "emacsclient --create-frame --alternate-editor emacs";
  };

  # programs.emacs.package = pkgs.emacs-git;
  programs = {
    emacs = { # Use "Pgtk" for pure GTK | Wayland ONLY; No EXWM
      enable = true;
      # package = emacs-overlay.packages.unstable.emacs-git;
      package = (pkgs.emacsWithPackagesFromUsePackage {
        # Your Emacs config file. Org mode babel files are also
        # supported.
        # NB: Config files cannot contain unicode characters, since
        #     they're being parsed in nix, which lacks unicode
        #     support.
        config = ./config.el;
        # config = ./emacs.el;

        # Whether to include your config as a default init file.
        # If being bool, the value of config is used.
        # Its value can also be a derivation like this if you want to do some
        # substitution:
        #   defaultInitFile = pkgs.substituteAll {
        #     name = "default.el";
        #     src = ./emacs.el;
        #     inherit (config.xdg) configHome dataHome;
        #   };
        defaultInitFile = true;

        # Package is optional, defaults to pkgs.emacs
        package = pkgs.emacs-git;


        # By default emacsWithPackagesFromUsePackage will only pull in
        # packages with `:ensure`, `:ensure t` or `:ensure <package name>`.
        # Setting `alwaysEnsure` to `true` emulates `use-package-always-ensure`
        # and pulls in all use-package references not explicitly disabled via
        # `:ensure nil` or `:disabled`.
        # Note that this is NOT recommended unless you've actually set
        # `use-package-always-ensure` to `t` in your config.
        alwaysEnsure = true;

        # For Org mode babel files, by default only code blocks with
        # `:tangle yes` are considered. Setting `alwaysTangle` to `true`
        # will include all code blocks missing the `:tangle` argument,
        # defaulting it to `yes`.
        # Note that this is NOT recommended unless you have something like
        # `#+PROPERTY: header-args:emacs-lisp :tangle yes` in your config,
        # which defaults `:tangle` to `yes`.
        alwaysTangle = true;

        # Optionally provide extra packages not in the configuration file.
        extraEmacsPackages = epkgs: [
          epkgs.cask
	        epkgs.tsc
	        epkgs.tree-sitter-langs
	        epkgs.treesit-grammars.with-all-grammars
	        epkgs.nerd-icons
	        epkgs.tree-sitter
          (epkgs.melpaStablePackages.use-package)  # Example: Notice the prefix
          (epkgs.melpaStablePackages.magit)
        ];







        # extraPackages = epkgs: with epkgs; [  ];

      }
      );
    };
  };
}
