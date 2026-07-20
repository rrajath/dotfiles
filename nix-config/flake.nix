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
    user = "rrajath";
  in
  {
    darwinConfigurations.default = nix-darwin.lib.darwinSystem {
      inherit system;
      specialArgs = inputs // { inherit user; };

      modules = [
        ./darwin.nix
        home-manager.darwinModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.${user} = import ./home.nix;
            extraSpecialArgs = { inherit inputs user; };
            backupFileExtension = "bak";
          };
          users.users.${user}.home = "/Users/${user}";
        }
      ];
    };
  };
}
