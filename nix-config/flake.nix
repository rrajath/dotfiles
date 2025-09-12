{
  description = "My macOS system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      # IMPORTANT: we're using "libgbm" and is only available in unstable so ensure
      # to have it up-to-date or simply don't specify the nixpkgs input
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, nix-darwin, home-manager, zen-browser }:
  let
    system = "aarch64-darwin";
    username = "rrajath";

    mkDarwinSystem = profile: nix-darwin.lib.darwinSystem {
      inherit system;
      specialArgs = inputs // {
        user = username;
        inherit profile;
      };

      modules = [
        ./shared/darwin.nix
        ./${profile}/darwin.nix
        home-manager.darwinModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.${username} = import ./${profile}/home.nix;
            extraSpecialArgs = { inherit profile inputs; };
          };
          users.users.${username}.home = "/Users/${username}";
        }
      ];
    };
  in
    {

      darwinConfigurations = {
        personal = mkDarwinSystem "personal";
        work = mkDarwinSystem "work";
      };
    };
}

