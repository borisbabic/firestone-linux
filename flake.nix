{
  description = "Parser for Firestone authentication URLs into Wine prefix configurations";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      pkgsFor = system: nixpkgs.legacyPackages.${system};
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = pkgsFor system;
          script = pkgs.writeShellApplication {
            name = "parse-firestone";
            runtimeInputs = with pkgs; [
              jq
              python3
              gnugrep
            ];
            text = builtins.readFile ./parse-firestone.sh;
          };
        in
        {
          default = script;
          parse-firestone = script;
        }
      );

      apps = forAllSystems (system: {
        default = {
          type = "app";
          program = "${self.packages.${system}.default}/bin/parse-firestone";
        };
      });
    };
}