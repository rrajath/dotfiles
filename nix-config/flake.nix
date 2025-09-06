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
  };

  outputs = inputs@{ self, nixpkgs, nix-darwin, home-manager }:
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
            extraSpecialArgs = { inherit profile; };
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

