{
  description = "Home Manager configuration of michael";
  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };


  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-23.11";

    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    home-manager = {
      url = "github:nix-community/home-manager";
    };
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";

    };




    # fix-emacs-ts.url = "github:pimeys/nixpkgs/emacs-tree-sitter/link-grammars";

    nix-straight.url = "github:nix-community/nix-straight.el";
    nix-straight.flake = false;
  };

  outputs = inputs@{  nixpkgs, emacs-overlay, home-manager, nixpkgs-stable, ... }:
    let
      system = "x86_64-linux";

      pkgs = nixpkgs.legacyPackages.${system};





      specialArgs = {
        inherit emacs-overlay nixpkgs-stable;


      };

      # nixpkgs = {
      #   config.allowUnfree = true;
      #   overlays = [
      #     emacs-overlay.overlay
      #   ];
      # };



    in {

      homeConfigurations."michael" = home-manager.lib.homeManagerConfiguration {
        # pkgs = import nixpkgs { inherit overlays; };
        inherit pkgs;


        # optionally use extraSpecialArgs
        # to pass through arguments to home.nix
        extraSpecialArgs = specialArgs;


        # Specify your home configuration modules here, for example,
        # the path to your home.nix.

        modules = [
          # ({ pkgs, ... }: { # Rust
          # nixpkgs.overlays = [ rust-overlay.overlays.default ];

          # })
          ./home.nix
          ./emacs.nix


        ];

      };
    };

}
